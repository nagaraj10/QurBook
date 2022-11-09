import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:launch_review/launch_review.dart';
import 'package:myfhb/constants/fhb_parameters.dart';
import 'package:myfhb/src/ui/SheelaAI/Controller/SheelaAIController.dart';
import 'package:provider/provider.dart';

import '../../caregiverAssosication/caregiverAPIProvider.dart';
import '../../chat_socket/view/ChatDetail.dart';
import '../../chat_socket/view/ChatUserList.dart';
import '../../claim/screen/ClaimRecordDisplay.dart';
import '../../common/CommonUtil.dart';
import '../../common/PreferenceUtil.dart';
import '../../constants/fhb_constants.dart';
import '../../constants/fhb_parameters.dart' as parameters;
import '../../constants/router_variable.dart' as router;
import '../../constants/router_variable.dart';
import '../../constants/variable_constant.dart' as variable;
import '../../myPlan/view/myPlanDetail.dart';
import '../../my_family_detail/models/my_family_detail_arguments.dart';
import '../../my_family_detail/screens/my_family_detail_screen.dart';
import '../../regiment/models/regiment_arguments.dart';
import '../../src/model/home_screen_arguments.dart';
import '../../src/model/user/user_accounts_arguments.dart';
import '../../src/ui/SheelaAI/Models/sheela_arguments.dart';
import '../../src/ui/SplashScreen.dart';
import '../../src/ui/settings/CaregiverSettng.dart';
import '../../src/utils/PageNavigator.dart';
import '../../telehealth/features/Notifications/services/notification_services.dart';
import '../../telehealth/features/Notifications/view/notification_main.dart';
import '../../widgets/checkout_page.dart';
import '../model/NotificationModel.dart';
import '../utils/audiocall_provider.dart';

