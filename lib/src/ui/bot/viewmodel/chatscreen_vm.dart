import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:audioplayer/audioplayer.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:gmiwidgetspackage/widgets/flutterToast.dart';
import 'package:intl/intl.dart';
import 'package:myfhb/QurHub/Controller/hub_list_controller.dart';
import 'package:myfhb/Qurhome/BleConnect/ApiProvider/ble_connect_api_provider.dart';
import 'package:myfhb/Qurhome/BleConnect/Models/ble_data_model.dart';
import 'package:myfhb/Qurhome/BpScan/model/ble_bp_data_model.dart';
import 'package:myfhb/Qurhome/QurhomeDashboard/Controller/QurhomeDashboardController.dart';
import 'package:myfhb/Qurhome/QurhomeDashboard/Controller/QurhomeRegimenController.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

import '../../../../common/CommonConstants.dart';
import '../../../../common/PreferenceUtil.dart';
import '../../../../constants/fhb_constants.dart' as Constants;
import '../../../../constants/fhb_constants.dart' as constants;
import '../../../../constants/fhb_parameters.dart' as parameters;
import '../../../../constants/router_variable.dart' as routervariable;
import '../../../../constants/variable_constant.dart' as variable;
import '../../../../my_family/screens/MyFamily.dart';
import '../../../../telehealth/features/appointments/view/appointmentsMain.dart';
import '../../../../widgets/checkout_page.dart';
import '../../../blocs/health/HealthReportListForUserBlock.dart';
import '../../../model/CreateDeviceSelectionModel.dart';
import '../../../model/GetDeviceSelectionModel.dart';
import '../../../model/UpdatedDeviceModel.dart';
import '../../../model/bot/ConversationModel.dart';
import '../../../model/bot/SpeechModelResponse.dart';
import '../../../model/bot/button_model.dart';
import '../../../model/user/MyProfileModel.dart';
import '../../../model/user/Tags.dart';
import '../../../model/user/user_accounts_arguments.dart';
import '../../../resources/repository/health/HealthReportListForUserRepository.dart';
import '../../../utils/FHBUtils.dart';
import '../common/botutils.dart';
import '../service/sheela_service.dart';

class ChatScreenViewModel extends ChangeNotifier {
  static MyProfileModel prof =
      PreferenceUtil.getProfileData(constants.KEY_PROFILE);
  List<Conversation> conversations = new List();
  var uuid = Uuid().v1();
  var user_id;
  var user_name;
  var auth_token;
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
  int playingIndex = 0;
  bool isMicListening = false;
  bool disableMic = false;

  List<Conversation> get getMyConversations => conversations;
  bool movedToBackScreen = false;

  int get getisMayaSpeaks => isMayaSpeaks;
  AudioPlayer audioPlayerForTTS = AudioPlayer();
  AudioPlayer newAudioPlay1 = AudioPlayer();
  bool isAudioPlayerPlaying = false;

  bool get getIsButtonResponse => isButtonResponse && !enableMic;
  CreateDeviceSelectionModel createDeviceSelectionModel;
  List<Tags> tagsList = new List<Tags>();
  static const stream = EventChannel('QurbookBLE/stream');
  StreamSubscription _timerSubscription;

  bool allowAppointmentNotification = true;
  bool allowVitalNotification = true;
  bool allowSymptomsNotification = true;
  HubListController hublistController;
  QurhomeDashboardController qurhomeController;
  String eId;

  void updateAppState(bool canSheelaSpeak, {bool isInitial: false}) {
    if (disableMic) {
      isLoading = true;
    } else {
      canSpeak = canSheelaSpeak;
      if (!canSheelaSpeak) {
        isLoading = false;
        stopTTSEngine();
      }
      if (!isInitial) notifyListeners();
    }
  }

  void clearMyConversation() {
    conversations = [];
    // notifyListeners();
  }

  void reEnableMicButton() {
    isButtonResponse = false;
    notifyListeners();
  }

  void _disableTimer() {
    if (_timerSubscription != null) {
      _timerSubscription.cancel();
      _timerSubscription = null;
    }
  }

  disposeTimer() {
    _disableTimer();
  }

