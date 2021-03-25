import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:myfhb/authentication/view/login_screen.dart';
import 'package:get/get.dart';
import 'package:myfhb/common/CommonUtil.dart';
import 'package:myfhb/common/PreferenceUtil.dart';
import 'package:myfhb/constants/fhb_constants.dart' as Constants;
import 'package:myfhb/constants/router_variable.dart' as router;
import 'package:myfhb/constants/variable_constant.dart' as variable;
import 'package:myfhb/src/model/GetDeviceSelectionModel.dart';
import 'package:myfhb/src/model/home_screen_arguments.dart';
import 'package:myfhb/src/resources/repository/health/HealthReportListForUserRepository.dart';
import 'package:myfhb/telehealth/features/MyProvider/view/TelehealthProviders.dart';
import 'package:myfhb/telehealth/features/Notifications/view/notification_main.dart';
import 'package:myfhb/telehealth/features/appointments/model/fetchAppointments/city.dart';
import 'package:myfhb/telehealth/features/appointments/model/fetchAppointments/doctor.dart'
    as doc;
import 'package:myfhb/src/utils/screenutils/size_extensions.dart';
import 'package:myfhb/telehealth/features/appointments/model/fetchAppointments/past.dart';
import 'package:myfhb/telehealth/features/appointments/view/resheduleMain.dart';
import 'package:myfhb/constants/fhb_parameters.dart' as parameters;
import 'package:myfhb/telehealth/features/chat/view/home.dart';
import '../utils/PageNavigator.dart';
import 'package:connectivity/connectivity.dart';
import 'NetworkScreen.dart';
import 'package:myfhb/src/ui/bot/SuperMaya.dart';
import 'package:myfhb/src/model/user/user_accounts_arguments.dart';

class SplashScreen extends StatefulWidget {
  final String nsRoute;
  final String bookingID;
  final String doctorID;
  final String appointmentDate;
  final String doctorSessionId;
  final String healthOrganizationId;
  final String templateName;
  final dynamic bundle;

  SplashScreen(
      {this.nsRoute,
      this.bookingID,
      this.doctorID,
      this.appointmentDate,
      this.doctorSessionId,
      this.healthOrganizationId,
      this.templateName,
      this.bundle});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  HealthReportListForUserRepository healthReportListForUserRepository =
      HealthReportListForUserRepository();
  GetDeviceSelectionModel selectionResult;

