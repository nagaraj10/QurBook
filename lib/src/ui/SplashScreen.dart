import 'dart:io';

import 'package:app_settings/app_settings.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:local_auth/error_codes.dart' as auth_error;
import 'package:provider/provider.dart';

import '../../authentication/view/login_screen.dart';
import '../../caregiverAssosication/caregiverAPIProvider.dart';
import '../../chat_socket/view/ChatDetail.dart';
import '../../chat_socket/view/ChatUserList.dart';
import '../../chat_socket/viewModel/chat_socket_view_model.dart';
import '../../claim/screen/ClaimRecordDisplay.dart';
import '../../common/CommonUtil.dart';
import '../../common/PreferenceUtil.dart';
import '../../common/firebase_analytics_qurbook/firebase_analytics_qurbook.dart';
import '../../constants/fhb_constants.dart';
import '../../constants/fhb_constants.dart' as Constants;
import '../../constants/fhb_parameters.dart' as parameters;
import '../../constants/fhb_parameters.dart';
import '../../constants/router_variable.dart';
import '../../constants/router_variable.dart' as router;
import '../../constants/variable_constant.dart' as variable;
import '../../constants/variable_constant.dart';
import '../../landing/view/landing_arguments.dart';
import '../../landing/view_model/landing_view_model.dart';
import '../../myPlan/view/myPlanDetail.dart';
import '../../my_family_detail/models/my_family_detail_arguments.dart';
import '../../regiment/models/regiment_arguments.dart';
import '../../regiment/view/manage_activities/manage_activities_screen.dart';
import '../../regiment/view_model/regiment_view_model.dart';
import '../../services/pushnotification_service.dart';
import '../../telehealth/features/MyProvider/view/BookingConfirmation.dart';
import '../../telehealth/features/MyProvider/view/TelehealthProviders.dart';
import '../../telehealth/features/Notifications/services/notification_services.dart';
import '../../telehealth/features/appointments/controller/AppointmentDetailsController.dart';
import '../../telehealth/features/appointments/model/fetchAppointments/city.dart';
import '../../telehealth/features/appointments/model/fetchAppointments/doctor.dart'
    as doc;
import '../../telehealth/features/appointments/model/fetchAppointments/past.dart';
import '../../telehealth/features/appointments/view/AppointmentDetailScreen.dart';
import '../../telehealth/features/appointments/view/resheduleMain.dart';
import '../../ticket_support/view/detail_ticket_view_screen.dart';
import '../../voice_cloning/model/voice_clone_status_arguments.dart';
import '../../widgets/checkout_page.dart';
import '../model/GetDeviceSelectionModel.dart';
import '../model/home_screen_arguments.dart';
import '../model/user/user_accounts_arguments.dart';
import '../resources/repository/health/HealthReportListForUserRepository.dart';
import '../utils/PageNavigator.dart';
import '../utils/screenutils/size_extensions.dart';
import '../utils/timezone/timezone_services.dart';
import 'NetworkScreen.dart';
import 'SheelaAI/Models/sheela_arguments.dart';
import 'SheelaAI/Views/SuperMaya.dart';
import 'settings/CaregiverSettng.dart';

class SplashScreen extends StatefulWidget {
  final String? nsRoute;
  final String? bookingID;
  final String? doctorID;
  final String? appointmentDate;
  final String? doctorSessionId;
  final String? healthOrganizationId;
  final String? templateName;
  final dynamic bundle;
  final bool isFromCallScreen;

