import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';
import 'package:gmiwidgetspackage/widgets/flutterToast.dart';
import 'package:myfhb/constants/fhb_constants.dart' as constants;
import 'package:myfhb/src/model/user/MyProfileModel.dart';
import 'package:myfhb/src/ui/bot/common/botutils.dart';
import 'package:myfhb/src/ui/bot/service/sheela_service.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';
import '../../../../common/PreferenceUtil.dart';
import '../../../blocs/health/HealthReportListForUserBlock.dart';
import '../../../model/bot/ConversationModel.dart';
import 'package:myfhb/constants/variable_constant.dart' as variable;
import 'package:myfhb/constants/fhb_parameters.dart' as parameters;
import '../../../model/bot/SpeechModelResponse.dart';
import '../../../utils/FHBUtils.dart';
import 'package:audioplayer/audioplayer.dart';
import 'package:myfhb/src/model/UpdatedDeviceModel.dart';
import 'package:myfhb/src/model/GetDeviceSelectionModel.dart';
import 'package:myfhb/src/resources/repository/health/HealthReportListForUserRepository.dart';
import 'package:myfhb/src/model/bot/button_model.dart';

class ChatScreenViewModel extends ChangeNotifier {
  static MyProfileModel prof =
      PreferenceUtil.getProfileData(constants.KEY_PROFILE);
  List<Conversation> conversations = new List();
  static var uuid = Uuid().v1();
  var user_id;
  var user_name;
  var auth_token = PreferenceUtil.getStringValue(constants.KEY_AUTHTOKEN);
  var isMayaSpeaks = -1;
  var userMappingId = '';
  bool _isdigitRecognition = true;
  bool _isdeviceRecognition = true;
  bool _isGFActive;
  bool _isHKActive = false;
  bool _firstTym = true;
  bool _isBPActive = true;
  bool _isGLActive = true;
  bool _isOxyActive = true;
  bool _isTHActive = true;
  bool _isWSActive = true;
  bool _isHealthFirstTime = false;
  String preferred_language;
  String qa_subscription;
  int preColor = 0xff5e1fe0;
  int greColor = 0xff753aec;
  var isEndOfConv = false;
  bool canSpeak = true;
  var isLoading = false;
  var isRedirect = false;
  var screenValue;
  bool enableMic = true;
  bool isButtonResponse = false;
  bool stopTTS = false;
  bool isSheelaSpeaking = false;
  String _screen = parameters.strSheela;
  int delayTime = 0;

  List<Conversation> get getMyConversations => conversations;

  int get getisMayaSpeaks => isMayaSpeaks;
  AudioPlayer audioPlayerForTTS = AudioPlayer();
  AudioPlayer newAudioPlay1 = AudioPlayer();
  bool isAudioPlayerPlaying = false;
  bool get getIsButtonResponse => isButtonResponse && !enableMic;

  void updateAppState(bool canSheelaSpeak, {bool isInitial: false}) {
    canSpeak = canSheelaSpeak;
    if (!canSheelaSpeak) {
      isLoading = false;
      stopTTSEngine();
    }
    if (!isInitial) notifyListeners();
  }

  void clearMyConversation() {
    conversations = List();
    // notifyListeners();
  }

  ChatScreenViewModel() {
    prof = PreferenceUtil.getProfileData(constants.KEY_PROFILE);
    user_name =
        prof.result != null ? prof.result.firstName + prof.result.lastName : '';
    user_id = PreferenceUtil.getStringValue(constants.KEY_USERID);
  }

  startMayaAutomatically() {
    isLoading = true;
    notifyListeners();
    Future.delayed(Duration(seconds: 1), () {
      _screen = parameters.strSheela;
      sendToMaya(variable.strhiMaya, screen: _screen);
    });

    // var date = new FHBUtils().getFormattedDateString(DateTime.now().toString());
    // // Conversation model = new Conversation(
    // //     isMayaSaid: false,
    // //     text: variable.strhiMaya,
    // //     name: prof.result != null
    // //         ? prof.result.firstName + prof.result.lastName
    // //         : '',
    // //     timeStamp: date,
    // //     redirect: isRedirect,
    // //     screen: parameters.strSheela);
    // //
    // // conversations.add(model);
    // notifyListeners();
  }

