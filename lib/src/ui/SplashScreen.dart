import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:myfhb/authentication/view/login_screen.dart';
import 'package:get/get.dart';
import 'package:myfhb/common/CommonUtil.dart';
import 'package:myfhb/common/PreferenceUtil.dart';
import 'package:myfhb/constants/fhb_constants.dart' as Constants;
import 'package:myfhb/constants/fhb_constants.dart';
import 'package:myfhb/constants/router_variable.dart' as router;
import 'package:myfhb/constants/router_variable.dart';
import 'package:myfhb/constants/variable_constant.dart' as variable;
import 'package:myfhb/regiment/models/regiment_arguments.dart';
import 'package:myfhb/landing/view/landing_arguments.dart';
import 'package:myfhb/landing/view_model/landing_view_model.dart';
import 'package:myfhb/regiment/view_model/regiment_view_model.dart';
import 'package:myfhb/src/model/GetDeviceSelectionModel.dart';
import 'package:myfhb/src/model/home_screen_arguments.dart';
import 'package:myfhb/src/resources/repository/health/HealthReportListForUserRepository.dart';
import 'package:myfhb/src/ui/Dashboard.dart';
import 'package:myfhb/src/ui/bot/view/sheela_arguments.dart';
import 'package:myfhb/src/ui/bot/viewmodel/chatscreen_vm.dart';
import 'package:myfhb/telehealth/features/MyProvider/view/TelehealthProviders.dart';
import 'package:myfhb/telehealth/features/Notifications/view/notification_main.dart';
import 'package:myfhb/telehealth/features/appointments/model/fetchAppointments/city.dart';
import 'package:myfhb/telehealth/features/appointments/model/fetchAppointments/doctor.dart'
    as doc;
