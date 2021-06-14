import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:myfhb/common/CommonUtil.dart';
import 'package:myfhb/constants/fhb_constants.dart';
import 'package:myfhb/constants/fhb_parameters.dart' as parameters;
import 'package:myfhb/constants/variable_constant.dart' as variable;
import 'package:myfhb/src/model/home_screen_arguments.dart';
import 'package:myfhb/src/model/user/user_accounts_arguments.dart';
import 'package:myfhb/src/ui/Dashboard.dart';
import 'package:myfhb/src/ui/SplashScreen.dart';
import 'package:myfhb/src/ui/bot/SuperMaya.dart';
import 'package:myfhb/telehealth/features/MyProvider/view/TelehealthProviders.dart';
import 'package:myfhb/telehealth/features/Notifications/view/notification_main.dart';
import 'package:myfhb/telehealth/features/chat/view/home.dart';
import 'package:myfhb/video_call/model/NotificationModel.dart';
import 'package:myfhb/constants/router_variable.dart' as router;
import 'package:myfhb/landing/view/landing_screen.dart';
import 'package:myfhb/src/utils/PageNavigator.dart';

class IosNotificationHandler {
  final myDB = Firestore.instance;
  bool isAlreadyLoaded = false;
  NotificationModel model;

  setUpListerForTheNotification() {
    variable.reponseToRemoteNotificationMethodChannel
        .setMethodCallHandler((call) {
      if (call.method == variable.notificationResponseMethod) {
        final data = Map<String, dynamic>.from(call.arguments);
        model = NotificationModel.fromMap(data);
        if (!isAlreadyLoaded) {
          Future.delayed(const Duration(seconds: 4), actionForTheNotification);
        } else {
          actionForTheNotification();
        }
      }
    });
  }

  void updateStatus(String status) async {
    try {
      await myDB
          .collection("call_log")
          .document("${model.callArguments.channelName}")
          .setData({"call_status": status});
    } catch (e) {
      print(e);
    }
    if (model.callArguments != null) {
      fbaLog(eveParams: {
        'eventTime': '${DateTime.now()}',
        'ns_type': 'call',
        'navigationPage': 'TeleHelath Call screen',
      });
      Get.key.currentState
          .pushNamed(router.rt_CallMain, arguments: model.callArguments);
    }
  }

  actionForTheNotification() {
    if (model.isCall) {
      updateStatus(parameters.accept.toLowerCase());
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
      isAlreadyLoaded
          ? Get.to(ChatHomeScreen())
          : Get.to(SplashScreen(
              nsRoute: parameters.chat,
            ));
    } else if (model.redirect == 'sheela') {
      fbaLog(eveParams: {
        'eventTime': '${DateTime.now()}',
        'ns_type': 'sheela',
        'navigationPage': 'Sheela Start Page',
      });
      isAlreadyLoaded
          ? Get.to(SuperMaya())
          : Get.to(SplashScreen(
              nsRoute: 'sheela',
            ));
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
      isAlreadyLoaded
          ? Get.toNamed(router.rt_Regimen)
          : Get.to(SplashScreen(
              nsRoute: 'regiment_screen',
            ));
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
      isAlreadyLoaded
          ? Get.to(TelehealthProviders(
              arguments: HomeScreenArguments(selectedIndex: 0),
            ))
          : Get.to(SplashScreen(
              nsRoute: model.redirect,
            ));
    } else {
      isAlreadyLoaded
          ? PageNavigator.goTo(Get.context, router.rt_Landing)
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
