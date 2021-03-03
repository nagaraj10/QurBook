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
import 'package:http/http.dart' as http;
import 'package:audioplayer/audioplayer.dart';

class ChatScreenViewModel extends ChangeNotifier {
  static MyProfileModel prof =
      PreferenceUtil.getProfileData(constants.KEY_PROFILE);
  List<Conversation> conversations = new List();
  static var uuid = Uuid().v1();
  var user_id;
  var user_name;
  var auth_token = PreferenceUtil.getStringValue(constants.KEY_AUTHTOKEN);
  var isMayaSpeaks = -1;
  var isEndOfConv = false;
  var stopTTSNow = false;
  var isLoading = false;
  var isRedirect = false;
  var screenValue;
  bool isButtonResponse = false;
  bool stopTTS = false;
  String _screen = parameters.strSheela;

  List<Conversation> get getMyConversations => conversations;

  int get getisMayaSpeaks => isMayaSpeaks;
  AudioPlayer audioPlayerForTTS = AudioPlayer();
  AudioPlayer newAudioPlay1 = AudioPlayer();
  bool isAudioPlayerPlaying = false;
  bool get getIsButtonResponse => isButtonResponse;
  bool get getStopTTS => stopTTS;

  void clearMyConversation() {
    conversations = List();
    notifyListeners();
  }

  ChatScreenViewModel() {
    prof = PreferenceUtil.getProfileData(constants.KEY_PROFILE);
    user_name =
        prof.result != null ? prof.result.firstName + prof.result.lastName : '';
    user_id = PreferenceUtil.getStringValue(constants.KEY_USERID);
  }

  startMayaAutomatically() {
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
    stopTTS = false;
    notifyListeners();
    if (index != null) {
      conversations[index].isSpeaking = false;
      notifyListeners();
    } else {
      conversations.forEach((conversation) {
        conversation.isSpeaking = false;
      });
      notifyListeners();
    }
    stopAudioPlayer();
    await variable.tts_platform.invokeMethod(variable.strtts, {
      parameters.strMessage: "",
      parameters.strIsClose: true,
      parameters.strLanguage: Utils.getCurrentLanCode()
    });
  }

