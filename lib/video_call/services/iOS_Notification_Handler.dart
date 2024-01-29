

import 'dart:io';

import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:launch_review/launch_review.dart';
import 'package:myfhb/authentication/constants/constants.dart';
import 'package:myfhb/reminders/ReminderModel.dart';
import 'package:myfhb/services/pushnotification_service.dart';
import 'package:provider/provider.dart';

import '../../QurHub/Controller/HubListViewController.dart';
import '../../QurHub/View/HubListView.dart';
import '../../caregiverAssosication/caregiverAPIProvider.dart';
import '../../chat_socket/view/ChatDetail.dart';
import '../../chat_socket/view/ChatUserList.dart';
import '../../claim/screen/ClaimRecordDisplay.dart';
import '../../common/CommonUtil.dart';
import '../../common/PreferenceUtil.dart';
import '../../constants/fhb_constants.dart';
import '../../constants/fhb_parameters.dart';
import '../../constants/fhb_parameters.dart' as parameters;
import '../../constants/router_variable.dart';
import '../../constants/router_variable.dart' as router;
import '../../constants/variable_constant.dart' as variable;
import '../../main.dart';
import '../../myPlan/view/myPlanDetail.dart';
import '../../my_family_detail/models/my_family_detail_arguments.dart';
import '../../my_family_detail/screens/my_family_detail_screen.dart';
import '../../regiment/models/regiment_arguments.dart';
import '../../regiment/view_model/regiment_view_model.dart';
import '../../services/notification_helper.dart';
import '../../services/notification_screen.dart';
import '../../src/model/home_screen_arguments.dart';
import '../../src/model/user/user_accounts_arguments.dart';
import '../../src/ui/SheelaAI/Controller/SheelaAIController.dart';
import '../../src/ui/SheelaAI/Models/sheela_arguments.dart';
import '../../src/ui/SplashScreen.dart';
import '../../src/ui/settings/CaregiverSettng.dart';
import '../../src/utils/PageNavigator.dart';
import '../../telehealth/features/MyProvider/view/BookingConfirmation.dart';
import '../../telehealth/features/Notifications/services/notification_services.dart';
import '../../telehealth/features/appointments/controller/AppointmentDetailsController.dart';
import '../../telehealth/features/appointments/view/AppointmentDetailScreen.dart';
import '../../ticket_support/view/detail_ticket_view_screen.dart';
import '../../voice_cloning/model/voice_clone_status_arguments.dart';
import '../../widgets/checkout_page.dart';
import '../model/NotificationModel.dart';
import '../pages/callmain.dart';
import '../utils/audiocall_provider.dart';
import '../utils/rtc_engine.dart';

class IosNotificationHandler {
  final myDB = FirebaseFirestore.instance;
  bool isAlreadyLoaded = false;
  late NotificationModel model;
  bool renewAction = false;
  bool callbackAction = false;
  bool acceptAction = false;
  bool escalteAction = false;
  bool rejectAction = false;
  bool declineAction = false;
  bool? viewMemberAction, snoozeAction,dismissAction,viewDetails = false;
  bool communicationSettingAction = false;
  bool notificationReceivedFromKilledState = false;
  bool? viewRecordAction, chatWithCC = false;

  //SheelaAIController sheelaAIController = Get.find();

  SheelaAIController? sheelaAIController =
      CommonUtil().onInitSheelaAIController();

  Map<String, dynamic> tempJsonDecode = Map<String, dynamic>();

  setUpListerForTheNotification() {
    variable.reponseToRemoteNotificationMethodChannel.setMethodCallHandler(
      (call) async {
        if (call.method == variable.notificationResponseMethod) {
          if (!isAlreadyLoaded) {
            notificationReceivedFromKilledState = true;
            await Future.delayed(const Duration(seconds: 5));
            isAlreadyLoaded = true;
          }
          final data = Map<String, dynamic>.from(call.arguments);
          model = NotificationModel.fromMap(data.containsKey("action")
              ? Map<String, dynamic>.from(data["data"])
              : data);
          if ((model.externalLink ?? '').isNotEmpty) {
            if (model.externalLink == variable.iOSAppStoreLink) {
              await LaunchReview.launch(
                  iOSAppId: variable.iOSAppId, writeReview: false);
            } else {
              CommonUtil().launchURL(model.externalLink!);
            }
          }

          var actionKey = data["action"] ?? '';
          if (actionKey.isNotEmpty) {
            renewAction = actionKey == "Renew";
            callbackAction = actionKey == "Callback";
            rejectAction = actionKey == "Reject";
            acceptAction = actionKey == "Accept";
            declineAction = actionKey == "Decline";
            escalteAction = actionKey == "Escalate";
            chatWithCC = actionKey == "chatwithcc";
            viewRecordAction = actionKey == "viewrecord";
            viewDetails = actionKey == "ViewDetails";
            viewMemberAction =
                actionKey.toLowerCase() == "ViewMember".toLowerCase();
            communicationSettingAction = actionKey.toLowerCase() ==
                "Communicationsettings".toLowerCase();
          }
          actionForTheNotification();
        } else if (call.method == variable.listenToCallStatusMethod) {
          if (!isAlreadyLoaded) {
            await 4.seconds;
            isAlreadyLoaded = true;
          }
          final data = Map<String, dynamic>.from(call.arguments);
          CommonUtil().listenToCallStatus(data);
        } else if (call.method == variable.navigateToSheelaReminderMethod) {
          if ((call.arguments["eid"] ?? '').isNotEmpty && isAlreadyLoaded) {
            //// allow the user to get notifications
            if (CommonUtil().isAllowSheelaLiveReminders()) {
              if (sheelaAIController!.isSheelaScreenActive) {
                var reqJson = {
                  KIOSK_task: KIOSK_remind,
                  KIOSK_eid: call.arguments["eid"],
                };
                CommonUtil().callQueueNotificationPostApi(reqJson);
              } else {
                await Get.toNamed(
                  rt_Sheela,
                  arguments: SheelaArgument(
                    eId: call.arguments["eid"],
                  ),
                );
              }
            } else {
              // live reminder off only queue flow working
              var reqJson = {
                KIOSK_task: KIOSK_remind,
                KIOSK_eid: call.arguments["eid"],
              };
              CommonUtil().callQueueNotificationPostApi(reqJson);
            }
          }
        }
      },
    );

    // Receive Local Notification
    variable.reminderMethodChannel.setMethodCallHandler((call) async {
      if (call.method == variable.callLocalNotificationMethod) {
        final data = Map<String, dynamic>.from(call.arguments);
        if (data != null) {
          callRegimenScreen(data);
        }
      }
    });
  }