import 'package:myfhb/src/utils/screenutils/size_extensions.dart';
import 'package:myfhb/telehealth/features/appointments/model/fetchAppointments/past.dart';
import 'package:myfhb/telehealth/features/appointments/view/resheduleMain.dart';
import 'package:myfhb/constants/fhb_parameters.dart' as parameters;
import 'package:myfhb/telehealth/features/chat/view/chat.dart';
import 'package:myfhb/telehealth/features/chat/view/home.dart';
import 'package:provider/provider.dart';
import '../utils/PageNavigator.dart';
import 'package:connectivity/connectivity.dart';
import 'NetworkScreen.dart';
import 'package:myfhb/src/ui/bot/SuperMaya.dart';
import 'package:myfhb/src/model/user/user_accounts_arguments.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:myfhb/src/ui/bot/view/ChatScreen.dart' as bot;

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
    //setReminder();
  }

  void setReminder() {
    var selecteTimeInDate =
        "${TimeOfDay.now().hour}-${TimeOfDay.now().minute + 3}";
    var ch_android = const MethodChannel('android/notification');
    var mappedReminder = {
      'id': 001,
      'title': 'Take BP tablet',
      'desc': 'dont forgot to take tablets',
      'date': '2021-04-13',
      'time': '$selecteTimeInDate',
    };
    ch_android.invokeMethod('remindMe', {'data': jsonEncode(mappedReminder)});
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
              var isFirstTime =
                  PreferenceUtil.isKeyValid(Constants.KEY_INTRO_SLIDER);
              var deviceIfo =
                  PreferenceUtil.isKeyValid(Constants.KEY_DEVICEINFO);
              PreferenceUtil.saveString(Constants.KEY_FAMILYMEMBERID, '');
              String authToken =
                  PreferenceUtil.getStringValue(Constants.KEY_AUTHTOKEN);

              Future.delayed(const Duration(seconds: 3), () {
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
                  if (authToken != null) {
                    if (deviceIfo) {
                      if (widget.nsRoute == 'DoctorRescheduling') {
                        fbaLog(eveParams: {
                          'eventTime': '${DateTime.now()}',
                          'ns_type': 'DoctorRescheduling',
                          'navigationPage': 'Reschedule screen',
                        });
                        var body = {};
                        body['templateName'] = widget.templateName;
                        body['contextId'] = widget.bookingID;
                        Get.to(
                          ResheduleMain(
                            isFromNotification: true,
                            isReshedule: true,
                            isFromFollowUpApp: false,
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
                        fbaLog(eveParams: {
                          'eventTime': '${DateTime.now()}',
                          'ns_type': 'DoctorCancellation',
                          'navigationPage': 'Appointment List',
                        });
                        Get.to(TelehealthProviders(
                          arguments: HomeScreenArguments(
                              selectedIndex: 0,
                              dialogType: 'CANCEL',
                              isCancelDialogShouldShow: true,
                              bookingId: widget.bookingID,
                              date: widget.appointmentDate,
                              templateName: widget.templateName),
                        )).then((value) => PageNavigator.goToPermanent(
                            context, router.rt_Landing));
                      } else if (widget.nsRoute ==
                          parameters.doctorCancellation) {
                        Get.to(NotificationMain());
                      } else if (widget.nsRoute == 'chat') {
                        fbaLog(eveParams: {
                          'eventTime': '${DateTime.now()}',
                          'ns_type': 'chat',
                          'navigationPage': 'Tele Health Chat list',
                        });
                        if (widget.bundle != null && widget.bundle != '') {
                          var chatParsedData = widget.bundle?.split('|');
                          Get.to(Chat(
                            peerId: chatParsedData[0],
                            peerName: chatParsedData[1],
                            peerAvatar: chatParsedData[2],
                            patientId: chatParsedData[3],
                            patientName: chatParsedData[4],
                            patientPicture: chatParsedData[5],
                            isFromVideoCall: false,
                            message: chatParsedData[6],
                          )).then((value) => PageNavigator.goToPermanent(
                              context, router.rt_Landing));
                        } else {
                          Get.to(ChatHomeScreen()).then((value) =>
                              PageNavigator.goToPermanent(
                                  context, router.rt_Landing));
                        }
                      } else if (widget.nsRoute == 'appointmentList' ||
                          widget.nsRoute == 'appointmentHistory') {
                        fbaLog(eveParams: {
                          'eventTime': '${DateTime.now()}',
                          'ns_type': 'appointmentList',
                          'navigationPage': 'Tele Health Appointment list',
                        });
                        //cancel appointments route
                        Get.to(TelehealthProviders(
                          arguments: HomeScreenArguments(
                              selectedIndex: 0,
                              bookingId: widget.bookingID,
                              date: widget.appointmentDate,
                              templateName: widget.templateName),
                        )).then((value) => PageNavigator.goToPermanent(
                            context, router.rt_Landing));
                      } else if (widget.nsRoute == 'sheela') {
                        fbaLog(eveParams: {
                          'eventTime': '${DateTime.now()}',
                          'ns_type': 'sheela',
                          'navigationPage': 'Sheela Start Page',
                        });
                        if (widget.bundle != null && widget.bundle.isNotEmpty) {
                          var rawTitle = widget.bundle?.split('|')[0];
                          var rawBody = widget.bundle?.split('|')[1];
                          String sheela_lang = PreferenceUtil.getStringValue(
                              Constants.SHEELA_LANG);
                          if ((Provider.of<ChatScreenViewModel>(context,
                                          listen: false)
                                      ?.conversations
                                      ?.length ??
                                  0) >
                              0) {
                            Provider.of<ChatScreenViewModel>(context,
                                    listen: false)
                                ?.startMayaAutomatically(message: rawBody);
                          } else if (sheela_lang != null && sheela_lang != '') {
                            Get.toNamed(
                              rt_Sheela,
                              arguments: SheelaArgument(
                                isSheelaAskForLang: false,
                                langCode: sheela_lang,
                                rawMessage: rawBody,
                              ),
                            ).then((value) => PageNavigator.goToPermanent(
                                context, router.rt_Landing));

                            /* Get.to(bot.ChatScreen(
                              arguments: SheelaArgument(
                                isSheelaAskForLang: false,
                                langCode: sheela_lang,
                                rawMessage: rawBody,
                              ),
                            )).then((value) => PageNavigator.goToPermanent(
                                context, router.rt_Landing)); */
                          } else {
                            Get.toNamed(
                              rt_Sheela,
                              arguments: SheelaArgument(
                                isSheelaAskForLang: true,
                                rawMessage: rawBody,
                              ),
                            ).then((value) => PageNavigator.goToPermanent(
                                context, router.rt_Landing));

                            /* Get.to(bot.ChatScreen(
                              arguments: SheelaArgument(
                                isSheelaAskForLang: true,
                                rawMessage: rawBody,
                              ),
                            )).then((value) => PageNavigator.goToPermanent(
                                context, router.rt_Landing)); */
                          }
                        } else {
                          Get.to(SuperMaya()).then((value) =>
                              PageNavigator.goToPermanent(
                                  context, router.rt_Landing));
                        }
                      } else if (widget.nsRoute == 'profile_page' ||
                          widget.nsRoute == 'profile') {
                        fbaLog(eveParams: {
                          'eventTime': '${DateTime.now()}',
                          'ns_type': 'profile_page',
                          'navigationPage': 'User Profile page',
                        });
                        Get.toNamed(router.rt_UserAccounts,
                                arguments:
                                    UserAccountsArguments(selectedIndex: 0))
                            .then((value) => PageNavigator.goToPermanent(
                                context, router.rt_Landing));
                      } else if (widget.nsRoute == 'googlefit') {
                        fbaLog(eveParams: {
                          'eventTime': '${DateTime.now()}',
                          'ns_type': 'googlefit',
                          'navigationPage': 'Google Fit page',
                        });
                        Get.toNamed(router.rt_AppSettings).then((value) =>
                            PageNavigator.goToPermanent(
                                context, router.rt_Landing));
                      } else if (widget.nsRoute == 'th_provider' ||
                          widget.nsRoute == 'provider') {
                        fbaLog(eveParams: {
                          'eventTime': '${DateTime.now()}',
                          'ns_type': 'th_provider',
                          'navigationPage': 'Tele Health Provider',
                        });
                        Get.toNamed(router.rt_TelehealthProvider,
                                arguments:
                                    HomeScreenArguments(selectedIndex: 1))
                            .then((value) => PageNavigator.goToPermanent(
                                context, router.rt_Landing));
                      } else if (widget.nsRoute == 'my_record' ||
                          widget.nsRoute == 'prescription_list' ||
                          widget.nsRoute == 'add_doc') {
                        fbaLog(eveParams: {
                          'eventTime': '${DateTime.now()}',
                          'ns_type': 'my_record',
                          'navigationPage': 'My Records',
                        });
                        getProfileData();
                        Get.toNamed(router.rt_HomeScreen,
                                arguments:
                                    HomeScreenArguments(selectedIndex: 1))
                            .then((value) => PageNavigator.goToPermanent(
                                context, router.rt_Landing));
                      } else if (widget.nsRoute == 'myRecords' &&
                          (widget.templateName != null &&
                              widget.templateName != '') &&
                          (widget.bundle != null && widget.bundle != '')) {
                        fbaLog(eveParams: {
                          'eventTime': '${DateTime.now()}',
                          'ns_type': 'myRecords',
                          'navigationPage': '${widget.templateName}',
                        });
                        CommonUtil().navigateToMyRecordsCategory(
                            widget.templateName, [widget.bundle], true);
                      } else if (widget.nsRoute == 'regiment_screen') {
                        fbaLog(eveParams: {
                          'eventTime': '${DateTime.now()}',
                          'ns_type': 'regiment_screen',
                          'navigationPage': 'Regimen Screen',
                        });
                        Provider.of<RegimentViewModel>(
                          context,
                          listen: false,
                        )?.regimentMode = RegimentMode.Schedule;
                        Provider.of<RegimentViewModel>(context, listen: false)
                            ?.regimentFilter = RegimentFilter.Missed;
                        PageNavigator.goToPermanent(context, router.rt_Regimen,
                            arguments:
                                RegimentArguments(eventId: widget.bundle));
                      } else if (widget.nsRoute == 'th_provider_hospital') {
                        fbaLog(eveParams: {
                          'eventTime': '${DateTime.now()}',
                          'ns_type': 'th_provider_hospital',
                          'navigationPage': 'TH provider Hospital Screen',
                        });
                        Get.toNamed(router.rt_TelehealthProvider,
                                arguments: HomeScreenArguments(
                                    selectedIndex: 1, thTabIndex: 1))
                            .then((value) => PageNavigator.goToPermanent(
                                context, router.rt_Landing));
                      } else if (widget.nsRoute == 'myfamily_list' ||
                          widget.nsRoute == 'profile_my_family') {
                        fbaLog(eveParams: {
                          'eventTime': '${DateTime.now()}',
                          'ns_type': 'myfamily_list',
                          'navigationPage': 'MyFamily List Screen',
                        });
                        Get.toNamed(router.rt_UserAccounts,
                                arguments:
                                    UserAccountsArguments(selectedIndex: 1))
                            .then((value) => PageNavigator.goToPermanent(
                                context, router.rt_Landing));
                      } else if (widget.nsRoute == 'myprovider_list') {
                        fbaLog(eveParams: {
                          'eventTime': '${DateTime.now()}',
                          'ns_type': 'myprovider_list',
                          'navigationPage': 'MyProvider List Screen',
                        });
                        Get.toNamed(router.rt_UserAccounts,
                                arguments:
                                    UserAccountsArguments(selectedIndex: 2))
                            .then((value) => PageNavigator.goToPermanent(
                                context, router.rt_Landing));
                      } else if (widget.nsRoute == 'myplans') {
                        fbaLog(eveParams: {
                          'eventTime': '${DateTime.now()}',
                          'ns_type': 'myplans',
                          'navigationPage': 'MyPlans Screen',
                        });
                        Get.toNamed(router.rt_UserAccounts,
                                arguments:
                                    UserAccountsArguments(selectedIndex: 3))
                            .then((value) => PageNavigator.goToPermanent(
                                context, router.rt_Landing));
                      } else if (widget.nsRoute == 'devices_tab') {
                        fbaLog(eveParams: {
                          'eventTime': '${DateTime.now()}',
                          'ns_type': 'devices_tab',
                          'navigationPage': 'Device Tab Screen',
                        });
                        Get.toNamed(
                          router.rt_HomeScreen,
                          arguments: HomeScreenArguments(
                              selectedIndex: 1, thTabIndex: 1),
                        ).then((value) => PageNavigator.goToPermanent(
                            context, router.rt_Landing));
                      } else if (widget.nsRoute == 'bills') {
                        fbaLog(eveParams: {
                          'eventTime': '${DateTime.now()}',
                          'ns_type': 'bills',
                          'navigationPage': 'Bills Screen',
                        });
                        Get.toNamed(
                          router.rt_HomeScreen,
                          arguments: HomeScreenArguments(
                              selectedIndex: 1, thTabIndex: 4),
                        ).then((value) => PageNavigator.goToPermanent(
                            context, router.rt_Landing));
                      } else if (widget.nsRoute == 'openurl') {
                        fbaLog(eveParams: {
                          'eventTime': '${DateTime.now()}',
                          'ns_type': 'landing',
                          'navigationPage': 'Landing',
                        });
                        Provider.of<LandingViewModel>(context, listen: false)
                            .isURLCome = true;
                        //ignore: lines_longer_than_80_chars
                        PageNavigator.goToPermanent(context, router.rt_Landing,
                            arguments:
                                LandingArguments(url: widget.bundle ?? null));
                      } else {
                        fbaLog(eveParams: {
                          'eventTime': '${DateTime.now()}',
                          'ns_type': 'landing',
                          'navigationPage': 'Landing',
                        });
                        PageNavigator.goToPermanent(context, router.rt_Landing);
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
                          fbaLog(eveParams: {
                            'eventTime': '${DateTime.now()}',
                            'ns_type': 'dashboard',
                            'navigationPage': 'Dashboard',
                          });
                          PageNavigator.goToPermanent(
                              context, router.rt_Landing);
                        });
                      });
                    }
                  } else {
                    //PageNavigator.goToPermanent(context, router.rt_WebCognito);
                    // Navigator.push(
                    //     context,
                    //     MaterialPageRoute(
                    //         builder: (context) => PatientSignInScreen()));
                    fbaLog(eveParams: {
                      'eventTime': '${DateTime.now()}',
                      'ns_type': 'sign_in',
                      'navigationPage': 'Login Page',
                    });
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
