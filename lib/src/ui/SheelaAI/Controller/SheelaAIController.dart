import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:gmiwidgetspackage/widgets/flutterToast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:myfhb/Qurhome/QurhomeDashboard/View/QurHomeRegimen.dart';
import 'package:myfhb/authentication/constants/constants.dart';
import 'package:myfhb/chat_socket/model/SheelaBadgeModel.dart';
import 'package:myfhb/chat_socket/service/ChatSocketService.dart';
import 'package:myfhb/chat_socket/viewModel/chat_socket_view_model.dart';
import 'package:myfhb/common/CommonUtil.dart';
import 'package:myfhb/constants/fhb_query.dart';
import 'package:myfhb/constants/router_variable.dart';
import 'package:myfhb/language/repository/LanguageRepository.dart';
import 'package:myfhb/main.dart';
import 'package:myfhb/reminders/QurPlanReminders.dart';
import 'package:myfhb/reminders/ReminderModel.dart';
import 'package:myfhb/src/model/user/user_accounts_arguments.dart';
import 'package:myfhb/src/ui/SheelaAI/Services/SheelaBadgeServices.dart';
import 'package:myfhb/src/ui/SheelaAI/Views/AttachmentListSheela.dart';
import 'package:myfhb/src/ui/SheelaAI/Views/audio_player_screen.dart';
import 'package:myfhb/src/ui/SheelaAI/Views/video_player_screen.dart';
import 'package:myfhb/src/ui/SheelaAI/Views/youtube_player.dart';
import 'package:myfhb/src/ui/camera/camera_timer_screen.dart';
import 'package:myfhb/src/ui/user/UserAccounts.dart';
import 'package:myfhb/src/utils/screenutils/size_extensions.dart';
import 'package:myfhb/telehealth/features/chat/view/full_photo.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:uuid/uuid.dart';
import 'package:video_thumbnail/video_thumbnail.dart' as thumbnail;
import 'package:youtube_player_flutter/youtube_player_flutter.dart' as youtube;

import '../../../../common/PreferenceUtil.dart';
import '../../../../common/keysofmodel.dart';
import '../../../../constants/fhb_constants.dart';
import '../../../../constants/fhb_parameters.dart';
import '../../../../constants/variable_constant.dart';
import '../../../../regiment/view_model/AddRegimentModel.dart';
import '../../../../regiment/view_model/pickImageController.dart';
import '../../../blocs/health/HealthReportListForUserBlock.dart';
import '../../../model/CreateDeviceSelectionModel.dart';
import '../../../model/GetDeviceSelectionModel.dart';
import '../../../model/user/MyProfileModel.dart';
import '../../../resources/network/ApiBaseHelper.dart';
import '../../../resources/repository/health/HealthReportListForUserRepository.dart';
import '../../audio/AudioRecorder.dart';
import '../../audio/AudioScreenArguments.dart';
import '../Models/DeviceStatus.dart';
import '../Models/GoogleTTSRequestModel.dart';
import '../Models/GoogleTTSResponseModel.dart';
import '../Models/SheelaRequest.dart';
import '../Models/SheelaResponse.dart';
import '../Models/sheela_arguments.dart';
import '../Services/SheelaAIAPIServices.dart';
import '../Services/SheelaAIBLEServices.dart';
import 'package:timezone/timezone.dart' as tz;

enum BLEStatus { Searching, Connected, Disabled }

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
  SheelaResponse? redoCurrentPlayingConversation;
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
  Timer? _popTimer;
  Timer? _exitAutoTimer;
  Timer? _reconnectTimer;
  Timer? _sessionTimeout;
  var sheelaIconBadgeCount = 0.obs;
  bool isUnAvailableCC = false;
  bool isProd = false;
  SheelaBadgeServices sheelaBadgeServices = SheelaBadgeServices();

  Rx<bool> isMuted = false.obs;
  Rx<bool> isDiscardDialogShown = false.obs;

  Rx<bool> isQueueDialogShowing = false.obs;
  Rx<BLEStatus> isBLEStatus = BLEStatus.Disabled.obs;
  bool isCallStartFromSheela = false;

  ChatSocketService _chatSocketService = ChatSocketService();

  Rx<bool> isFullScreenVideoPlayer = false.obs;
  Rx<bool> isPlayPauseView = false.obs;
  Rx<bool> isAudioScreenLoading = false.obs;

  LanguageRepository languageBlock = LanguageRepository();
  Map<String, dynamic> langaugeDropdownList = {};

  List<String> sheelaTTSWordList = ['sheila', 'sila', 'shila', 'shiela'];

  bool isAllowSheelaLiveReminders = true;
  SheelaBadgeModel? _sheelaBadgeModel;

  // Represents the countdown seconds remaining, using the RxInt type
  RxInt countDownSecondsRemaining = 10.obs;

// Represents a stream controller for handling events of type int
  StreamController<int> streamEvents = StreamController<int>();

// Represents a timer used for countdown functionality
  Timer? countDownSecondsTimer;

// Represents an instance of SpeechToText for handling speech-related operations
  SpeechToText? speechToText = SpeechToText();

// Represents the current language code using Rx (reactive programming)
  var currentLanguageCode = 'en_US'.obs;

// Represents a reactive boolean indicating whether the countdown dialog is currently showing
  Rx<bool> isCountDownDialogShowing = false.obs;

// Represents a text editing controller for Sheela's input dialog
  TextEditingController sheelaInputTextEditingController =
      TextEditingController();