  Future<void> stopTTSEngine({int index}) async {
    stopTTS = true;
    notifyListeners();
    if (index != null) {
      conversations[index].isSpeaking = false;
      isSheelaSpeaking = false;
      notifyListeners();
    } else {
      conversations.forEach((conversation) {
        conversation.isSpeaking = false;
      });
      isSheelaSpeaking = false;
      notifyListeners();
    }
    stopAudioPlayer();
    await variable.tts_platform.invokeMethod(variable.strtts, {
      parameters.strMessage: "",
      parameters.strIsClose: true,
      parameters.strLanguage: Utils.getCurrentLanCode()
    });
  }

  Future<bool> startTTSEngine({
    String textToSpeak,
    int index,
    String langCode,
    bool stopPrevious: true,
  }) async {
    if (stopPrevious) {
      stopTTSEngine();
    }
    if (canSpeak) {
      if (index != null) {
        conversations[index].isSpeaking = true;
        isSheelaSpeaking = true;
        notifyListeners();
      }
      final lan = langCode != null && langCode.isNotEmpty
          ? langCode
          : Utils.getCurrentLanCode();
      if (Platform.isIOS ||
          lan == "undef" ||
          lan.toLowerCase() == "en-IN".toLowerCase() ||
          lan.toLowerCase() == "en-US".toLowerCase()) {
        await variable.tts_platform.invokeMethod(variable.strtts, {
          parameters.strMessage: textToSpeak,
          parameters.strIsClose: false,
          parameters.strLanguage: langCode ?? Utils.getCurrentLanCode(),
        }).then((response) async {
          if (response == 1) {
            if (index != null) {
              conversations[index].isSpeaking = false;
              isSheelaSpeaking = false;
              notifyListeners();
            }
          }
        });
      } else {
        String langCodeForRequest;
        if (lan != "undef") {
          final langCode = lan.split("-").first;
          langCodeForRequest = langCode;
          //print(langCode);
        }
        newAudioPlay1 = AudioPlayer();
        final languageForTTS = langCodeForRequest ?? Utils.getCurrentLanCode();
        newAudioPlay1.onPlayerStateChanged.listen((event) async {
          print(event);
          if (event == AudioPlayerState.COMPLETED ||
              event == AudioPlayerState.PAUSED ||
              event == AudioPlayerState.STOPPED) {
            if (index != null && stopPrevious) {
              conversations[index].isSpeaking = false;
              isSheelaSpeaking = false;
              notifyListeners();
            }
          }
          if (event == AudioPlayerState.PLAYING) {
            if (index != null) {
              conversations[index].isSpeaking = true;
              isSheelaSpeaking = true;
              notifyListeners();
            }
            await setTimeDuration(newAudioPlay1);
          }
        });
        await getGoogleTTSResponse(
            textToSpeak, languageForTTS != null ? languageForTTS : "en", true);
      }
    }
  }

  startSheelaFromButton({
    String buttonText,
    String payload,
  }) async {
    stopTTSEngine();
    Future.delayed(Duration(seconds: 1), () {
      sendToMaya(payload, screen: _screen);
    });

    var date = new FHBUtils().getFormattedDateString(DateTime.now().toString());
    Conversation model = new Conversation(
        isMayaSaid: false,
        text: buttonText,
        name: prof.result != null
            ? prof.result.firstName + prof.result.lastName
            : '',
        timeStamp: date,
        redirect: isRedirect,
        screen: _screen);

    conversations.add(model);
    notifyListeners();
  }

  startSheelaFromDashboard(String inputs) async {
    Future.delayed(Duration(seconds: 1), () {
      if (inputs != null && inputs != '') {
        _screen = parameters.strDashboard;
        sendToMaya(inputs, screen: _screen);
      } else {
        FlutterToast()
            .getToast('Invalid inputs for sheela from dashboard', Colors.red);
      }
    });
    if (inputs != null && inputs != '') {
      _screen = parameters.strDashboard;
      var date =
          new FHBUtils().getFormattedDateString(DateTime.now().toString());
      Conversation model = new Conversation(
          isMayaSaid: false,
          text: inputs,
          name: prof.result != null
              ? prof.result.firstName + prof.result.lastName
              : '',
          timeStamp: date,
          redirect: isRedirect,
          screen: _screen);

      conversations.add(model);
      // notifyListeners();
    }
  }