  void _enableTimer() {
    disableMic = true;
    movedToBackScreen = false;
    _timerSubscription ??= stream.receiveBroadcastStream().listen((val) {
      // print(val);

      List<String> receivedValues = val.split('|');
      if ((receivedValues ?? []).length > 0) {
        switch ((receivedValues.first ?? "")) {
          case "enablebluetooth":
            FlutterToast()
                .getToast(receivedValues.last ?? 'Request Timeout', Colors.red);
            break;
          case "permissiondenied":
            FlutterToast()
                .getToast(receivedValues.last ?? 'Request Timeout', Colors.red);
            break;
          case "scanstarted":
            // FlutterToast()
            //     .getToast(receivedValues.last ?? 'Request Timeout', Colors.red);
            break;
          case "connectionfailed":
            // moveToBack();
            // FlutterToast()
            //     .getToast(receivedValues.last ?? 'Request Timeout', Colors.red);
            break;
          case "connected":
            // addToSheelaConversation(
            //     text: receivedValues.last ?? 'Request Timeout');
            break;
          case "measurement":
            updateUserData(data: receivedValues.last);
            break;
          case "disconnected":
            // FlutterToast()
            //     .getToast(receivedValues.last ?? 'Request Timeout', Colors.red);
            moveToBack();
            break;

          default:
          // FlutterToast()
          //     .getToast(receivedValues.last ?? 'Request Timeout', Colors.red);
        }
      }
    });
  }

  moveToBack({bool showFailure = true}) async {
    try {
      if (!movedToBackScreen) {
        if (showFailure) {
          addToSheelaConversation(
              text: "Failed to measure values. Please try again");
        }
        await Future.delayed(Duration(seconds: 4));
        movedToBackScreen = true;
        updateAppState(false);
        stopTTSEngine();
        final QurhomeDashboardController qurhomeDashboardController =
            Get.find();
        qurhomeDashboardController.updateTabIndex(0);
        final QurhomeRegimenController qurhomeRegimenController = Get.find();
        qurhomeRegimenController.getRegimenList();
        Get.back();
      }
    } catch (e) {
      print(e);
    }
  }

  setupListenerForReadings() async {
    await Future.delayed(Duration(seconds: 4));
    //addToSheelaConversation(text: "Checking for SpO2 value");
    _enableTimer();
    Future.delayed(Duration(seconds: 30)).then((value) {
      if (_timerSubscription != null) {
        moveToBack();
      }
    });
  }

  updateUserData({String data = ''}) async {
    if ((data ?? '').isNotEmpty) {
      disposeTimer();
      // addToSheelaConversation(text: "Uploading your data");
      try {
        hublistController = Get.find<HubListController>();
        var model = BleDataModel.fromJson(
          jsonDecode(data),
        );
        model.hubId = hublistController.virtualHubId;
        model.deviceId = hublistController.bleMacId.value;
        model.eid = hublistController.eid;
        model.uid = hublistController.uid;
        var now = DateTime.now();
        var formatterDateTime = DateFormat('yyyy-MM-dd HH:mm:ss');
        String actualDateTime = formatterDateTime.format(now);
        model.ackLocal = actualDateTime;
        hublistController.eid = null;
        hublistController.uid = null;
       /* await Future.delayed(Duration(
          seconds: 2,
        ));
        addToSheelaConversation(
          text: "Completed ",
        );*/
        /*await Future.delayed(Duration(
          seconds: 3,
        ));
        addToSheelaConversation(
          text:
              "Your SpO2 is  ${model.data.sPO2} and Pulse is ${model.data.pulse}",
        );*/
        bool response = await BleConnectApiProvider().uploadBleDataReadings(
          model,
        );
        await Future.delayed(Duration(
          seconds: 5,
        ));
        addToSheelaConversation(
          text: response
              ? "Thank you. Your SpO2 is  ${model.data.sPO2} and Pulse is ${model.data.pulse} is successfully recorded, Bye!"
              : "Failed to save the values, Please try again",
        );
        moveToBack(showFailure: false);
      } catch (e) {
        addToSheelaConversation(
          text: "Failed to save the values, Please try again",
        );
        moveToBack(showFailure: false);
      }
    }
  }