  void handleNotificationResponse(Map<String, dynamic> jsonDecode) async {

     // Extract the notification ID from the JSON data or use '0' if not present
    var tempNotificationId = jsonDecode[parameters.notificationListId] ?? getMyMeetingID().toString();

    // Get the current notification ID from the PreferenceUtil, or an empty string if not set
    var currentNotificationId = PreferenceUtil.getStringValue(strCurrentNotificationId)??'';

    // Check if the temporary notification ID is different from the current notification ID
    if (tempNotificationId != currentNotificationId)
    {

      await PreferenceUtil.saveString(strCurrentNotificationId, tempNotificationId);

      tempJsonDecode = jsonDecode;
      if (!isAlreadyLoaded) {
        //notificationReceivedFromKilledState = true;
        await Future.delayed(const Duration(seconds: 5));
        isAlreadyLoaded = true;
      }
      final data = Map<String, dynamic>.from(jsonDecode);
      model = NotificationModel.fromMap(data.containsKey("action")
          ? Map<String, dynamic>.from(data["data"]??data)
          : data);
      if (data['type'] == 'call' && Platform.isAndroid) {
        if(data.containsKey('action')){
          if(data['action']=='Decline'){
            await updateCallStatus(false,model.meeting_id.toString());
          }else{
            await updateCallStatus(true,model.meeting_id.toString());
            if (model.callType!.toLowerCase() == 'audio') {
              Provider.of<AudioCallProvider>(Get.context!, listen: false)
                  .enableAudioCall();
            } else if (model.callType!.toLowerCase() == 'video') {
              Provider.of<AudioCallProvider>(Get.context!, listen: false)
                  .disableAudioCall();
            }
            Get.to(CallMain(
              doctorName:model?.username??'',
              doctorId:model?.doctorId??'',
              doctorPic: model?.doctorPicture??'',
              patientId:model?.patientId??'',
              patientName:model?.patientName??'',
              patientPicUrl:model?.patientPicture??'',
              channelName:model?.callArguments?.channelName??'',
              role: ClientRole.Broadcaster,
              isAppExists: true,
              isWeb:model?.isWeb??false,
            ));
          }
        }else{
          Get.to(NotificationScreen(model));
        }
      } else if (data['redirectTo'] == 'appointmentPayment' && Platform.isAndroid) {
        Get.to(BookingConfirmation(
          isFromPaymentNotification: true,
          appointmentId: model?.appointmentId ?? '',
        ));
        model = NotificationModel();
      } else if (data['redirectTo'] == 'mycart' && Platform.isAndroid) {
        Get.to(CheckoutPage(
          isFromNotification: true,
          cartUserId: model?.userId ?? '',
          bookingId: model?.bookingId ?? '',
          notificationListId: model?.createdBy ?? '',
          cartId: model?.bookingId ?? '',
          patientName: model?.patientName ?? '',
        ));
        model = NotificationModel();
      } else if (data[strRedirectTo] == stringRegimentScreen &&
          data["action"] == null) {
        // Check if the redirect target is the regiment screen and no specific action is provided.

        // If the conditions are met, call the function to navigate to the regiment screen.
        callRegimenScreen(data);
      } else{
        var actionKey = data["action"] ?? '';
        if (actionKey.isNotEmpty) {
          renewAction = actionKey == "Renew";
          callbackAction = actionKey == "Callback";
          rejectAction = actionKey == "Reject";
          acceptAction = actionKey == "Accept";
          declineAction = actionKey == "Decline";
          escalteAction = actionKey == "Escalate";
          chatWithCC = actionKey == "chatwithcc";
          viewRecordAction = actionKey == "viewrecord";
          viewDetails = actionKey == "ViewDetails";
          viewMemberAction =
              actionKey.toLowerCase() == "ViewMember".toLowerCase();
          communicationSettingAction = actionKey.toLowerCase() ==
              "Communicationsettings".toLowerCase();
          // Check if the actionKey, when converted to lowercase, matches the "Snooze" action.
          snoozeAction = actionKey.toLowerCase() == stringSnooze.toLowerCase();

          // Check if the actionKey, when converted to lowercase, matches the "Dismiss" action.
          dismissAction = actionKey.toLowerCase() == stringDismiss.toLowerCase();

        }
        await actionForTheNotification();
      }
    }
  }