  @override
  void initState() {
    super.initState();

    PreferenceUtil.init();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<ConnectivityResult>(
        future: Connectivity().checkConnectivity(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData &&
                (snapshot.data == ConnectivityResult.mobile ||
                    snapshot.data == ConnectivityResult.wifi)) {
              Future.delayed(const Duration(seconds: 3), () {
                var isFirstTime =
                    PreferenceUtil.isKeyValid(Constants.KEY_INTRO_SLIDER);

                var deviceIfo =
                    PreferenceUtil.isKeyValid(Constants.KEY_DEVICEINFO);
                PreferenceUtil.saveString(Constants.KEY_FAMILYMEMBERID, '');

                if (!isFirstTime) {
                  PreferenceUtil.saveString(
                      Constants.KEY_INTRO_SLIDER, variable.strtrue);
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) =>
                              PatientSignInScreen()),
                      (route) => false);

                  // PageNavigator.goToPermanent(context, router.rt_WebCognito);
                } else {
                  String authToken =
                      PreferenceUtil.getStringValue(Constants.KEY_AUTHTOKEN);
                  if (authToken != null) {
                    if (deviceIfo) {
                      if (widget.nsRoute == 'DoctorRescheduling') {
                        var body = {};
                        body['templateName'] = widget.templateName;
                        body['contextId'] = widget.bookingID;
                        Get.to(
                          ResheduleMain(
                            isFromNotification: true,
                            isReshedule: true,
                            doc: Past(
                              //! this is has to be correct
                              doctorSessionId: widget.doctorSessionId,
                              bookingId: widget.bookingID,
                              doctor: doc.Doctor(id: widget.doctorID),
                              healthOrganization:
                                  City(id: widget.healthOrganizationId),
                            ),
                            body: body,
                          ),
                        );
                      } else if (widget.nsRoute == 'DoctorCancellation') {
                        //cancel appointments route

                        Get.offAll(TelehealthProviders(
                          arguments: HomeScreenArguments(
                              selectedIndex: 0,
                              dialogType: 'CANCEL',
                              isCancelDialogShouldShow: true,
                              bookingId: widget.bookingID,
                              date: widget.appointmentDate,
                              templateName: widget.templateName),
                        ));
                      } else if (widget.nsRoute ==
                          parameters.doctorCancellation) {
                        Get.to(NotificationMain());
                      } else if (widget.nsRoute == 'chat') {
                        Get.to(
                          ChatHomeScreen(),
                        );
                      } else if (widget.nsRoute == 'appointmentList') {
                        //cancel appointments route
                        Get.offAll(TelehealthProviders(
                          arguments: HomeScreenArguments(
                              selectedIndex: 0,
                              bookingId: widget.bookingID,
                              date: widget.appointmentDate,
                              templateName: widget.templateName),
                        ));
                      } else if (widget.nsRoute == 'sheela') {
                        Get.to(SuperMaya()).then((value) =>
                            PageNavigator.goToPermanent(
                                context, router.rt_Dashboard));
                      } else if (widget.nsRoute == 'profile_page') {
                        Get.toNamed(router.rt_UserAccounts,
                                arguments:
                                    UserAccountsArguments(selectedIndex: 0))
                            .then((value) => PageNavigator.goToPermanent(
                                context, router.rt_Dashboard));
                      } else if (widget.nsRoute == 'googlefit') {
                        Get.toNamed(router.rt_AppSettings).then((value) =>
                            PageNavigator.goToPermanent(
                                context, router.rt_Dashboard));
                      } else if (widget.nsRoute == 'th_provider') {
                        Get.toNamed(router.rt_TelehealthProvider,
                                arguments:
                                    HomeScreenArguments(selectedIndex: 1))
                            .then((value) => PageNavigator.goToPermanent(
                                context, router.rt_Dashboard));
                      } else if (widget.nsRoute == 'my_record') {
                        getProfileData();
                        Get.toNamed(router.rt_HomeScreen,
                                arguments:
                                    HomeScreenArguments(selectedIndex: 1))
                            .then((value) => PageNavigator.goToPermanent(
                                context, router.rt_Dashboard));
                      } else if (widget.nsRoute == 'myRecords' &&
                          (widget.templateName != null &&
                              widget.templateName != '') &&
                          (widget.bundle != null && widget.bundle != '')) {
                        CommonUtil().navigateToMyRecordsCategory(
                            widget.templateName, [widget.bundle], true);
                      } else {
                        PageNavigator.goToPermanent(
                            context, router.rt_Dashboard);
                      }
                    } else {
                      FirebaseMessaging _firebaseMessaging =
                          FirebaseMessaging();

                      _firebaseMessaging.getToken().then((token) {
                        new CommonUtil()
                            .sendDeviceToken(
                                PreferenceUtil.getStringValue(
                                    Constants.KEY_USERID),
                                PreferenceUtil.getStringValue(
                                    Constants.KEY_EMAIL),
                                PreferenceUtil.getStringValue(
                                    Constants.MOB_NUM),
                                token,
                                true)
                            .then((value) {
                          PageNavigator.goToPermanent(
                              context, router.rt_Dashboard);
                        });
                      });
                    }
                  } else {
                    //PageNavigator.goToPermanent(context, router.rt_WebCognito);
                    // Navigator.push(
                    //     context,
                    //     MaterialPageRoute(
                    //         builder: (context) => PatientSignInScreen()));
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext context) =>
                                PatientSignInScreen()),
                        (route) => false);
                  }
                }
              });
              return Scaffold(
                body: Center(
                    child: Image.asset(
                  variable.icon_splash_logo,
                  height: 150.0.h,
                  width: 150.0.h,
                )),
              );
            }
            return NetworkScreen();
          }
          return Scaffold(
            body: Center(
                child: Image.asset(
              variable.icon_splash_logo,
              height: 150.0.h,
              width: 150.0.h,
            )),
          );
        });
  }

  void getProfileData() async {
    try {
      await new CommonUtil().getUserProfileData();
    } catch (e) {}
  }
}
