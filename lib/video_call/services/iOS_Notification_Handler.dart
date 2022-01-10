import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:launch_review/launch_review.dart';
import 'package:myfhb/claim/model/claimmodel/ClaimRecordDetail.dart';
import 'package:myfhb/claim/screen/ClaimRecordDisplay.dart';
import 'package:myfhb/common/CommonUtil.dart';
import 'package:myfhb/common/PreferenceUtil.dart';
import 'package:myfhb/constants/fhb_constants.dart';
import 'package:myfhb/constants/fhb_parameters.dart' as parameters;
import 'package:myfhb/constants/router_variable.dart';
import 'package:myfhb/constants/variable_constant.dart' as variable;
import 'package:myfhb/myPlan/view/myPlanDetail.dart';
import 'package:myfhb/regiment/models/regiment_arguments.dart';
import 'package:myfhb/src/model/home_screen_arguments.dart';
import 'package:myfhb/src/model/user/user_accounts_arguments.dart';
import 'package:myfhb/src/ui/SplashScreen.dart';
import 'package:myfhb/src/ui/bot/SuperMaya.dart';
import 'package:myfhb/src/ui/bot/view/ChatScreen.dart' as bot;
import 'package:myfhb/src/ui/bot/view/sheela_arguments.dart';
import 'package:myfhb/telehealth/features/MyProvider/view/TelehealthProviders.dart';
import 'package:myfhb/telehealth/features/Notifications/services/notification_services.dart';
import 'package:myfhb/telehealth/features/Notifications/view/notification_main.dart';
import 'package:myfhb/telehealth/features/chat/view/chat.dart';
import 'package:myfhb/telehealth/features/chat/view/home.dart';
import 'package:myfhb/video_call/model/NotificationModel.dart';
import 'package:myfhb/constants/router_variable.dart' as router;
import 'package:myfhb/src/utils/PageNavigator.dart';
import 'package:myfhb/video_call/utils/audiocall_provider.dart';
import 'package:myfhb/widgets/checkout_page.dart';
import 'package:provider/provider.dart';

class IosNotificationHandler {
  final myDB = FirebaseFirestore.instance;
  bool isAlreadyLoaded = false;
  NotificationModel model;
  bool renewAction = false;
  bool callbackAction = false;