  Future<bool> startTTSEngine({String textToSpeak, int index}) async {
    stopTTSEngine();
    if (index != null) {
      conversations[index].isSpeaking = true;
      notifyListeners();
    }
    final lan = Utils.getCurrentLanCode();
    if (Platform.isIOS ||
        lan == "undef" ||
        lan.toLowerCase() == "en-IN".toLowerCase() ||
        lan.toLowerCase() == "en-US".toLowerCase()) {
      await variable.tts_platform.invokeMethod(variable.strtts, {
        parameters.strMessage: textToSpeak,
        parameters.strIsClose: false,
        parameters.strLanguage: Utils.getCurrentLanCode(),
      }).then((response) async {
        if (response == 1) {
          if (index != null) {
            conversations[index].isSpeaking = false;
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
      AudioPlayer newAudioPlay1 = AudioPlayer();
      final languageForTTS = Utils.getCurrentLanCode();
      getGoogleTTSResponse(
          textToSpeak, languageForTTS != null ? languageForTTS : "en", true);
      newAudioPlay1.onPlayerStateChanged.listen((event) async {
        print(event);
        if (event == AudioPlayerState.COMPLETED ||
            event == AudioPlayerState.PAUSED ||
            event == AudioPlayerState.STOPPED) {
          if (index != null) {
            conversations[index].isSpeaking = false;
            notifyListeners();
          }
        }
      });
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
      notifyListeners();
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
              isSpeaking: true);
          conversations.add(model);
          if ((res?.buttons?.length ?? 0) > 0) {
            isButtonResponse = true;
          } else {
            isButtonResponse = false;
          }
          isLoading = true;
          notifyListeners();
          Future.delayed(
              Duration(
                seconds: 4,
              ), () async {
            isLoading = false;
            notifyListeners();
            isMayaSpeaks = 0;
            final lan = Utils.getCurrentLanCode();
            String langCodeForRequest;
            if (lan != "undef") {
              final langCode = lan.split("-").first;
              langCodeForRequest = langCode;
              //print(langCode);
            }

            if (!stopTTSNow) {
              if (Platform.isIOS ||
                  lan == "undef" ||
                  lan.toLowerCase() == "en-IN".toLowerCase() ||
                  lan.toLowerCase() == "en-US".toLowerCase()) {
                String textToSpeak = '.';
                if ((res?.buttons?.length ?? 0) > 0) {
                  await Future.forEach(res.buttons, (button) async {
                    textToSpeak = textToSpeak + button.title + '.';
                  });
                }
                if (res.lang == null || res.lang == "undef") {
                  res.lang = "en-IN";
                }
                variable.tts_platform.invokeMethod(variable.strtts, {
                  parameters.strMessage: res.text + textToSpeak,
                  parameters.strIsClose: false,
                  parameters.strLanguage: res.lang
                }).then((response) async {
                  conversations[conversations.length - 1].isSpeaking = false;
                  notifyListeners();
                  if (response == 1) {
                    isMayaSpeaks = 1;
                  }
                  if (!isButtonResponse) {
                    if (!isEndOfConv) {
                      gettingReposnseFromNative();
                    } else {
                      refreshData();
                    }
                  }
                }).catchError((error) {
                  conversations[conversations.length - 1].isSpeaking = false;
                  notifyListeners();
                  if (!isEndOfConv) {
                    gettingReposnseFromNative();
                  }
                });
              } else {
                //print(res.text);
                String textToSpeak = '.';
                if ((res?.buttons?.length ?? 0) > 0) {
                  await Future.forEach(res.buttons, (button) async {
                    textToSpeak = textToSpeak + button.title + '.';
                  });
                }
                audioPlayerForTTS = AudioPlayer();
                final languageForTTS = Utils.getCurrentLanCode();
                getGoogleTTSResponse(res.text + textToSpeak,
                    languageForTTS != null ? languageForTTS : "en", false);
                audioPlayerForTTS.onPlayerStateChanged.listen((event) async {
                  if (event == AudioPlayerState.PLAYING) {
                    isAudioPlayerPlaying = true;
                  }
                  if (event == AudioPlayerState.COMPLETED) {
                    conversations[conversations.length - 1].isSpeaking = false;
                    notifyListeners();
                    if (!isButtonResponse) {
                      gettingReposnseFromNative();
                    }
                  }
                  if (event == AudioPlayerState.PAUSED ||
                      event == AudioPlayerState.STOPPED) {
                    conversations[conversations.length - 1].isSpeaking = false;
                    notifyListeners();
                    // if (!isButtonResponse) {
                    //   gettingReposnseFromNative();
                    // }
                  }
                });
              }
            }
          });
          return jsonResponse;
        }
      }
    } else {
      FlutterToast().getToast(
          'There is some issue with sheela,\n Please try after some time',
          Colors.black54);
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
    Service mService = Service();
    final response = await mService.getAudioFileTTS(reqJson);

    if (response.statusCode == 200) {
      if (response.body != null) {
        final data = jsonDecode(response.body);
        final result = data["result"];
        if (result != null) {
          final audioContent = result["audioContent"];
          if (audioContent != null) {
            final bytes = Base64Decoder().convert(audioContent);
            if (bytes != null) {
              final dir = await getTemporaryDirectory();
              final file = File('${dir.path}/wavenet.mp3');
              await file.writeAsBytes(bytes);
              final path = dir.path + "/wavenet.mp3";
              if (isTTS) {
                newAudioPlay1.play(path, isLocal: true);
              } else {
                audioPlayerForTTS.play(path, isLocal: true);
              }
            }
          }
        }
      }
    } else {
      FlutterToast().getToast(
          'There is some issue with sheela,\n Please try after some time',
          Colors.black54);
    }

    // } else if (Platform.isAndroid) {
    //   newAudioPlay.playBytes(bytes);
    // }

    //print(dir.path);
  }

  stopAudioPlayer() {
    audioPlayerForTTS?.stop();
    newAudioPlay1?.stop();
  }

  Future<void> gettingReposnseFromNative() async {
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
}
