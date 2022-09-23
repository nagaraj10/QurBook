import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:myfhb/authentication/view/login_screen.dart';
import 'package:get/get.dart';
import 'package:myfhb/caregiverAssosication/caregiverAPIProvider.dart';
import 'package:myfhb/claim/screen/ClaimRecordDisplay.dart';
import 'package:myfhb/chat_socket/view/ChatDetail.dart';
import 'package:myfhb/chat_socket/view/ChatUserList.dart';
import 'package:myfhb/chat_socket/viewModel/chat_socket_view_model.dart';
import 'package:myfhb/common/CommonUtil.dart';
import 'package:myfhb/common/PreferenceUtil.dart';
import 'package:myfhb/constants/fhb_constants.dart' as Constants;
import 'package:myfhb/constants/fhb_constants.dart';
import 'package:myfhb/constants/router_variable.dart' as router;
import 'package:myfhb/constants/router_variable.dart';
import 'package:myfhb/constants/variable_constant.dart' as variable;
import 'package:myfhb/myPlan/view/myPlanDetail.dart';
import 'package:myfhb/my_family_detail/models/my_family_detail_arguments.dart';
import 'package:myfhb/regiment/models/regiment_arguments.dart';
import 'package:myfhb/landing/view/landing_arguments.dart';
import 'package:myfhb/landing/view_model/landing_view_model.dart';
import 'package:myfhb/regiment/view/manage_activities/manage_activities_screen.dart';
import 'package:myfhb/regiment/view_model/regiment_view_model.dart';
import 'package:myfhb/src/model/GetDeviceSelectionModel.dart';
import 'package:myfhb/src/model/home_screen_arguments.dart';
import 'package:myfhb/src/resources/repository/health/HealthReportListForUserRepository.dart';
import 'package:myfhb/src/ui/Dashboard.dart';
import 'package:myfhb/src/ui/settings/CaregiverSettng.dart';
import 'package:myfhb/telehealth/features/MyProvider/view/BookingConfirmation.dart';
import 'package:myfhb/telehealth/features/MyProvider/view/TelehealthProviders.dart';
import 'package:myfhb/telehealth/features/Notifications/services/notification_services.dart';
import 'package:myfhb/telehealth/features/Notifications/view/notification_main.dart';
import 'package:myfhb/telehealth/features/appointments/model/fetchAppointments/city.dart';
import 'package:myfhb/telehealth/features/appointments/model/fetchAppointments/doctor.dart'
    as doc;
import 'package:myfhb/src/utils/screenutils/size_extensions.dart';
import 'package:myfhb/telehealth/features/appointments/model/fetchAppointments/past.dart';
import 'package:myfhb/telehealth/features/appointments/view/resheduleMain.dart';
import 'package:myfhb/constants/fhb_parameters.dart' as parameters;
import 'package:myfhb/telehealth/features/chat/view/PDFViewerController.dart';
import 'package:myfhb/telehealth/features/chat/view/chat.dart';
import 'package:myfhb/telehealth/features/chat/view/home.dart';
import 'package:myfhb/ticket_support/view/detail_ticket_view_screen.dart';
import 'package:myfhb/widgets/checkout_page.dart';
import 'package:provider/provider.dart';
import '../utils/PageNavigator.dart';
import 'package:connectivity/connectivity.dart';
import 'NetworkScreen.dart';
import 'package:myfhb/src/model/user/user_accounts_arguments.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