class IosNotificationHandler {
  final myDB = FirebaseFirestore.instance;
  bool isAlreadyLoaded = false;
  NotificationModel model;
  bool renewAction = false;
  bool callbackAction = false;
  bool acceptAction = false;
  bool escalteAction = false;
  bool rejectAction = false;
  bool viewMemberAction, viewDetails = false;
  bool communicationSettingAction = false;
  bool notificationReceivedFromKilledState = false;
  bool viewRecordAction, chatWithCC = false;
  SheelaAIController sheelaAIController = Get.find();
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
              LaunchReview.launch(
                  iOSAppId: variable.iOSAppId, writeReview: false);
            } else {
              CommonUtil().launchURL(model.externalLink);
            }
          }

          var actionKey = (data["action"] ?? '');
          if (actionKey.isNotEmpty) {
            renewAction = (actionKey == "Renew");
            callbackAction = (actionKey == "Callback");
            rejectAction = (actionKey == "Reject");
            acceptAction = (actionKey == "Accept");
            escalteAction = (actionKey == "Escalate");
            chatWithCC = (actionKey == "chatwithcc");
            viewRecordAction = (actionKey == "viewrecord");
            viewDetails = (actionKey == "ViewDetails");
            viewMemberAction =
                (actionKey.toLowerCase() == "ViewMember".toLowerCase());
            communicationSettingAction = (actionKey.toLowerCase() ==
                "Communicationsettings".toLowerCase());
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
            if (sheelaAIController.isSheelaScreenActive) {
              var reqJson = {
                KIOSK_task: KIOSK_remind,
                KIOSK_eid: call.arguments["eid"],
              };
              CommonUtil().callQueueNotificationPostApi(reqJson);
            } else {
              Get.toNamed(
                rt_Sheela,
                arguments: SheelaArgument(
                  eId: call.arguments["eid"],
                ),
              );
            }
          }
        }
      },
    );
  }

  void updateStatus(String status) async {
    try {
      await myDB
          .collection("call_log")
          .doc("${model.callArguments.channelName}")
          .set({"call_status": status});
    } catch (e) {
      print(e);
    }
    if (model.callArguments != null) {
      fbaLog(eveParams: {
        'eventTime': '${DateTime.now()}',
        'ns_type': 'call',
        'navigationPage': 'TeleHelath Call screen',
      });
      if (model.callType.toLowerCase() == 'audio') {
        Provider.of<AudioCallProvider>(Get.context, listen: false)
            .enableAudioCall();
      } else if (model.callType.toLowerCase() == 'video') {
        Provider.of<AudioCallProvider>(Get.context, listen: false)
            .disableAudioCall();
      }
      Get.key.currentState.pushNamed(
        router.rt_CallMain,
        arguments: model.callArguments,
      );
    }
  }

  actionForTheNotification() async {
    if (model.isCall) {
      updateStatus(parameters.accept.toLowerCase());
    } else if (callbackAction) {
      callbackAction = false;
      model.redirect = "";
      CommonUtil().CallbackAPI(
        model.patientName,
        model.planId,
        model.userId,
      );
      var body = {};
      body['templateName'] = model.templateName;
      body['contextId'] = model.planId;
      FetchNotificationService().updateNsActionStatus(body).then((data) {
        FetchNotificationService().updateNsOnTapAction(body);
      });
    } else if (rejectAction &&
        (model.caregiverReceiver ?? '').isNotEmpty &&
        (model.caregiverRequestor ?? '').isNotEmpty) {
      CaregiverAPIProvider().rejectCareGiver(
        receiver: model.caregiverReceiver,
        requestor: model.caregiverRequestor,
      );
    } else if (viewDetails && (model.userId ?? '').isNotEmpty) {
      CommonUtil().getDetailsOfAddedFamilyMember(
        Get.context,
        model.userId,
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
      Get.to(
        MyFamilyDetailScreen(
          arguments: MyFamilyDetailArguments(
            caregiverRequestor: model.caregiverRequestor,
          ),
        ),
      );
    } else if (communicationSettingAction) {
      Get.to(CareGiverSettings());
    } else if (model.isSheela ?? false) {
      if (sheelaAIController.isSheelaScreenActive &&
          (model.rawBody ?? '').isNotEmpty) {
        var reqJson = {
          KIOSK_task: KIOSK_read,
          KIOSK_message_api: model.rawBody,
        };
        CommonUtil().callQueueNotificationPostApi(reqJson);
      } else if ((model.message ?? '').isNotEmpty) {
        Get.toNamed(
          rt_Sheela,
          arguments: SheelaArgument(
            isSheelaFollowup: true,
            message: model.message,
          ),
        );
      } else if ((model.sheelaAudioMsgUrl ?? '').isNotEmpty) {
        await Future.delayed(const Duration(seconds: 5));
        Get.toNamed(
          router.rt_Sheela,
          arguments: SheelaArgument(
            audioMessage: model.sheelaAudioMsgUrl,
          ),
        );
      }
    } else if (model.templateName ==
            parameters.notifyCaregiverForMedicalRecord &&
        chatWithCC) {
      if (!notificationReceivedFromKilledState) {
        if ((model.userId ?? '').isNotEmpty &&
            (model.patientName ?? '').isNotEmpty &&
            (model.doctorPicture ?? '').isNotEmpty &&
            (model.careCoordinatorUserId ?? '').isNotEmpty) {
          Get.to(
            () => ChatDetail(
              peerId: model.userId,
              peerName: model.patientName,
              peerAvatar: model.doctorPicture,
              patientId: "",
              patientName: "",
              patientPicture: "",
              isFromVideoCall: false,
              isFromFamilyListChat: true,
              isFromCareCoordinator: (model.isFromCareCoordinator ?? false),
              carecoordinatorId: model.careCoordinatorUserId,
              isCareGiver: (model.isCaregiver ?? false),
              groupId: '',
              lastDate: model.deliveredDateTime,
            ),
          );
        } else {
          Get.to(() => ChatUserList());
        }
      } else {
        model.viewRecordAction = viewRecordAction;
        model.chatWithCC = chatWithCC;
        notificationReceivedFromKilledState = false;
        await PreferenceUtil.saveNotificationData(model);
      }
    } else if (model.templateName ==
            parameters.notifyCaregiverForMedicalRecord &&
        viewRecordAction) {
      if (model.redirectData != null) {
        final dataOne = model.redirectData[1];
        final dataTwo = model.redirectData[2];

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
      await CommonUtil.sendLogToServer();
    } else if (model.templateName == parameters.familyMemberCaregiverRequest) {
      //No Navigation required
    } else if (model.templateName ==
        parameters.associationNotificationToCaregiver) {
      //No Navigation required
    } else if (model.isCancellation) {
      fbaLog(eveParams: {
        'eventTime': '${DateTime.now()}',
        'ns_type': 'DoctorCancellation',
        'navigationPage': 'Appointment List',
      });
      isAlreadyLoaded
          ? Get.to(() => NotificationMain())
          : Get.to(() => SplashScreen(
                nsRoute: parameters.doctorCancellation,
              ));
    } else if (((model.templateName ?? '').isNotEmpty &&
        model.templateName == parameters.chat)) {
      fbaLog(eveParams: {
        'eventTime': '${DateTime.now()}',
        'ns_type': 'chat',
        'navigationPage': 'Tele Health Chat list',
      });
      isAlreadyLoaded
          ? Get.to(() => ChatUserList())
          : Get.to(() => SplashScreen(
                nsRoute: parameters.chat,
              ));
    } else if (model.redirectData != null) {
      final dataOne = model.redirectData[1];
      final dataTwo = model.redirectData[2];
      fbaLog(eveParams: {
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
    } else if (model.redirect == parameters.chat) {
      if (!notificationReceivedFromKilledState) {
        if ((model.doctorId ?? '').isNotEmpty &&
            (model.doctorName ?? '').isNotEmpty &&
            (model.doctorPicture ?? '').isNotEmpty) {
          Get.to(
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
          Get.to(() => ChatUserList());
        }
      } else {
        notificationReceivedFromKilledState = false;
        await PreferenceUtil.saveNotificationData(model);
      }
    } else if (model.redirect == 'sheela') {
      fbaLog(
        eveParams: {
          'eventTime': '${DateTime.now()}',
          'ns_type': 'sheela',
          'navigationPage': 'Sheela Start Page',
        },
      );
      if (isAlreadyLoaded) {
        if ((model.notificationListId ?? '').isNotEmpty) {
          FetchNotificationService()
              .inAppUnreadAction(model.notificationListId);
        }
        if (model.rawBody != null) {
          String sheela_lang = PreferenceUtil.getStringValue(SHEELA_LANG);
          if (sheela_lang != null && sheela_lang != '') {
            Get.toNamed(
              rt_Sheela,
              arguments: SheelaArgument(
                isSheelaAskForLang: false,
                langCode: sheela_lang,
                rawMessage: model.rawBody,
              ),
            );
            /*  Get.to(
            () => bot.ChatScreen(
              arguments: SheelaArgument(
                isSheelaAskForLang: false,
                langCode: sheela_lang,
                rawMessage: model.rawBody,
              ),
            )); */
          } else {
            Get.toNamed(
              rt_Sheela,
              arguments: SheelaArgument(
                isSheelaAskForLang: true,
                rawMessage: model.rawBody,
              ),
            );

            /* Get.to(
            () => bot.ChatScreen(
              arguments: SheelaArgument(
                isSheelaAskForLang: true,
                rawMessage: model.rawBody,
              ),
            )); */
          }
        } else {
          Get.to(() => SplashScreen(
                nsRoute: 'sheela',
              ));
        }
      } else {
        Get.to(() => SplashScreen(
              nsRoute: 'sheela',
            ));
      }
    } else if ((model.redirect == 'profile_page') ||
        (model.redirect == 'profile')) {
      fbaLog(eveParams: {
        'eventTime': '${DateTime.now()}',
        'ns_type': 'profile_page',
        'navigationPage': 'User Profile page',
      });

      isAlreadyLoaded
          ? Get.toNamed(router.rt_UserAccounts,
              arguments: UserAccountsArguments(selectedIndex: 0))
          : Get.to(() => SplashScreen(
                nsRoute: 'profile_page',
              ));
    } else if (model.redirect == parameters.myCartDetails &&
        (model.planId ?? '').isNotEmpty) {
      final userId = PreferenceUtil.getStringValue(KEY_USERID);

      if (model.userId == userId) {
        isAlreadyLoaded
            ? Get.to(
                () => MyPlanDetail(
                    packageId: model.planId,
                    showRenew: renewAction,
                    templateName: model.templateName),
              ).then((value) {
                renewAction = false;
              })
            : Get.to(() => SplashScreen(
                  nsRoute: 'regiment_screen',
                )).then((value) {
                renewAction = false;
              });
      } else {
        CommonUtil.showFamilyMemberPlanExpiryDialog(model.patientName);
      }
    } else if (model.redirect == parameters.claimList &&
        (model.claimId ?? '').isNotEmpty) {
      Get.to(
        () => ClaimRecordDisplay(
          claimID: model.claimId,
        ),
      );
      // }
    } else if (model.redirect == parameters.myPlanDetails &&
        (model.planId ?? '').isNotEmpty) {
      final userId = PreferenceUtil.getStringValue(KEY_USERID);
      if (model.userId == userId) {
        Get.to(
          () => MyPlanDetail(
            packageId: model.planId,
            showRenew: false,
            templateName: model.templateName,
          ),
        ).then((value) {
          renewAction = false;
        });
      } else {
        CommonUtil.showFamilyMemberPlanExpiryDialog(
          model.patientName,
          redirect: parameters.myPlanDetails,
        );
      }
    } else if (model.redirect == 'googlefit') {
      fbaLog(eveParams: {
        'eventTime': '${DateTime.now()}',
        'ns_type': 'googlefit',
        'navigationPage': 'Google Fit page',
      });
      isAlreadyLoaded
          ? Get.toNamed(router.rt_AppSettings)
          : Get.to(() => SplashScreen(
                nsRoute: 'googlefit',
              ));
    } else if ((model.redirect == 'th_provider') ||
        (model.redirect == 'provider')) {
      fbaLog(eveParams: {
        'eventTime': '${DateTime.now()}',
        'ns_type': 'th_provider',
        'navigationPage': 'Tele Health Provider',
      });
      isAlreadyLoaded
          ? Get.toNamed(router.rt_TelehealthProvider,
              arguments: HomeScreenArguments(selectedIndex: 1))
          : Get.to(() => SplashScreen(
                nsRoute: 'th_provider',
              ));
    } else if ((model.redirect == 'my_record') ||
        (model.redirect == 'prescription_list') ||
        (model.redirect == 'add_doc')) {
      fbaLog(eveParams: {
        'eventTime': '${DateTime.now()}',
        'ns_type': 'my_record',
        'navigationPage': 'My Records',
      });
      CommonUtil().getUserProfileData();
      isAlreadyLoaded
          ? Get.toNamed(router.rt_HomeScreen,
              arguments: HomeScreenArguments(selectedIndex: 1))
          : Get.to(() => SplashScreen(
                nsRoute: 'my_record',
              ));
    } else if ((model.redirect == 'devices_tab')) {
      fbaLog(eveParams: {
        'eventTime': '${DateTime.now()}',
        'ns_type': 'my_record',
        'navigationPage': 'My Records',
      });
      CommonUtil().getUserProfileData();
      isAlreadyLoaded
          ? Get.toNamed(
              router.rt_HomeScreen,
              arguments: HomeScreenArguments(selectedIndex: 1, thTabIndex: 1),
            )
          : Get.to(() => SplashScreen(
                nsRoute: 'my_record',
              ));
    } else if ((model.redirect == 'bills')) {
      fbaLog(eveParams: {
        'eventTime': '${DateTime.now()}',
        'ns_type': 'my_record',
        'navigationPage': 'My Records',
      });
      CommonUtil().getUserProfileData();
      isAlreadyLoaded
          ? Get.toNamed(
              router.rt_HomeScreen,
              arguments: HomeScreenArguments(selectedIndex: 1, thTabIndex: 4),
            )
          : Get.to(() => SplashScreen(
                nsRoute: 'my_record',
              ));
    } else if (model.redirect == 'regiment_screen') {
      fbaLog(eveParams: {
        'eventTime': '${DateTime.now()}',
        'ns_type': 'regiment_screen',
        'navigationPage': 'Regimen Screen',
      });
      if (isAlreadyLoaded) {
        if (model.eventId != null) {
          Get.toNamed(router.rt_Regimen,
              arguments: RegimentArguments(eventId: model.eventId));
        } else {
          Get.to(() => SplashScreen(
                nsRoute: 'regiment_screen',
              ));
        }
      } else {
        Get.to(() => SplashScreen(
              nsRoute: 'regiment_screen',
            ));
      }
    } else if (model.redirect == 'mycart') {
      fbaLog(eveParams: {
        'eventTime': '${DateTime.now()}',
        'ns_type': 'my cart',
        'navigationPage': 'My Cart',
      });
      Get.to(
        () => CheckoutPage(
          isFromNotification: true,
        ),
      );
    } else if (model.redirect == 'dashboard') {
      fbaLog(eveParams: {
        'eventTime': '${DateTime.now()}',
        'ns_type': 'dashboard',
        'navigationPage': 'Device List Screen',
      });
      isAlreadyLoaded
          ? PageNavigator.goToPermanent(
              Get.key.currentContext, router.rt_Landing)
          : Get.to(() => SplashScreen(
                nsRoute: 'regiment_screen',
              ));
    } else if (model.redirect == 'th_provider_hospital') {
      fbaLog(eveParams: {
        'eventTime': '${DateTime.now()}',
        'ns_type': 'th_provider_hospital',
        'navigationPage': 'TH provider Hospital Screen',
      });
      isAlreadyLoaded
          ? Get.toNamed(router.rt_TelehealthProvider,
              arguments: HomeScreenArguments(selectedIndex: 1, thTabIndex: 1))
          : Get.to(() => SplashScreen(
                nsRoute: 'th_provider_hospital',
              ));
    } else if ((model.redirect == 'myfamily_list') ||
        (model.redirect == 'profile_my_family')) {
      fbaLog(eveParams: {
        'eventTime': '${DateTime.now()}',
        'ns_type': 'myfamily_list',
        'navigationPage': 'MyFamily List Screen',
      });
      isAlreadyLoaded
          ? Get.toNamed(router.rt_UserAccounts,
              arguments: UserAccountsArguments(selectedIndex: 1))
          : Get.to(() => SplashScreen(
                nsRoute: 'myfamily_list',
              ));
    } else if ((model.redirect == 'myprovider_list')) {
      fbaLog(eveParams: {
        'eventTime': '${DateTime.now()}',
        'ns_type': 'myprovider_list',
        'navigationPage': 'MyProvider List Screen',
      });
      isAlreadyLoaded
          ? Get.toNamed(router.rt_UserAccounts,
              arguments: UserAccountsArguments(selectedIndex: 2))
          : Get.to(() => SplashScreen(
                nsRoute: 'myprovider_list',
              ));
    } else if (model.redirect == 'myplans') {
      fbaLog(eveParams: {
        'eventTime': '${DateTime.now()}',
        'ns_type': 'myplans',
        'navigationPage': 'MyPlans Screen',
      });
      isAlreadyLoaded
          ? Get.toNamed(router.rt_UserAccounts,
              arguments: UserAccountsArguments(selectedIndex: 3))
          : Get.to(() => SplashScreen(
                nsRoute: 'myplans',
              ));
    } else if ((model.redirect == 'appointmentList') ||
        (model.redirect == 'appointmentHistory')) {
      fbaLog(eveParams: {
        'eventTime': '${DateTime.now()}',
        'ns_type': 'appointmentList',
        'navigationPage': 'Tele Health Appointment list',
      });
      model.redirect = 'appointmentList';
      await PreferenceUtil.saveNotificationData(model);
      isAlreadyLoaded
          ? PageNavigator.goTo(Get.context, router.rt_Landing)
          : Get.to(() => SplashScreen(
                nsRoute: model.redirect,
              ));
    } else if (model.redirect == 'manageActivities') {
      fbaLog(eveParams: {
        'eventTime': '${DateTime.now()}',
        'ns_type': 'manageActivities',
        'navigationPage': 'ManageActivities list',
      });
      Get.toNamed(rt_ManageActivitiesScreen);
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
    } else {
      isAlreadyLoaded
          ? PageNavigator.goTo(
              Get.context,
              router.rt_Landing,
            )
          : Get.to(() => SplashScreen(
                nsRoute: '',
              ));
    }
  }

  void navigateToMyRecordsCategory(
      dynamic categoryType, List<String> hrmId, bool isTerminate) async {
    CommonUtil().getCategoryListPos(categoryType).then(
          (value) => CommonUtil().goToMyRecordsScreen(
            value,
            hrmId,
            isTerminate,
          ),
        );
  }
}