  updateBPUserData() async {
    try {
      hublistController = Get.find<HubListController>();
      qurhomeController = Get.find<QurhomeDashboardController>();
      var now = DateTime.now();
      var formatterDateTime = DateFormat('yyyy-MM-dd HH:mm:ss');
      String actualDateTime = formatterDateTime.format(now);
      await Future.delayed(Duration(
        seconds: 2,
      ));
      bool response = await BleConnectApiProvider().uploadBleBPDataReadings(
          ackLocal: actualDateTime,
          hubId: hublistController.virtualHubId,
          eId: hublistController.eid,
          uId: hublistController.uid,
          qurHomeBpScanResult: qurhomeController?.qurHomeBpScanResultModel);
      addToSheelaConversation(
        text: response
            ? "Thank you. Your BP systolic is ${qurhomeController?.qurHomeBpScanResultModel?.measurementRecords[0].systolicKey} "
                ", Diastolic is ${qurhomeController?.qurHomeBpScanResultModel?.measurementRecords[0].diastolicKey} "
                "and Pulse is ${qurhomeController?.qurHomeBpScanResultModel?.measurementRecords[0].pulseRateKey} is successfully recorded, Bye!"
            : "Failed to save the values, please try again",
      );
      await Future.delayed(Duration(
        seconds: 12,
      ));
      moveToBack(showFailure: false);
    } catch (e) {
      addToSheelaConversation(
        text: "Failed to save the values, please try again",
      );
      moveToBack(showFailure: false);
    }
  }

  ChatScreenViewModel() {
    prof = PreferenceUtil.getProfileData(constants.KEY_PROFILE);
    user_name = prof.result != null
        ? prof.result.firstName + ' ' + prof.result.lastName
        : '';
    user_id = PreferenceUtil.getStringValue(constants.KEY_USERID);
  }

  addToSheelaConversation({String text = ''}) async {
    // if (!isMicListening) {
    //   isMicListening = true;
    //   notifyListeners();
    // }
    isLoading = true;
    Conversation model = new Conversation(
      isMayaSaid: true,
      text: text,
      name: prof.result != null
          ? prof.result.firstName + ' ' + prof.result.lastName
          : '',
    );
    conversations.add(model);
    isMayaSpeaks = 0;
    final lan = Utils.getCurrentLanCode();
    String langCodeForRequest;
    if (lan != "undef") {
      final langCode = lan.split("-").first;
      langCodeForRequest = langCode;
      //print(langCode);
    }
    // isLoading = false;
    conversations[conversations.length - 1].isSpeaking = true;
    isSheelaSpeaking = true;
    notifyListeners();
    var response = await variable.tts_platform.invokeMethod(variable.strtts, {
      parameters.strMessage: text,
      parameters.strIsClose: false,
      parameters.strLanguage: langCodeForRequest
    });
    if (response == 1) {
      isMayaSpeaks = 1;
    }
    conversations[conversations.length - 1].isSpeaking = false;
    isSheelaSpeaking = false;
    notifyListeners();
  }