  void updateStatus(String status) async {
    try {
      await myDB
          .collection("call_log")
          .doc("${model.callArguments!.channelName}")
          .set({"call_status": status});
    } catch (e, stackTrace) {
      CommonUtil().appLogs(message: e, stackTrace: stackTrace);
      print(e);
    }
    if (status == parameters.accept.toLowerCase()) {
      if (model.callArguments != null) {
        await fbaLog(eveParams: {
          'eventTime': '${DateTime.now()}',
          'ns_type': 'call',
          'navigationPage': 'TeleHelath Call screen',
        });
        if (model.callType!.toLowerCase() == 'audio') {
          Provider.of<AudioCallProvider>(Get.context!, listen: false)
              .enableAudioCall();
        } else if (model.callType!.toLowerCase() == 'video') {
          Provider.of<AudioCallProvider>(Get.context!, listen: false)
              .disableAudioCall();
        }
        CommonUtil.isCallStarted = true;

        await Get.key.currentState!.pushNamed(
          router.rt_CallMain,
          arguments: model.callArguments,
        );
      }
    } else if (status == parameters.decline.toLowerCase() &&
        CommonUtil.isCallStarted) {
      // End the iOS call if the call is still running
      CommonUtil.isCallStarted = false;
      Get.key.currentState!.pop();
      rtcEngine!.leaveChannel();
      rtcEngine!.destroy();
      Provider.of<RTCEngineProvider>(Get.context!, listen: false)
          .isVideoPaused = false;
    }
  }

  void navigateToMyRecordsCategory(
      dynamic categoryType, List<String>? hrmId, bool isTerminate) async {
    await CommonUtil().getCategoryListPos(categoryType).then(
          (value) => CommonUtil().goToMyRecordsScreen(
            value,
            hrmId,
            isTerminate,
          ),
        );
  }