import 'SheelaAI/Models/sheela_arguments.dart';
import 'SheelaAI/Views/SuperMaya.dart';

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
    CommonUtil().ListenForTokenUpdate();
    Provider.of<ChatSocketViewModel>(Get.context)?.initSocket();
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
                                ))
                            .then((value) => PageNavigator.goToPermanent(
                                context, router.rt_Landing));
                        ;
                      } else {
                        Get.to(ChatUserList()).then((value) =>
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
                        var notificationListId = widget.bundle?.split('|')[2];
                        if (notificationListId != null &&
                            notificationListId != '') {
                          FetchNotificationService()
                              .inAppUnreadAction(notificationListId);
                        }

                        Get.toNamed(
                          rt_Sheela,
                          arguments: SheelaArgument(
                            isSheelaAskForLang: true,
                            rawMessage: rawBody,
                          ),
                        ).then((value) => PageNavigator.goToPermanent(
                            context, router.rt_Landing));
                      } else {
                        Get.to(SuperMaya()).then((value) =>
                            PageNavigator.goToPermanent(
                                context, router.rt_Landing));
                      }
                    } else if (widget.nsRoute == 'isSheelaFollowup') {
                      final temp = widget.bundle.split('|');
                      Get.toNamed(
                        rt_Sheela,
                        arguments: SheelaArgument(
                          isSheelaFollowup: true,
                          message: temp[1],
                        ),
                      );
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
                              arguments: HomeScreenArguments(selectedIndex: 1))
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
                              arguments: HomeScreenArguments(selectedIndex: 1))
                          .then((value) => PageNavigator.goToPermanent(
                              context, router.rt_Landing));
                    } else if (widget.nsRoute == 'myRecords' &&
                        (widget.templateName != null &&
                            widget.templateName != '')) {
                      fbaLog(eveParams: {
                        'eventTime': '${DateTime.now()}',
                        'ns_type': 'myRecords',
                        'navigationPage': '${widget.templateName}',
                      });
                      final temp = widget.templateName.split('|');
                      final dataOne = temp[1] ?? '';
                      final dataTwo = temp[2];
                      if (dataTwo.runtimeType == String &&
                          (dataTwo ?? '').isNotEmpty) {
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
                          arguments: RegimentArguments(eventId: widget.bundle));
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
                    } else if (widget.nsRoute == 'mycart') {
                      fbaLog(eveParams: {
                        'eventTime': '${DateTime.now()}',
                        'ns_type': 'my cart',
                        'navigationPage': 'My Cart',
                      });
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
                      )).then((value) => PageNavigator.goToPermanent(
                          context, router.rt_Landing));
                    } else if (widget.nsRoute == "familyProfile") {
                      var passedValArr = widget.bundle?.split('&');

                      new CommonUtil()
                          .getDetailsOfAddedFamilyMember(
                              Get.context, passedValArr[2].toString())
                          .then((value) {
                        try {
                          if (!value?.isSuccess || value == null) {
                            PageNavigator.goToPermanent(
                                context, router.rt_Landing);
                          }
                        } catch (e) {
                          PageNavigator.goToPermanent(
                              context, router.rt_Landing);
                        }
                      });
                    } else if (widget.nsRoute == 'Renew' ||
                        widget.nsRoute == 'Callback' ||
                        widget.nsRoute == 'myplandetails') {
                      final planid = widget?.bundle['planid'];
                      final template = widget?.bundle['template'];
                      final userId = widget?.bundle['userId'];
                      final patName = widget?.bundle['patName'];
                      //TODO if its Renew take the user into plandetail view
                      if (widget.nsRoute == 'Renew' ||
                          widget.nsRoute == 'myplandetails') {
                        final currentUserId =
                            PreferenceUtil.getStringValue(KEY_USERID);
                        if (currentUserId == userId) {
                          fbaLog(eveParams: {
                            'eventTime': '${DateTime.now()}',
                            'ns_type': 'myplan_deatails',
                            'navigationPage': 'My Plan Details',
                          });
                          Get.to(
                            MyPlanDetail(
                              packageId: planid,
                              showRenew: widget.nsRoute != 'myplandetails',
                              templateName: template,
                            ),
                          ).then((value) => PageNavigator.goToPermanent(
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
                      final userId = widget?.bundle['userId'];
                      final claimId = widget?.bundle['claimId'];
                      Get.to(
                        ClaimRecordDisplay(
                          claimID: claimId,
                        ),
                      ).then((value) => PageNavigator.goToPermanent(
                          context, router.rt_Landing));
                    } else if (widget.nsRoute == 'manageActivities') {
                      fbaLog(eveParams: {
                        'eventTime': '${DateTime.now()}',
                        'ns_type': 'manageActivities',
                        'navigationPage': 'Manage Activities',
                      });
                      Get.to(ManageActivitiesScreen()).then((value) =>
                          PageNavigator.goToPermanent(
                              context, router.rt_Landing));
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
                        FirebaseMessaging.instance;

                    _firebaseMessaging.getToken().then((token) {
                      new CommonUtil()
                          .sendDeviceToken(
                              PreferenceUtil.getStringValue(
                                  Constants.KEY_USERID),
                              PreferenceUtil.getStringValue(
                                  Constants.KEY_EMAIL),
                              PreferenceUtil.getStringValue(Constants.MOB_NUM),
                              token,
                              true)
                          .then((value) {
                        fbaLog(eveParams: {
                          'eventTime': '${DateTime.now()}',
                          'ns_type': 'dashboard',
                          'navigationPage': 'Dashboard',
                        });
                        PageNavigator.goToPermanent(context, router.rt_Landing);
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

  void getProfileData() async {
    try {
      await new CommonUtil().getUserProfileData();
    } catch (e) {}
  }
}