  startMayaAutomatically({String message}) {
    isLoading = true;
    Future.delayed(Duration(seconds: 1), () {
      _screen = parameters.strSheela;
      sendToMaya(
          ((message ?? '').isNotEmpty)
              ? '/provider_message'
              : variable.strhiMaya,
          screen: _screen,
          providerMsg:
              (message != null && message.isNotEmpty) ? message : null);
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

  Future<void> stopTTSEngine({
    int index,
    String langCode,
    bool isInitial = false,
  }) async {
    stopTTS = true;
    if (!isInitial) {
      notifyListeners();
    }
    if (index != null) {
      conversations[index].isSpeaking = false;
      isSheelaSpeaking = false;
    } else {
      conversations.forEach((conversation) {
        conversation.isSpeaking = false;
      });
      isSheelaSpeaking = false;
    }
    conversations.forEach((conversation) {
      conversation.buttons?.forEach((button) {
        button.isPlaying = false;
      });
    });
    isSheelaSpeaking = false;
    if (!isInitial) {
      notifyListeners();
    }

    stopAudioPlayer();
    final lan = langCode != null && langCode.isNotEmpty
        ? langCode
        : Utils.getCurrentLanCode();
    // if (Platform.isIOS) {
    if (lan == "undef" ||
        lan.toLowerCase() == "en-IN".toLowerCase() ||
        lan.toLowerCase() == "en-US".toLowerCase()) {
      await variable.tts_platform.invokeMethod(variable.strtts, {
        parameters.strMessage: "",
        parameters.strIsClose: true,
        parameters.strLanguage: Utils.getCurrentLanCode()
      });
    } else {
      if (!isInitial) {
        notifyListeners();
      }
    }
    // } else {
    //   notifyListeners();
    // }
  }

  Future<bool> startTTSEngine({
    String textToSpeak,
    int index,
    String langCode,
    bool stopPrevious: true,
    bool isRegiment: false,
    bool isButtonText: false,
    Function onStop,
    String dynamicText,
  }) async {
    if (stopPrevious) {
      stopTTSEngine();
    }
    isMicListening = false;
    stopTTS = false;
    if (canSpeak) {
      if (index != null) {
        playingIndex = index;
        conversations[index].isSpeaking = true;
        isSheelaSpeaking = true;
        notifyListeners();
      }
      final lan = langCode != null && langCode.isNotEmpty
          ? langCode
          : Utils.getCurrentLanCode();
      if (Platform.isIOS) {
        if (lan == "undef" ||
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
              if (isRegiment) {
                onStop();
              }
            }
          });
        } else if (isRegiment) {
          String langCodeForRequest;
          if (lan != "undef") {
            final langCode = lan.split("-").first;
            langCodeForRequest = langCode;
            //print(langCode);
          }
          newAudioPlay1 = AudioPlayer();
          final languageForTTS =
              langCodeForRequest ?? Utils.getCurrentLanCode();
          newAudioPlay1.onPlayerStateChanged.listen((event) async {
            if (event == AudioPlayerState.COMPLETED ||
                event == AudioPlayerState.PAUSED ||
                event == AudioPlayerState.STOPPED) {
              if (index != null && stopPrevious && !isButtonText) {
                conversations[index].isSpeaking = false;
                isSheelaSpeaking = false;
                notifyListeners();
              }
              if (isRegiment) {
                onStop();
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
          if (isRegiment) {
            await getGoogleTTSRegiment(
              staticText: textToSpeak,
              dynamicText: dynamicText,
              langCode: languageForTTS != null ? languageForTTS : "en",
            );
          } else {
            await getGoogleTTSResponse(textToSpeak,
                languageForTTS != null ? languageForTTS : "en", true);
          }
        }
      } else {
        if (lan == "undef" ||
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
              if (isRegiment) {
                onStop();
              }
            }
          });
        } else {
          String langCodeForRequest;
          if (lan != "undef") {
            final langCode = lan.split("-").first;
            langCodeForRequest = langCode;
          }
          newAudioPlay1 = AudioPlayer();
          final languageForTTS =
              langCodeForRequest ?? Utils.getCurrentLanCode();
          newAudioPlay1.onPlayerStateChanged.listen((event) async {
            if (event == AudioPlayerState.COMPLETED ||
                event == AudioPlayerState.PAUSED ||
                event == AudioPlayerState.STOPPED) {
              if (index != null && stopPrevious && !isButtonText) {
                conversations[index].isSpeaking = false;
                isSheelaSpeaking = false;
                notifyListeners();
              }
              if (isRegiment) {
                onStop();
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
          if (isRegiment) {
            await getGoogleTTSRegiment(
              staticText: textToSpeak,
              dynamicText: dynamicText,
              langCode: languageForTTS != null ? languageForTTS : "en",
            );
          } else {
            await getGoogleTTSResponse(textToSpeak,
                languageForTTS != null ? languageForTTS : "en", true);
          }
        }
      }
    }
  }

  startSheelaFromButton({
    String buttonText,
    String payload,
    bool isRedirectionNeed = false,
  }) async {
    stopTTSEngine();

    if (!isRedirectionNeed) {
      Future.delayed(Duration(seconds: 1), () {
        sendToMaya(payload, screen: _screen);
      });

      var date =
          new FHBUtils().getFormattedDateString(DateTime.now().toString());
      Conversation model = new Conversation(
          isMayaSaid: false,
          text: buttonText,
          name: prof.result != null
              ? prof.result.firstName + ' ' + prof.result.lastName
              : '',
          timeStamp: date,
          redirect: isRedirect,
          screen: _screen);

      conversations.add(model);
      notifyListeners();
    }
    Future.delayed(Duration(seconds: 3), () {
      conversations.forEach((conversation) {
        conversation.buttons?.forEach((button) {
          button.isSelected = false;
        });
      });
      notifyListeners();
    });
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
              ? prof.result.firstName + ' ' + prof.result.lastName
              : '',
          timeStamp: date,
          redirect: isRedirect,
          screen: _screen);

      conversations.add(model);
      // notifyListeners();
    }
  }

  askUserForLanguage({String message}) {
    Future.delayed(Duration(seconds: 1), () {
      _screen = parameters.strSheela;
      sendToMaya(
          ((message ?? '').isNotEmpty)
              ? '/provider_message'
              : variable.strhiMaya,
          screen: _screen,
          providerMsg:
              (message != null && message.isNotEmpty) ? message : null);
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

  sendToMaya(
    String msg, {
    String screen,
    String providerMsg,
  }) async {
    prof = await PreferenceUtil.getProfileData(constants.KEY_PROFILE);
    auth_token = await PreferenceUtil.getStringValue(constants.KEY_AUTHTOKEN);
    user_name = prof.result != null
        ? prof.result.firstName + ' ' + prof.result.lastName
        : '';

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
    reqJson[parameters.strProviderMsg] = providerMsg;
    if (eId != null) {
      reqJson[parameters.KIOSK_data] = {
        parameters.KIOSK_task: parameters.KIOSK_remind,
        parameters.KIOSK_eid: eId
      };
      eId = null;
    }
    screenValue = screen;
    isLoading = true;

    Service mService = Service();
    final response = await mService.sendMetaToMaya(reqJson);

    if (response != null && response?.statusCode == 200) {
      isMicListening = false;
      if (response.body != null) {
        final jsonResponse = jsonDecode(response.body);

        List<dynamic> list = jsonResponse;
        if (list.length > 0) {
          SpeechModelResponse res = SpeechModelResponse.fromJson(list[0]);
          if ((conversations?.length ?? 0) == 0 ||
              (conversations?.length > 0 &&
                  (res?.text ?? '') !=
                      conversations[conversations?.length - 1].text)) {
            isEndOfConv = res.endOfConv;
            isRedirect = res.redirect;
            PreferenceUtil.saveString(constants.SHEELA_LANG, res.lang);
            var date = new FHBUtils()
                .getFormattedDateString(DateTime.now().toString());
            Conversation model = new Conversation(
                isMayaSaid: true,
                text: res.text,
                name: prof.result != null
                    ? prof.result.firstName + ' ' + prof.result.lastName
                    : '',
                imageUrl: res.imageURL,
                timeStamp: date,
                buttons: res.buttons,
                langCode: res.lang,
                searchURL: res.searchURL,
                videoLinks: res.videoLinks,
                redirect: isRedirect,
                screen: screenValue,
                isSpeaking: false,
                provider_msg: res.provider_msg,
                singleuse: res.singleuse,
                isActionDone: res.isActionDone,
                redirectTo: res.redirectTo);
            if (res.text == null || res.text == '') {
              isLoading = false;
            }
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
                      conversations[conversations.length - 1].isSpeaking =
                          false;
                      isSheelaSpeaking = false;
                      notifyListeners();
                      if (!isEndOfConv) {
                        gettingReposnseFromNative();
                      } else {
                        refreshData();
                        /* Future<dynamic>.delayed(const Duration(seconds: 2),
                            () async {
                          if (conversations[conversations.length - 1]
                                      .redirectTo !=
                                  null &&
                              conversations[conversations.length - 1]
                                  .redirectTo
                                  .contains('myfamily_list')) {
                            Get.toNamed(
                              routervariable.rt_UserAccounts,
                              arguments: UserAccountsArguments(
                                selectedIndex: 1,
                              ),
                            );

                            FlutterToast()
                                .getToast('Redirecting...', Colors.black54);
                          } else if (conversations[conversations.length - 1]
                                      .redirectTo !=
                                  null &&
                              conversations[conversations.length - 1]
                                  .redirectTo
                                  .contains('mycart')) {
                            Get.to(CheckoutPage());

                            FlutterToast()
                                .getToast('Redirecting...', Colors.black54);
                          } else if (conversations[conversations.length - 1]
                                      .redirectTo !=
                                  null &&
                              conversations[conversations.length - 1]
                                  .redirectTo
                                  .contains('appointmentList')) {
                            Get.to(AppointmentsMain());

                            FlutterToast()
                                .getToast('Redirecting...', Colors.black54);
                          }
                        }); */
                      }
                    } else {
                      playingIndex = conversations.length - 1;
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
                        } else {
                          Future<dynamic>.delayed(const Duration(seconds: 2),
                              () {
                            if (conversations[conversations.length - 1]
                                        .redirectTo !=
                                    null &&
                                conversations[conversations.length - 1]
                                    .redirectTo
                                    .contains('myfamily_list')) {
                              //Get.to(MyFamily());
                              Get.toNamed(
                                routervariable.rt_UserAccounts,
                                arguments: UserAccountsArguments(
                                  selectedIndex: 1,
                                ),
                              );

                              FlutterToast()
                                  .getToast('Redirecting...', Colors.black87);
                            } else if (conversations[conversations.length - 1]
                                        .redirectTo !=
                                    null &&
                                conversations[conversations.length - 1]
                                    .redirectTo
                                    .contains('mycart')) {
                              Get.to(CheckoutPage());

                              FlutterToast()
                                  .getToast('Redirecting...', Colors.black54);
                            } else if (conversations[conversations.length - 1]
                                        .redirectTo !=
                                    null &&
                                conversations[conversations.length - 1]
                                    .redirectTo
                                    .contains('appointmentList')) {
                              Get.to(AppointmentsMain());

                              FlutterToast()
                                  .getToast('Redirecting...', Colors.black54);
                            }
                          });
                        }
                      } else {
                        playingIndex = conversations.length - 1;
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
                        playingIndex = conversations.length - 1;
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
          } else {
            isLoading = false;
            notifyListeners();
          }
          return jsonResponse;
        } else {
          isLoading = false;
          notifyListeners();
        }
      } else {
        isLoading = false;
        notifyListeners();
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
    if ((buttons?.length ?? 0) > 0 && playingIndex == index) {
      stopTTS = false;
      Conversation recentConversation = conversations[index];
      await Future.forEach(buttons, (Buttons button) async {
        if (stopTTS || playingIndex != index) {
          // if ((recentConversation?.buttons?.length ?? 0) > 0) {
          //   recentConversation.buttons.forEach((button) {
          //     button.isPlaying = false;
          //   });
          // }
          // notifyListeners();
          // if (recentConversation.isSpeaking ?? false) {
          // stopTTSEngine(index: index);
          // }
          return;
        } else if (!button?.skipTTS) {
          if ((recentConversation?.buttons?.length ?? 0) > 0) {
            recentConversation
                .buttons[recentConversation.buttons?.indexOf(button)]
                .isPlaying = true;
          }
          notifyListeners();
          await startTTSEngine(
            langCode: langCode,
            index: index,
            textToSpeak: button.title,
            stopPrevious: false,
          );
          if ((recentConversation?.buttons?.length ?? 0) > 0) {
            recentConversation
                .buttons[recentConversation.buttons?.indexOf(button)]
                .isPlaying = false;
          }
          notifyListeners();
        }
      });
      stopTTSEngine(index: index);
      // conversations[index].isSpeaking = false;
      // isSheelaSpeaking = false;
      // notifyListeners();
    }
    // else {
    //   stopTTSEngine();
    // }
  }

  getGoogleTTSResponse(String dataForVoice, String langCode, bool isTTS) async {
    // final str =
    //     "https://heyr2.com/tts/ws_tts.php?key=67ca0bad-83a8-4f1b-a31b-5a1f2380b385&Action=GetSpeech&json=1&lang=" +
    //         langCode +
    //         "&ttsdata=" +
    //         dataForVoice;
    // final response = await ApiServices.get(
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

    if (response.statusCode == 200 && response.body != null) {
      final data = jsonDecode(response.body);
      final result = data["payload"];
      if (result != null && (data['isSuccess'] ?? false)) {
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
              await Future.delayed(Duration(milliseconds: 500), () async {
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
      } else {
        isLoading = false;
        stopTTSEngine();
        notifyListeners();
        FlutterToast().getToast(
            'There is some issue with sheela,\n Please try after some time',
            Colors.black54);
      }
    } else {
      isLoading = false;
      notifyListeners();
      stopTTSEngine();
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
  }

  stopAudioPlayer() {
    if (audioPlayerForTTS.state == AudioPlayerState.PLAYING) {
      audioPlayerForTTS?.stop();
    }
    if (newAudioPlay1.state == AudioPlayerState.PLAYING) {
      newAudioPlay1?.stop();
    }
  }

  Future<void> gettingReposnseFromNative() async {
    stopTTSEngine();
    try {
      var micStatus = await variable.voice_platform
          .invokeMethod(variable.strvalidateMicAvailablity);
      if (micStatus) {
        if (!isMicListening) {
          isMicListening = true;
          notifyListeners();
          await variable.voice_platform.invokeMethod(variable.strspeakAssistant,
              {'langcode': Utils.getCurrentLanCode()}).then((response) {
            isMicListening = false;
            notifyListeners();
            if ((response ?? '').toString()?.isNotEmpty) {
              sendToMaya(response, screen: screenValue);
              var date = new FHBUtils()
                  .getFormattedDateString(DateTime.now().toString());
              Conversation model = new Conversation(
                  isMayaSaid: false,
                  text: response,
                  name: prof.result != null
                      ? prof.result.firstName + ' ' + prof.result.lastName
                      : '',
                  timeStamp: date,
                  redirect: isRedirect,
                  screen: screenValue);
              conversations.add(model);
              notifyListeners();
            }
          }).whenComplete(() {
            isMicListening = false;
            notifyListeners();
          }).onError((error, stackTrace) {
            isMicListening = false;
            notifyListeners();
          });
        }
      } else {
        FlutterToast().getToast(CommonConstants.strMicAlertMsg, Colors.black);
      }
    } on PlatformException catch (e) {
      isMicListening = false;
      notifyListeners();
    }
  }

  void refreshData() {
    var _healthReportListForUserBlock = new HealthReportListForUserBlock();
    _healthReportListForUserBlock.getHelthReportLists().then((value) {
      PreferenceUtil.saveCompleteData(constants.KEY_COMPLETE_DATA, value);
    });
  }

  Future<void> getDeviceSelectionValues({String preferredLanguage}) async {
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
          allowAppointmentNotification = true;
          allowSymptomsNotification = true;
          allowVitalNotification = true;
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
        allowAppointmentNotification = true;
        allowSymptomsNotification = true;
        allowVitalNotification = true;

        var userId = PreferenceUtil.getStringValue(Constants.KEY_USERID);
        healthReportListForUserRepository
            .createDeviceSelection(
                _isdigitRecognition,
                _isdeviceRecognition,
                _isGFActive,
                _isHKActive,
                _isBPActive,
                _isGLActive,
                _isOxyActive,
                _isTHActive,
                _isWSActive,
                userId,
                preferred_language,
                qa_subscription,
                preColor,
                greColor,
                tagsList,
                allowAppointmentNotification,
                allowVitalNotification,
                allowSymptomsNotification)
            .then((value) {
          createDeviceSelectionModel = value;
          if (createDeviceSelectionModel.isSuccess) {
            updateDeviceSelectionModel(preferredLanguage: preferredLanguage);
          } else {
            var userId = PreferenceUtil.getStringValue(Constants.KEY_USERID);
            healthReportListForUserRepository
                .createDeviceSelection(
                    _isdigitRecognition,
                    _isdeviceRecognition,
                    _isGFActive,
                    _isHKActive,
                    _isBPActive,
                    _isGLActive,
                    _isOxyActive,
                    _isTHActive,
                    _isWSActive,
                    userId,
                    preferred_language,
                    qa_subscription,
                    preColor,
                    greColor,
                    tagsList,
                    allowAppointmentNotification,
                    allowVitalNotification,
                    allowSymptomsNotification)
                .then((value) {
              createDeviceSelectionModel = value;
              if (createDeviceSelectionModel.isSuccess) {
                updateDeviceSelectionModel(
                    preferredLanguage: preferredLanguage);
              }
            });
          }
        });
      }
    });
  }

  setValues(GetDeviceSelectionModel getDeviceSelectionModel) {
    preColor = getDeviceSelectionModel.result[0].profileSetting.preColor;
    greColor = getDeviceSelectionModel.result[0].profileSetting.greColor;
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

    tagsList = getDeviceSelectionModel.result[0].tags != null &&
            getDeviceSelectionModel.result[0].tags.length > 0
        ? getDeviceSelectionModel.result[0].tags
        : new List();

    allowAppointmentNotification = getDeviceSelectionModel
                    .result[0].profileSetting.caregiverCommunicationSetting !=
                null &&
            getDeviceSelectionModel
                    .result[0].profileSetting.caregiverCommunicationSetting !=
                ''
        ? getDeviceSelectionModel.result[0].profileSetting
            .caregiverCommunicationSetting?.appointments
        : true;

    allowVitalNotification = getDeviceSelectionModel
                    .result[0].profileSetting.caregiverCommunicationSetting !=
                null &&
            getDeviceSelectionModel
                    .result[0].profileSetting.caregiverCommunicationSetting !=
                ''
        ? getDeviceSelectionModel
            .result[0].profileSetting.caregiverCommunicationSetting?.vitals
        : true;

    allowSymptomsNotification = getDeviceSelectionModel
                    .result[0].profileSetting.caregiverCommunicationSetting !=
                null &&
            getDeviceSelectionModel
                    .result[0].profileSetting.caregiverCommunicationSetting !=
                ''
        ? getDeviceSelectionModel
            .result[0].profileSetting.caregiverCommunicationSetting?.symptoms
        : true;
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
            greColor,
            tagsList,
            allowAppointmentNotification,
            allowVitalNotification,
            allowSymptomsNotification)
        .then(
      (value) {
        if (value?.isSuccess ?? false) {
          getDeviceSelectionValues(
              preferredLanguage: preferredLanguage ?? preferred_language);
        } else {
          var userId = PreferenceUtil.getStringValue(Constants.KEY_USERID);
          healthReportListForUserRepository
              .createDeviceSelection(
                  _isdigitRecognition,
                  _isdeviceRecognition,
                  _isGFActive,
                  _isHKActive,
                  _isBPActive,
                  _isGLActive,
                  _isOxyActive,
                  _isTHActive,
                  _isWSActive,
                  userId,
                  preferred_language,
                  qa_subscription,
                  preColor,
                  greColor,
                  tagsList,
                  allowAppointmentNotification,
                  allowVitalNotification,
                  allowSymptomsNotification)
              .then((value) {
            createDeviceSelectionModel = value;
            if (createDeviceSelectionModel.isSuccess) {
              updateDeviceSelectionModel(preferredLanguage: preferredLanguage);
            }
          });
        }
      },
    );
  }

  getGoogleTTSRegiment(
      {String staticText, String dynamicText, String langCode}) async {
    Map<String, dynamic> reqJson = {};
    reqJson[parameters.regimentInput] = staticText;
    reqJson[parameters.regimentToTranslateInput] = dynamicText;
    reqJson[parameters.regimentSource] = 'en';
    reqJson[parameters.regimentTarget] = langCode;
    reqJson[parameters.regimentFormat] = 'text';
    reqJson[parameters.regimentAudioEncoding] = 'MP3';
    reqJson[parameters.regimentIsAudioFile] = false;

    Service mService = Service();
    final response = await mService.getAudioFileRegiments(reqJson);

    if (response.statusCode == 200) {
      try {
        if (response.body != null) {
          final data = jsonDecode(response.body);
          final result = data["payload"];
          if (result != null) {
            final audioContent = result["audioContent"];
            if (audioContent != null) {
              final bytes = Base64Decoder().convert(audioContent);
              if (bytes != null) {
                String path;
                if (Platform.isIOS) {
                  final Directory dir = await getTemporaryDirectory();
                  Directory dirFolder = Directory("${dir.path}/regiment");
                  if (await dirFolder.exists()) {
                    await dirFolder.delete(recursive: true);
                  }
                  dirFolder = await dirFolder.create(recursive: true);
                  final id = DateTime.now().millisecondsSinceEpoch;
                  if (await dir.exists()) {}
                  var file = File(dirFolder.path + "/$id.mp3");
                  if (await file.exists()) {
                    print(await file.lastModified());
                    await file.delete();
                  }

                  if (await file.exists()) {
                    file.delete();
                  } else {
                    file = File(dirFolder.path + "/$id.mp3");
                  }
                  await file.writeAsBytes(bytes);
                  print(await file.lastModified());
                  path = file.path;
                } else {
                  final dir = await getTemporaryDirectory();
                  final file = File('${dir.path}/wavenet.mp3');
                  await file.writeAsBytes(bytes);
                  path = dir.path + "/wavenet.mp3";
                }
                if (canSpeak) {
                  print(path);
                  newAudioPlay1.play(path, isLocal: true);
                  await Future.delayed(Duration(milliseconds: 500), () async {
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
      } catch (e) {
        print(e);
        isLoading = false;
        notifyListeners();
        FlutterToast().getToast(
          'There is some issue in translation,\n Please try after some time',
          Colors.black54,
        );
      }
    } else {
      isLoading = false;
      notifyListeners();
      FlutterToast().getToast(
        'There is some issue in translation,\n Please try after some time',
        Colors.black54,
      );
    }

    // } else if (Platform.isAndroid) {
    //   newAudioPlay.playBytes(bytes);
    // }

    //print(dir.path);
  }
}