  actionForTheNotification() async {
    if (model.isCall!) {
      updateStatus(model.status!.toLowerCase());
      // updateStatus(parameters.accept.toLowerCase());
    } else if (callbackAction) {
      callbackAction = false;
      model.redirect = "";
      await CommonUtil().CallbackAPI(
        model.patientName,
        model.planId,
        model.userId,
      );
      var body = {};
      body['templateName'] = model.templateName;
      body['contextId'] = model.planId;
      await FetchNotificationService().updateNsActionStatus(body).then((data) {
        FetchNotificationService().updateNsOnTapAction(body);
      });
    } else if (rejectAction &&
        (model.caregiverReceiver ?? '').isNotEmpty &&
        (model.caregiverRequestor ?? '').isNotEmpty) {
      CaregiverAPIProvider().rejectCareGiver(
        receiver: model.caregiverReceiver,
        requestor: model.caregiverRequestor,
      );
    } else if (viewDetails! && (model.userId ?? '').isNotEmpty) {
      await CommonUtil().getDetailsOfAddedFamilyMember(
        Get.context!,
        model.userId!,
      );
    } else if (acceptAction &&
        (model.patientPhoneNumber ?? '').isNotEmpty &&
        (model.verificationCode ?? '').isNotEmpty) {
      CaregiverAPIProvider().approveCareGiver(
        phoneNumber: model.patientPhoneNumber,
        code: model.verificationCode,
      );
    } else if ((viewMemberAction ?? false) &&
        (model.caregiverRequestor ?? '').isNotEmpty) {
      await Get.to(
        MyFamilyDetailScreen(
          arguments: MyFamilyDetailArguments(
            caregiverRequestor: model.caregiverRequestor,
          ),
        ),
      );
    } else if (communicationSettingAction) {
      await Get.to(CareGiverSettings());
    } else if (model.isSheela ?? false) {
      //// allow the user for auto redirect to sheela screen on time
      if (CommonUtil().isAllowSheelaLiveReminders()) {
        if (model.eventType != null && model.eventType == strWrapperCall) {
          await Get.toNamed(
            rt_Sheela,
            arguments: SheelaArgument(
              isSheelaAskForLang: true,
              rawMessage: model.rawBody,
              eventType: model.eventType,
              others: model.others,
            ),
          );
        } else if ((model.rawBody ?? '').isNotEmpty) {
          await Get.toNamed(
            rt_Sheela,
            arguments: SheelaArgument(
                allowBackBtnPress: true,
                textSpeechSheela: model.rawBody,
                isNeedPreferredLangauge: true,
                eventIdViaSheela: model.eventId),
          );
        } else if ((model.message ?? '').isNotEmpty) {
          await Get.toNamed(
            rt_Sheela,
            arguments: SheelaArgument(
                isSheelaFollowup: true,
                message: model.message,
                eventIdViaSheela: model.eventId),
          );
        } else if ((model.sheelaAudioMsgUrl ?? '').isNotEmpty) {
          await Future.delayed(const Duration(seconds: 5));
          await Get.toNamed(
            router.rt_Sheela,
            arguments: SheelaArgument(
                allowBackBtnPress: true,
                audioMessage: model.sheelaAudioMsgUrl,
                eventIdViaSheela: model.eventId),
          );
        }
      }
// Check if templateName is not empty and matches specific templates
      if ((model.templateName ?? '').isNotEmpty &&
          (model.templateName ==
                  parameters.NonTeleconsultationAppointmentPreReminder5 ||
              model.templateName == parameters.AppointmentReminder5)) {
        // Prepare JSON data for adding to the sheela queue request
        final reqJson = {
          KIOSK_task: KIOSK_appointment_avail,
          KIOSK_appoint_id: model.appointmentId ?? '',
          KIOSK_eid: model.eventId ?? '',
        };
        // Check if Sheela Live reminders are allowed
        if (CommonUtil().isAllowSheelaLiveReminders()) {
          // Check if Sheela screen is active
          if (sheelaAIController?.isSheelaScreenActive ?? false) {
            //Adding the notificaiton to sheela reminder Queue
            CommonUtil().callQueueNotificationPostApi(reqJson);
          } else if (PreferenceUtil.getIfQurhomeisAcive()) {
            // Navigate to Sheela screen with specific arguments
            await Get.toNamed(
              rt_Sheela,
              arguments: SheelaArgument(
                scheduleAppointment: true,
              ),
            );
          }
        } else {
          //Adding the notificaiton to sheela reminder Queue
          //since the live notifications are disabled.
          CommonUtil().callQueueNotificationPostApi(reqJson);
        }
      }
    } else if (CommonUtil.isUSRegion() &&
        model.templateName == strPatientReferralAcceptToPatient) {
      await fbaLog(eveParams: {
        'eventTime': '${DateTime.now()}',
        'ns_type': 'myprovider_list',
        'navigationPage': 'MyProvider List Screen',
      });
      await Get.toNamed(router.rt_UserAccounts,
              arguments: UserAccountsArguments(selectedIndex: 2))
          ?.then((value) => PageNavigator.goToPermanent(
              Get.key.currentContext!, router.rt_Landing));
    } else if (model.templateName == strNotifyPatientServiceTicketByCC &&
        (model.eventId ?? '').isNotEmpty) {
      await fbaLog(eveParams: {
        'eventTime': '${DateTime.now()}',
        'ns_type': 'notifyPatientServiceTicketByCC',
        'navigationPage': 'TicketDetails',
      });
      await Get.to(
        DetailedTicketView(
          null,
          true,
          model.eventId,
        ),
      );
    } else if (model.templateName ==
            parameters.notifyCaregiverForMedicalRecord &&
        chatWithCC!) {
      if (!notificationReceivedFromKilledState) {
        if ((model.userId ?? '').isNotEmpty &&
            (model.patientName ?? '').isNotEmpty &&
            (model.doctorPicture ?? '').isNotEmpty &&
            (model.careCoordinatorUserId ?? '').isNotEmpty) {
          await Get.to(
            () => ChatDetail(
              peerId: model.userId,
              peerName: model.patientName,
              peerAvatar: model.doctorPicture,
              patientId: "",
              patientName: "",
              patientPicture: "",
              isFromVideoCall: false,
              isFromFamilyListChat: true,
              isFromCareCoordinator: model.isFromCareCoordinator ?? false,
              carecoordinatorId: model.careCoordinatorUserId,
              isCareGiver: model.isCaregiver ?? false,
              groupId: '',
              lastDate: model.deliveredDateTime,
            ),
          );
        } else {
          await Get.to(() => ChatUserList());
        }
      } else {
        model.viewRecordAction = viewRecordAction;
        model.chatWithCC = chatWithCC;
        notificationReceivedFromKilledState = false;
        await PreferenceUtil.saveNotificationData(model);
      }
    } else if (model.templateName ==
            parameters.notifyCaregiverForMedicalRecord &&
        viewRecordAction!) {
      if (model.redirectData != null) {
        final dataOne = model.redirectData![1];
        final dataTwo = model.redirectData![2];

        if (dataTwo.runtimeType == String && (dataTwo ?? '').isNotEmpty) {
          final userId = PreferenceUtil.getStringValue(KEY_USERID);
          if ((model.userId ?? '') == userId) {
            CommonUtil().navigateToRecordDetailsScreen(dataTwo);
          } else {
            CommonUtil.showFamilyMemberPlanExpiryDialog(
              model.patientName,
              redirect: model.redirect,
            );
          }
        } else {
          navigateToMyRecordsCategory(
            dataOne,
            dataTwo,
            false,
          );
        }
      }
    } else if (model.type == parameters.FETCH_LOG) {
    } else if (model.templateName == parameters.familyMemberCaregiverRequest) {
      //No Navigation required
    } else if ([
      parameters.strVCApproveByProvider,
      parameters.strVCDeclineByProvider
    ].contains(model.templateName)) {
      await Get.toNamed(
        rt_VoiceCloningStatus,
        arguments: const VoiceCloneStatusArguments(fromMenu: true),
      );
    } else if (model.templateName ==
        parameters.associationNotificationToCaregiver) {
      //No Navigation required
    } else if (model.isCancellation) {
      await fbaLog(eveParams: {
        'eventTime': '${DateTime.now()}',
        'ns_type': 'DoctorCancellation',
        'navigationPage': 'Appointment List',
      });
      await await isAlreadyLoaded
          ? Get.toNamed(rt_notification_main)
          : Get.to(() => SplashScreen(
                nsRoute: parameters.doctorCancellation,
              ));
    } else if ((model.templateName ?? '').isNotEmpty &&
        model.templateName == parameters.chat) {
      await fbaLog(eveParams: {
        'eventTime': '${DateTime.now()}',
        'ns_type': 'chat',
        'navigationPage': 'Tele Health Chat list',
      });
      await await isAlreadyLoaded
          ? Get.to(() => ChatUserList())
          : Get.to(() => SplashScreen(
                nsRoute: parameters.chat,
              ));
    } else if (model.redirectData != null) {
      final dataOne = model.redirectData![1];
      final dataTwo = model.redirectData![2];
      await fbaLog(eveParams: {
        'eventTime': '${DateTime.now()}',
        'ns_type': 'myRecords',
        'navigationPage': '$dataOne',
      });
      if (dataTwo.runtimeType == String && (dataTwo ?? '').isNotEmpty) {
        final userId = PreferenceUtil.getStringValue(KEY_USERID);
        if ((model.userId ?? '') == userId) {
          CommonUtil().navigateToRecordDetailsScreen(dataTwo);
        } else {
          CommonUtil.showFamilyMemberPlanExpiryDialog(
            model.patientName,
            redirect: model.redirect,
          );
        }
      } else {
        navigateToMyRecordsCategory(
          dataOne,
          dataTwo,
          false,
        );
      }
    } else if (model.redirect == parameters.stringConnectedDevicesScreen) {
      if (!isAlreadyLoaded) {
        await Future.delayed(const Duration(seconds: 5));
        isAlreadyLoaded = true;
      }
      try {
        await Get.to(
          () => HubListView(),
          binding: BindingsBuilder(
            () {
              if (!Get.isRegistered<HubListViewController>()) {
                Get.lazyPut(
                  () => HubListViewController(),
                );
              }
            },
          ),
        );
      } catch (e, stackTrace) {
        CommonUtil().appLogs(message: e, stackTrace: stackTrace);
      }
    } else if (model.redirect == parameters.strAppointmentDetail &&
        (model.appointmentId ?? '').isNotEmpty &&
        (model.patientId ?? '').isNotEmpty &&
        (acceptAction || declineAction)) {
      new CommonUtil().acceptCareGiverTransportRequestReminder(
          Get.context!, model.appointmentId!, model.patientId!, acceptAction);
      acceptAction = false;
      declineAction = false;
    } else if (model.redirect == parameters.strAppointmentDetail &&
        (model.appointmentId ?? '').isNotEmpty) {
      AppointmentDetailsController appointmentDetailsController =
          CommonUtil().onInitAppointmentDetailsController();
      appointmentDetailsController.getAppointmentDetail(model.appointmentId!);
      await Get.to(() => AppointmentDetailScreen());
    } else if (model.redirect == parameters.chat) {
      if (!notificationReceivedFromKilledState) {
        if ((model.doctorId ?? '').isNotEmpty &&
            (model.doctorName ?? '').isNotEmpty &&
            (model.doctorPicture ?? '').isNotEmpty) {
          await Get.to(
            () => ChatDetail(
              peerId: model.doctorId,
              peerName: model.doctorName,
              peerAvatar: model.doctorPicture,
              patientId: "",
              patientName: "",
              patientPicture: "",
              isFromVideoCall: false,
              isCareGiver: false,
              isForGetUserId: true,
            ),
          );
        } else {
          await Get.to(() => ChatUserList());
        }
      } else {
        notificationReceivedFromKilledState = false;
        await PreferenceUtil.saveNotificationData(model);
      }
    } else if (model.redirect == 'sheela') {
      await fbaLog(
        eveParams: {
          'eventTime': '${DateTime.now()}',
          'ns_type': 'sheela',
          'navigationPage': 'Sheela Start Page',
        },
      );
      if (CommonUtil().isAllowSheelaLiveReminders()) {
        if (isAlreadyLoaded) {
          if ((model.notificationListId ?? '').isNotEmpty) {
            await FetchNotificationService()
                .inAppUnreadAction(model.notificationListId!);
          }
          if (model.rawBody != null) {
            String? sheela_lang = PreferenceUtil.getStringValue(SHEELA_LANG);
            if (sheela_lang != null && sheela_lang != '') {
              await Get.toNamed(
                rt_Sheela,
                arguments: SheelaArgument(
                  isSheelaAskForLang: false,
                  langCode: sheela_lang,
                  rawMessage: model.rawBody,
                ),
              );
            } else {
              await Get.toNamed(
                rt_Sheela,
                arguments: SheelaArgument(
                  isSheelaAskForLang: true,
                  rawMessage: model.rawBody,
                ),
              );
            }
          } else {
            await Get.to(() => SplashScreen(
                  nsRoute: 'sheela',
                ));
          }
        } else {
          await Get.to(() => SplashScreen(
                nsRoute: 'sheela',
              ));
        }
      }
    } else if ((model.redirect == 'profile_page') ||
        (model.redirect == 'profile')) {
      await fbaLog(eveParams: {
        'eventTime': '${DateTime.now()}',
        'ns_type': 'profile_page',
        'navigationPage': 'User Profile page',
      });

      await await isAlreadyLoaded
          ? Get.toNamed(router.rt_UserAccounts,
              arguments: UserAccountsArguments(selectedIndex: 0))
          : Get.to(() => SplashScreen(
                nsRoute: 'profile_page',
              ));
    } else if (model.redirect == parameters.myCartDetails &&
        (model.planId ?? '').isNotEmpty) {
      final userId = PreferenceUtil.getStringValue(KEY_USERID);

      if (model.userId == userId) {
        await await isAlreadyLoaded
            ? Get.to(
                () => MyPlanDetail(
                    packageId: model.planId,
                    showRenew: renewAction,
                    templateName: model.templateName),
              )!
                .then((value) {
                renewAction = false;
              })
            : Get.to(() => SplashScreen(
                      nsRoute: '',
                    ))!
                .then((value) {
                renewAction = false;
              });
      } else {
        CommonUtil.showFamilyMemberPlanExpiryDialog(model.patientName);
      }
    } else if (model.templateName ==
            parameters.strVoiceClonePatientAssignment &&
        (acceptAction || declineAction)) {
      // Check if the first element of passedValArr is related to voice clone patient assignment
      // Call the method to save the voice clone patient assignment status
      CommonUtil().saveVoiceClonePatientAssignmentStatus(
        model.voiceCloneId ?? '',
        acceptAction,
      );
      acceptAction = false;
      declineAction = false;
    } else if (model.redirect == parameters.claimList &&
        (model.claimId ?? '').isNotEmpty) {
      await Get.to(
        () => ClaimRecordDisplay(
          claimID: model.claimId,
        ),
      );
      // }
    } else if (model.redirect == parameters.myPlanDetails &&
        (model.planId ?? '').isNotEmpty) {
      final userId = PreferenceUtil.getStringValue(KEY_USERID);
      if (model.userId == userId) {
        await Get.to(
          () => MyPlanDetail(
            packageId: model.planId,
            showRenew: false,
            templateName: model.templateName,
          ),
        )!
            .then((value) {
          renewAction = false;
        });
      } else {
        CommonUtil.showFamilyMemberPlanExpiryDialog(
          model.patientName,
          redirect: parameters.myPlanDetails,
        );
      }
    } else if (model.redirect == 'googlefit') {
      await fbaLog(eveParams: {
        'eventTime': '${DateTime.now()}',
        'ns_type': 'googlefit',
        'navigationPage': 'Google Fit page',
      });
      await await isAlreadyLoaded
          ? Get.toNamed(router.rt_AppSettings)
          : Get.to(() => SplashScreen(
                nsRoute: 'googlefit',
              ));
    } else if ((model.redirect == 'th_provider') ||
        (model.redirect == 'provider')) {
      await fbaLog(eveParams: {
        'eventTime': '${DateTime.now()}',
        'ns_type': 'th_provider',
        'navigationPage': 'Tele Health Provider',
      });
      await await isAlreadyLoaded
          ? Get.toNamed(router.rt_TelehealthProvider,
              arguments: HomeScreenArguments(selectedIndex: 1))
          : Get.to(() => SplashScreen(
                nsRoute: 'th_provider',
              ));
    } else if ((model.redirect == 'my_record') ||
        (model.redirect == 'prescription_list') ||
        (model.redirect == 'add_doc')) {
      await fbaLog(eveParams: {
        'eventTime': '${DateTime.now()}',
        'ns_type': 'my_record',
        'navigationPage': 'My Records',
      });
      await CommonUtil().getUserProfileData();
      await await isAlreadyLoaded
          ? Get.toNamed(router.rt_HomeScreen,
              arguments: HomeScreenArguments(selectedIndex: 1))
          : Get.to(() => SplashScreen(
                nsRoute: 'my_record',
              ));
    } else if (model.redirect == 'devices_tab') {
      await fbaLog(eveParams: {
        'eventTime': '${DateTime.now()}',
        'ns_type': 'my_record',
        'navigationPage': 'My Records',
      });
      await CommonUtil().getUserProfileData();
      await await isAlreadyLoaded
          ? Get.toNamed(
              router.rt_HomeScreen,
              arguments: HomeScreenArguments(selectedIndex: 1, thTabIndex: 1),
            )
          : Get.to(() => SplashScreen(
                nsRoute: 'my_record',
              ));
    } else if (model.redirect == 'bills') {
      await fbaLog(eveParams: {
        'eventTime': '${DateTime.now()}',
        'ns_type': 'my_record',
        'navigationPage': 'My Records',
      });
      await CommonUtil().getUserProfileData();
      await await isAlreadyLoaded
          ? Get.toNamed(
              router.rt_HomeScreen,
              arguments: HomeScreenArguments(selectedIndex: 1, thTabIndex: 4),
            )
          : Get.to(() => SplashScreen(
                nsRoute: 'my_record',
              ));
    } /*else if (model.redirect == 'regiment_screen') {
      await fbaLog(eveParams: {
        'eventTime': '${DateTime.now()}',
        'ns_type': CommonUtil.isUSRegion()
            ? 'QurHomeRegimenScreen'
            : 'regiment_screen',
        'navigationPage': 'Regimen Screen',
      });
      if (isAlreadyLoaded) {
        if (model.eventId != null) {
          if (CommonUtil.isUSRegion()) {
            var qurhomeDashboardController =
                CommonUtil().onInitQurhomeDashboardController();
            qurhomeDashboardController.eventId.value = model.eventId!;
            await Get.to(() => QurhomeDashboard())?.then((value) =>
                PageNavigator.goToPermanent(Get.context!, router.rt_Landing));
          } else {
            await Get.toNamed(router.rt_Regimen,
                arguments: RegimentArguments(eventId: model.eventId));
          }
        } else {
          await Get.to(() => SplashScreen(
                nsRoute: 'regiment_screen',
              ));
        }
      } else {
        await Get.to(() => SplashScreen(
              nsRoute: 'regiment_screen',
            ));
      }
    } */else if (model.redirect == 'mycart') {
      await fbaLog(eveParams: {
        'eventTime': '${DateTime.now()}',
        'ns_type': 'my cart',
        'navigationPage': 'My Cart',
      });
      await Get.to(
        () => CheckoutPage(
          isFromNotification: true,
        ),
      );
    } else if (model.redirect == 'dashboard') {
      await fbaLog(eveParams: {
        'eventTime': '${DateTime.now()}',
        'ns_type': 'dashboard',
        'navigationPage': 'Device List Screen',
      });
      isAlreadyLoaded
          ? PageNavigator.goToPermanent(
              Get.key.currentContext!, router.rt_Landing)
          : Get.to(() => SplashScreen(
                nsRoute: '',
              ));
    } else if (model.redirect == 'th_provider_hospital') {
      await fbaLog(eveParams: {
        'eventTime': '${DateTime.now()}',
        'ns_type': 'th_provider_hospital',
        'navigationPage': 'TH provider Hospital Screen',
      });
      await await isAlreadyLoaded
          ? Get.toNamed(router.rt_TelehealthProvider,
              arguments: HomeScreenArguments(selectedIndex: 1, thTabIndex: 1))
          : Get.to(() => SplashScreen(
                nsRoute: 'th_provider_hospital',
              ));
    } else if ((model.redirect == 'myfamily_list') ||
        (model.redirect == 'profile_my_family')) {
      await fbaLog(eveParams: {
        'eventTime': '${DateTime.now()}',
        'ns_type': 'myfamily_list',
        'navigationPage': 'MyFamily List Screen',
      });
      await await isAlreadyLoaded
          ? Get.toNamed(router.rt_UserAccounts,
              arguments: UserAccountsArguments(selectedIndex: 1))
          : Get.to(() => SplashScreen(
                nsRoute: 'myfamily_list',
              ));
    } else if (model.redirect == 'myprovider_list') {
      await fbaLog(eveParams: {
        'eventTime': '${DateTime.now()}',
        'ns_type': 'myprovider_list',
        'navigationPage': 'MyProvider List Screen',
      });
      await await isAlreadyLoaded
          ? Get.toNamed(router.rt_UserAccounts,
              arguments: UserAccountsArguments(selectedIndex: 2))
          : Get.to(() => SplashScreen(
                nsRoute: 'myprovider_list',
              ));
    } else if (model.redirect == 'myplans') {
      await fbaLog(eveParams: {
        'eventTime': '${DateTime.now()}',
        'ns_type': 'myplans',
        'navigationPage': 'MyPlans Screen',
      });
      await await isAlreadyLoaded
          ? Get.toNamed(router.rt_UserAccounts,
              arguments: UserAccountsArguments(selectedIndex: 3))
          : Get.to(() => SplashScreen(
                nsRoute: 'myplans',
              ));
    } else if ((model.redirect == 'appointmentList') ||
        (model.redirect == 'appointmentHistory')) {
      await fbaLog(eveParams: {
        'eventTime': '${DateTime.now()}',
        'ns_type': 'appointmentList',
        'navigationPage': 'Tele Health Appointment list',
      });
      model.redirect = 'appointmentList';
      await PreferenceUtil.saveNotificationData(model);
      isAlreadyLoaded
          ? PageNavigator.goTo(Get.context!, router.rt_Landing)
          : Get.to(() => SplashScreen(
                nsRoute: model.redirect,
              ));
    } else if (model.redirect == 'manageActivities') {
      await fbaLog(eveParams: {
        'eventTime': '${DateTime.now()}',
        'ns_type': 'manageActivities',
        'navigationPage': 'ManageActivities list',
      });
      await Get.toNamed(rt_ManageActivitiesScreen);
    } else if ((model.redirect ==
            parameters.escalateToCareCoordinatorToRegimen) &&
        escalteAction) {
      escalteAction = false;
      CommonUtil().escalateNonAdherance(
          model.careCoordinatorUserId,
          model.patientName,
          model.careGiverName,
          model.activityTime,
          model.activityName,
          model.userId,
          model.uid,
          model.patientPhoneNumber);
    } else if (model.templateName ==
        parameters.stringAssignOrUpdatePersonalPlanActivities) {
      //No Navigation required
    } else if ((snoozeAction ?? false) && (model.redirect == parameters.stringRegimentScreen)) {
      // Check if snoozeAction is true (or defaults to false if null) and the model redirect is to the regiment screen.

      // Extract notification list ID from the model and initialize a temporary ID.
      var tempNotificationListId = int.tryParse('${model.notificationListId}') ?? 0;

      // Cancel the existing notification with the extracted notification list ID.
      await localNotificationsPlugin.cancel(tempNotificationListId);

      // Extract reminder data from the temporary JSON and obtain the event date-time.
      var reminderData = Reminder.fromMap(tempJsonDecode);
      var eventDateTime = reminderData.estart ?? '';

      // Parse the event date-time into a DateTime object.
      var scheduledDate = CommonUtil().parseDateTimeFromString(eventDateTime);

      // Generate a new notification ID based on the canceled notification and snooze tap count.
      var baseId = '${tempNotificationListId.toString()}${(reminderData.snoozeTapCountTime ?? 0).toString()}';
      tempNotificationListId = int.tryParse(baseId) ?? 0;

      // Schedule a new notification with the updated ID and other details.
      await zonedScheduleNotification(reminderData, tempNotificationListId, scheduledDate, true, true);

      // Reset snoozeAction and dismissAction to false.
      snoozeAction = false;
      dismissAction = false;
    }
    // Check if dismissAction is true (or defaults to false if null) and the model redirect is to the regiment screen.
    else if ((dismissAction ?? false) && (model.redirect == parameters.stringRegimentScreen)) {
      // Extract notification list ID from the model and cancel the corresponding notification.
      var tempNotificationListId = int.tryParse('${model.notificationListId}') ?? 0;
      await localNotificationsPlugin.cancel(tempNotificationListId);

      // Reset snoozeAction and dismissAction to false.
      snoozeAction = false;
      dismissAction = false;
    }
    else {
      isAlreadyLoaded
          ? PageNavigator.goTo(
              Get.context!,
              router.rt_Landing,
            )
          : Get.to(() => SplashScreen(
                nsRoute: '',
              ));
    }
  }