  askUserForLanguage() {
    Future.delayed(Duration(seconds: 1), () {
      _screen = parameters.strSheela;
      sendToMaya(variable.strhiMaya, screen: _screen);
    });

    // var date = new FHBUtils().getFormattedDateString(DateTime.now().toString());
    // Conversation model = new Conversation(
    //     isMayaSaid: false,
    //     text: variable.strhiMaya,
    //     name: prof.result != null
    //         ? prof.result.firstName + prof.result.lastName
    //         : '',
    //     timeStamp: date,
    //     redirect: isRedirect,
    //     screen: parameters.strSheela);
    //
    // conversations.add(model);
    // notifyListeners();
  }

  sendToMaya(String msg, {String screen}) async {
    prof = await PreferenceUtil.getProfileData(constants.KEY_PROFILE);
    user_name =
        prof.result != null ? prof.result.firstName + prof.result.lastName : '';

    String uuidString = uuid;
    String tzOffset = DateTime.now().timeZoneOffset.toString();
    var user_id = await PreferenceUtil.getStringValue(constants.KEY_USERID);
    var splitedArr = tzOffset.split(':');
    Map<String, dynamic> reqJson = {};
    reqJson[parameters.strSender] = user_id;
    reqJson[parameters.strSenderName] = user_name;
    reqJson[parameters.strMessage] = msg;
    reqJson[parameters.strSource] = variable.strdevice;
    reqJson[parameters.strSessionId] = uuidString;
    reqJson[parameters.strAuthtoken] = auth_token;
    reqJson[parameters.strLanguage] = Utils.getCurrentLanCode();
    reqJson[parameters.strtimezone] =
        splitedArr.length > 0 ? '${splitedArr[0]}:${splitedArr[1]}' : '';

    reqJson[parameters.strPlatforType] = Platform.isAndroid ? 'android' : 'ios';
    reqJson[parameters.strScreen] = screen;
    screenValue = screen;
    isLoading = true;

    Service mService = Service();
    final response = await mService.sendMetaToMaya(reqJson);

    if (response.statusCode == 200) {
      if (response.body != null) {
        final jsonResponse = jsonDecode(response.body);

        List<dynamic> list = jsonResponse;
        if (list.length > 0) {
          SpeechModelResponse res = SpeechModelResponse.fromJson(list[0]);
          isEndOfConv = res.endOfConv;
          isRedirect = res.redirect;
          PreferenceUtil.saveString(constants.SHEELA_LANG, res.lang);
          var date =
              new FHBUtils().getFormattedDateString(DateTime.now().toString());
          Conversation model = new Conversation(
              isMayaSaid: true,
              text: res.text,
              name: prof.result != null
                  ? prof.result.firstName + prof.result.lastName
                  : '',
              imageUrl: res.imageURL,
              timeStamp: date,
              buttons: res.buttons,
              langCode: res.lang,
              searchURL: res.searchURL,
              videoLinks: res.videoLinks,
              redirect: isRedirect,
              screen: screenValue,
              isSpeaking: false);
          conversations.add(model);
          if ((res?.buttons?.length ?? 0) > 0) {
            isButtonResponse = true;
          } else {
            isButtonResponse = false;
          }
          isSheelaSpeaking = false;
          enableMic = res.enableMic ?? false;
          notifyListeners();
          Future.delayed(
              Duration(
                seconds: 1,
              ), () async {
            isMayaSpeaks = 0;
            final lan = Utils.getCurrentLanCode();
            String langCodeForRequest;
            if (lan != "undef") {
              final langCode = lan.split("-").first;
              langCodeForRequest = langCode;
              //print(langCode);
            }

            if (canSpeak) {
              if (Platform.isIOS ||
                  lan == "undef" ||
                  lan.toLowerCase() == "en-IN".toLowerCase() ||
                  lan.toLowerCase() == "en-US".toLowerCase()) {
                String textToSpeak = '';
                // if ((res?.buttons?.length ?? 0) > 0) {
                //   textToSpeak = '.';
                //   await Future.forEach(res.buttons, (button) async {
                //     textToSpeak = textToSpeak + button.title + '.';
                //   });
                // }
                if (res.lang == null || res.lang == "undef") {
                  res.lang = "en-IN";
                }
                isLoading = false;
                conversations[conversations.length - 1].isSpeaking = true;
                isSheelaSpeaking = true;
                notifyListeners();
                variable.tts_platform.invokeMethod(variable.strtts, {
                  parameters.strMessage: res.text + textToSpeak,
                  parameters.strIsClose: false,
                  parameters.strLanguage: res.lang
                }).then((response) async {
                  if (response == 1) {
                    isMayaSpeaks = 1;
                  }
                  if (!isButtonResponse) {
                    conversations[conversations.length - 1].isSpeaking = false;
                    isSheelaSpeaking = false;
                    notifyListeners();
                    if (!isEndOfConv) {
                      gettingReposnseFromNative();
                    } else {
                      refreshData();
                    }
                  } else {
                    await startButtonsSpeech(
                      index: conversations.length - 1,
                      langCode: res.lang,
                      buttons: res.buttons,
                    );
                  }
                }).catchError((error) {
                  conversations[conversations.length - 1].isSpeaking = false;
                  isSheelaSpeaking = false;
                  notifyListeners();
                  if (!isEndOfConv) {
                    gettingReposnseFromNative();
                  }
                });
              } else {
                //print(res.text);
                String textToSpeak = '';
                // if ((res?.buttons?.length ?? 0) > 0) {
                //   textToSpeak = '.';
                //   await Future.forEach(res.buttons, (button) async {
                //     textToSpeak = textToSpeak + button.title + '.';
                //   });
                // }
                audioPlayerForTTS = AudioPlayer();
                final languageForTTS = Utils.getCurrentLanCode();
                audioPlayerForTTS.onPlayerStateChanged.listen((event) async {
                  if (event == AudioPlayerState.PLAYING) {
                    isLoading = false;
                    conversations[conversations.length - 1].isSpeaking = true;
                    isSheelaSpeaking = true;
                    notifyListeners();
                    isAudioPlayerPlaying = true;
                    await setTimeDuration(audioPlayerForTTS);
                  }
                  if (event == AudioPlayerState.COMPLETED) {
                    if (!isButtonResponse) {
                      isLoading = false;
                      conversations[conversations.length - 1].isSpeaking =
                          false;
                      isSheelaSpeaking = false;
                      notifyListeners();
                      if (!isEndOfConv) {
                        gettingReposnseFromNative();
                      }
                    } else {
                      await startButtonsSpeech(
                        index: conversations.length - 1,
                        langCode: res.lang,
                        buttons: res.buttons,
                      );
                    }
                  }
                  if (event == AudioPlayerState.PAUSED ||
                      event == AudioPlayerState.STOPPED) {
                    isLoading = false;
                    if (!isButtonResponse) {
                      conversations[conversations.length - 1].isSpeaking =
                          false;
                      isSheelaSpeaking = false;
                      notifyListeners();
                    } else {
                      await startButtonsSpeech(
                        index: conversations.length - 1,
                        langCode: res.lang,
                        buttons: res.buttons,
                      );
                    }
                  }
                });
                await getGoogleTTSResponse(res.text + textToSpeak,
                    languageForTTS != null ? languageForTTS : "en", false);
              }
            }
          });
          return jsonResponse;
        }
      }
    } else {
      isLoading = false;
      notifyListeners();
      FlutterToast().getToast(
          'There is some issue with sheela,\n Please try after some time',
          Colors.black54);
    }
  }

