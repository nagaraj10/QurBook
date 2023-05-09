import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:gmiwidgetspackage/widgets/flutterToast.dart';
import 'package:myfhb/Qurhome/QurhomeDashboard/View/QurHomeRegimen.dart';
import 'package:myfhb/common/CommonUtil.dart';
import 'package:myfhb/constants/router_variable.dart';
import 'package:myfhb/src/model/user/user_accounts_arguments.dart';
import 'package:myfhb/src/ui/SheelaAI/Services/SheelaBadgeServices.dart';
import 'package:myfhb/reminders/QurPlanReminders.dart';
import 'package:myfhb/src/ui/user/UserAccounts.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

import '../../../../common/CommonUtil.dart';
import '../../../../common/PreferenceUtil.dart';
import '../../../../common/keysofmodel.dart';
import '../../../../constants/fhb_constants.dart';
import '../../../../constants/fhb_parameters.dart';
import '../../../../constants/variable_constant.dart';
import '../../../../reminders/QurPlanReminders.dart';
import '../../../blocs/health/HealthReportListForUserBlock.dart';
import '../../../model/CreateDeviceSelectionModel.dart';
import '../../../model/GetDeviceSelectionModel.dart';
import '../../../model/user/MyProfileModel.dart';
import '../../../resources/repository/health/HealthReportListForUserRepository.dart';
import '../Models/DeviceStatus.dart';
import '../Models/GoogleTTSRequestModel.dart';
import '../Models/GoogleTTSResponseModel.dart';
import '../Models/SheelaRequest.dart';
import '../Models/SheelaResponse.dart';
import '../Models/sheela_arguments.dart';
import '../Services/SheelaAIAPIServices.dart';
import '../Services/SheelaAIBLEServices.dart';

class SheelaAIController extends GetxController {
  MyProfileModel? profile;
  String? authToken;
  String? userName;
  String? sessionToken;
  String? userId;
  Rx<bool> isLoading = false.obs;
  Rx<bool> isMicListening = false.obs;
  bool canSpeak = false;
  List conversations = [].obs;
  SheelaResponse? currentPlayingConversation;
  int? indexOfCurrentPlayingConversation;
  AudioPlayer? player;
  ScrollController scrollController = ScrollController();

  //Just make it true for using local tts,
  //rest of the cases will be auto handled .
  bool useLocalTTSEngine = false;
  SheelaArgument? arguments;
  SheelaBLEController? bleController;
  bool isSheelaScreenActive = false;
  int randomNum = 0;
  String? relationshipId;
  String? conversationFlag;
  Map<dynamic, dynamic>? additionalInfo = {};
  bool lastMsgIsOfButtons = false;
  late AudioCache _audioCache;
  Timer? _popTimer;
  var sheelaIconBadgeCount = 0.obs;
  bool isUnAvailableCC = false;
  bool isProd = false;
  SheelaBadgeServices sheelaBadgeServices = SheelaBadgeServices();

  @override
  void onInit() {
    super.onInit();
    setDefaultValues();
  }

  setDefaultValues() async {
    if (BASE_URL == prodINURL) {
      isProd = true;
    } else if (BASE_URL == prodUSURL) {
      isProd = true;
    }
    if (Platform.isIOS) {
      _audioCache = AudioCache();
      _audioCache.loadAll(['raw/Negative.mp3', 'raw/Positive.mp3']);
    }
    profile = PreferenceUtil.getProfileData(KEY_PROFILE);
    authToken = PreferenceUtil.getStringValue(KEY_AUTHTOKEN);
    userId = PreferenceUtil.getStringValue(KEY_USERID);
    relationshipId = userId;
    userName = profile?.result != null
        ? '${profile!.result!.firstName} ${profile!.result!.lastName}'
        : '';
    conversationFlag = null;
    additionalInfo = {};
    player = AudioPlayer();
    listnerForAudioPlayer();
    if (Platform.isIOS) {
      tts_platform.setMethodCallHandler((call) {
        if (call.method == tts_platform_closeMic) {
          if (isMicListening.isTrue) {
            isMicListening.value = false;
            _audioCache.play('raw/Negative.mp3');
          }
        }
        return Future.value("");
      });
    }
  }