// Represents a reactive boolean indicating whether Sheela's input dialog is currently showing
  Rx<bool> isSheelaInputDialogShowing = false.obs;

  /// Represents a Sheela Input is Started or not
  bool isSheelaInputStarted = false;

  String? btnTextLocal = '';
  bool? isRetakeCapture = false;
  //reconnect feature enable flag
  bool? isRetryScanFailure = false;
  String? fileRequestUrl = '';

  final ApiBaseHelper _helper = ApiBaseHelper();
  Timer? _debounceRecognizedWords;

  // Create a Map to store reminder timers. The keys are String identifiers (presumably related to reminders),
  // and the values are Timer objects that will be used for managing timing events associated with reminders.
  Map<String, Timer> reminderTimers = {};

  @override
  void onInit() {
    try {
      super.onInit();
      setDefaultValues();
      onInitActivitySheelaRemainder();
    } catch (e, stackTrace) {
      CommonUtil().appLogs(message: e, stackTrace: stackTrace);
    }
  }

  setDefaultValues() async {
    if ((BASE_URL == prodINURL) ||
        (BASE_URL == prodUSURL) ||
        (BASE_URL == demoINURL) ||
        (BASE_URL == demoUSURL)) {
      isProd = true;
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
    try {
      if ((arguments?.eventIdViaSheela != null) &&
          (arguments?.eventIdViaSheela != 'null') &&
          (arguments?.eventIdViaSheela != '')) {
        _chatSocketService
            .getUnreadChatWithMsgId(arguments?.eventIdViaSheela ?? '');
      }
    } catch (e, stackTrace) {
      CommonUtil().appLogs(message: e, stackTrace: stackTrace);
    }
  }

  listnerForAudioPlayer() {
    player!.onPlayerStateChanged.listen(
      (event) {
        if (event == PlayerState.COMPLETED) {
          afterCompletedAudioPlayer();
        }
      },
    );
  }

  afterCompletedAudioPlayer() {
    if ((currentPlayingConversation!.buttons ?? []).isNotEmpty) {
      final buttons = currentPlayingConversation!.buttons!;
      if ((currentPlayingConversation!.currentButtonPlayingIndex ?? 0) <
          buttons.length) {
        var index = currentPlayingConversation!.currentButtonPlayingIndex ?? 0;
        if ((index < buttons.length - 1) &&
            (buttons[index + 1].skipTts ?? false) &&
            !currentPlayingConversation!.isButtonNumber!) {
          if (currentPlayingConversation!.currentButtonPlayingIndex != null) {
            index++;
            currentPlayingConversation!.currentButtonPlayingIndex = index;
          }
        }
        checkForButtonsAndPlay();
      }
    } else {
      stopTTS();
      try {
        if (!(conversations.last.endOfConv??true)) {
          if (CommonUtil.isUSRegion()) {
            if (!isMuted.value) {
              if (!isDiscardDialogShown.value) {
                gettingReposnseFromNative();
              }
            }
          } else {
            gettingReposnseFromNative();
          }
        } else if ((conversations.last.redirectTo ?? '') ==
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
        } else if ((conversations.last.redirectTo ?? '') ==
            strMyFamilyList.toLowerCase()) {
          Get.to(
              UserAccounts(arguments: UserAccountsArguments(selectedIndex: 1)));
        } else if ((conversations.last.redirectTo ?? '') ==
            strHomeScreen.toLowerCase()) {
          startTimer();
        } // Check if the last conversation's redirectTo is equal to the specified value (strReconnect)
        else if ((conversations.last.redirectTo ?? '') == strReconnect) {
          resetBLE(); // Reset the BLE (Bluetooth Low Energy) connection
          // Set up a reconnect timer after the delay
          reconnectTimer();
        }
      } catch (e, stackTrace) {
        //gettingReposnseFromNative();
        if (kDebugMode)
          printError(
            info: e.toString(),
          );
        CommonUtil().appLogs(message: e, stackTrace: stackTrace);
      }
    }
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

  resetBLE() async {
    Get.find<SheelaBLEController>().stopScanning();
    await Future.delayed(const Duration(seconds: 2));
    Get.find<SheelaBLEController>().setupListenerForReadings();
  }

  startSheelaFromButton({
    String? buttonText,
    String? payload,
    Buttons? buttons,
    bool? isFromImageUpload = false,
    String? requestFileType,
  }) async {
    stopTTS();
    conversations.add(SheelaResponse(text: buttonText));
    getAIAPIResponseFor(payload, buttons,
        isFromImageUpload: isFromImageUpload, requestFileType: requestFileType);
  }

  startSheelaConversation() {
    canSpeak = true;
    conversations = [];
    redoCurrentPlayingConversation = null;
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
        getTextTranslate(arguments?.sheelaInputs ?? '').then((value) {
          if (value != null) {
            msg = value.toString();
            conversations.add(SheelaResponse(text: msg));
            getAIAPIResponseFor(msg, null);
          }
        });
      } else if ((arguments?.eId ?? '').isNotEmpty ||
          (arguments?.scheduleAppointment ?? false) ||
          (arguments?.showUnreadMessage ?? false)) {
        msg = KIOSK_SHEELA;
        getAIAPIResponseFor(msg, null);
      } else if (arguments?.sheelReminder ?? false) {
        msg = KIOSK_SHEELA;
        getAIAPIResponseFor(msg, null);
      } else if ((arguments?.audioMessage ?? '').isNotEmpty) {
        isLoading(true);
        SheelaResponse audioResponse = SheelaResponse();
        audioResponse.recipientId = sheelaAudioMsgUrl;
        audioResponse.audioFile = arguments!.audioMessage;
        conversations.add(audioResponse);
        audioResponse.endOfConvDiscardDialog =
            arguments?.allowBackBtnPress ?? false;
      } else if ((arguments?.textSpeechSheela ?? '').isNotEmpty) {
        conversations = [];
        currentPlayingConversation = null;
        isLoading.value = true;
        if (arguments?.isNeedPreferredLangauge ?? false) {
          getTextTranslate(arguments!.textSpeechSheela ?? '').then((value) {
            if (value != null) {
              msg = value.toString();
              addSpeechTextConversation(msg);
            }
          });
        } else {
          msg = (arguments?.textSpeechSheela ?? '').toString();
          addSpeechTextConversation(msg);
        }
      } else {
        gettingReposnseFromNative();
      }
    }
  }

  addSpeechTextConversation(String message) {
    var currentCon = SheelaResponse(text: message, recipientId: sheelaRecepId);
    conversations.add(currentCon);
    currentPlayingConversation = currentCon;
    currentPlayingConversation?.endOfConvDiscardDialog =
        arguments?.allowBackBtnPress ?? false;
    isLoading.value = false;
    playTTS();
  }

  getAIAPIResponseFor(String? message, Buttons? buttonsList,
      {bool? isFromImageUpload = false, String? requestFileType}) async {
    try {
      isCallStartFromSheela = false;
      isLoading.value = true;
      conversations.add(SheelaResponse(loading: true));
      scrollToEnd();
      final String tzOffset = DateTime.now().timeZoneOffset.toString();
      final splitedArr = tzOffset.split(':');
      // Check if the 'isFromFileUpload' variable is defined and truthy, otherwise default to false
      if (isFromImageUpload ?? false) {
        // If it's an image upload, update additionalInfo with the file URL and request type
        additionalInfo?[strRequestFileUrl] =
            fileRequestUrl; // Add file URL to additionalInfo
        additionalInfo?[strRequestType] =
            requestFileType; // Add request type to additionalInfo
      }
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
        localDateTime: CommonUtil.dateFormatterWithdatetimesecondsApiFormatAI(
            DateTime.now()),
        endPoint: BASE_URL,
        directCall: isUnAvailableCC ? 'UNAVAILABLE' : null,
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
        if (arguments?.isSurvey ?? false) {
          reqJson = {
            KIOSK_task: (arguments?.isRetakeSurvey ?? false)
                ? KIOSK_retakeSurvey
                : KIOSK_survey,
            KIOSK_eid: arguments!.eId
          };
          sheelaRequest.message = KIOSK_SHEELA;
          arguments!.eId = null;
        } else {
          reqJson = {KIOSK_task: KIOSK_remind, KIOSK_eid: arguments!.eId};
          sheelaRequest.message = KIOSK_SHEELA;
          arguments!.eId = null;
        }
      } else if (arguments?.scheduleAppointment ?? false) {
        reqJson = {KIOSK_task: KIOSK_appointment_avail};
        sheelaRequest.message = KIOSK_SHEELA;
        arguments!.scheduleAppointment = false;
      } else if (arguments?.showUnreadMessage ?? false) {
        sheelaRequest.message = KIOSK_SHEELA_UNREAD_MSG;
        arguments!.showUnreadMessage = false;
      } else if (arguments?.eventType != null &&
          arguments?.eventType == strWrapperCall) {
        sheelaRequest.additionalInfo = arguments?.others ?? '';
        arguments?.eventType = null;
      } else if (arguments?.sheelReminder ?? false) {
        reqJson = {
          KIOSK_task: KIOSK_messages,
          KIOSK_chatId: arguments!.chatMessageIdSocket
        };
        sheelaRequest.message = KIOSK_SHEELA;
        arguments!.sheelReminder = false;
      }
      if (reqJson != null) {
        sheelaRequest.kioskData = reqJson;
      }
      sheelaRequest.language = getCurrentLanCode(splittedCode: true);
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
            currentResponse.recipientId = 'Sheela Response';
          }
          currentResponse =
              (await getGoogleTTSForConversation(currentResponse))!;
          currentPlayingConversation = currentResponse;
          conversations.last = currentResponse;
          clearTimerForSessionExpiry();
          /*if ((currentResponse.buttons ?? []).length > 0) {
            currentResponse.endOfConv = false;
            lastMsgIsOfButtons = true;
          } else {
            lastMsgIsOfButtons = false;
          }*/
          if ((currentResponse.sessionId ?? '').isNotEmpty) {
            sessionToken = currentResponse.sessionId;
          }
          if ((currentResponse.relationshipId ?? '').isNotEmpty) {
            relationshipId = currentResponse.relationshipId;
          }
          if ((currentResponse.conversationFlag ?? '').isNotEmpty) {
            conversationFlag = currentResponse.conversationFlag;
          }
          //if ((currentResponse.additionalInfo ?? '').isNotEmpty) {
          additionalInfo = currentResponse.additionalInfo;
          // }
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
            conversationFlag = null;
            //additionalInfo = {};
            sessionToken = const Uuid().v1();
            relationshipId = userId;
          }
          if (currentResponse.additionalInfoSheelaResponse?.sessionTimeoutMin !=
                  null &&
              currentResponse.additionalInfoSheelaResponse?.sessionTimeoutMin !=
                  '') {
            startTimerForSessionExpiry(currentResponse
                    .additionalInfoSheelaResponse?.sessionTimeoutMin ??
                0);
          }
          if (CommonUtil.isUSRegion()) {
            if (!isMuted.value) {
              playTTS();
            }
          } else {
            playTTS();
          }
          callToCC(currentResponse);
          /*if (currentResponse.lang != null && currentResponse.lang != '') {
            PreferenceUtil.saveString(SHEELA_LANG, currentResponse.lang ?? "");
          }*/
          scrollToEnd();
        } else {
          //Received a wrong format data
          conversations.removeLast();
        }
      } else {
        // Failed to get Sheela Response
        conversations.removeLast();
        if (kDebugMode) print(response.body);
        FlutterToast().getToast(StrSheelaErrorMsg, Colors.black54);
      }
      isLoading.value = false;
    } catch (e, stackTrace) {
      //need to handle errors
      CommonUtil().appLogs(message: e, stackTrace: stackTrace);

      isLoading.value = false;
      conversations.removeLast();
      if (kDebugMode) print(e.toString());
      FlutterToast().getToast(StrSheelaErrorMsg, Colors.black54);
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
    } catch (e, stackTrace) {
      //failed to play in the local tts
      CommonUtil().appLogs(message: e, stackTrace: stackTrace);

      return false;
    }
  }

  playTTS({bool playButtons = false}) async {
    bool muteButton = false;
    if (!canSpeak) {
      stopTTS();
      return;
    }
    if (useLocalTTSEngine) {
      try {
        if ((currentPlayingConversation!.text ?? '').isNotEmpty) {
          currentPlayingConversation!.isPlaying.value = true;
          final status = await playUsingLocalTTSEngineFor(
              (getPronunciationText(currentPlayingConversation)
                      .trim()
                      .isNotEmpty
                  ? getPronunciationText(currentPlayingConversation)
                  : (currentPlayingConversation!.text)));
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
              } else if ((conversations.last.redirectTo ?? '') ==
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
            } catch (e, stackTrace) {
              //gettingReposnseFromNative();
              CommonUtil().appLogs(message: e, stackTrace: stackTrace);
            }
          }
        }
      } catch (e, stackTrace) {
        //failed to play in local tts
        CommonUtil().appLogs(message: e, stackTrace: stackTrace);
      }
    } else {
      String? textForPlaying;
      if (playButtons) {
        final currentButton = currentPlayingConversation!
            .buttons![currentPlayingConversation!.currentButtonPlayingIndex!];
        if ((currentButton.title!.contains(StrExit)) ||
            (currentButton.title!.contains(str_Undo)) ||
            (currentButton.title!.contains(StrUndoAll)) ||
            (conversations.last.endOfConv ?? false)) {
          if (conversations.last.endOfConv) {
            currentPlayingConversation!.isPlaying.value = false;
            currentButton.isPlaying.value = false;
          } else {
            gettingReposnseFromNative();
            return;
          }
        } else if ((currentButton.ttsResponse?.payload?.audioContent ?? '')
            .isNotEmpty) {
          if (currentButton.mute != sheela_hdn_btn_yes) {
            textForPlaying = currentButton.ttsResponse!.payload!.audioContent;
          } else {
            muteButton = true;
          }
        } else if ((currentButton.title ?? '').isNotEmpty) {
          var result;
          try {
            if ((currentButton.sayText ?? '').isNotEmpty) {
              result = await getGoogleTTSForText(currentButton.sayText);
            } else {
              result = await getGoogleTTSForText(currentButton.title);
            }
          } catch (e, stackTrace) {
            CommonUtil().appLogs(message: e, stackTrace: stackTrace);

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
        } else if ((currentPlayingConversation?.text ?? '').isNotEmpty) {
          final result = await getGoogleTTSForText(
              (getPronunciationText(currentPlayingConversation)
                      .trim()
                      .isNotEmpty
                  ? getPronunciationText(currentPlayingConversation)
                  : (currentPlayingConversation!.text)));
          if ((result?.payload?.audioContent ?? '').isNotEmpty) {
            textForPlaying = result!.payload!.audioContent;
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
              final path = '${dir.path}/tempAudioFile.mp3';
              currentPlayingConversation!.isPlaying.value = true;
              await player!.play(path, isLocal: true);
            }
          }
        } catch (e, stackTrace) {
          CommonUtil().appLogs(message: e, stackTrace: stackTrace);

          //failed play the audio
          print(e.toString());
          FlutterToast().getToast('failed play the audio', Colors.black54);
          stopTTS();
        }
      } else {
        if (muteButton) {
          afterCompletedAudioPlayer();
        }
      }
    }
  }

  stopTTS() {
    player?.stop();
    if (useLocalTTSEngine) {
      playUsingLocalTTSEngineFor('', close: true);
    }
    if (isMicListening.isTrue) {
      isMicListening(false);
    }
    // Invoking a method from the CommonUtil class to close Sheela's dialog
    CommonUtil().closeSheelaDialog();

    /*if (Platform.isIOS) {
      voice_platform.invokeMethod(strCloseSheelaDialog);
    } else {
      CommonUtil().closeSheelaDialog();
    }*/
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
      List<Future> apis = [
        getGoogleTTSForConversationForMessage(
          conversation,
        ),
      ];
      if ((conversation.buttons ?? []).isNotEmpty) {
        for (var button in conversation.buttons!) {
          apis.add(
            getGoogleTTSForConversationForButton(
              button,
            ),
          );
        }
      }
      final result = await Future.wait(apis);
      return conversation;
    } catch (e, stackTrace) {
      CommonUtil().appLogs(message: e, stackTrace: stackTrace);

      //Failed to get tts in conversation
      FlutterToast()
          .getToast('Failed to get tts in conversation', Colors.black54);
    }
  }

  Future<bool> getGoogleTTSForConversationForMessage(
      SheelaResponse conversation) async {
    try {
      final result = await getGoogleTTSForText(
          (getPronunciationText(conversation).trim().isNotEmpty
              ? getPronunciationText(conversation)
              : (conversation.text)));
      conversation.ttsResponse = result;
      return true;
    } catch (e, stackTrace) {
      CommonUtil().appLogs(message: e, stackTrace: stackTrace);

      return false;
    }
  }

  Future<bool> getGoogleTTSForConversationForButton(Buttons button) async {
    try {
      String toSpeech = '';
      if ((button.sayText ?? '').isNotEmpty) {
        toSpeech = button.sayText!;
      } else {
        toSpeech = button.title!;
      }
      final result = await getGoogleTTSForText(toSpeech);
      button.ttsResponse = result;
      return true;
    } catch (e, stackTrace) {
      CommonUtil().appLogs(message: e, stackTrace: stackTrace);

      return false;
    }
  }

  Future<GoogleTTSResponseModel?> getGoogleTTSForText(String? text) async {
    try {
      final req = GoogleTTSRequestModel.fromJson({});
      req.input!.text = text;
      req.voice!.languageCode = getCurrentLanCode(splittedCode: true);
      final response = await SheelAIAPIService().getAudioFileTTS(req.toJson());
      if (response.statusCode == 200 && (response.body).isNotEmpty) {
        final data = jsonDecode(response.body);
        final GoogleTTSResponseModel result =
            GoogleTTSResponseModel.fromJson(data);
        if (result != null && (result.isSuccess ?? false)) {
          if (kDebugMode) {
            log("getGoogleTTSForText audioContent ${result.payload?.audioContent ?? ''}");
          }
          return result;
        } else {
          //Need to handle failure
          FlutterToast().getToast(StrSheelaErrorMsg, Colors.black54);
        }
      } else {
        //Failed to get body or failed status code
        FlutterToast().getToast(StrSheelaErrorMsg, Colors.black54);
      }
    } catch (e, stackTrace) {
      CommonUtil().appLogs(message: e, stackTrace: stackTrace);
      print(e.toString());
      //need to handle failure in the api call for tts
      FlutterToast().getToast(StrSheelaErrorMsg, Colors.black54);
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

          currentLanguageCode.value = getCurrentLanCode() ?? '';

          initiateVoiceAssistantInteraction();
        }
      } else {
        FlutterToast().getToast(strMicAlertMsg, Colors.black);
      }
    } on PlatformException {
      isMicListening.value = false;
      FlutterToast().getToast(StrSheelaErrorMsg, Colors.black54);
    } catch (e, stackTrace) {
      CommonUtil().appLogs(message: e, stackTrace: stackTrace);

      print(e.toString());
      FlutterToast().getToast(StrSheelaErrorMsg, Colors.black54);
    }
  }

  String? getCurrentLanCode({bool splittedCode = false}) {
    try {
      String? currentLang = PreferenceUtil.getStringValue(SHEELA_LANG);
      if (!((currentLang ?? '').contains('-'))) {
        currentLang = CommonUtil.langaugeCodes[currentLang ?? 'undef'];
      }
      if ((currentLang ?? '').isNotEmpty) {
        if (splittedCode && (currentLang != 'undef')) {
          final langCode = currentLang!.split('-').first;
          currentLang = langCode;
        }
      } else {
        currentLang = 'undef';
      }
      return currentLang;
    } catch (e, stackTrace) {
      CommonUtil().appLogs(message: e, stackTrace: stackTrace);

      return 'undef';
    }
  }

  void refreshData() async {
    try {
      final data = await HealthReportListForUserBlock().getHelthReportLists();
      await PreferenceUtil.saveCompleteData(KEY_COMPLETE_DATA, data);
    } catch (e, stackTrace) {
      CommonUtil().appLogs(message: e, stackTrace: stackTrace);

      print(e.toString());
    }
  }

  DeviceStatus currentDeviceStatus = DeviceStatus();
  late CreateDeviceSelectionModel createDeviceSelectionModel;

  setValues(
      GetDeviceSelectionModel getDeviceSelectionModel, bool savePrefLang) {
    final selection = getDeviceSelectionModel.result![0];
    final prof = selection.profileSetting!;
    currentDeviceStatus.preColor = prof.preColor;
    currentDeviceStatus.greColor = prof.greColor;
    currentDeviceStatus.isdeviceRecognition = prof.allowDevice ?? true;
    currentDeviceStatus.isdigitRecognition = prof.allowDigit ?? true;
    currentDeviceStatus.isSheelaLiveReminders =
        prof.sheelaLiveReminders ?? true;
    isAllowSheelaLiveReminders =
        currentDeviceStatus.isSheelaLiveReminders ?? true;
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
    currentDeviceStatus.voiceCloning = prof.voiceCloning ?? false;

    if (savePrefLang) {
      PreferenceUtil.saveString(
          SHEELA_LANG, prof.preferred_language ?? 'en-IN');
    }
  }

  Future<CreateDeviceSelectionModel?> createDeviceSel() async {
    try {
      final data = await HealthReportListForUserRepository()
          .createDeviceSelection(
              currentDeviceStatus.isdigitRecognition,
              currentDeviceStatus.isdeviceRecognition,
              currentDeviceStatus.isSheelaLiveReminders,
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
              currentDeviceStatus.allowSymptomsNotification,
              currentDeviceStatus.voiceCloning,
              currentDeviceStatus.useClonedVoice);
      return data;
    } catch (e, stackTrace) {
      CommonUtil().appLogs(message: e, stackTrace: stackTrace);

      print(e.toString());
    }
  }

  Future getDeviceSelectionValues(
      {String? preferredLanguage, bool savePrefLang = false}) async {
    final GetDeviceSelectionModel selectionResult =
        await HealthReportListForUserRepository().getDeviceSelection();
    if (selectionResult.isSuccess!) {
      if (selectionResult.result != null) {
        setValues(selectionResult, savePrefLang);
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
        currentDeviceStatus.isSheelaLiveReminders,
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
        currentDeviceStatus.preferredMeasurement,
        currentDeviceStatus.voiceCloning,
        null,
        currentDeviceStatus.useClonedVoice);
    if (value.isSuccess ?? false) {
      //updated
    } else {
      //failed to update
    }
  }

  checkIfWeNeedToShowDialogBox(
      {bool isNeedSheelaDialog = false,
      bool isFromQurHomeRegimen = false}) async {
    if ((CommonUtil().isTablet == true)) {
      showRemainderBasedOnCondition(
          isFromQurHomeRegimen: isFromQurHomeRegimen,
          isNeedSheelaDialog: isNeedSheelaDialog);
    }
  }

/*
getSheelaBadgeCount is used to get the latest Sheela Queue badge count.
makeApiRequest is used to update the data with latest data
*/

  Future<void> getSheelaBadgeCount({
    bool isNeedSheelaDialog = false,
    bool isFromQurHomeRegimen = false,
    bool makeApiRequest = false,
  }) async {
    try {
      // Check if sheelaIconBadgeCount is not greater than 0
      if (!(sheelaIconBadgeCount.value > 0)) {
        // If not, set it to 0
        sheelaIconBadgeCount.value = 0;
      }

      if (makeApiRequest || _sheelaBadgeModel == null) {
// Retrieve sheela badge count asynchronously
        _sheelaBadgeModel = await sheelaBadgeServices.getSheelaBadgeCount();
      }

      // Check if the response is successful and contains a valid result
      if (_sheelaBadgeModel?.isSuccess == true &&
          _sheelaBadgeModel?.result != null) {
        // Update sheelaIconBadgeCount with the queue count from the result
        sheelaIconBadgeCount.value = _sheelaBadgeModel?.result?.queueCount ?? 0;

        // Check conditions for showing the dialog
        if (isFromQurHomeRegimen && isQueueDialogShowing.value) {
          // Close existing dialog and update flags
          Get.back();
          isQueueDialogShowing.value = false;
          isNeedSheelaDialog = true;
        }

        // Extract conditions for showing the sheela dialog
        final hasQueueCount = (_sheelaBadgeModel?.result!.queueCount ?? 0) > 0;
        final isQurhomeActive = PreferenceUtil.getIfQurhomeisAcive();
        final isTablet = CommonUtil().isTablet ?? false;
        final isQueueDialogShowen = !isQueueDialogShowing.value;

        // Check if all conditions are met to show the dialog
        if (isNeedSheelaDialog &&
            hasQueueCount &&
            isQurhomeActive &&
            isQueueDialogShowen &&
            !isTablet) {
          showDialogForSheelaBox(
            isFromQurHomeRegimen: isFromQurHomeRegimen,
            isNeedSheelaDialog: isNeedSheelaDialog,
          );
        }
      } else {
        // If response is not successful or result is null,
        // set sheelaIconBadgeCount to 0
        sheelaIconBadgeCount.value = 0;
        _sheelaBadgeModel = null;
      }
    } catch (e, stackTrace) {
      // Handle exceptions, log the error, and set sheelaIconBadgeCount to 0
      CommonUtil().appLogs(message: e, stackTrace: stackTrace);
      sheelaIconBadgeCount.value = 0;
      _sheelaBadgeModel = null;
    }
  }

  Future<int?> playAudioPlayer() async {
    try {
      late AudioCache _audioCache;
      _audioCache = AudioCache();

      String audioasset = 'assets/raw/ns_final.mp3';
      ByteData bytes =
          await rootBundle.load(audioasset); //load sound from assets
      Uint8List soundbytes =
          bytes.buffer.asUint8List(bytes.offsetInBytes, bytes.lengthInBytes);
      int? result = await player?.playBytes(soundbytes);
      player?.play(audioasset);
      return result;
    } catch (e) {
      print(e);
    }
  }

  void updateTimer({bool enable = false}) {
    try {
      if (_popTimer != null && _popTimer!.isActive) {
        printInfo(info: 'Cancelled the timer');
        _popTimer!.cancel();
        _popTimer = null;
      } else if (enable) {
        printInfo(info: 'started the timer');
        _popTimer = Timer(const Duration(seconds: 30), () {
          if (isSheelaScreenActive && bleController == null) {
            printInfo(info: 'timeout the timer');
            stopTTS();
            canSpeak = false;
            isSheelaScreenActive = false;
            getSheelaBadgeCount();
            Get.back();
          }
        });
      }
    } catch (e, stackTrace) {
      CommonUtil().appLogs(message: e, stackTrace: stackTrace);

      printError(info: e.toString());
    }
  }

  void startTimer() {
    _exitAutoTimer = Timer(const Duration(seconds: 10), () {
      Get.back();
    });
  }

  clearTimer() {
    if (_exitAutoTimer != null && _exitAutoTimer!.isActive) {
      _exitAutoTimer!.cancel();
      _exitAutoTimer = null;
    }
  }

  // Method to set up a reconnect timer with a duration of 120 seconds
  void reconnectTimer() {
    // Create a timer that closes the current screen after 120 seconds
    _reconnectTimer = Timer(const Duration(seconds: 120), () {
      Get.back();  // Close the current screen
    });
  }

// Method to clear the reconnect timer
  clearReconnectTimer() {
    // Check if the timer is active and not null
    if (_reconnectTimer != null && _reconnectTimer!.isActive) {
      // Cancel the timer to prevent it from triggering
      _reconnectTimer!.cancel();
      // Set the timer reference to null after cancellation
      _reconnectTimer = null;
    }
  }


  callToCC(SheelaResponse currentResponse) async {
    if ((currentResponse.directCall != null && currentResponse.directCall!) &&
        (currentResponse.recipient != null &&
            currentResponse.recipient!.trim().toLowerCase() == 'cc')) {
      var regController = CommonUtil().onInitQurhomeRegimenController();
      if (CommonUtil()
          .validString(regController.careCoordinatorId.value)
          .trim()
          .isEmpty) {
        regController.getUserDetails();
        await regController.getCareCoordinatorId();
      }
      isCallStartFromSheela = true;
      updateTimer(enable: false);
      regController.callSOSEmergencyServices(1);
    }
  }

  playYoutube(var currentVideoLinkUrl) {
    try {
      if (isLoading.isTrue) {
        return;
      }
      String? videoId;
      videoId = youtube.YoutubePlayer.convertUrlToId(currentVideoLinkUrl);
      updateTimer(enable: false);
      if (videoId != null) {
        Get.to(
          MyYoutubePlayer(
            videoId: videoId,
          ),
        )!
            .then((value) {
          updateTimer(enable: true);
          playPauseTTSFromApi(); // based on toggle flag from qurplus auto read TTS
        });
      } else {
        isPlayPauseView.value = false;
        isFullScreenVideoPlayer.value =
            (CommonUtil().isTablet ?? false) ? true : false;
        Get.to(
          VideoPlayerScreen(
            videoURL: (currentVideoLinkUrl ?? ''),
          ),
        )!
            .then((value) {
          updateTimer(enable: true);
          playPauseTTSFromApi(); // based on toggle flag from qurplus auto read TTS
        });
      }
    } catch (e, stackTrace) {
      CommonUtil().appLogs(message: e, stackTrace: stackTrace);
    }
  }

  playAudioFile(var audioURLLink) {
    try {
      if (isLoading.isTrue) {
        return;
      }
      updateTimer(enable: false);
      Get.to(AudioPlayerScreen(
        audioUrl: (audioURLLink ?? ''),
      ))!
          .then((value) {
        updateTimer(enable: true);
        playPauseTTSFromApi(); // based on toggle flag from qurplus auto read TTS
      });
    } catch (e, stackTrace) {
      CommonUtil().appLogs(message: e, stackTrace: stackTrace);
    }
  }

  onStopTTSWithDelay() async {
    try {
      await Future.delayed(Duration(milliseconds: 100));
      stopTTS();
    } catch (e, stackTrace) {
      CommonUtil().appLogs(message: e, stackTrace: stackTrace);
    }
  }

  String getPronunciationText(SheelaResponse? currentPlayingConversation) {
    return CommonUtil()
        .validString(currentPlayingConversation!.pronunciationText ?? '');
  }

  void startTimerForSessionExpiry(int minutes) {
    if ((minutes != null) && (minutes != '') && (minutes != 0)) {
      _sessionTimeout = Timer(Duration(minutes: (minutes - 1)), () {
        if (PreferenceUtil.getIfSheelaAttachmentPreviewisActive()) {
          FlutterToast()
              .getToastForLongTime(strSessionTimeoutAlert, Colors.black);
        }
      });
    }
  }

  clearTimerForSessionExpiry() {
    if (_sessionTimeout != null && _sessionTimeout!.isActive) {
      _sessionTimeout!.cancel();
      _sessionTimeout = null;
    }
  }

  Future<void> getLanguagesFromApi() async {
    langaugeDropdownList = {};
    try {
      var languageModelList = await languageBlock.getLanguage();
      if (languageModelList != null) {
        if (languageModelList.result != null) {
          for (var languageResultObj in languageModelList.result!) {
            if (languageResultObj.referenceValueCollection != null &&
                languageResultObj.referenceValueCollection!.isNotEmpty) {
              for (var referenceValueCollection
                  in languageResultObj.referenceValueCollection!) {
                if (referenceValueCollection.name != null &&
                    referenceValueCollection.code != null) {
                  langaugeDropdownList.addAll({
                    referenceValueCollection.name?.toLowerCase() ?? '':
                        referenceValueCollection.code ?? ''
                  });
                }
              }
            }
          }
        }
      }
    } catch (e, stackTrace) {
      CommonUtil().appLogs(message: e, stackTrace: stackTrace);
    }
  }

  Future<String?> getTextTranslate(String? text) async {
    try {
      String? selLanguageCode = getCurrentLanCode(splittedCode: true);
      if ((selLanguageCode ?? '').contains('en')) {
        return text;
      }
      Map<String, dynamic> reqJson = Map<String, dynamic>();
      reqJson[qr_textToTranslate] = text;
      reqJson[qr_targetLanguageCode] = getCurrentLanCode(splittedCode: true);
      reqJson[qr_sourceLanguageCode] = 'en';
      final response = await SheelAIAPIService().getTextTranslate(reqJson);
      if (response.statusCode == 200 && (response.body).isNotEmpty) {
        final data = jsonDecode(response.body);
        final GoogleTTSResponseModel googleTTSResponseModel =
            GoogleTTSResponseModel.fromJson(data);
        if ((googleTTSResponseModel != null) &&
            (googleTTSResponseModel.isSuccess ?? false)) {
          String strText =
              (googleTTSResponseModel?.result?.translatedText ?? '');
          return (strText.trim().isNotEmpty) ? strText : text;
        } else {
          return text;
        }
      } else {
        return text;
      }
    } catch (e, stackTrace) {
      CommonUtil().appLogs(message: e, stackTrace: stackTrace);
      return text;
    }
  }

  void showDialogForSheelaBox(
      {bool isNeedSheelaDialog = false, bool isFromQurHomeRegimen = false}) {
    isQueueDialogShowing.value = true;

    CommonUtil().dialogForSheelaQueueStable(Get.context!,
        unReadMsgCount:
            Provider.of<ChatSocketViewModel>(Get.context!, listen: false)
                .chatTotalCount,
        fromQurhomeRegimen: isFromQurHomeRegimen,
        onTapSheelaRemainders: (value) {
      isQueueDialogShowing.value = false;
      Get.back();
      Get.toNamed(
        rt_Sheela,
        arguments: value
            ? SheelaArgument(
                rawMessage: sheelaQueueShowRemind,
              )
            : SheelaArgument(showUnreadMessage: true),
      )?.then((value) {
        ///Update Sheela remainder count
        getSheelaBadgeCount(isNeedSheelaDialog: true);
      });
    });
  }

  /**
   * This method checks the first and last activity time of the day
   * Get the list of times on which the remainder should popup based on
   * the interval time
   * If the device time matched the time with any of the value in the remainder
   * list then check if the remainder count in not empty
   * If not show popup dialog else doesnt
   */
  void showRemainderBasedOnCondition(
      {bool isNeedSheelaDialog = false,
      bool isFromQurHomeRegimen = false}) async {
    String? startDate = PreferenceUtil.getStringValue(SHEELA_REMAINDER_START);
    String? endDate = PreferenceUtil.getStringValue(SHEELA_REMAINDER_END);
    var sheelaAIController = Get.find<SheelaAIController>();
    var qurhomeCOntroller = CommonUtil().onInitQurhomeRegimenController();
    final controllerQurhomeRegimen =
        CommonUtil().onInitQurhomeRegimenController();

    List activitiesFilteredList =
        controllerQurhomeRegimen.remainderTimestamps ?? [];

    if (startDate != null &&
        startDate != '' &&
        endDate != null &&
        endDate != '') {
      if ((DateTime.parse(startDate ?? '').isAtSameMomentAs(DateTime.now()) ||
              DateTime.now().isAfter(DateTime.parse(startDate ?? ''))) &&
          (DateTime.now().isBefore(DateTime.parse(endDate ?? ''))) &&
          (qurhomeCOntroller.evryOneMinuteRemainder != null ||
              qurhomeCOntroller.evryOneMinuteRemainder?.isActive == true)) {
        if (activitiesFilteredList != null &&
            activitiesFilteredList.length > 0) {
          for (int i = 0; i < activitiesFilteredList.length; i++) {
            if (((DateTime.now()
                            .difference(activitiesFilteredList[i])
                            .inMinutes ??
                        0) ==
                    0) ||
                ((DateTime.now()
                            .difference(activitiesFilteredList[i])
                            .inMinutes ??
                        0) ==
                    1)) {
              if (((sheelaAIController.sheelaIconBadgeCount.value ?? 0)) > 0) {
                if (isQueueDialogShowing.value == false) {
                  playAudioPlayer().then((value) {
                    activitiesFilteredList.removeAt(i);
                    showDialogForSheelaBox(
                        isFromQurHomeRegimen: isFromQurHomeRegimen,
                        isNeedSheelaDialog: isNeedSheelaDialog);
                  });
                }
              }
            }
          }
        }
      } else if (((DateTime.parse(endDate ?? '')
                  .isAtSameMomentAs(DateTime.now())) ||
              (DateTime.now().isAfter(DateTime.parse(endDate ?? '')))) &&
          (qurhomeCOntroller.evryOneMinuteRemainder != null &&
              qurhomeCOntroller.evryOneMinuteRemainder?.isActive == true)) {
        qurhomeCOntroller.evryOneMinuteRemainder?.cancel();
        PreferenceUtil.saveString(SHEELA_REMAINDER_START, '');
        PreferenceUtil.saveString(SHEELA_REMAINDER_END, '');
      }
    }
  }

  playPauseTTS(SheelaResponse chat) {
    try {
      if (isLoading.isTrue) {
        return;
      }
      if (chat.isPlaying.isTrue) {
        stopTTS();
      } else {
        stopTTS();
        currentPlayingConversation = chat;
        playTTS();
      }
    } catch (e, stackTrace) {
      CommonUtil().appLogs(message: e, stackTrace: stackTrace);
    }
  }

  String? prefixListFiltering(String strResponse) {
    try {
      for (String strSheelaText in sheelaTTSWordList) {
        if ((strResponse ?? '')
            .toLowerCase()
            .contains(strSheelaText.toLowerCase())) {
          var regEx = RegExp(strSheelaText, caseSensitive: false);
          strResponse = strResponse.replaceAll(regEx, sheelaText);
        }
      }
      return strResponse;
    } catch (e, stackTrace) {
      CommonUtil().appLogs(message: e, stackTrace: stackTrace);
      return strResponse;
    }
  }

  Future<void> freeTextConversation({dynamic freeText}) async {
    try {
      if (freeText != null) {
        // Translate user input and Sheela's response
        List<String?> translationsText = await Future.wait([
          getTextTranslate(freeText),
          getTextTranslate(
              freeTextReply + (freeText ?? '') + freeTextReplyConfirm),
        ]);

        // Reset loading flag and remove the loading response from conversations
        isLoading.value = false;
        conversations.removeLast();

        // Add user's response to the conversation (right user card)
        conversations.add(SheelaResponse(text: translationsText[0]));
        scrollToEnd();

        // Add Sheela's response to the conversation (left sheela card)
        await Future.delayed(Duration(seconds: 1));
        isLoading.value = true;
        conversations.add(SheelaResponse(
            loading: true)); // Add loading response to conversations
        scrollToEnd(); // Scroll to the end of conversations
        SheelaResponse currentCon = SheelaResponse(
          text: translationsText[1],
          recipientId: sheelaRecepId,
          endOfConv: false,
          endOfConvDiscardDialog: false,
          singleuse: true,
          isActionDone: false,
          isButtonNumber: false,
          buttons: await freeTextButtons(freeTextPayload: freeText),
        );
        // Reset loading flag and remove the loading response from conversations
        isLoading.value = false;
        conversations.removeLast();
        conversations.add(currentCon);
        currentPlayingConversation = currentCon;
        isLoading.value = false;
        playTTS();
        scrollToEnd();
      }
    } catch (e, stackTrace) {
      // Handle exceptions and log
      CommonUtil().appLogs(message: e, stackTrace: stackTrace);
    }
  }

  Future<List<Buttons>> freeTextButtons({String? freeTextPayload}) async {
    // Translate button titles
    List<String?> translatedTexts = await Future.wait([
      getTextTranslate(strContinue),
      getTextTranslate(strRedo),
      getTextTranslate(strExit),
    ]);

    // Create Buttons with translated titles and payloads
    return [
      Buttons(title: translatedTexts[0], payload: freeTextPayload),
      Buttons(title: translatedTexts[1], btnRedirectTo: strRedirectRedo),
      Buttons(
          title: translatedTexts[2],
          payload: strExit,
          mute: sheela_hdn_btn_yes),
    ];
  }

  // Function to generate a list of button configurations for image preview
  List<Buttons> sheelaImagePreviewButtons(
      String? btnTitle, String? requestFileType) {
    List<Buttons> buttons = [
      Buttons(
        title: strCamelYes, // Button title
        payload: btnTitle, // Payload data (optional)
        btnRedirectTo:
            getRedirectTo(requestFileType), // Redirection information
      ),
      Buttons(
        title: getButtonTitle(requestFileType), // Button title
        btnRedirectTo: getRetakeTo(requestFileType), // Redirection information
      ),
      Buttons(
        title: strExit, // Button title
        payload: strExit, // Payload data
        mute: sheela_hdn_btn_yes, // Mute flag (optional)
      ),
    ];
    return buttons;
  }

  // Get the redirect action based on the request file type
  String? getRedirectTo(requestFileType) {
    switch (requestFileType) {
      case strImage:
        return strRedirectToUploadImage;
      case strAudio:
        return strRedirectToUploadAudio;
      case strVideo:
        return strRedirectToUploadVideo;
    }
    // Return an empty string if the request file type is not recognized
    return '';
  }

// Get the retake action based on the request file type
  String? getRetakeTo(requestFileType) {
    switch (requestFileType) {
      case strImage:
        return strRedirectRetakePicture;
      case strAudio:
        return strRedirectRetakeAudio;
      case strVideo:
        return strRedirectRetakeVideo;
    }
    // Return an empty string if the request file type is not recognized
    return '';
  }

  // Function to get the title based on the request file type
  String? getTitle(requestFileType) {
    // Using a switch statement to determine the file type
    switch (requestFileType) {
      case strImage:
        // Return the title for an image file
        return strImageConfirmTitle;
      case strAudio:
        // Return the title for an audio file
        return strAudioConfirmTitle;
      case strVideo:
        // Return the title for a video file
        return strVideoConfirmTitle;
    }
    // Return an empty string if the request file type is not recognized
    return '';
  }

// Get the button title based on the request file type
  String? getButtonTitle(requestFileType) {
    switch (requestFileType) {
      case strImage:
        return strRecapture;
      case strAudio:
        return strRecordAgain;
      case strVideo:
        return strRecordAgain;
    }
    // Return an empty string if the request file type is not recognized
    return '';
  }

  // A function to handle the logic for displaying in the Sheela chat
  Future<void> sheelaFileStaticConversation(
      {String? btnTitle, // Optional button title
      String? selectedImagePath, // Path to the selected image
      String? requestFileType}) async {
    try {
      // Left Sheela card setup
      isLoading.value = true; // Set loading flag to true
      SheelaResponse currentCon =
          SheelaResponse(); // Create a new SheelaResponse instance
      currentCon.recipientId = sheelaRecepId; // Set recipient ID
      currentCon.text = getTitle(requestFileType); // Set title to that card
      currentCon.endOfConv = false; // Set end of conversation flag to false
      currentCon.endOfConvDiscardDialog =
          false; // Set end of conversation discard dialog flag to false
      currentCon.singleuse = true; // Set single use flag to true
      currentCon.isActionDone = false; // Set action done flag to false
      currentCon.isButtonNumber = false; // Set button number flag to false
      currentCon.recipientId =
          sheelaRecepId; // Set recipient ID again (duplicated line?)
      currentCon.buttons = sheelaImagePreviewButtons(
          btnTitle, requestFileType); // Generate buttons for the Sheela card
      if (requestFileType == strImage) {
        currentCon.imageThumbnailUrl =
            selectedImagePath; // Set image thumbnail URL
      } else if (requestFileType == strAudio) {
        currentCon.audioThumbnailUrl =
            selectedImagePath; // Set audio thumbnail URL
      } else if (requestFileType == strVideo) {
        currentCon.videoThumbnailUrl =
            selectedImagePath; // Set audio thumbnail URL
        Future.delayed(const Duration(seconds: 1)).then((_) => scrollToEnd());
      }
      if (isRetakeCapture ?? false) {
        isLoading.value = false; // Set loading flag to false
        conversations.removeLast(); // Remove the last conversation (if retake)
      }
      conversations.add(currentCon); // Add the current conversation to the list
      currentPlayingConversation =
          currentCon; // Set the current playing conversation
      isLoading.value = false; // Set loading flag to false
      isRetakeCapture = false; // Reset retake flag
      canSpeak = true;
      playTTS(); // Check for play the conversation
      scrollToEnd(); // Scroll to the end of the conversation
    } catch (e, stackTrace) {
      // Catch any exceptions and log them
      CommonUtil().appLogs(message: e, stackTrace: stackTrace);
    }
  }

  // A function to show a dialog with options to choose from Camera or Gallery
  Future<void> showCameraGalleryDialog(
      String? btnTitle, String? requestFileType) {
    if (requestFileType == strImage) {
      return imgFromCamera(
          strGallery, btnTitle); // Handle action when Camera is tapped
    } else {
      // Show a dialog using the showDialog function
      return showDialog(
        context: Get.context!, // Use Get.context to get the current context
        builder: (context) {
          // Return an AlertDialog with title and content
          return AlertDialog(
            title: Text('Choose an action'), // Set the title of the dialog
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  // Gallery option with GestureDetector
                  GestureDetector(
                    onTap: () {
                      getOpenGallery(
                          requestFileType == strImage ? strGallery : strVideo,
                          btnTitle,
                          requestFileType); // Handle action when Gallery is tapped
                      Navigator.of(context).pop(); // Close the dialog
                    },
                    child: Text(requestFileType == strImage
                        ? Gallery
                        : strSelectVideo), // Display "Gallery" text
                  ),
                  Padding(padding: EdgeInsets.all(8)),
                  // Add padding between options
                  // Camera option with GestureDetector
                  GestureDetector(
                    onTap: () {
                      openVideoCamera(btnTitle, requestFileType);
                      Navigator.of(context).pop(); // Close the dialog
                    },
                    child: Text(requestFileType == strImage
                        ? Camera
                        : strRecordVideo), // Display "Camera" text
                  ),
                ],
              ),
            ),
          );
        },
      );
    }
  }

  // Function to capture an image from the camera and trigger image preview
  imgFromCamera(String fromPath, String? btnTitle) async {
    late File _image; // Declare a variable to store the captured image
    //
    // var picker = ImagePicker(); // Create an instance of ImagePicker
    // var pickedFile = await picker.pickImage(source: ImageSource.camera, imageQuality: 80); // Capture an image from the camera
    //
    // if (pickedFile != null) {
    //   _image = File(pickedFile.path); // Create a File object from the captured image path
    //
    //   // Trigger the image preview thumbnail with the captured image path
    //   sheelaFileStaticConversation(
    //       btnTitle: btnTitle, // Optional button title
    //       selectedImagePath: _image.path, // Path to the captured image
    //       requestFileType: strImage);
    List<CameraDescription> cameras = await availableCameras();

    await Get.to(CameraPreviewScreen(
      cameras: cameras,
    ))?.then((value) {
      if (value != null) {
        _image = File(
            value.path); // Create a File object from the captured image path

        // Trigger the image preview thumbnail with the captured image path
        sheelaFileStaticConversation(
            btnTitle: btnTitle, // Optional button title
            selectedImagePath: _image.path, // Path to the captured image
            requestFileType: strImage);
      }
    });
    // Navigator.push(
    //     context,
    //     MaterialPageRoute(
    //     builder: (context) {
    //   return CameraPreviewScreen(
    //     cameras: cameras,
    //   );
    // })).then((value) {
    //   if(value!=null){
    //     _image = File(value.path); // Create a File object from the captured image path
    //
    //     // Trigger the image preview thumbnail with the captured image path
    //     sheelaFileStaticConversation(
    //         btnTitle: btnTitle, // Optional button title
    //         selectedImagePath: _image.path, // Path to the captured image
    //         requestFileType: strImage);
    //   }
    // });
  }

  // Function to open the gallery, crop the selected image, and trigger image preview
  void getOpenGallery(
      String fromPath, String? btnTitle, String? requestFileType) {
    // Use PickImageController to crop the image from the gallery
    PickImageController.instance
        .cropImageFromFile(fromPath)
        .then((croppedFile) async {
      if (croppedFile != null) {
        // Validate the size of the cropped image
        if (await validateImageSize(croppedFile, requestFileType)) {
          var imagePathGallery = croppedFile.path;

          // Check if the image path is not null or empty
          if (imagePathGallery != null && imagePathGallery != '') {
            // Trigger the image preview thumbnail with the cropped image path
            sheelaFileStaticConversation(
                btnTitle: btnTitle,
                // Optional button title
                selectedImagePath: imagePathGallery,
                // Path to the cropped image
                requestFileType: requestFileType);
          }
        } else {
          // Check if the requested file type is an image
          if (requestFileType == strImage) {
            // Display a long-duration toast with image size validation message in red
            FlutterToast()
                .getToastForLongTime(strImageSizeValidation, Colors.red);
          } else {
            // Display a long-duration toast with video size validation message in red
            FlutterToast()
                .getToastForLongTime(strVideoSizeValidation, Colors.red);
          }
        }
      }
    });
  }

  // Function to save media regiment information
  Future<AddMediaRegimentModel> saveMediaRegiment(
      String imagePaths, String? providerId) async {
    // Get the patient ID from shared preferences
    var patientId = PreferenceUtil.getStringValue(KEY_USERID);

    // Make an API call to save regiment media using the helper class
    final response = await _helper.saveRegimentMedia(
        qr_save_regi_media, imagePaths, patientId, providerId);

    // Return the parsed response as an AddMediaRegimentModel
    return AddMediaRegimentModel.fromJson(response);
  }

  // Function to validate the size of a selected image
  Future<bool> validateImageSize(
      var _selectedImage, String? requestFileType) async {
    try {
      int maxSizeInBytes;
      if (requestFileType == strImage) {
        maxSizeInBytes =
            5 * 1024 * 1024; // Set the maximum allowed size to 5MB to image
      } else {
        maxSizeInBytes =
            100 * 1024 * 1024; // Set the maximum allowed size to 100MB to video
      }

      int selectedImageSize = await _getImageSize(
          _selectedImage); // Get the size of the selected image

      // Check if the selected image size exceeds the maximum allowed size
      if (selectedImageSize > maxSizeInBytes) {
        //print('Selected image exceeds the maximum allowed size');
        return false; // Return false if the image size is too large
      } else {
        //print('Selected image size is within the allowed limit');
        return true; // Return true if the image size is within the allowed limit
      }
    } catch (e, stackTrace) {
      // Catch any exceptions and log them
      CommonUtil().appLogs(message: e, stackTrace: stackTrace);
      return false; // Return false in case of an exception
    }
  }

  // Function to get the size of an image file
  Future<int> _getImageSize(File imageFile) async {
    int length =
        await imageFile.lengthSync(); // Get the length (size) of the image file
    return length; // Return the size of the image file
  }

  // Asynchronously get the file size of a video given its file path
  Future<int> getVideoFileSize(String videoFilePath) async {
    // Create a File object using the provided video file path
    File videoFile = File(videoFilePath);

    // Get the length (size) of the video file in bytes
    int fileSizeInBytes = await videoFile.length();

    // Convert the file size from bytes to megabytes
    int fileSizeInMB = fileSizeInBytes ~/ (1024 * 1024);

    // Return the file size in megabytes
    return fileSizeInMB;
  }

  openVideoCamera(String? btnTitle, String? requestFileType) async {
    late File _video; // Declare a variable to store the captured image
    int maxFileSizeMB = 100;
    var picker = ImagePicker(); // Create an instance of ImagePicker
    var pickedFile = await picker.pickVideo(
        source: ImageSource.camera); // Capture an image from the camera

    if (pickedFile != null) {
      getVideoFileSize(pickedFile.path).then((fileSizeInMB) {
        if (fileSizeInMB > maxFileSizeMB) {
          FlutterToast()
              .getToastForLongTime(strVideoSizeValidation, Colors.red);
        } else {
          _video = File(pickedFile
              .path); // Create a File object from the captured image path

          // Trigger the image preview thumbnail with the captured image path
          sheelaFileStaticConversation(
              btnTitle: btnTitle, // Optional button title
              selectedImagePath: _video.path, // Path to the captured image
              requestFileType: strVideo);
        }
      });
    }
  }

  @override
  void onClose() {
    try {
      // Cancel the countdown timer if it's active
      countDownSecondsTimer?.cancel();
      countDownSecondsTimer = null;

      // Close the stream controller to release resources
      streamEvents.close();

      // Stop speech listening using a method (assuming it's defined in the same class)
      stopSpeechListening();

      // Cancel all timers when the widget is disposed
      clearAllTimers();

      // Call the parent class's onClose method
      super.onClose();
    } catch (e, stackTrace) {
      // Handle any exceptions that occur during cleanup and log them
      CommonUtil().appLogs(message: e, stackTrace: stackTrace);
    }
  }

  // Initiates the voice assistant interaction process
  initiateVoiceAssistantInteraction() async {
    try {
      // Set up the countdown timer and stream for handling events
      setupCountdownTimerAndStream();

      // Show a dialog indicating that the voice assistant is listening
      showListeningCountdownDialog();

      // Initialize and configure the speech recognizer
      initializeAndConfigureSpeechRecognizer();
    } catch (e, stackTrace) {
      // Handle any exceptions that occur during the initiation process and log them
      CommonUtil().appLogs(message: e, stackTrace: stackTrace);
    }
  }

  // Sets up a countdown timer and stream for handling countdown events
  void setupCountdownTimerAndStream() {
    try {
      // Create a stream controller for handling countdown events of type int
      streamEvents = StreamController<int>();

      // Initialize the stream with the initial countdown value (e.g., 10 seconds)
      streamEvents.add(10);

      // Set the initial value of the countdown seconds remaining
      countDownSecondsRemaining.value = 10;

      // Cancel the existing countdown timer if it's active
      if (countDownSecondsTimer != null) {
        countDownSecondsTimer?.cancel();
      }

      // Set up a new periodic timer to update the countdown
      countDownSecondsTimer =
          Timer.periodic(const Duration(seconds: 1), (timer) {
        // Check if the stream is still open to avoid unnecessary updates
        if (!streamEvents.isClosed) {
          // Decrease the countdown seconds remaining
          if (countDownSecondsRemaining > 0) {
            countDownSecondsRemaining.value--;
          } else {
            // If countdown is complete, cancel the timer
            countDownSecondsTimer?.cancel();
          }

          // Add the updated countdown value to the stream
          streamEvents.add(countDownSecondsRemaining.value);

          // Check and handle any actions needed upon countdown completion
          checkAndHandleCountdownCompletion();
        } else {
          // If the stream is closed, cancel the timer
          countDownSecondsTimer?.cancel();
        }
      });
    } catch (e, stackTrace) {
      // Handle any exceptions that occur during the setup process and log them
      CommonUtil().appLogs(message: e, stackTrace: stackTrace);
    }
  }

  // Checks and handles actions upon countdown completion
  void checkAndHandleCountdownCompletion() async {
    try {
      // Check if the countdown has reached zero
      if (countDownSecondsRemaining.value == 0) {
        // If countdown is complete, close the countdown dialog and perform cleanup
        await closeCountdownTimerDialogAndCleanup();

        // Stop speech listening as the countdown is complete
        stopSpeechListening();

        // Set the value of isMicListening to false.
        isMicListening.value = false;
      }
    } catch (e, stackTrace) {
      // Handle any exceptions that occur during the completion check and log them
      CommonUtil().appLogs(message: e, stackTrace: stackTrace);
    }
  }

  // Closes the countdown timer dialog and performs cleanup
  closeCountdownTimerDialogAndCleanup() async {
    try {
      // Close the stream controller to release resources
      await streamEvents.close();
      // Set the flag indicating that the countdown dialog is not showing
      isCountDownDialogShowing.value = false;

      // Close the countdown timer dialog using GetX
      Get.back();

      // Cancel the countdown timer if it's active
      countDownSecondsTimer?.cancel();
      countDownSecondsTimer = null;
    } catch (e, stackTrace) {
      // Handle any exceptions that occur during the cleanup process and log them
      CommonUtil().appLogs(message: e, stackTrace: stackTrace);
    }
  }

  // Shows a dialog indicating that the voice assistant is listening with a countdown timer
  showListeningCountdownDialog() {
    // Set the flag indicating that the countdown dialog is currently showing
    isCountDownDialogShowing.value = true;

    return showDialog<void>(
      context: Get.context!,
      barrierDismissible: false,
      barrierColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(builder: (context, setState) {
          return WillPopScope(
            // Disable the ability to dismiss the dialog by pressing the back button
            onWillPop: () async => false,
            child: AlertDialog(
              backgroundColor: Colors.transparent,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6),
              ),
              content: StreamBuilder<int>(
                // Listen to the countdown stream for updates
                stream: streamEvents.stream,
                builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
                  final double containerSize =
                      MediaQuery.of(context).size.width * 0.8;

                  return Material(
                    color: Colors.transparent,
                    child: Container(
                      width: containerSize,
                      height: containerSize,
                      color: Colors.transparent,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          // Loading spinner animation
                          SpinKitDoubleBounce(
                            size: containerSize,
                            // This sets the color using hexadecimal representation (0xFFd6c7f4)
                            color: Color(0xFFd6c7f4),
                            /*color: PreferenceUtil.getIfQurhomeisAcive()
                                ? Color(CommonUtil().getQurhomeGredientColor()).withOpacity(0.2)
                                : Color(CommonUtil().getMyPrimaryColor()).withOpacity(0.2),*/
                          ),
                          // Text displaying 'Listening' and the countdown seconds
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                strListening,
                                style: TextStyle(
                                  fontSize: containerSize * 0.07,
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                "${(snapshot.data.toString() ?? '0')} $strSeconds",
                                style: TextStyle(
                                  fontSize: containerSize * 0.08,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          );
        });
      },
    );
  }

  // This method handles the Speech to text initialization process, status updates, and errors.
  initializeAndConfigureSpeechRecognizer() async {
    try {
      // Initialize the SpeechToText recognizer
      await speechToText?.initialize(
        // Callback for status updates
        onStatus: (status) {
          // Check if the status is not 'Listening'
          if (status.toString().toLowerCase() != strListening.toLowerCase()) {
            // If Sheela's input dialog is showing, trigger a refresh and start listening
            if (isSheelaInputDialogShowing.value) {
              // Initiate the speech listening process
              initiateSpeechListening();
            }
          }
        },
        // Callback for errors
        onError: (error) {
          // Initiate the speech listening process
          initiateSpeechListening();
        },
      );
      // Initiate the speech listening process
      initiateSpeechListening();
    } catch (e, stackTrace) {
      // Handle any exceptions that occur during initialization and log them
      CommonUtil().appLogs(message: e, stackTrace: stackTrace);
    }
  }

  // Initiates the speech listening process
  initiateSpeechListening() async {
    try {
      isSheelaInputStarted = true;
      if (Platform.isIOS) {
        sheelaInputTextEditingController.text = '';
      }
      // Start listening using the SpeechToText recognizer
      await speechToText?.listen(
        // Callback for speech recognition results
        onResult: handleSpeechRecognitionResult,

        // Set the maximum duration for listening to 2 minutes
        listenFor: const Duration(minutes: 2),

        // Specify the locale for speech recognition
        localeId: currentLanguageCode.value,
      );
    } catch (e, stackTrace) {
      // Handle any exceptions that occur during speech listening and log them
      CommonUtil().appLogs(message: e, stackTrace: stackTrace);
    }
  }

  // Stops the speech listening process
  stopSpeechListening() async {
    try {
      isSheelaInputStarted = false;
      // Stop the speech recognition using the SpeechToText recognizer
      await speechToText?.stop();

      // Clear the input text in the Sheela's input text editing controller
      sheelaInputTextEditingController.text = '';
    } catch (e, stackTrace) {
      // Handle any exceptions that occur during stopping speech listening and log them
      CommonUtil().appLogs(message: e, stackTrace: stackTrace);
    }
  }

  // Handles the speech recognition result
  // This method is called when the SpeechToText recognizer provides a recognition result.
  handleSpeechRecognitionResult(SpeechRecognitionResult result) async {
    try {
      // Check if the countdown dialog is currently showing and close it if true
      if (isCountDownDialogShowing.value) {
        await closeCountdownTimerDialogAndCleanup();
      }

      // Check if Sheela's input dialog is not showing, and show it if true
      if (!isSheelaInputDialogShowing.value && isSheelaInputStarted) {
        showSpeechToTextInputDialog();
      } else {
        var recognizedWords = result.recognizedWords;
        if (Platform.isIOS) {
          sheelaInputTextEditingController.text = '$recognizedWords ';
          // Perform further actions if the region is US
          if (CommonUtil.isUSRegion()) {
            // Extract the response from the input text, trim, and handle it
            final response = CommonUtil()
                .validString(sheelaInputTextEditingController.text)
                .trim();
            if (_debounceRecognizedWords?.isActive ?? false) {
              _debounceRecognizedWords?.cancel();
            }
            _debounceRecognizedWords =
                Timer(const Duration(milliseconds: 500), () async {
              await closeSheelaInputDialogAndStopListening();

              // Handle the Sheela's input response
              if (result.finalResult) {
                // Close Sheela's input dialog and stop listening
                await handleSheelaInputResponse(response);
              }
            });
          }
        }
      }

      // Check if the recognition result is final
      if ((result?.finalResult ?? false) && Platform.isAndroid) {
        // Extract recognized words and update the input text
        var recognizedWords = result?.recognizedWords ?? '';

        sheelaInputTextEditingController.text += '$recognizedWords ';

        // Log the recognized text in debug mode
        if (kDebugMode) {
          log('onSpeechResult here ${sheelaInputTextEditingController.text}');
        }

        // Perform further actions if the region is US
        if (CommonUtil.isUSRegion()) {
          // Extract the response from the input text, trim, and handle it
          String response = CommonUtil()
              .validString(sheelaInputTextEditingController.text)
              .trim();

          // Close Sheela's input dialog and stop listening
          await closeSheelaInputDialogAndStopListening();

          // Handle the Sheela's input response
          handleSheelaInputResponse(response);
        }
      }
    } catch (e, stackTrace) {
      // Handle any exceptions that occur during result handling and log them
      CommonUtil().appLogs(message: e, stackTrace: stackTrace);
    }
  }

  // Shows the input dialog for Sheela's speech-to-text interaction
  showSpeechToTextInputDialog() {
    // Set the flag indicating that Sheela's input dialog is currently showing
    isSheelaInputDialogShowing.value = true;
    return showDialog(
        context: Get.context!,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return WillPopScope(
            // Disable the ability to dismiss the dialog by pressing the back button
            onWillPop: () async => false,
            child: AlertDialog(
              insetPadding: EdgeInsets.only(
                  left: CommonUtil().isTablet! ? 0.0 : 25,
                  right: CommonUtil().isTablet! ? 0.0 : 25),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              titlePadding: EdgeInsets.zero,
              contentPadding: EdgeInsets.only(top: 0.0),
              content: Container(
                width: CommonUtil().isTablet!
                    ? MediaQuery.of(context).size.width * 0.6
                    : MediaQuery.of(context).size.width,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(
                          right: CommonUtil().isTablet! ? 20 : 10, top: 5.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          IconButton(
                            icon: Icon(
                              Icons.close,
                              color: Color(0xFF282828),
                              size: CommonUtil().isTablet! ? 35.0.sp : 24.0.sp,
                            ),
                            onPressed: () {
                              // Close Sheela's input dialog and stop listening
                              closeSheelaInputDialogAndStopListening();
                            },
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: CommonUtil().isTablet! ? 20.0 : 10.0,
                    ),
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        SpinKitDoubleBounce(
                          size: CommonUtil().isTablet! ? 300.0 : 200.0,
                          // This sets the color using hexadecimal representation (0xFFd6c7f4)
                          color: Color(0xFFd6c7f4),
                          /*color: PreferenceUtil.getIfQurhomeisAcive()
                              ? Color(CommonUtil().getQurhomeGredientColor()).withOpacity(0.2)
                              : Color(CommonUtil().getMyPrimaryColor()).withOpacity(0.2),*/
                        ),
                        Image.asset(
                          icon_mayaMain, // replace with your image
                          width: CommonUtil().isTablet! ? 200.0 : 100.0,
                          height: CommonUtil().isTablet! ? 200.0 : 100.0,
                        ),
                      ],
                    ),
                    SizedBox(
                      height: CommonUtil().isTablet! ? 50.0 : 15.0,
                    ),
                    Visibility(
                      visible: !(CommonUtil.isUSRegion()),
                      child: Container(
                        margin: EdgeInsets.all(10),
                        padding: EdgeInsets.only(
                            right: (CommonUtil().isTablet ?? false) ? 7 : 5,
                            left: (CommonUtil().isTablet ?? false) ? 10 : 5,
                            top: (CommonUtil().isTablet ?? false) ? 7 : 2,
                            bottom: (CommonUtil().isTablet ?? false) ? 7 : 2),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black),
                          borderRadius: BorderRadius.circular(
                              CommonUtil().isTablet! ? 40.0 : 20.0),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                controller: sheelaInputTextEditingController,
                                maxLines: 5,
                                minLines: 1,
                                style: TextStyle(
                                  fontSize: (CommonUtil().isTablet ?? false)
                                      ? 18.0.sp
                                      : null,
                                  fontFamily: font_roboto,
                                  color: Colors
                                      .black, // Set your desired text color here
                                ),
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.zero,
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () async {
                                // Process and handle Sheela's input response
                                String response = CommonUtil()
                                    .validString(
                                        sheelaInputTextEditingController.text)
                                    .trim();
                                if (response.isEmpty) {
                                  FlutterToast().getToast(
                                      strPleaseEnterValidInput, Colors.black54);
                                } else {
                                  await closeSheelaInputDialogAndStopListening();
                                  handleSheelaInputResponse(response);
                                }
                              },
                              child: Icon(
                                Icons.send_sharp,
                                color: Color(0xFF5E1FE0),
                                size:
                                    CommonUtil().isTablet! ? 35.0.sp : 28.0.sp,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }

  // Closes Sheela's input dialog and stops speech listening
  closeSheelaInputDialogAndStopListening() async {
    try {
      if (isSheelaInputDialogShowing.value) {
        Get.back();
      }
      // Set the flag indicating that Sheela's input dialog is not showing
      isSheelaInputDialogShowing.value = false;
      // Stop speech listening
      await stopSpeechListening();

      if (isCountDownDialogShowing.value) {
        await closeCountdownTimerDialogAndCleanup();
      }
    } catch (e, stackTrace) {
      // Handle any exceptions that occur during the closing process and log them
      CommonUtil().appLogs(message: e, stackTrace: stackTrace);
    }
  }

  // Handles the response received from Sheela's input
  handleSheelaInputResponse(String? response) async {
    try {
      isMicListening.value = false;
      /*if (Platform.isIOS) {
        await Future.delayed(const Duration(seconds: 1));
      }*/

      if ((response ?? '').toString().isNotEmpty) {
        if ((currentLanguageCode.value ?? '').contains('en')) {
          response = prefixListFiltering(response ?? '');
        }
        if ((conversations.isNotEmpty) &&
            (conversations
                    .last?.additionalInfoSheelaResponse?.reconfirmationFlag ??
                false)) {
          redoCurrentPlayingConversation = conversations.last;
          isLoading.value = true; // Set loading flag
          conversations.add(SheelaResponse(
              loading: true)); // Add loading response to conversations
          scrollToEnd(); // Scroll to the end of conversations
          freeTextConversation(freeText: response);
        } else {
          final newConversation = SheelaResponse(text: response);
          if (conversations.isNotEmpty &&
              ((conversations.last?.buttons?.length ?? 0) > 0)) {
            try {
              var responseRecived = response.toString().toLowerCase().trim();

              dynamic button = null;

              if (!(conversations.last?.isButtonNumber ?? false)) {
                if (responseRecived == carGiverSheela) {
                  responseRecived = careGiverSheela;
                }
                for (var btn in conversations.last?.buttons) {
                  // Check if the title of the button matches the response or any of its synonyms
                  if ((btn.title ?? '').toLowerCase() ==
                          responseRecived.toLowerCase() ||
                      (btn.synonymsList != null &&
                          btn.synonymsList.any((synonym) =>
                              synonym.toLowerCase() ==
                              responseRecived.toLowerCase()))) {
                    button = btn;
                    break; // Exit the loop if a match is found
                  }
                }
              } else if ((conversations.last?.isButtonNumber ?? false)) {
                bool isDigit = CommonUtil().isNumeric(responseRecived);
                for (int i = 0; i < conversations.last?.buttons.length; i++) {
                  var temp = conversations.last?.buttons[i].title.split('.');
                  var realNumber = CommonUtil()
                      .realNumber(int.tryParse(temp[0].toString().trim()));
                  var optionWithRealNumber =
                      'Option ${realNumber.toString().trim()}';
                  var optionWithDigit = 'Option ${temp[0].toString().trim()}';
                  var numberWithRealNumber =
                      'Number ${realNumber.toString().trim()}';
                  var numberWithDigit = 'Number ${temp[0].toString().trim()}';
                  if (((temp[isDigit ? 0 : 1].toString().trim())
                              .toLowerCase() ==
                          responseRecived) ||
                      (realNumber.toString().toLowerCase().trim() ==
                          responseRecived) ||
                      (optionWithRealNumber.toString().toLowerCase().trim() ==
                          responseRecived) ||
                      (optionWithDigit.toString().toLowerCase().trim() ==
                          responseRecived) ||
                      (numberWithRealNumber.toString().toLowerCase().trim() ==
                          responseRecived) ||
                      (numberWithDigit.toString().toLowerCase().trim() ==
                          responseRecived)) {
                    button = conversations.last?.buttons[i];
                    break;
                  }
                }
              }
              if (button != null) {
                if (button?.btnRedirectTo == strPreviewScreen) {
                  if (button?.chatAttachments != null &&
                      (button?.chatAttachments?.length ?? 0) > 0) {
                    if (isLoading.isTrue) {
                      return;
                    }
                    stopTTS();
                    isSheelaScreenActive = false;
                    CommonUtil()
                        .onInitQurhomeDashboardController()
                        .setActiveQurhomeDashboardToChat(status: false);
                    Get.to(
                      AttachmentListSheela(
                          chatAttachments: button?.chatAttachments ?? []),
                    )?.then((value) {
                      isSheelaScreenActive = true;
                      playPauseTTSFromApi(); // based on toggle flag from qurplus auto read TTS
                    });
                  }
                } else if (button?.btnRedirectTo == strRedirectToHelpPreview) {
                  if (button?.videoUrl != null && button?.videoUrl != '') {
                    playYoutube(button?.videoUrl);
                  } else if (button?.audioUrl != null &&
                      button?.audioUrl != '') {
                    playAudioFile(button?.audioUrl);
                  } else if (button?.imageUrl != null &&
                      button?.imageUrl != '') {
                    isSheelaScreenActive = false;
                    Get.to(FullPhoto(
                      url: button?.imageUrl ?? '',
                      titleSheelaPreview: strImageTitle,
                    ))?.then((value) {
                      isSheelaScreenActive = true;
                      playPauseTTSFromApi(); // based on toggle flag from qurplus auto read TTS
                    });
                  }
                } else if (button?.btnRedirectTo == strRedirectRedo) {
                  final cardResponse = SheelaResponse(text: button?.title);
                  conversations.add(cardResponse);
                  scrollToEnd();
                  Future.delayed(Duration(seconds: 2), () {
                    conversations.add(redoCurrentPlayingConversation);
                    currentPlayingConversation = redoCurrentPlayingConversation;
                    isLoading.value = false;
                    playTTS();
                    scrollToEnd();
                  });
                } else if ((button?.btnRedirectTo ?? '') ==
                    strHomeScreenForce.toLowerCase()) {
                  Get.back();
                } else if ((button?.isSnoozeAction ?? false)) {
                  /// we can true this condition is for if snooze enable from api
                  try {
                    var apiReminder;
                    Reminder reminder = Reminder();
                    reminder.uformname = conversations
                            .last
                            ?.additionalInfoSheelaResponse
                            ?.snoozeData
                            ?.uformName ??
                        '';
                    reminder.activityname = conversations
                            .last
                            ?.additionalInfoSheelaResponse
                            ?.snoozeData
                            ?.activityName ??
                        '';
                    reminder.title = conversations.last
                            ?.additionalInfoSheelaResponse?.snoozeData?.title ??
                        '';
                    reminder.description = conversations
                            .last
                            ?.additionalInfoSheelaResponse
                            ?.snoozeData
                            ?.description ??
                        '';
                    reminder.eid = conversations.last
                            ?.additionalInfoSheelaResponse?.snoozeData?.eid ??
                        '';
                    reminder.estart = CommonUtil()
                        .snoozeDataFormat(DateTime.now().add(Duration(
                            minutes: int.parse(button?.payload ?? '0'))))
                        .toString();
                    reminder.dosemeal = conversations
                            .last
                            ?.additionalInfoSheelaResponse
                            ?.snoozeData
                            ?.dosemeal ??
                        '';
                    reminder.snoozeTime =
                        CommonUtil().getTimeMillsSnooze(button?.payload ?? '');
                    reminder.tplanid = '0';
                    reminder.teid_user = '0';
                    reminder.remindin = '0';
                    reminder.remindin_type = '0';
                    reminder.providerid = '0';
                    reminder.remindbefore = '0';
                    reminder.otherinfo = Otherinfo();
                    List<Reminder> data = [reminder];
                    for (var i = 0; i < data.length; i++) {
                      apiReminder = data[i];
                    }

                    // snooze invoke to android native for locally save the reminder data
                    QurPlanReminders.getTheRemindersFromAPI(
                        isSnooze: true, snoozeReminderData: apiReminder);

                    // Start Sheela from button with specified parameters
                    startSheelaFromButton(
                        buttonText: button.title,
                        payload: button.payload,
                        buttons: button);
                  } catch (e, stackTrace) {
                    CommonUtil().appLogs(message: e, stackTrace: stackTrace);
                  }
                } else if (button?.needPhoto ?? false) {
                  // Check if the button requires a photo
                  if (isLoading.isTrue) {
                    return; // If loading, do nothing
                  }
                  stopTTS(); // Stop Text-to-Speech
                  isSheelaScreenActive = false; // Deactivate Sheela screen
                  updateTimer(enable: false); // disable the timer
                  btnTextLocal = button?.title ?? ''; // Set local button text
                  // Show the camera/gallery dialog and handle the result
                  showCameraGalleryDialog(btnTextLocal ?? '', strImage)
                      .then((value) {
                    isSheelaScreenActive =
                        true; // Reactivate Sheela screen after dialog
                    updateTimer(enable: true); // disable the timer
                  });
                } else if (button?.btnRedirectTo == strRedirectRetakePicture) {
                  // Check if the button redirects to retake picture
                  if (isLoading.isTrue) {
                    return; // If loading, do nothing
                  }
                  stopTTS(); // Stop Text-to-Speech
                  isSheelaScreenActive = false; // Deactivate Sheela screen
                  updateTimer(enable: false); // disable the timer
                  isRetakeCapture = true; // Set flag for retake capture
                  // Show the camera/gallery dialog and handle the result
                  showCameraGalleryDialog(btnTextLocal ?? '', strImage)
                      .then((value) {
                    isSheelaScreenActive =
                        true; // Reactivate Sheela screen after dialog
                    updateTimer(enable: true); // disable the timer
                  });
                } else if (button?.btnRedirectTo == strRedirectToUploadImage) {
                  // Check if the button redirects to upload image
                  SheelaResponse sheelaLastConversation = SheelaResponse();
                  sheelaLastConversation = conversations.last;
                  isLoading.value = true; // Set loading flag
                  conversations.add(SheelaResponse(
                      loading: true)); // Add loading response to conversations
                  scrollToEnd(); // Scroll to the end of conversations
                  if (sheelaLastConversation.imageThumbnailUrl != null &&
                      sheelaLastConversation.imageThumbnailUrl != '') {
                    // Check if there is a valid image thumbnail URL
                    saveMediaRegiment(
                      sheelaLastConversation.imageThumbnailUrl ?? '',
                      // Save media regiment
                      '',
                    ).then((value) {
                      isLoading.value = false; // Reset loading flag
                      conversations
                          .removeLast(); // Remove the loading response from conversations
                      if (value.isSuccess ?? false) {
                        fileRequestUrl = value.result?.accessUrl ?? '';
                        if (isLoading.isTrue) {
                          return; // If loading, do nothing
                        }
                        if (conversations.last.singleuse != null &&
                            conversations.last.singleuse! &&
                            conversations.last.isActionDone != null) {
                          conversations.last.isActionDone =
                              true; // Set action done flag if it's a single-use button
                        }
                        button?.isSelected =
                            true; // Mark the button as selected
                        // Start Sheela from the button with specified parameters
                        startSheelaFromButton(
                            buttonText: button?.title,
                            payload: button?.payload,
                            buttons: button,
                            isFromImageUpload: true,
                            requestFileType: strImage); // add requestFileType
                        // Delay for 3 seconds and then unselect the button
                        Future.delayed(const Duration(seconds: 3), () {
                          button?.isSelected = false;
                        });
                      }
                    });
                  }
                } // Check if the button requires audio
                else if (button?.needAudio ?? false) {
                  // Check if loading is in progress, if true, return without performing any action
                  if (isLoading.isTrue) {
                    return;
                  }

                  // Stop Text-to-Speech, update timer, set Sheela screen as inactive, and set button text
                  stopTTS();
                  updateTimer(enable: false);
                  isSheelaScreenActive = false;
                  btnTextLocal = button?.title ?? '';

                  // Navigate to the audio record screen with Sheela file upload option
                  goToAudioRecordScreen(isFromSheelaFileUpload: true);
                }
// Check if the button redirects to retake audio
                else if (button?.btnRedirectTo == strRedirectRetakeAudio) {
                  // Check if loading is in progress, if true, return without performing any action
                  if (isLoading.isTrue) {
                    return;
                  }

                  // Stop Text-to-Speech, set Sheela screen as inactive, update timer, and set retake capture to true
                  stopTTS();
                  isSheelaScreenActive = false;
                  updateTimer(enable: false);
                  isRetakeCapture = true;

                  // Navigate to the audio record screen with Sheela file upload option
                  goToAudioRecordScreen(isFromSheelaFileUpload: true);
                }
// Check if the button redirects to upload audio
                else if (button?.btnRedirectTo == strRedirectToUploadAudio) {
                  // Retrieve the last Sheela conversation
                  SheelaResponse sheelaLastConversation = SheelaResponse();
                  sheelaLastConversation = conversations.last;

                  // Set loading state and add a loading response to conversations
                  isLoading.value = true;
                  conversations.add(SheelaResponse(loading: true));
                  scrollToEnd();

                  // Check if the last Sheela conversation has a valid audioThumbnailUrl
                  if (sheelaLastConversation.audioThumbnailUrl != null &&
                      sheelaLastConversation.audioThumbnailUrl != '') {
                    // Save media regiment and handle the result
                    saveMediaRegiment(
                            sheelaLastConversation.audioThumbnailUrl ?? '', '')
                        .then((value) {
                      isLoading.value = false;
                      conversations.removeLast();

                      // Check if the media saving operation was successful
                      if (value.isSuccess ?? false) {
                        // Set fileRequestUrl and check loading state
                        fileRequestUrl = value.result?.accessUrl ?? '';
                        if (isLoading.isTrue) {
                          return;
                        }

                        // Check if the last Sheela conversation is singleuse and isActionDone is not null, then set isActionDone to true
                        if (conversations.last.singleuse != null &&
                            conversations.last.singleuse! &&
                            conversations.last.isActionDone != null) {
                          conversations.last.isActionDone = true;
                        }

                        // Set button isSelected to true, start Sheela from the button, and delay setting isSelected to false
                        button?.isSelected = true;
                        startSheelaFromButton(
                          buttonText: button?.title,
                          payload: button?.payload,
                          buttons: button,
                          isFromImageUpload: true,
                          requestFileType: strAudio,
                        );
                        Future.delayed(const Duration(seconds: 3), () {
                          button?.isSelected = false;
                        });
                      }
                    });
                  }
                } else if (button?.needVideo ?? false) {
                  // Check if the button requires a video
                  if (isLoading.isTrue) {
                    return; // If loading, do nothing
                  }
                  stopTTS(); // Stop Text-to-Speech
                  updateTimer(enable: false); // disable the timer
                  isSheelaScreenActive = false; // Deactivate Sheela screen
                  btnTextLocal = button?.title ?? ''; // Set local button text
                  // Show the camera/gallery dialog and handle the result
                  showCameraGalleryDialog(btnTextLocal ?? '', strVideo)
                      .then((value) {
                    /*controller.isSheelaScreenActive =
                              true; // Reactivate Sheela screen after dialog
                          controller.updateTimer(
                              enable: true);*/ // enable the timer
                  });
                } else if (button?.btnRedirectTo == strRedirectRetakeVideo) {
                  // Check if the button redirects to retake video
                  if (isLoading.isTrue) {
                    return; // If loading, do nothing
                  }
                  stopTTS(); // Stop Text-to-Speech
                  isSheelaScreenActive = false; // Deactivate Sheela screen
                  updateTimer(enable: false); // disable the timer
                  isRetakeCapture = true; // Set flag for retake capture
                  // Show the camera/gallery dialog and handle the result
                  showCameraGalleryDialog(btnTextLocal ?? '', strVideo)
                      .then((value) {
                    /*controller.isSheelaScreenActive =
                              true; // Reactivate Sheela screen after dialog
                          controller.updateTimer(
                              enable: true); // enable the timer*/
                  });
                } else if (button?.btnRedirectTo == strRedirectToUploadVideo) {
                  SheelaResponse sheelaLastConversation = SheelaResponse();
                  sheelaLastConversation = conversations.last;
                  // Check if the button redirects to upload video
                  isLoading.value = true; // Set loading flag
                  conversations.add(SheelaResponse(
                      loading: true)); // Add loading response to conversations
                  scrollToEnd(); // Scroll to the end of conversations
                  if (sheelaLastConversation.videoThumbnailUrl != null &&
                      sheelaLastConversation.videoThumbnailUrl != '') {
                    // Check if there is a valid image thumbnail URL
                    saveMediaRegiment(
                            sheelaLastConversation.videoThumbnailUrl ?? '',
                            '') // Save media regiment
                        .then((value) {
                      isLoading.value = false; // Reset loading flag
                      conversations
                          .removeLast(); // Remove the loading response from conversations
                      if (value.isSuccess ?? false) {
                        fileRequestUrl = value.result?.accessUrl ?? '';
                        if (isLoading.isTrue) {
                          return; // If loading, do nothing
                        }
                        if (conversations.last.singleuse != null &&
                            conversations.last.singleuse! &&
                            conversations.last.isActionDone != null) {
                          conversations.last.isActionDone =
                              true; // Set action done flag if it's a single-use button
                        }
                        button?.isSelected =
                            true; // Mark the button as selected
                        // Start Sheela from the button with specified parameters
                        startSheelaFromButton(
                            buttonText: button?.title,
                            payload: button?.payload,
                            buttons: button,
                            isFromImageUpload: true,
                            requestFileType: strVideo // add requestFileType
                            );
                        // Delay for 3 seconds and then unselect the button
                        Future.delayed(const Duration(seconds: 3), () {
                          button?.isSelected = false;
                        });
                      }
                    });
                  }
                } // Check if the button's redirection is to reconnect
                else if (button?.btnRedirectTo == strReconnect) {
                  // Check if loading is in progress, if true, return
                  if (isLoading.isTrue) {
                    return;
                  }

                  // Check if the last conversation is marked as singleuse and action is not done
                  if (conversations.last.singleuse != null &&
                      conversations.last.singleuse! &&
                      conversations.last.isActionDone != null) {
                    conversations.last.isActionDone = true;
                  }

                  // Mark the button as selected, stop TTS, and set loading state to true
                  button?.isSelected = true;
                  stopTTS();
                  isLoading.value = true;

                  // Add a card response with the button's title to the conversation
                  final cardResponse = SheelaResponse(text: button?.title);
                  conversations.add(cardResponse);
                  scrollToEnd();

                  // Introduce a delay before further actions (2 seconds in this case)
                  await Future.delayed(Duration(seconds: 2));

                  // Initialize SheelaBLEController
                  SheelaBLEController? bleController =
                      CommonUtil().onInitSheelaBLEController();

                  // Create a reconnect card and add it to the conversation and play
                  final reconnectCard = SheelaResponse(
                    text: await getTextTranslate(strFailureRetry),
                    recipientId: sheelaRecepId,
                    redirectTo: strReconnect,
                  );
                  bleController.addToConversationAndPlay(reconnectCard);

                  // Set loading state to false
                  isLoading.value = false;

                  // Introduce a delay before resetting the button selection (3 seconds in this case)
                  Future.delayed(const Duration(seconds: 3), () {
                    button?.isSelected = false;
                  });
                } else {
                  startSheelaFromButton(
                      buttonText: button.title,
                      payload: button.payload,
                      buttons: button);
                }
              } else {
                lastMsgIsOfButtons = false;
                conversations.add(newConversation);
                getAIAPIResponseFor(response, button);
              }
            } catch (e, stackTrace) {
              CommonUtil().appLogs(message: e, stackTrace: stackTrace);

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
      }
      scrollToEnd();
    } catch (e, stackTrace) {
      // Handle any exceptions that occur during the closing process and log them
      CommonUtil().appLogs(message: e, stackTrace: stackTrace);
    }
  }

  // Function to navigate to the AudioRecorder screen
  void goToAudioRecordScreen({bool? isFromSheelaFileUpload = false}) {
    // Use Get.to to navigate to the AudioRecorder screen and pass AudioScreenArguments
    Get.to(AudioRecorder(
      arguments: AudioScreenArguments(
        fromVoice: false,
        isFromSheelaFileUpload: isFromSheelaFileUpload,
      ),
    ))?.then((results) {
      // Set isSheelaScreenActive to true and enable the timer
      isSheelaScreenActive = true;
      updateTimer(enable: true);

      // Retrieve the audioPath from the results
      var audioPath = results[keyAudioFile];

      // Check if audioPath is not null and not empty
      if (audioPath != null && audioPath != '') {
        // Call sheelaFileStaticConversation with provided parameters
        sheelaFileStaticConversation(
          btnTitle:
              btnTextLocal ?? '', // Use btnTextLocal or an empty string if null
          selectedImagePath: audioPath,
          requestFileType: strAudio,
        );
      }
    });
  }

  // Define a function to get the thumbnail image data from a video path
  Future<Uint8List?> getThumbnailImage(path) async {
    // Use the VideoThumbnail package to generate thumbnail data from the video path
    return await thumbnail.VideoThumbnail.thumbnailData(
      video: path, // Specify the video path
      imageFormat: thumbnail.ImageFormat.JPEG, // Set the image format to JPEG
      maxWidth:
          128, // Specify the width of the thumbnail; let the height auto-scaled to keep the source aspect ratio
      quality: 50, // Set the quality of the thumbnail
    );
  }

  // Create a timer based on the scheduled time for a reminder.
  Timer createTimer(Reminder reminder, tz.TZDateTime scheduledDateTime) {
    // Convert the scheduledDateTime to UTC
    final utcScheduledDateTime = scheduledDateTime.toUtc();

    // Calculate the duration until the scheduled time based on UTC time
    final durationUntilScheduledTime =
        utcScheduledDateTime.difference(tz.TZDateTime.now(tz.UTC));

    // Schedule the method to be called after the calculated duration
    return Timer(durationUntilScheduledTime, () {
      // Call the scheduled method passing the reminder
      scheduledMethod(reminder);
      // Optional: Reschedule the method for the next occurrence
    });
  }

  // Method called when the timer expires, triggers the reminder-related logic.
  scheduledMethod(Reminder reminder) async {
    final notificationId = int.tryParse('${reminder?.notificationListId}') ?? 0;
    // Get the list of pending notifications
    List<PendingNotificationRequest> pendingNotifications =
        await localNotificationsPlugin.pendingNotificationRequests();

    // Check if the notification with the given ID is already scheduled
    bool isScheduled = pendingNotifications.any(
      (notification) => notification.id == notificationId,
    );

    // If already scheduled, cancel the existing notification with the same ID
    if (isScheduled) {
      await Future.delayed(const Duration(milliseconds: 100));
      final sheelaAIController = CommonUtil().onInitSheelaAIController();
      // Construct an array of values for the reminder invocation
      var strValue = '$strActivityRemainderInvokeSheela${reminder.eid}';
      final passedValArr = strValue.split('&');
      // Invoke the method to handle the reminder invocation
      await CommonUtil()
          .getActivityRemainderInvokeSheela(passedValArr, sheelaAIController);
      // Example usage of clearScheduledTime with null safety
      clearScheduledTime(reminder?.notificationListId ?? '');
    }
  }

  // Add or update the timer associated with a reminder based on its scheduled time.
  addScheduledTime(Reminder reminder, tz.TZDateTime scheduledDateTime) async {
    await clearScheduledTime(reminder.notificationListId!);
    try {
      // Create a new timer for the new scheduled time and add it to the map
      final newTimer = createTimer(reminder, scheduledDateTime);
      reminderTimers[reminder.notificationListId!] = newTimer;
    } catch (e, stackTrace) {
      CommonUtil().appLogs(
          message: 'Error adding scheduled time: $e', stackTrace: stackTrace);
    }
  }

  // Cancel and clear all timers associated with reminders.
  clearAllTimers() {
    try {
      for (var timer in reminderTimers.values) {
        timer.cancel();
      }
      reminderTimers.clear();
    } catch (e, stackTrace) {
      CommonUtil().appLogs(
          message: 'Error clearing all timers: $e', stackTrace: stackTrace);
    }
  }

  // Function to clear the scheduled time for a reminder
  clearScheduledTime(String notificationListId) {
    // Check if a timer already exists for the given notificationListId
    try {
      if (reminderTimers.containsKey(notificationListId)) {
        // If a timer exists, cancel it and remove it from the map
        reminderTimers[notificationListId]?.cancel();
        reminderTimers.remove(notificationListId);
      }
    } catch (e, stackTrace) {
      CommonUtil().appLogs(
          message: 'Error clearing scheduled time: $e', stackTrace: stackTrace);
    }
  }

  // Function to clear the scheduled time for a reminder
  onInitActivitySheelaRemainder() async {
    try {
      // Refresh activity reminders
      await QurPlanReminders.refreshActivityReminders();
    } catch (e, stackTrace) {
      // Handle any exceptions and log them using appLogs method
      CommonUtil().appLogs(message: e, stackTrace: stackTrace);
    }
  }

  // Function to get the TTS play again flag
  bool getTTSPlayAgainFlag() {
    // Using the nullish coalescing operator (??) to handle null cases
    // If currentPlayingConversation is not null, check isPlayAgainMediaTTS; otherwise, default to false
    return conversations.last?.additionalInfoSheelaResponse?.isAutoReadTTS ??
        false;
  }

  playPauseTTSFromApi() {
    // Check if TTS play again flag is true
    if (getTTSPlayAgainFlag()) {
      // Play or pause TTS with the last conversation, or a default SheelaResponse if conversations.last is null
      playPauseTTS(conversations.last ?? SheelaResponse());
    }
  }

  // Future method to get a list of Buttons for sheelaFailureRetry
  Future<List<Buttons>> sheelaFailureRetryButtons() async {
    // Use Future.wait to asynchronously translate the texts
    List<String?> translatedTexts = await Future.wait([
      getTextTranslate(strReconnect),
      getTextTranslate(strExit),
    ]);

    // Return a list of Buttons with translated titles and redirections
    return [
      Buttons(title: translatedTexts[0], btnRedirectTo: strReconnect),
      Buttons(
        title: translatedTexts[1],
        payload: strExit,
        mute: sheela_hdn_btn_yes,
      ),
    ];
  }
}