  Future<void> startButtonsSpeech({
    @required List<Buttons> buttons,
    @required int index,
    @required String langCode,
  }) async {
    if ((buttons?.length ?? 0) > 0) {
      stopTTS = false;
      Conversation recentConversation = conversations[conversations.length - 1];
      await Future.forEach(buttons, (button) async {
        if (stopTTS) {
          recentConversation.buttons[recentConversation.buttons.indexOf(button)]
              .isPlaying = false;
          notifyListeners();
          stopTTSEngine(index: index);
          return;
        }
        recentConversation.buttons[recentConversation.buttons.indexOf(button)]
            .isPlaying = true;
        notifyListeners();
        await startTTSEngine(
          langCode: langCode,
          index: index,
          textToSpeak: button.title,
          stopPrevious: false,
        );
        recentConversation.buttons[recentConversation.buttons.indexOf(button)]
            .isPlaying = false;
        notifyListeners();
      });
      stopTTSEngine(index: index);
      // conversations[index].isSpeaking = false;
      // isSheelaSpeaking = false;
      // notifyListeners();
    } else {
      stopTTSEngine();
    }
  }

  getGoogleTTSResponse(String dataForVoice, String langCode, bool isTTS) async {
    // final str =
    //     "https://heyr2.com/tts/ws_tts.php?key=67ca0bad-83a8-4f1b-a31b-5a1f2380b385&Action=GetSpeech&json=1&lang=" +
    //         langCode +
    //         "&ttsdata=" +
    //         dataForVoice;
    // final response = await http.get(
    //   str,
    // );
    Map<String, dynamic> reqJson = {};
    Map<String, dynamic> input = {};
    Map<String, dynamic> voice = {};
    Map<String, dynamic> audioConfig = {};
    input[parameters.text] = dataForVoice;
    voice[parameters.languageCode] = langCode;
    audioConfig[parameters.audioEncoding] = parameters.MP3;
    reqJson[parameters.input] = input;
    reqJson[parameters.voice] = voice;
    reqJson[parameters.audioConfig] = audioConfig;
    reqJson[parameters.isAudioFile] = false;
    Service mService = Service();
    final response = await mService.getAudioFileTTS(reqJson);

    if (response.statusCode == 200) {
      if (response.body != null) {
        final data = jsonDecode(response.body);
        final result = data["payload"];
        if (result != null) {
          final audioContent = result["audioContent"];
          if (audioContent != null) {
            final bytes = Base64Decoder().convert(audioContent);
            if (bytes != null) {
              final dir = await getTemporaryDirectory();
              final file = File('${dir.path}/wavenet.mp3');
              await file.writeAsBytes(bytes);
              final path = dir.path + "/wavenet.mp3";
              if (canSpeak) {
                if (isTTS) {
                  newAudioPlay1.play(path, isLocal: true);
                } else {
                  audioPlayerForTTS.play(path, isLocal: true);
                }
                print('Check delayTime - $delayTime');
                await Future.delayed(Duration(milliseconds: 500), () async {
                  print('Check delayTime - new $delayTime');
                  await Future.delayed(
                      Duration(
                        milliseconds: delayTime > 0 ? delayTime : 0,
                      ), () {
                    return true;
                  });
                });
              }
            }
          }
        }
      }
    } else {
      isLoading = false;
      notifyListeners();
      FlutterToast().getToast(
          'There is some issue with sheela,\n Please try after some time',
          Colors.black54);
    }

    // } else if (Platform.isAndroid) {
    //   newAudioPlay.playBytes(bytes);
    // }

    //print(dir.path);
  }