  SplashScreen(
      {this.nsRoute,
      this.bookingID,
      this.doctorID,
      this.appointmentDate,
      this.doctorSessionId,
      this.healthOrganizationId,
      this.templateName,
      this.bundle,
      this.isFromCallScreen = false});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with WidgetsBindingObserver {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  HealthReportListForUserRepository healthReportListForUserRepository =
      HealthReportListForUserRepository();
  GetDeviceSelectionModel? selectionResult;
  bool _loaded = false;
  bool _isSettingsOpen = false;
  bool _biometricNotEntrolled = false;

  @override
  void initState() {
    super.initState();
    FABService.trackCurrentScreen(FBAAppLaunch);
    PreferenceUtil.init();
    WidgetsBinding.instance.addObserver(this);
    CommonUtil().ListenForTokenUpdate();
    Provider.of<ChatSocketViewModel>(Get.context!).initSocket();
    CommonUtil().OnInitAction();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (Platform.isIOS) {
        // Get the iOS push kit Token
        variable.reponseToTriggerPushKitTokenMethodChannel
            .setMethodCallHandler((call) async {
          if (call.method == variable.pushKitTokenMethod) {
            final data = Map<String, dynamic>.from(call.arguments);
            await PreferenceUtil.saveString(
                Constants.KEY_PUSH_KIT_TOKEN, data[isTokenStr]);
          }
        });
        if (widget.isFromCallScreen) {
          // It comes from callscreen on iOS after clicking the cancel call button
          callAppLockFeatureMethod(false);
        } else {
          variable.reponseToTriggerAppLockMethodChannel
              .setMethodCallHandler((call) async {
            if (call.method == variable.callAppLockFeatureMethod) {
              final data = Map<String, dynamic>.from(call.arguments);
              callAppLockFeatureMethod(data[isCallRecieved]);
            }
          });
        }
      } else {
        callAppLockFeatureMethod(
            widget.nsRoute != null && widget.nsRoute == call ? true : false);
      }
    });
  }

  callAppLockFeatureMethod(bool isCallRecieved) async {
    try {
      if (!isCallRecieved) {
        // No call notification is received so call security types code
        String authToken = PreferenceUtil.getStringValue(
            Constants.KEY_AUTHTOKEN)!; // To check whether it's logged in or not
        if (PreferenceUtil.getEnableAppLock() && authToken != null) {
          _loaded = await CommonUtil().checkAppLock(
              useErrorDialogs: false,
              authErrorCallback: (e) {
                _biometricNotEntrolled = e == auth_error.notEnrolled ||
                    e == auth_error.passcodeNotSet;
              });
          if (_loaded) {
            setState(() {});
            if (Platform.isIOS) {
              reponseToRemoteNotificationMethodChannel.invokeListMethod(
                IsAppLockChecked,
                {'status': _loaded},
              );
            }
          } else {
            _biometricNotEntrolled
                ? _showAuthenticationError()
                : _showMyDialog();
          }
        } else {
          if (Platform.isIOS) {
            PreferenceUtil.setCallNotificationRecieved(isCalled: false);
            reponseToRemoteNotificationMethodChannel.invokeListMethod(
              IsAppLockChecked,
              {'status': true},
            );
          }
          setState(() {
            _loaded = true;
          });
        }
      } else {
        // Recieved from call notification so don't call security types code
        if (Platform.isIOS) {
          PreferenceUtil.setCallNotificationRecieved(isCalled: true);
          reponseToRemoteNotificationMethodChannel.invokeListMethod(
            IsAppLockChecked,
            {'status': true},
          );
        }
        setState(() {
          _loaded = true;
        });
      }
    } catch (e, stackTrace) {
      CommonUtil().appLogs(message: e, stackTrace: stackTrace);

      if (kDebugMode) print(e.toString());
    }
  }

  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return WillPopScope(
            onWillPop: () async {
              Navigator.pop(context);
              Navigator.pop(context);
              return true;
            },
            child: AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20.0))),
              content: SingleChildScrollView(
                child: ListBody(
                  children: <Widget>[
                    SizedBox(
                      height: 10,
                    ),
                    Image.asset(
                      variable.lock_icon,
                      height: 20,
                      width: 20,
                      color: Color(0xff5f059b),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      variable.strQurbookLocked,
                      style:
                          TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      variable.strQurbookLockDescription,
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextButton(
                      child: Text(
                        variable.strUnlock,
                        style: TextStyle(
                          color: Color(0xff2a08c0),
                        ),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                        callAppLockFeatureMethod(false);
                      },
                    ),
                  ],
                ),
              ),
            ));
      },
    );
  }

  Future<void> _showAuthenticationError() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return WillPopScope(
            onWillPop: () async {
              return false;
            },
            child: AlertDialog(
                insetPadding: EdgeInsets.symmetric(horizontal: 20),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20.0))),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    Image.asset(
                      variable.warning_icon,
                      height: 30,
                      width: 30,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      variable.strAuthenticationError,
                      style: TextStyle(
                          fontSize: 22,
                          //      color: Colors.red,
                          fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      child: Divider(
                        height: 2,
                        thickness: 1.3,
                      ),
                    ),
                    RichText(
                      textAlign: TextAlign.start,
                      text: TextSpan(
                        style: TextStyle(
                            fontSize: 14,
                            height: 1.6,
                            color: Colors.black,
                            fontWeight: FontWeight.w400),
                        children: [
                          TextSpan(
                            text: '${variable.strPleaseGoTo} ',
                            style: TextStyle(fontSize: 16.0),
                          ),
                          TextSpan(
                              text: variable.strSettings,
                              style: TextStyle(
                                  fontSize: 16.0,
                                  color: Colors.blue,
                                  decoration: TextDecoration.underline),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  AppSettings.openLockAndPasswordSettings();
                                  _isSettingsOpen = true;
                                  Navigator.of(context).pop();
                                }),
                          TextSpan(
                            text: ' ${variable.strErrorAuthDescription}',
                            style: TextStyle(fontSize: 16.0),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    TextButton(
                      child: Text(
                        variable.strLogin,
                        style: TextStyle(
                          color: Color(CommonUtil().getMyPrimaryColor()),
                        ),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                        moveToLoginPage();
                      },
                    ),
                  ],
                )));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<ConnectivityResult>(
        future: Connectivity().checkConnectivity(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done && _loaded) {
            if (snapshot.hasData &&
                (snapshot.data == ConnectivityResult.mobile ||
                    snapshot.data == ConnectivityResult.wifi)) {
              var isFirstTime =
                  PreferenceUtil.isKeyValid(Constants.KEY_INTRO_SLIDER);
              var deviceIfo =
                  PreferenceUtil.isKeyValid(Constants.KEY_DEVICEINFO);
              PreferenceUtil.saveString(Constants.KEY_FAMILYMEMBERID, '');
              String? authToken =
                  PreferenceUtil.getStringValue(Constants.KEY_AUTHTOKEN);

              Future.delayed(const Duration(seconds: 3), () {
                PushNotificationService().readInitialMessage();
                if (!isFirstTime) {
                  PreferenceUtil.saveString(
                      Constants.KEY_INTRO_SLIDER, variable.strtrue);
                }
                // if (!isFirstTime) {
                //   PreferenceUtil.saveString(
                //       Constants.KEY_INTRO_SLIDER, variable.strtrue);
                //   Navigator.pushAndRemoveUntil(
                //       context,
                //       MaterialPageRoute(
                //           builder: (BuildContext context) =>
                //               PatientSignInScreen()),
                //       (route) => false);
                //
                //   // PageNavigator.goToPermanent(context, router.rt_WebCognito);
                // } else {
                if (authToken != null) {
                  if (deviceIfo) {
                    FirebaseMessaging _firebaseMessaging =
                        FirebaseMessaging.instance;

                    _firebaseMessaging.getToken().then((token) {
                      TimezoneServices().checkUpdateTimezone();
                      CommonUtil()
                          .sendDeviceToken(
                              PreferenceUtil.getStringValue(
                                  Constants.KEY_USERID),
                              PreferenceUtil.getStringValue(
                                  Constants.KEY_EMAIL),
                              PreferenceUtil.getStringValue(Constants.MOB_NUM),
                              token,
                              true)
                          .then((value) {});
                    });
                    if (widget.nsRoute == 'DoctorRescheduling') {
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
                    } else if (widget.nsRoute == 'vcApproveByProvider' ||
                        widget.nsRoute == 'vcDeclineByProvider') {
                      Get.toNamed(
                        rt_VoiceCloningStatus,
                        arguments:
                            const VoiceCloneStatusArguments(fromMenu: true),
                      )?.then((value) => PageNavigator.goToPermanent(
                          context, router.rt_Landing));
                    } else if (widget.nsRoute == 'DoctorCancellation') {
                      //cancel appointments route

                      Get.to(TelehealthProviders(
                        arguments: HomeScreenArguments(
                            selectedIndex: 0,
                            dialogType: 'CANCEL',
                            isCancelDialogShouldShow: true,
                            bookingId: widget.bookingID,
                            date: widget.appointmentDate,
                            templateName: widget.templateName),
                      ))!
                          .then((value) => PageNavigator.goToPermanent(
                              context, router.rt_Landing));
                    } else if (widget.nsRoute ==
                        parameters.doctorCancellation) {
                      Get.toNamed(rt_notification_main);
                    } else if (widget.nsRoute == 'chat') {
                      if (widget.bundle != null && widget.bundle != '') {
                        var chatParsedData = widget.bundle?.split('&');
                        Get.to(() => ChatDetail(
                                  peerId: chatParsedData[2],
                                  peerName: chatParsedData[3],
                                  peerAvatar: chatParsedData[4],
                                  groupId: chatParsedData[5],
                                  patientId: '',
                                  patientName: '',
                                  patientPicture: '',
                                  isFromVideoCall: false,
                                  isCareGiver: false,
                                ))!
                            .then((value) => PageNavigator.goToPermanent(
                                context, router.rt_Landing));
                        ;
                      } else {
                        Get.to(ChatUserList())!.then((value) =>
                            PageNavigator.goToPermanent(
                                context, router.rt_Landing));
                      }
                    } else if (widget.nsRoute == 'appointmentList' ||
                        widget.nsRoute == 'appointmentHistory') {
                      //cancel appointments route
                      Get.to(TelehealthProviders(
                        arguments: HomeScreenArguments(
                            selectedIndex: 0,
                            bookingId: widget.bookingID,
                            date: widget.appointmentDate,
                            templateName: widget.templateName),
                      ))!
                          .then((value) => PageNavigator.goToPermanent(
                              context, router.rt_Landing));
                    } else if (widget.nsRoute == 'sheela') {
                      if (widget.bundle != null && widget.bundle.isNotEmpty) {
                        var rawTitle;
                        var rawBody;
                        String? eventType = "";
                        String? others = "";
                        var notificationListId;
                        final parsedData = widget.bundle?.split('|');

                        if (parsedData.length == 1) {
                          rawTitle = parsedData[0];
                        } else if (parsedData.length == 2) {
                          rawTitle = parsedData[0];
                          rawBody = parsedData[1];
                        } else if (parsedData.length == 3) {
                          rawTitle = parsedData[0];
                          rawBody = parsedData[1];
                          notificationListId = parsedData[2] ?? '';
                        } else if (parsedData.length == 5) {
                          eventType = parsedData[0];
                          others = parsedData[1];
                          rawBody = parsedData[3];
                        }

                        if (notificationListId != null &&
                            notificationListId != '') {
                          FetchNotificationService()
                              .inAppUnreadAction(notificationListId);
                        }

                        if (rawTitle != null &&
                            rawTitle != "" &&
                            rawTitle != "null") {
                          Get.toNamed(
                            rt_Sheela,
                            arguments: SheelaArgument(
                              allowBackBtnPress: true,
                              isSheelaAskForLang: true,
                              textSpeechSheela: rawTitle,
                            ),
                          )!
                              .then((value) => PageNavigator.goToPermanent(
                                  context, router.rt_Landing));
                        } else {
                          Get.toNamed(
                            rt_Sheela,
                            arguments: SheelaArgument(
                              isSheelaAskForLang: true,
                              rawMessage: rawBody,
                              eventType: eventType,
                              others: others,
                            ),
                          )!
                              .then((value) => PageNavigator.goToPermanent(
                                  context, router.rt_Landing));
                        }
                      } else {
                        Get.to(SuperMaya())!.then((value) =>
                            PageNavigator.goToPermanent(
                                context, router.rt_Landing));
                      }
                    } else if (widget.nsRoute == 'isSheelaFollowup') {
                      final temp = widget.bundle.split('|');
                      if (temp != null) {
                        if (temp[0] == 'isSheelaFollowup' &&
                            temp[1].toString() == 'audio') {
                          Get.toNamed(
                            router.rt_Sheela,
                            arguments: SheelaArgument(
                                audioMessage: temp[2].toString(),
                                allowBackBtnPress: true),
                          )!
                              .then((value) => PageNavigator.goToPermanent(
                                  context, router.rt_Landing));
                        } else {
                          Get.toNamed(
                            rt_Sheela,
                            arguments: SheelaArgument(
                                isSheelaFollowup: true,
                                isNeedPreferredLangauge: true,
                                textSpeechSheela: temp[1]),
                          )?.then((value) {
                            PageNavigator.goToPermanent(
                                context, router.rt_Landing);
                          });
                        }
                      }
                    } else if (widget.nsRoute ==
                        'familyMemberCaregiverRequest') {
                      final temp = widget.bundle.split('|');
                      if (temp[0] == 'accept') {
                        CaregiverAPIProvider().approveCareGiver(
                          phoneNumber: temp[1],
                          code: temp[2],
                        );
                      } else {
                        CaregiverAPIProvider().rejectCareGiver(
                          receiver: temp[3],
                          requestor: temp[4],
                        );
                      }
                      PageNavigator.goToPermanent(context, router.rt_Landing);
                    } else if (widget.nsRoute ==
                        'escalateToCareCoordinatorToRegimen') {
                      final temp = widget.bundle.split('|');
                      final userId = PreferenceUtil.getStringValue(KEY_USERID);
                      if (temp[5] == userId) {
                        CommonUtil().escalateNonAdherance(
                            temp[0],
                            temp[1],
                            temp[2],
                            temp[3],
                            temp[4],
                            temp[5],
                            temp[6],
                            temp[7]);
                        Get.toNamed(rt_Regimen);
                      } else {
                        CommonUtil.showFamilyMemberPlanExpiryDialog(
                          temp[1],
                          redirect: "caregiver",
                        );
                      }
                    } else if (widget.nsRoute == 'appointmentPayment') {
                      var passedValArr = widget.bundle?.split('&');
                      var body = {};
                      body['templateName'] =
                          parameters.strCaregiverAppointmentPayment;
                      body['contextId'] = passedValArr[2];
                      FetchNotificationService()
                          .updateNsActionStatus(body)
                          .then((data) {
                        FetchNotificationService().updateNsOnTapAction(body);
                      });

                      Get.to(BookingConfirmation(
                          isFromPaymentNotification: true,
                          appointmentId: passedValArr[1] ?? ""));
                    } else if (widget.nsRoute ==
                        'qurbookServiceRequestStatusUpdate') {
                      var passedValArr = widget.bundle?.split('&');

                      Get.to(DetailedTicketView(null, true, passedValArr[0]));
                    } else if (widget.nsRoute ==
                        'notifyPatientServiceTicketByCC') {
                      var passedValArr = widget.bundle?.split('&');

                      Get.to(DetailedTicketView(null, true, passedValArr[0]));
                    } else if (widget.nsRoute == 'profile_page' ||
                        widget.nsRoute == 'profile') {
                      Get.toNamed(router.rt_UserAccounts,
                              arguments:
                                  UserAccountsArguments(selectedIndex: 0))!
                          .then((value) => PageNavigator.goToPermanent(
                              context, router.rt_Landing));
                    } else if (widget.nsRoute == 'googlefit') {
                      Get.toNamed(router.rt_AppSettings)!.then((value) =>
                          PageNavigator.goToPermanent(
                              context, router.rt_Landing));
                    } else if (widget.nsRoute == 'th_provider' ||
                        widget.nsRoute == 'provider') {
                      Get.toNamed(router.rt_TelehealthProvider,
                              arguments: HomeScreenArguments(selectedIndex: 1))!
                          .then((value) => PageNavigator.goToPermanent(
                              context, router.rt_Landing));
                    } else if (widget.nsRoute == 'my_record' ||
                        widget.nsRoute == 'prescription_list' ||
                        widget.nsRoute == 'add_doc') {
                      getProfileData();
                      Get.toNamed(router.rt_HomeScreen,
                              arguments: HomeScreenArguments(selectedIndex: 1))!
                          .then((value) => PageNavigator.goToPermanent(
                              context, router.rt_Landing));
                    } else if (widget.nsRoute == 'myRecords' &&
                        (widget.templateName != null &&
                            widget.templateName != '')) {
                      final temp = widget.templateName!.split('|');
                      final dataOne = temp[1];
                      final dataTwo = temp[2];
                      if (dataTwo.runtimeType == String &&
                          (dataTwo).isNotEmpty) {
                        final userId =
                            PreferenceUtil.getStringValue(KEY_USERID);
                        if ((widget.bundle ?? '') == userId) {
                          CommonUtil().navigateToRecordDetailsScreen(dataTwo);
                        } else {
                          CommonUtil.showFamilyMemberPlanExpiryDialog(
                            widget.bundle ?? '',
                            redirect: temp[0],
                          );
                        }
                      } else {
                        if (widget.bundle != null && widget.bundle != '') {
                          CommonUtil().navigateToMyRecordsCategory(
                              temp[1], [widget.bundle], true);
                        } else {
                          CommonUtil()
                              .navigateToMyRecordsCategory(temp[1], null, true);
                        }
                      }
                    } else if (widget.nsRoute ==
                            'notifyCaregiverForMedicalRecord' &&
                        (widget.templateName != null &&
                            widget.templateName != '')) {
                      final passedValArr = widget.bundle.split('|');
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ChatDetail(
                                  peerId: passedValArr[0],
                                  peerAvatar: passedValArr[6],
                                  peerName: passedValArr[1],
                                  patientId: '',
                                  patientName: '',
                                  patientPicture: '',
                                  isFromVideoCall: false,
                                  isFromFamilyListChat: true,
                                  isFromCareCoordinator: passedValArr[5]
                                          .toString()
                                          .toLowerCase() ==
                                      'true',
                                  carecoordinatorId: passedValArr[2],
                                  isCareGiver: passedValArr[3]
                                          .toString()
                                          .toLowerCase() ==
                                      'true',
                                  groupId: '',
                                  lastDate: passedValArr[4]))).then((value) {});
                    } else if (widget.nsRoute == 'regiment_screen') {
                      var passedValArr = widget.bundle?.split('&');
                      if ((CommonUtil.isUSRegion()) &&
                          (passedValArr[3] != null) &&
                          (passedValArr[3] != 'null') &&
                          (passedValArr[4] != null) &&
                          (passedValArr[4] != 'null')) {
                        var qurhomeDashboardController =
                            CommonUtil().onInitQurhomeDashboardController();
                        qurhomeDashboardController.eventId.value =
                            passedValArr[2];
                        qurhomeDashboardController.estart.value =
                            passedValArr[3];
                        if (passedValArr[4] == Constants.doseValueless ||
                            passedValArr[4] == Constants.doseValueHigh) {
                          qurhomeDashboardController
                              .isOnceInAPlanActivity.value = true;
                        } else {
                          qurhomeDashboardController
                              .isOnceInAPlanActivity.value = false;
                        }
                        qurhomeDashboardController.updateTabIndex(0);
                        PageNavigator.goToPermanent(context, router.rt_Landing);
                      } else {
                        Provider.of<RegimentViewModel>(
                          context,
                          listen: false,
                        ).regimentMode = RegimentMode.Schedule;
                        Provider.of<RegimentViewModel>(context, listen: false)
                            .regimentFilter = RegimentFilter.Missed;
                        PageNavigator.goToPermanent(context, router.rt_Regimen,
                            arguments:
                                RegimentArguments(eventId: passedValArr[2]));
                      }
                    } else if (widget.nsRoute == 'th_provider_hospital') {
                      Get.toNamed(router.rt_TelehealthProvider,
                              arguments: HomeScreenArguments(
                                  selectedIndex: 1, thTabIndex: 1))!
                          .then((value) => PageNavigator.goToPermanent(
                              context, router.rt_Landing));
                    } else if (widget.nsRoute == 'myfamily_list' ||
                        widget.nsRoute == 'profile_my_family') {
                      Get.toNamed(router.rt_UserAccounts,
                              arguments:
                                  UserAccountsArguments(selectedIndex: 1))!
                          .then((value) => PageNavigator.goToPermanent(
                              context, router.rt_Landing));
                    } else if (widget.nsRoute == 'myprovider_list') {
                      Get.toNamed(router.rt_UserAccounts,
                              arguments:
                                  UserAccountsArguments(selectedIndex: 2))!
                          .then((value) => PageNavigator.goToPermanent(
                              context, router.rt_Landing));
                    } else if (CommonUtil.isUSRegion() &&
                        widget.nsRoute == strPatientReferralAcceptToPatient) {
                      Get.toNamed(router.rt_UserAccounts,
                              arguments:
                                  UserAccountsArguments(selectedIndex: 2))
                          ?.then((value) => PageNavigator.goToPermanent(
                              context, router.rt_Landing));
                    } else if (widget.nsRoute == 'myplans') {
                      Get.toNamed(router.rt_UserAccounts,
                              arguments:
                                  UserAccountsArguments(selectedIndex: 3))!
                          .then((value) => PageNavigator.goToPermanent(
                              context, router.rt_Landing));
                    } else if (widget.nsRoute == 'devices_tab') {
                      Get.toNamed(
                        router.rt_HomeScreen,
                        arguments: HomeScreenArguments(
                            selectedIndex: 1, thTabIndex: 1),
                      )!
                          .then((value) => PageNavigator.goToPermanent(
                              context, router.rt_Landing));
                    } else if (widget.nsRoute == 'bills') {
                      Get.toNamed(
                        router.rt_HomeScreen,
                        arguments: HomeScreenArguments(
                            selectedIndex: 1, thTabIndex: 4),
                      )!
                          .then((value) => PageNavigator.goToPermanent(
                              context, router.rt_Landing));
                    } else if (widget.nsRoute == 'openurl') {
                      Provider.of<LandingViewModel>(context, listen: false)
                          .isURLCome = true;
                      PageNavigator.goToPermanent(context, router.rt_Landing,
                          arguments:
                              LandingArguments(url: widget.bundle ?? null));
                    } else if (widget.nsRoute == 'mycart') {
                      var passedValArr = widget.bundle?.split('&');

                      var body = {};
                      body['templateName'] =
                          parameters.strCaregiverNotifyPlanSubscription;
                      body['contextId'] = passedValArr[4];
                      FetchNotificationService()
                          .updateNsActionStatus(body)
                          .then((data) {
                        FetchNotificationService().updateNsOnTapAction(body);
                      });
                      Get.to(CheckoutPage(
                        isFromNotification: true,
                        cartUserId: passedValArr[2],
                        bookingId: passedValArr[4],
                        notificationListId: passedValArr[3],
                        cartId: passedValArr[4],
                        patientName: passedValArr[6],
                      ))!
                          .then((value) => PageNavigator.goToPermanent(
                              context, router.rt_Landing));
                    } else if (widget.nsRoute == "familyProfile") {
                      var passedValArr = widget.bundle?.split('&');

                      CommonUtil()
                          .getDetailsOfAddedFamilyMember(
                              Get.context!, passedValArr[2].toString())
                          .then((value) {
                        try {
                          if (!value!.isSuccess! || value == null) {
                            PageNavigator.goToPermanent(
                                context, router.rt_Landing);
                          }
                        } catch (e, stackTrace) {
                          CommonUtil()
                              .appLogs(message: e, stackTrace: stackTrace);

                          PageNavigator.goToPermanent(
                              context, router.rt_Landing);
                        }
                      });
                    } else if (widget.nsRoute == 'Renew' ||
                        widget.nsRoute == 'Callback' ||
                        widget.nsRoute == 'myplandetails') {
                      final planid = widget.bundle['planid'];
                      final template = widget.bundle['template'];
                      final userId = widget.bundle['userId'];
                      final patName = widget.bundle['patName'];
                      if (widget.nsRoute == 'Renew' ||
                          widget.nsRoute == 'myplandetails') {
                        final currentUserId =
                            PreferenceUtil.getStringValue(KEY_USERID);
                        if (currentUserId == userId) {
                          Get.to(
                            MyPlanDetail(
                              packageId: planid,
                              showRenew: widget.nsRoute != 'myplandetails',
                              templateName: template,
                            ),
                          )!
                              .then((value) => PageNavigator.goToPermanent(
                                  context, router.rt_Landing));
                        } else {
                          CommonUtil.showFamilyMemberPlanExpiryDialog(patName,
                              redirect: widget.nsRoute);
                        }
                      } else {
                        //TODO if its Callback just show the message alone
                        PageNavigator.goToPermanent(context, router.rt_Landing);
                        CommonUtil().CallbackAPI(
                          patName,
                          planid,
                          userId,
                        );
                      }
                      var body = {};
                      body['templateName'] = template;
                      body['contextId'] = planid;
                      FetchNotificationService()
                          .updateNsActionStatus(body)
                          .then((data) {
                        FetchNotificationService().updateNsOnTapAction(body);
                      });
                    } else if (widget.nsRoute == 'careGiverMemberProfile') {
                      Navigator.pushNamed(
                        context,
                        router.rt_FamilyDetailScreen,
                        arguments: MyFamilyDetailArguments(
                            caregiverRequestor: widget.bundle),
                      );
                    } else if (widget.nsRoute == 'communicationSetting') {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CareGiverSettings(),
                        ),
                      ).then((value) {});
                    } else if (widget.nsRoute == 'claimList') {
                      final claimId = widget.bundle['claimId'];
                      Get.to(
                        ClaimRecordDisplay(
                          claimID: claimId,
                        ),
                      )!
                          .then((value) => PageNavigator.goToPermanent(
                              context, router.rt_Landing));
                    } else if (widget.nsRoute == 'manageActivities') {
                      Get.to(ManageActivitiesScreen())!.then((value) =>
                          PageNavigator.goToPermanent(
                              context, router.rt_Landing));
                    } else if (widget.nsRoute == strAppointmentDetail) {
                      var passedValArr = widget.bundle?.split('&');

                      if (passedValArr[2] != null) {
                        try {
                          if (passedValArr[3] != null) {
                            CommonUtil()
                                .acceptCareGiverTransportRequestReminder(
                                    context,
                                    passedValArr[2],
                                    passedValArr[3],
                                    passedValArr[4]
                                        .toString()
                                        .contains("accept"));
                          } else {
                            AppointmentDetailsController
                                appointmentDetailsController = CommonUtil()
                                    .onInitAppointmentDetailsController();
                            appointmentDetailsController
                                .getAppointmentDetail(passedValArr[2]);
                            Get.to(() => AppointmentDetailScreen())!.then(
                                (value) => PageNavigator.goToPermanent(
                                    context, router.rt_Landing));
                          }
                        } catch (e, stackTrace) {
                          CommonUtil()
                              .appLogs(message: e, stackTrace: stackTrace);

                          AppointmentDetailsController
                              appointmentDetailsController =
                              CommonUtil().onInitAppointmentDetailsController();
                          appointmentDetailsController
                              .getAppointmentDetail(passedValArr[2]);
                          Get.to(() => AppointmentDetailScreen())!.then(
                              (value) => PageNavigator.goToPermanent(
                                  context, router.rt_Landing));
                        }
                      }
                    } else if (widget.nsRoute == call) {
                      CommonUtil().startTheCall(widget.bundle);
                    } else if (widget.nsRoute == strConnectedDevicesScreen) {
                      CommonUtil()
                          .navigateToHubList(context, fromNotification: false);
                    } else if (widget.nsRoute ==
                        Constants.strVoiceClonePatientAssignment) {
                      // Handling logic for Voice Clone Patient Assignment route
                      var passedValArr = widget.bundle?.split('&');

                      // Extract Voice Clone ID and check for acceptance in the passed values
                      CommonUtil().saveVoiceClonePatientAssignmentStatus(
                          passedValArr[1],
                          passedValArr[2]
                              .toString()
                              .contains(accept.toLowerCase()));

                      // Navigate to the permanent landing page after processing the Voice Clone Patient Assignment
                      PageNavigator.goToPermanent(context, router.rt_Landing);
                    } else {
                      PageNavigator.goToPermanent(context, router.rt_Landing);
                    }
                  } else {
                    FirebaseMessaging _firebaseMessaging =
                        FirebaseMessaging.instance;

                    _firebaseMessaging.getToken().then((token) {
                      CommonUtil()
                          .sendDeviceToken(
                              PreferenceUtil.getStringValue(
                                  Constants.KEY_USERID),
                              PreferenceUtil.getStringValue(
                                  Constants.KEY_EMAIL),
                              PreferenceUtil.getStringValue(Constants.MOB_NUM),
                              token,
                              true)
                          .then((value) {
                        PageNavigator.goToPermanent(context, router.rt_Landing);
                      });
                    });
                  }
                } else {
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) =>
                              PatientSignInScreen()),
                      (route) => false);
                }
                // }
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

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      String? authToken =
          PreferenceUtil.getStringValue(Constants.KEY_AUTHTOKEN);

      /// Added Lifecycle because not possible to receive the callback  from os so handled manually.
      if (PreferenceUtil.getEnableAppLock() &&
          authToken != null &&
          _isSettingsOpen) {
        _isSettingsOpen = false;
        callAppLockFeatureMethod(false);
      }
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance?.removeObserver(this);
    super.dispose();
  }

  void getProfileData() async {
    try {
      await CommonUtil().getUserProfileData();
    } catch (e, stackTrace) {
      CommonUtil().appLogs(message: e, stackTrace: stackTrace);
    }
  }

  void moveToLoginPage() async {
    /// Removing the preferences and navigating to Login
    await PreferenceUtil.clearAllData();
    Navigator.pushAndRemoveUntil(
      Get.context!,
      MaterialPageRoute(
        builder: (context) => PatientSignInScreen(),
      ),
      (route) => false,
    );
  }
}