  listnerForAudioPlayer() {
    player!.onPlayerStateChanged.listen(
      (event) {
        if (event == PlayerState.COMPLETED) {
          if ((currentPlayingConversation!.buttons ?? []).isNotEmpty) {
            final buttons = currentPlayingConversation!.buttons!;
            if ((currentPlayingConversation!.currentButtonPlayingIndex ?? 0) <
                buttons.length) {
              var index =
                  currentPlayingConversation!.currentButtonPlayingIndex ?? 0;
              if ((index < buttons.length - 1) &&
                  buttons[index + 1].skipTts! &&
                  !currentPlayingConversation!.isButtonNumber!) {
                if (currentPlayingConversation!.currentButtonPlayingIndex !=
                    null) {
                  index++;
                  currentPlayingConversation!.currentButtonPlayingIndex = index;
                }
              }
              checkForButtonsAndPlay();
            }
          } else {
            stopTTS();
            try {
              if (!conversations.last.endOfConv) {
                gettingReposnseFromNative();
              } else if ((conversations.last.redirectTo ?? "") ==
                  strRegimen.toLowerCase()) {
                if (PreferenceUtil.getIfQurhomeisAcive()) {
                  Get.to(
                    () => QurHomeRegimenScreen(
                      addAppBar: true,
                    ),
                  );
                } else {
                  Get.toNamed(rt_Regimen);
                }
              } else if ((conversations.last.redirectTo ?? "") ==
                  strMyFamilyList.toLowerCase()) {
                Get.to(UserAccounts(
                    arguments: UserAccountsArguments(selectedIndex: 1)));
              }
            } catch (e) {
              //gettingReposnseFromNative();
              if (kDebugMode)
                printError(
                  info: e.toString(),
                );
            }
          }
        }
      },
    );
  }

  checkForButtonsAndPlay() {
    final buttons = currentPlayingConversation!.buttons;
    if (currentPlayingConversation!.currentButtonPlayingIndex != null) {
      var index = currentPlayingConversation!.currentButtonPlayingIndex;
      if (index! < (buttons!.length - 1)) {
        buttons[index].isPlaying.value = false;
        index++;
        currentPlayingConversation!.currentButtonPlayingIndex = index;
        buttons[currentPlayingConversation!.currentButtonPlayingIndex!]
            .isPlaying
            .value = true;
        playTTS(playButtons: true);
      } else {
        stopTTS();
        gettingReposnseFromNative();
      }
    } else {
      currentPlayingConversation!.currentButtonPlayingIndex = 0;
      buttons!.first.isPlaying.value = true;
      playTTS(playButtons: true);
    }
  }