  Future<bool> setTimeDuration(AudioPlayer audioPlayer) async {
    delayTime = await audioPlayer.duration.inMilliseconds;
    print('delayTime - $delayTime');
  }

  stopAudioPlayer() {
    audioPlayerForTTS?.stop();
    newAudioPlay1?.stop();
  }

  Future<void> gettingReposnseFromNative() async {
    stopTTSEngine();
    try {
      await variable.voice_platform.invokeMethod(variable.strspeakAssistant,
          {'langcode': Utils.getCurrentLanCode()}).then((response) {
        sendToMaya(response, screen: screenValue);
        var date =
            new FHBUtils().getFormattedDateString(DateTime.now().toString());
        Conversation model = new Conversation(
            isMayaSaid: false,
            text: response,
            name: prof.result != null
                ? prof.result.firstName + prof.result.lastName
                : '',
            timeStamp: date,
            redirect: isRedirect,
            screen: screenValue);
        conversations.add(model);
        notifyListeners();
      });
    } on PlatformException catch (e) {}
  }

  void refreshData() {
    var _healthReportListForUserBlock = new HealthReportListForUserBlock();
    _healthReportListForUserBlock.getHelthReportLists().then((value) {
      PreferenceUtil.saveCompleteData(constants.KEY_COMPLETE_DATA, value);
    });
  }

  Future<void> getDeviceSelectionValues() async {
    HealthReportListForUserRepository healthReportListForUserRepository =
        HealthReportListForUserRepository();
    GetDeviceSelectionModel selectionResult;
    await healthReportListForUserRepository.getDeviceSelection().then((value) {
      selectionResult = value;
      if (selectionResult.isSuccess) {
        if (selectionResult.result != null) {
          setValues(selectionResult);
          userMappingId = selectionResult.result[0].id;
        } else {
          userMappingId = '';
          _isdeviceRecognition = true;
          _isHKActive = false;
          _firstTym = true;
          _isBPActive = true;
          _isGLActive = true;
          _isOxyActive = true;
          _isTHActive = true;
          _isWSActive = true;
          _isHealthFirstTime = false;
        }
      } else {
        userMappingId = '';
        _isdigitRecognition = true;
        _isdeviceRecognition = true;
        _isHKActive = false;
        _firstTym = true;
        _isBPActive = true;
        _isGLActive = true;
        _isOxyActive = true;
        _isTHActive = true;
        _isWSActive = true;
        _isHealthFirstTime = false;
      }
    });
  }