  setUpListerForTheNotification() {
    variable.reponseToRemoteNotificationMethodChannel.setMethodCallHandler(
      (call) {
        if (call.method == variable.notificationResponseMethod) {
          final data = Map<String, dynamic>.from(call.arguments);
          model = NotificationModel.fromMap(data.containsKey("action")
              ? Map<String, dynamic>.from(data["data"])
              : data);
          if (model.externalLink != null) {
            if (model.externalLink == variable.iOSAppStoreLink) {
              LaunchReview.launch(
                  iOSAppId: variable.iOSAppId, writeReview: false);
            } else {
              CommonUtil().launchURL(model.externalLink);
            }
          }
          if (data.containsKey("action")) {
            if (data["action"] != null) {
              if (data["action"] == "Renew") {
                renewAction = true;
              } else if (data["action"] == "Callback") {
                callbackAction = true;
              }
            }

            if (!isAlreadyLoaded) {
              Future.delayed(
                const Duration(seconds: 4),
                actionForTheNotification,
              );
            } else {
              if (callbackAction) {
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
                FetchNotificationService()
                    .updateNsActionStatus(body)
                    .then((data) {
                  FetchNotificationService().updateNsOnTapAction(body);
                });
                return;
              }
              actionForTheNotification();
            }
          } else {
            if (!isAlreadyLoaded) {
              Future.delayed(
                const Duration(seconds: 4),
                actionForTheNotification,
              );
            } else {
              actionForTheNotification();
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
    if (callbackAction) {
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
      FetchNotificationService().updateNsActionStatus(body).then(
        (data) {
          FetchNotificationService().updateNsOnTapAction(body);
        },
      );
    }
    if (model.isCall) {
      updateStatus(parameters.accept.toLowerCase());
    } else if (model.type == parameters.FETCH_LOG) {
      await CommonUtil.sendLogToServer();
    } else if (model.isCancellation) {
      fbaLog(eveParams: {
        'eventTime': '${DateTime.now()}',
        'ns_type': 'DoctorCancellation',
        'navigationPage': 'Appointment List',
      });
      isAlreadyLoaded
          ? Get.to(NotificationMain())
          : Get.to(SplashScreen(
              nsRoute: parameters.doctorCancellation,
            ));
    } else if ((model.templateName != null &&
        model.templateName == parameters.chat)) {
      fbaLog(eveParams: {
        'eventTime': '${DateTime.now()}',
        'ns_type': 'chat',
        'navigationPage': 'Tele Health Chat list',
      });
      isAlreadyLoaded
          ? Get.to(ChatHomeScreen())
          : Get.to(SplashScreen(
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
      isAlreadyLoaded
          ? navigateToMyRecordsCategory(dataOne, dataTwo, false)
          : Get.to(SplashScreen(
              nsRoute: 'myRecords',
              templateName: dataOne,
              bundle: dataTwo,
            ));
      ;
    } else if (model.redirect == parameters.chat) {
      if (isAlreadyLoaded) {
        if (model.doctorId != null &&
            model.doctorName != null &&
            model.doctorPicture != null &&
            model.patientId != null &&
            model.patientName != null &&
            model.patientPicture != null) {
          Get.to(
            Chat(
              peerId: model.doctorId,
              peerName: model.doctorName,
              peerAvatar: model.doctorPicture,
              patientId: model.patientId,
              patientName: model.patientName,
              patientPicture: model.patientPicture,
              isFromVideoCall: false,
              isCareGiver: false,
            ),
          );
        } else {
          Get.to(ChatHomeScreen());
        }
      } else {
        Get.to(SplashScreen(
          nsRoute: parameters.chat,
        ));
      }
    } else if (model.redirect == 'sheela') {
      fbaLog(eveParams: {
        'eventTime': '${DateTime.now()}',
        'ns_type': 'sheela',
        'navigationPage': 'Sheela Start Page',
      });
      if (isAlreadyLoaded) {
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
            /*  Get.to(bot.ChatScreen(
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

            /* Get.to(bot.ChatScreen(
              arguments: SheelaArgument(
                isSheelaAskForLang: true,
                rawMessage: model.rawBody,
              ),
            )); */
          }
        } else {
          Get.to(SplashScreen(
            nsRoute: 'sheela',
          ));
        }
      } else {
        Get.to(SplashScreen(
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
          : Get.to(SplashScreen(
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
            : Get.to(SplashScreen(
                nsRoute: 'regiment_screen',
              )).then((value) {
                renewAction = false;
              });
      } else {
        CommonUtil.showFamilyMemberPlanExpiryDialog(model.patientName);
      }
    } else if (model.redirect == parameters.claimList &&
        model.claimId != null) {
      // final userId = PreferenceUtil.getStringValue(KEY_USERID);
      // if (model.userId == userId) {
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
          : Get.to(SplashScreen(
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
          : Get.to(SplashScreen(
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
          : Get.to(SplashScreen(
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
          : Get.to(SplashScreen(
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
          : Get.to(SplashScreen(
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
          Get.to(SplashScreen(
            nsRoute: 'regiment_screen',
          ));
        }
      } else {
        Get.to(SplashScreen(
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
        CheckoutPage(
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
          : Get.to(SplashScreen(
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
          : Get.to(SplashScreen(
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
          : Get.to(SplashScreen(
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
          : Get.to(SplashScreen(
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
          : Get.to(SplashScreen(
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
          : Get.to(SplashScreen(
              nsRoute: model.redirect,
            ));
    } else if (model.redirect == 'manageActivities') {
      fbaLog(eveParams: {
        'eventTime': '${DateTime.now()}',
        'ns_type': 'manageActivities',
        'navigationPage': 'ManageActivities list',
      });
      Get.toNamed(rt_ManageActivitiesScreen);
    } else {
      isAlreadyLoaded
          ? PageNavigator.goTo(
              Get.context,
              router.rt_Landing,
            )
          : Get.to(SplashScreen(
              nsRoute: '',
            ));
    }
  }

  void navigateToMyRecordsCategory(
      dynamic categoryType, List<String> hrmId, bool isTerminate) async {
    CommonUtil().getCategoryListPos(categoryType).then(
        (value) => CommonUtil().goToMyRecordsScreen(value, hrmId, isTerminate));
  }
}