  scrollToEnd() {
    Future.delayed(const Duration(milliseconds: 100)).then(
      (_) => scrollController.animateTo(
        scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 100),
        curve: Curves.easeInOut,
      ),
    );
  }

  startSheelaFromButton({
    String? buttonText,
    String? payload,
    Buttons? buttons,
  }) async {
    stopTTS();
    conversations.add(SheelaResponse(text: buttonText));
    getAIAPIResponseFor(payload, buttons);
  }

  startSheelaConversation() {
    canSpeak = true;
    conversations = [];
    sessionToken = const Uuid().v1();
    if (PreferenceUtil.getIfQurhomeisAcive() &&
        (arguments?.takeActiveDeviceReadings ?? false)) {
      //BLE devices handling
      //bleController = Get.find();
      bleController = CommonUtil().onInitSheelaBLEController();
      bleController!.startSheelaBLEDeviceReadings();
      isLoading(true);
    } else {
      if (Get.isRegistered<SheelaBLEController>())
        Get.find<SheelaBLEController>().stopScanning();
      var msg = strhiMaya;
      if ((arguments?.rawMessage ?? '').isNotEmpty) {
        msg = arguments!.rawMessage!;
        getAIAPIResponseFor(msg, null);
      } else if ((arguments?.sheelaInputs ?? '').isNotEmpty) {
        msg = arguments!.sheelaInputs!;
        conversations.add(SheelaResponse(text: msg));
        getAIAPIResponseFor(msg, null);
      } else if ((arguments?.eId ?? '').isNotEmpty ||
          (arguments?.scheduleAppointment ?? false) ||
          (arguments?.showUnreadMessage ?? false)) {
        msg = KIOSK_SHEELA;
        getAIAPIResponseFor(msg, null);
      } else if ((arguments?.audioMessage ?? '').isNotEmpty) {
        isLoading(true);
        SheelaResponse audioResponse = SheelaResponse();
        audioResponse.recipientId = sheelaAudioMsgUrl;
        audioResponse.audioFile = arguments!.audioMessage;
        conversations.add(audioResponse);
      } else if ((arguments?.textSpeechSheela ?? '').isNotEmpty) {
        msg = arguments!.textSpeechSheela!;
        var currentCon = SheelaResponse(text: msg, recipientId: sheelaRecepId);
        conversations.add(currentCon);
        currentPlayingConversation = currentCon;
        playTTS();
      } else {
        gettingReposnseFromNative();
      }
    }
  }

  getAIAPIResponseFor(String? message, Buttons? buttonsList) async {
    try {
      isLoading.value = true;
      conversations.add(SheelaResponse(loading: true));
      scrollToEnd();
      final String tzOffset = DateTime.now().timeZoneOffset.toString();
      final splitedArr = tzOffset.split(':');
      final sheelaRequest = SheelaRequestModel(
        sender: userId,
        name: userName,
        message: message,
        sessionId: sessionToken,
        // authToken: authToken,
        lang: getCurrentLanCode(),
        timezone:
            splitedArr.isNotEmpty ? '${splitedArr[0]}:${splitedArr[1]}' : '',
        deviceType: Platform.isAndroid ? 'android' : 'ios',
        relationshipId: lastMsgIsOfButtons
            ? buttonsList?.relationshipIdNotRequired ?? false
                ? userId
                : message
            : relationshipId,
        conversationFlag: conversationFlag,
        additionalInfo: json.encode(additionalInfo),
        localDateTime:
            CommonUtil.dateFormatterWithdatetimeseconds(DateTime.now()),
        endPoint: BASE_URL,
        directCall: isUnAvailableCC ? "UNAVAILABLE" : null,
      );
      if (getCurrentLanCode() == 'undef') {
        sheelaRequest.message = '/provider_message';
        sheelaRequest.ProviderMsg = message;
      }
      var reqJson;
      if (arguments?.isSheelaFollowup ?? false) {
        reqJson = {
          KIOSK_task: strfollowup,
          KIOSK_eid: arguments!.eId,
          KIOSK_action: arguments!.action,
          KIOSK_activityName: arguments!.activityName,
          KIOSK_message: message,
          KIOSK_isSheela: arguments!.isSheelaFollowup,
        };
        arguments!.isSheelaFollowup = false;
      } else if (arguments?.eId != '' && arguments?.eId != null) {
        reqJson = {KIOSK_task: KIOSK_remind, KIOSK_eid: arguments!.eId};
        sheelaRequest.message = KIOSK_SHEELA;
        arguments!.eId = null;
      } else if (arguments?.scheduleAppointment ?? false) {
        reqJson = {KIOSK_task: KIOSK_appointment_avail};
        sheelaRequest.message = KIOSK_SHEELA;
        arguments!.scheduleAppointment = false;
      } else if (arguments?.showUnreadMessage ?? false) {
        reqJson = {"task": "messages"};
        sheelaRequest.message = KIOSK_SHEELA;
        arguments!.showUnreadMessage = false;
      } else if (arguments?.eventType != null &&
          arguments?.eventType == strWrapperCall) {
        sheelaRequest.additionalInfo = arguments?.others ?? "";
        arguments?.eventType = null;
      }
      if (reqJson != null) {
        sheelaRequest.kioskData = reqJson;
      }
      final body = sheelaRequest.toJson();
      final response = await SheelAIAPIService().SheelaAIAPI(
        body,
      );
      if (response.statusCode == 200 && (response.body).isNotEmpty) {
        if (isUnAvailableCC) {
          isUnAvailableCC = false;
        }
        final parsedResponse = jsonDecode(response.body);
        SpeechModelAPIResponse apiResponse =
            SpeechModelAPIResponse.fromJson(parsedResponse);
        if (apiResponse.isSuccess! && apiResponse.result != null) {
          var currentResponse = apiResponse.result!;
          if ((currentResponse.recipientId ?? '').isEmpty) {
            currentResponse.recipientId = "Sheela Response";
          }
          currentResponse =
              (await getGoogleTTSForConversation(currentResponse))!;
          currentPlayingConversation = currentResponse;
          conversations.last = currentResponse;
          if ((currentResponse.buttons ?? []).length > 0) {
            currentResponse.endOfConv = false;
            lastMsgIsOfButtons = true;
          } else {
            lastMsgIsOfButtons = false;
          }
          if ((currentResponse.sessionId ?? '').isNotEmpty) {
            sessionToken = currentResponse.sessionId;
          }
          if ((currentResponse.relationshipId ?? '').isNotEmpty) {
            relationshipId = currentResponse.relationshipId;
          }
          if ((currentResponse.conversationFlag ?? '').isNotEmpty) {
            conversationFlag = currentResponse.conversationFlag;
          }
          if ((currentResponse.additionalInfo ?? '').isNotEmpty) {
            additionalInfo = currentResponse.additionalInfo;
          }
          if ((currentResponse.audioURL != null) &&
              (currentResponse.audioURL ?? '').isNotEmpty) {
            isLoading(true);
            SheelaResponse audioResponse = SheelaResponse();
            audioResponse.recipientId = sheelaAudioMsgUrl;
            audioResponse.audioFile = currentResponse.audioURL;
            audioResponse.playAudioInit = true;
            conversations.add(audioResponse);
          }
          if (currentResponse.endOfConv ?? false) {
            QurPlanReminders.getTheRemindersFromAPI();
            conversationFlag = null;
            additionalInfo = {};
            sessionToken = const Uuid().v1();
            relationshipId = userId;
          }
          playTTS();
          callToCC(currentResponse);
          if (currentResponse.lang != null && currentResponse.lang != '') {
            PreferenceUtil.saveString(SHEELA_LANG, currentResponse.lang ?? "");
          }
          scrollToEnd();
        } else {
          //Received a wrong format data
          conversations.removeLast();
        }
      } else {
        // Failed to get Sheela Response
        conversations.removeLast();
        if (kDebugMode) print(response.body);
        FlutterToast().getToast(
            'There is some issue with sheela,\n Please try after some time',
            Colors.black54);
      }
      isLoading.value = false;
    } catch (e) {
      //need to handle errors
      isLoading.value = false;
      conversations.removeLast();
      if (kDebugMode) print(e.toString());
      FlutterToast().getToast(
          'There is some issue with sheela,\n Please try after some time',
          Colors.black54);
    }
  }

  Future<bool> playUsingLocalTTSEngineFor(String? message,
      {bool close = false}) async {
    try {
      final status = await tts_platform.invokeMethod(
        strtts,
        {
          strMessage: message,
          strIsClose: close,
          strLanguage: getCurrentLanCode(),
        },
      );
      return true;
    } catch (e) {
      //failed to play in the local tts
      return false;
    }
  }

  playTTS({bool playButtons = false}) async {
    if (!canSpeak) {
      stopTTS();
      return;
    }
    if (useLocalTTSEngine) {
      try {
        if ((currentPlayingConversation!.text ?? '').isNotEmpty) {
          currentPlayingConversation!.isPlaying.value = true;
          final status = await playUsingLocalTTSEngineFor(
              currentPlayingConversation!.text);
          if (status &&
              (currentPlayingConversation!.buttons ?? []).isNotEmpty) {
            for (final button in currentPlayingConversation!.buttons!) {
              if ((button.title ?? '').isNotEmpty && !button.skipTts!) {
                button.isPlaying.value = true;
                await playUsingLocalTTSEngineFor(button.title);
                button.isPlaying.value = false;
              }
            }
            stopTTS();
            gettingReposnseFromNative();
          } else {
            stopTTS();
            try {
              if (!conversations.last.endOfConv) {
                gettingReposnseFromNative();
              } else if ((conversations.last.redirectTo ?? "") ==
                  strRegimen.toLowerCase()) {
                if (PreferenceUtil.getIfQurhomeisAcive()) {
                  Get.to(
                    () => QurHomeRegimenScreen(
                      addAppBar: true,
                    ),
                  );
                } else {
                  Get.toNamed(rt_Regimen);
                }
              }
            } catch (e) {
              //gettingReposnseFromNative();
            }
          }
        }
      } catch (e) {
        //failed to play in local tts
      }
    } else {
      String? textForPlaying;
      if (playButtons) {
        final currentButton = currentPlayingConversation!
            .buttons![currentPlayingConversation!.currentButtonPlayingIndex!];
        if (currentButton.title!.contains("Exit")) {
          gettingReposnseFromNative();
          return;
        } else if ((currentButton.ttsResponse?.payload?.audioContent ?? '')
            .isNotEmpty) {
          textForPlaying = currentButton.ttsResponse!.payload!.audioContent;
        } else if ((currentButton.title ?? '').isNotEmpty) {
          var result;
          try {
            var stringToSpeech = currentButton.title;
            if (currentButton.title!.contains(".")) {
              stringToSpeech = currentButton.title!.split(".")[1];
              result = await getGoogleTTSForText(stringToSpeech);
            } else {
              result = await getGoogleTTSForText(currentButton.title);
            }
          } catch (e) {
            result = await getGoogleTTSForText(currentButton.title);
          }

          if ((result.payload?.audioContent ?? '').isNotEmpty) {
            textForPlaying = result.payload.audioContent;
          }
        }
      } else {
        if ((currentPlayingConversation!.ttsResponse?.payload?.audioContent ??
                '')
            .isNotEmpty) {
          textForPlaying =
              currentPlayingConversation!.ttsResponse!.payload!.audioContent;
        } else if ((currentPlayingConversation!.text ?? '').isNotEmpty) {
          final result =
              await getGoogleTTSForText(currentPlayingConversation!.text);
          if ((result!.payload!.audioContent ?? '').isNotEmpty) {
            textForPlaying = result.payload!.audioContent;
          }
        }
      }
      if ((textForPlaying ?? '').isNotEmpty) {
        try {
          if (Platform.isIOS) {
            final bytes = base64Decode(textForPlaying!);
            if (bytes != null) {
              final dir = await getTemporaryDirectory();
              randomNum++;
              if (randomNum > 4) {
                randomNum = 0;
              }
              final tempFile =
                  await File('${dir.path}/tempAudioFile$randomNum.mp3')
                      .create();
              tempFile.writeAsBytesSync(
                bytes,
              );
              currentPlayingConversation!.isPlaying.value = true;
              player!.play('${dir.path}/tempAudioFile$randomNum.mp3');
            }
          } else {
            final bytes = const Base64Decoder().convert(textForPlaying!);
            if (bytes != null) {
              final dir = await getTemporaryDirectory();
              final file = File('${dir.path}/tempAudioFile.mp3');
              await file.writeAsBytes(bytes);
              final path = "${dir.path}/tempAudioFile.mp3";
              currentPlayingConversation!.isPlaying.value = true;
              await player!.play(path, isLocal: true);
            }
          }
        } catch (e) {
          //failed play the audio
          print(e.toString());
          FlutterToast().getToast('failed play the audio', Colors.black54);
          stopTTS();
        }
      }
    }
  }

  stopTTS() {
    player?.stop();
    if (useLocalTTSEngine) {
      playUsingLocalTTSEngineFor("", close: true);
    }
    if (isMicListening.isTrue) {
      isMicListening(false);
    }
    if (Platform.isIOS) {
      voice_platform.invokeMethod(strCloseSheelaDialog);
    } else {
      CommonUtil().closeSheelaDialog();
    }
    if (currentPlayingConversation != null) {
      currentPlayingConversation!.isPlaying.value = false;
      currentPlayingConversation!.currentButtonPlayingIndex = null;
      if ((currentPlayingConversation!.buttons ?? []).isNotEmpty) {
        for (final button in currentPlayingConversation!.buttons!) {
          button.isPlaying.value = false;
        }
      }
      currentPlayingConversation = null;
    }
  }

  Future<SheelaResponse?> getGoogleTTSForConversation(
      SheelaResponse conversation) async {
    try {
      final result = await getGoogleTTSForText(conversation.text);
      conversation.ttsResponse = result;

//This will increase the delay in the api calls

      // if ((conversation.buttons ?? []).isNotEmpty) {
      //   for (var button in conversation.buttons) {
      //     final resultForButton = await getGoogleTTSForText(button.title);
      //     button.ttsResponse = resultForButton;
      //   }
      // }
      return conversation;
    } catch (e) {
      //Failed to get tts in conversation
      FlutterToast()
          .getToast('Failed to get tts in conversation', Colors.black54);
    }
  }

  Future<GoogleTTSResponseModel?> getGoogleTTSForText(String? text) async {
    try {
      final req = GoogleTTSRequestModel.fromJson({});
      req.input!.text = text;
      req.voice!.languageCode = getCurrentLanCode();
      final response = await SheelAIAPIService().getAudioFileTTS(req.toJson());
      if (response.statusCode == 200 && (response.body).isNotEmpty) {
        final data = jsonDecode(response.body);
        final GoogleTTSResponseModel result =
            GoogleTTSResponseModel.fromJson(data);
        if (result != null && (result.isSuccess ?? false)) {
          return result;
        } else {
          //Need to handle failure
          FlutterToast().getToast(
              'There is some issue with sheela,\n Please try after some time',
              Colors.black54);
        }
      } else {
        //Failed to get body or failed status code
        FlutterToast().getToast(
            'There is some issue with sheela,\n Please try after some time',
            Colors.black54);
      }
    } catch (e) {
      print(e.toString());
      //need to handle failure in the api call for tts
      FlutterToast().getToast(
          'There is some issue with sheela,\n Please try after some time',
          Colors.black54);
    }
  }

  gettingReposnseFromNative() async {
    stopTTS();
    try {
      final micStatus =
          await voice_platform.invokeMethod(strvalidateMicAvailablity);
      if (micStatus) {
        if (isMicListening.isFalse) {
          isMicListening.value = true;
          if (Platform.isIOS) {
            await _audioCache.play('raw/Positive.mp3');
            await Future.delayed(const Duration(seconds: 1));
          }
          await voice_platform.invokeMethod(
            strspeakAssistant,
            {
              'langcode': getCurrentLanCode(),
            },
          ).then((response) async {
            isMicListening.value = false;
            if (Platform.isIOS) {
              await Future.delayed(const Duration(seconds: 1));
            }

            if ((response ?? '').toString().isNotEmpty) {
              final newConversation = SheelaResponse(text: response);
              if (conversations.isNotEmpty &&
                  ((conversations.last?.buttons?.length ?? 0) > 0)) {
                try {
                  var responseRecived =
                      response.toString().toLowerCase().trim();

                  dynamic button = null;

                  if (!conversations.last?.isButtonNumber) {
                    if (responseRecived == carGiverSheela) {
                      responseRecived = careGiverSheela;
                    }
                    button = conversations.last?.buttons.firstWhere((element) =>
                        (element.title ?? "").toLowerCase() == responseRecived);
                  } else if (conversations.last?.isButtonNumber) {
                    bool isDigit = CommonUtil().isNumeric(responseRecived);
                    for (int i = 0;
                        i < conversations.last?.buttons.length;
                        i++) {
                      var temp =
                          conversations.last?.buttons[i].title.split(".");
                      var realNumber = CommonUtil()
                          .realNumber(int.tryParse(temp[0].toString().trim()));
                      var optionWithRealNumber =
                          "Option ${realNumber.toString().trim()}";
                      var optionWithDigit =
                          "Option ${temp[0].toString().trim()}";
                      var numberWithRealNumber =
                          "Number ${realNumber.toString().trim()}";
                      var numberWithDigit =
                          "Number ${temp[0].toString().trim()}";
                      if (((temp[isDigit ? 0 : 1].toString().trim())
                                  .toLowerCase() ==
                              responseRecived) ||
                          (realNumber.toString().toLowerCase().trim() ==
                              responseRecived) ||
                          (optionWithRealNumber
                                  .toString()
                                  .toLowerCase()
                                  .trim() ==
                              responseRecived) ||
                          (optionWithDigit.toString().toLowerCase().trim() ==
                              responseRecived) ||
                          (numberWithRealNumber
                                  .toString()
                                  .toLowerCase()
                                  .trim() ==
                              responseRecived) ||
                          (numberWithDigit.toString().toLowerCase().trim() ==
                              responseRecived)) {
                        button = conversations.last?.buttons[i];
                        break;
                      }
                    }
                  }

                  if (button != null) {
                    startSheelaFromButton(
                        buttonText: button.title,
                        payload: button.payload,
                        buttons: button);
                  } else {
                    lastMsgIsOfButtons = false;
                    conversations.add(newConversation);
                    getAIAPIResponseFor(response, button);
                  }
                } catch (e) {
                  lastMsgIsOfButtons = false;
                  conversations.add(newConversation);
                  getAIAPIResponseFor(response, null);
                }
              } else {
                lastMsgIsOfButtons = false;
                conversations.add(newConversation);
                getAIAPIResponseFor(response, null);
              }
            }
            scrollToEnd();
          }).whenComplete(() {
            isMicListening.value = false;
          }).onError((dynamic error, stackTrace) {
            isMicListening.value = false;
          });
        }
      } else {
        FlutterToast().getToast(strMicAlertMsg, Colors.black);
      }
    } on PlatformException {
      isMicListening.value = false;
      FlutterToast().getToast(
          'There is some issue with sheela,\n Please try after some time',
          Colors.black54);
    } catch (e) {
      print(e.toString());
      FlutterToast().getToast(
          'There is some issue with sheela,\n Please try after some time',
          Colors.black54);
    }
  }

  String? getCurrentLanCode({bool splittedCode = false}) {
    try {
      String? currentLang = PreferenceUtil.getStringValue(SHEELA_LANG);
      if ((currentLang ?? '').isNotEmpty) {
        if (splittedCode && (currentLang != "undef")) {
          final langCode = currentLang!.split("-").first;
          currentLang = langCode;
        }
      } else {
        currentLang = 'undef';
      }
      return currentLang;
    } catch (e) {
      return 'undef';
    }
  }

  void refreshData() async {
    try {
      final data = await HealthReportListForUserBlock().getHelthReportLists();
      await PreferenceUtil.saveCompleteData(KEY_COMPLETE_DATA, data);
    } catch (e) {
      print(e.toString());
    }
  }

  DeviceStatus currentDeviceStatus = DeviceStatus();
  late CreateDeviceSelectionModel createDeviceSelectionModel;

  setValues(GetDeviceSelectionModel getDeviceSelectionModel) {
    final selection = getDeviceSelectionModel.result![0];
    final prof = selection.profileSetting!;
    currentDeviceStatus.preColor = prof.preColor;
    currentDeviceStatus.greColor = prof.greColor;
    currentDeviceStatus.isdeviceRecognition = prof.allowDevice ?? true;
    currentDeviceStatus.isdigitRecognition = prof.allowDigit ?? true;
    currentDeviceStatus.isHkActive = prof.healthFit ?? false;
    currentDeviceStatus.isBpActive = prof.bpMonitor ?? true;
    currentDeviceStatus.isGFActive = prof.glucoMeter ?? true;
    currentDeviceStatus.isOxyActive = prof.pulseOximeter ?? true;
    currentDeviceStatus.isWsActive = prof.weighScale ?? true;
    currentDeviceStatus.isThActive = prof.thermoMeter ?? true;
    currentDeviceStatus.preferred_language =
        (prof.preferred_language ?? '').isNotEmpty
            ? prof.preferred_language
            : 'undef';
    currentDeviceStatus.qa_subscription =
        (prof.qa_subscription ?? '').isNotEmpty ? prof.qa_subscription : 'Y';
    currentDeviceStatus.preferredMeasurement = prof.preferredMeasurement;
    currentDeviceStatus.tagsList = selection.tags ?? [];
    currentDeviceStatus.allowAppointmentNotification =
        prof.caregiverCommunicationSetting?.appointments ?? true;
    currentDeviceStatus.allowVitalNotification =
        prof.caregiverCommunicationSetting?.vitals ?? true;
    currentDeviceStatus.allowSymptomsNotification =
        prof.caregiverCommunicationSetting?.symptoms ?? true;
  }

  Future<CreateDeviceSelectionModel?> createDeviceSel() async {
    try {
      final data = await HealthReportListForUserRepository()
          .createDeviceSelection(
              currentDeviceStatus.isdigitRecognition,
              currentDeviceStatus.isdeviceRecognition,
              currentDeviceStatus.isGFActive,
              currentDeviceStatus.isHkActive,
              currentDeviceStatus.isBpActive,
              currentDeviceStatus.isGlActive,
              currentDeviceStatus.isOxyActive,
              currentDeviceStatus.isThActive,
              currentDeviceStatus.isWsActive,
              userId,
              currentDeviceStatus.preferred_language,
              currentDeviceStatus.qa_subscription,
              currentDeviceStatus.preColor,
              currentDeviceStatus.greColor,
              currentDeviceStatus.tagsList,
              currentDeviceStatus.allowAppointmentNotification,
              currentDeviceStatus.allowVitalNotification,
              currentDeviceStatus.allowSymptomsNotification);
      return data;
    } catch (e) {
      print(e.toString());
    }
  }

  Future getDeviceSelectionValues({String? preferredLanguage}) async {
    final GetDeviceSelectionModel selectionResult =
        await HealthReportListForUserRepository().getDeviceSelection();
    if (selectionResult.isSuccess!) {
      if (selectionResult.result != null) {
        setValues(selectionResult);
        currentDeviceStatus.userMappingId = selectionResult.result![0].id;
      } else {
        currentDeviceStatus = DeviceStatus();
      }
    } else {
      currentDeviceStatus = DeviceStatus();
      createDeviceSelectionModel = (await createDeviceSel())!;
      if (createDeviceSelectionModel.isSuccess!) {
        updateDeviceSelectionModel(preferredLanguage: preferredLanguage);
      } else {
        //failed to create new model
      }
    }
  }

  updateDeviceSelectionModel({String? preferredLanguage}) async {
    final value = await HealthReportListForUserRepository().updateDeviceModel(
        currentDeviceStatus.userMappingId,
        currentDeviceStatus.isdigitRecognition,
        currentDeviceStatus.isdeviceRecognition,
        currentDeviceStatus.isGFActive,
        currentDeviceStatus.isHkActive,
        currentDeviceStatus.isBpActive,
        currentDeviceStatus.isGlActive,
        currentDeviceStatus.isOxyActive,
        currentDeviceStatus.isThActive,
        currentDeviceStatus.isWsActive,
        preferredLanguage ?? currentDeviceStatus.preferred_language,
        currentDeviceStatus.qa_subscription,
        currentDeviceStatus.preColor,
        currentDeviceStatus.greColor,
        currentDeviceStatus.tagsList,
        currentDeviceStatus.allowAppointmentNotification,
        currentDeviceStatus.allowVitalNotification,
        currentDeviceStatus.allowSymptomsNotification,
        currentDeviceStatus.preferredMeasurement);
    if (value.isSuccess ?? false) {
      //updated

    } else {
      //failed to update

    }
  }

  getSheelaBadgeCount({bool isNeedSheelaDialog = false}) async {
    sheelaIconBadgeCount.value = 0;
    try {
      sheelaBadgeServices.getSheelaBadgeCount().then((value) {
        if (value != null) {
          if (value.isSuccess!) {
            if (value.result != null) {
              sheelaIconBadgeCount.value = value.result?.queueCount ?? 0;
              if (isNeedSheelaDialog) {
                if ((value.result?.queueCount ?? 0) > 0) {
                  CommonUtil().dialogForSheelaQueueStable(
                      Get.context!, value.result?.queueCount ?? 0,
                      onTapSheela: () {
                    Get.back();
                    Get.toNamed(
                      rt_Sheela,
                      arguments: SheelaArgument(
                        rawMessage: sheelaQueueShowRemind,
                      ),
                    )!
                        .then((value) {
                      getSheelaBadgeCount(isNeedSheelaDialog: true);
                    });
                  });
                }
              }
            } else {
              sheelaIconBadgeCount.value = 0;
            }
          } else {
            sheelaIconBadgeCount.value = 0;
          }
        } else {
          sheelaIconBadgeCount.value = 0;
        }
      });
    } catch (e) {
      sheelaIconBadgeCount.value = 0;
    }
  }

  void updateTimer({bool enable = false}) {
    try {
      if (_popTimer != null && _popTimer!.isActive) {
        printInfo(info: "Cancelled the timer");
        _popTimer!.cancel();
        _popTimer = null;
      } else if (enable) {
        printInfo(info: "started the timer");
        _popTimer = Timer(const Duration(minutes: 1), () {
          if (isSheelaScreenActive && bleController == null) {
            printInfo(info: "timeout the timer");
            stopTTS();
            canSpeak = false;
            isSheelaScreenActive = false;
            getSheelaBadgeCount();
            Get.back();
          }
        });
      }
    } catch (e) {
      printError(info: e.toString());
    }
  }

  callToCC(SheelaResponse currentResponse) async {
    if ((currentResponse.directCall != null && currentResponse.directCall!) &&
        (currentResponse.recipient != null &&
            currentResponse.recipient!.trim().toLowerCase() == "cc")) {
      var regController = CommonUtil().onInitQurhomeRegimenController();
      if (CommonUtil()
          .validString(regController.careCoordinatorId.value)
          .trim()
          .isEmpty) {
        regController.getUserDetails();
        await regController.getCareCoordinatorId();
      }
      regController.callSOSEmergencyServices(1);
    }
  }
}