  setValues(GetDeviceSelectionModel getDeviceSelectionModel) {
    _isdeviceRecognition =
        getDeviceSelectionModel.result[0].profileSetting.allowDevice != null &&
                getDeviceSelectionModel.result[0].profileSetting.allowDevice !=
                    ''
            ? getDeviceSelectionModel.result[0].profileSetting.allowDevice
            : true;
    _isdigitRecognition =
        getDeviceSelectionModel.result[0].profileSetting.allowDigit != null &&
                getDeviceSelectionModel.result[0].profileSetting.allowDigit !=
                    ''
            ? getDeviceSelectionModel.result[0].profileSetting.allowDigit
            : true;
    _isHKActive =
        getDeviceSelectionModel.result[0].profileSetting.healthFit != null &&
                getDeviceSelectionModel.result[0].profileSetting.healthFit != ''
            ? getDeviceSelectionModel.result[0].profileSetting.healthFit
            : false;
    _isBPActive =
        getDeviceSelectionModel.result[0].profileSetting.bpMonitor != null &&
                getDeviceSelectionModel.result[0].profileSetting.bpMonitor != ''
            ? getDeviceSelectionModel.result[0].profileSetting.bpMonitor
            : true;
    _isGLActive = getDeviceSelectionModel.result[0].profileSetting.glucoMeter !=
                null &&
            getDeviceSelectionModel.result[0].profileSetting.glucoMeter != ''
        ? getDeviceSelectionModel.result[0].profileSetting.glucoMeter
        : true;
    _isOxyActive = getDeviceSelectionModel
                    .result[0].profileSetting.pulseOximeter !=
                null &&
            getDeviceSelectionModel.result[0].profileSetting.pulseOximeter != ''
        ? getDeviceSelectionModel.result[0].profileSetting.pulseOximeter
        : true;
    _isWSActive = getDeviceSelectionModel.result[0].profileSetting.weighScale !=
                null &&
            getDeviceSelectionModel.result[0].profileSetting.weighScale != ''
        ? getDeviceSelectionModel.result[0].profileSetting.weighScale
        : true;
    _isTHActive =
        getDeviceSelectionModel.result[0].profileSetting.thermoMeter != null &&
                getDeviceSelectionModel.result[0].profileSetting.thermoMeter !=
                    ''
            ? getDeviceSelectionModel.result[0].profileSetting.thermoMeter
            : true;

    preferred_language = getDeviceSelectionModel
                    .result[0].profileSetting.preferred_language !=
                null &&
            getDeviceSelectionModel
                    .result[0].profileSetting.preferred_language !=
                ''
        ? getDeviceSelectionModel.result[0].profileSetting.preferred_language
        : 'undef';

    qa_subscription = getDeviceSelectionModel
                    .result[0].profileSetting.qa_subscription !=
                null &&
            getDeviceSelectionModel.result[0].profileSetting.qa_subscription !=
                ''
        ? getDeviceSelectionModel.result[0].profileSetting.qa_subscription
        : 'Y';
  }

  Future<UpdateDeviceModel> updateDeviceSelectionModel(
      {String preferredLanguage}) async {
    HealthReportListForUserRepository healthReportListForUserRepository =
        HealthReportListForUserRepository();
    await healthReportListForUserRepository
        .updateDeviceModel(
            userMappingId,
            _isdigitRecognition,
            _isdeviceRecognition,
            _isGFActive,
            _isHKActive,
            _isBPActive,
            _isGLActive,
            _isOxyActive,
            _isTHActive,
            _isWSActive,
            preferredLanguage ?? preferred_language,
            qa_subscription,
            preColor,
            greColor)
        .then(
      (value) {
        if (value?.isSuccess ?? false) {
          getDeviceSelectionValues();
        }
      },
    );
  }
}