  // Function to handle redirection to the regiment screen based on provided data.
  void callRegimenScreen(Map<String, dynamic> tempData) {
    try {
      var eventId = tempData['eid'];
      var estart = tempData['estart'];
      var dosemeal = tempData['dosemeal'];

      // Check if the region is US and estart is not null.
      if (CommonUtil.isUSRegion() && estart != null) {
        // Initialize the QurhomeDashboardController and set its values.
        var qurhomeDashboardController =
        CommonUtil().onInitQurhomeDashboardController();
        qurhomeDashboardController.eventId.value = eventId;
        qurhomeDashboardController.estart.value = estart;

        // Check dosemeal values for special cases and update the controller accordingly.
        if (dosemeal == doseValueless || dosemeal == doseValueHigh) {
          qurhomeDashboardController.isOnceInAPlanActivity.value = true;
        } else {
          qurhomeDashboardController.isOnceInAPlanActivity.value = false;
        }

        // Update the tab index and navigate to the permanent landing page.
        qurhomeDashboardController.updateTabIndex(0);
        PageNavigator.goToPermanent(Get.context!, router.rt_Landing);
      } else {
        // For non-US regions or when estart is null, navigate to the Regiment screen.
        Provider.of<RegimentViewModel>(
          Get.context!,
          listen: false,
        ).regimentMode = RegimentMode.Schedule;
        Provider.of<RegimentViewModel>(Get.context!, listen: false)
            .regimentFilter = RegimentFilter.Missed;
        PageNavigator.goToPermanent(Get.context!, router.rt_Regimen,
            arguments: RegimentArguments(eventId: eventId));
      }
    } catch (e, stackTrace) {
      // Handle any exceptions and log them.
      CommonUtil().appLogs(message: e, stackTrace: stackTrace);
    }
  }

}
