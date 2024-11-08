import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gmiwidgetspackage/widgets/IconWidget.dart';
import 'package:gmiwidgetspackage/widgets/SizeBoxWithChild.dart';
import 'package:gmiwidgetspackage/widgets/flutterToast.dart';
import 'package:gmiwidgetspackage/widgets/sized_box.dart';
import 'package:gmiwidgetspackage/widgets/text_widget.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:provider/provider.dart';

import '../../../../QurHub/Controller/HubListViewController.dart';
import '../../../../QurHub/View/HubListView.dart';
import '../../../../Qurhome/Common/GradientAppBarQurhome.dart';
import '../../../../Qurhome/QurhomeDashboard/Controller/QurhomeDashboardController.dart';
import '../../../../caregiverAssosication/caregiverAPIProvider.dart';
import '../../../../chat_socket/view/ChatDetail.dart';
import '../../../../claim/screen/ClaimRecordDisplay.dart';
import '../../../../common/CommonUtil.dart';
import '../../../../common/PreferenceUtil.dart';
import '../../../../common/firebase_analytics_qurbook/firebase_analytics_qurbook.dart';
import '../../../../constants/fhb_constants.dart';
import '../../../../constants/fhb_parameters.dart' as parameters;
import '../../../../constants/router_variable.dart';
import '../../../../constants/router_variable.dart' as routervariable;
import '../../../../constants/router_variable.dart' as router;
import '../../../../landing/view/landing_arguments.dart';
import '../../../../main.dart';
import '../../../../myPlan/view/myPlanDetail.dart';
import '../../../../my_family_detail/models/my_family_detail_arguments.dart';
import '../../../../regiment/models/regiment_arguments.dart';
import '../../../../regiment/view_model/regiment_view_model.dart';
import '../../../../src/model/home_screen_arguments.dart';
import '../../../../src/model/user/user_accounts_arguments.dart';
import '../../../../src/ui/MyRecord.dart';
import '../../../../src/ui/SheelaAI/Models/sheela_arguments.dart';
import '../../../../src/ui/SheelaAI/Views/SuperMaya.dart';
import '../../../../src/ui/settings/CaregiverSettng.dart';
import '../../../../src/utils/PageNavigator.dart';
import '../../../../src/utils/language/language_utils.dart';
import '../../../../src/utils/screenutils/size_extensions.dart';
import '../../../../ticket_support/view/detail_ticket_view_screen.dart';
import '../../../../voice_cloning/model/voice_clone_status_arguments.dart';
import '../../../../widgets/GradientAppBar.dart';
import '../../../../widgets/checkout_page.dart';
import '../../MyProvider/model/appointments/AppointmentNotificationPayment.dart';
import '../../MyProvider/view/BookingConfirmation.dart';
import '../../MyProvider/view/TelehealthProviders.dart';
import '../../MyProvider/viewModel/CreateAppointmentViewModel.dart';
import '../../appointments/controller/AppointmentDetailsController.dart';
import '../../appointments/model/cancelAppointments/cancelModel.dart';
import '../../appointments/model/fetchAppointments/city.dart';
import '../../appointments/model/fetchAppointments/doctor.dart' as doctorObj;
import '../../appointments/model/fetchAppointments/past.dart';
import '../../appointments/view/AppointmentDetailScreen.dart';
import '../../appointments/view/resheduleMain.dart';
import '../../appointments/viewModel/cancelAppointmentViewModel.dart';
import '../constants/notification_constants.dart' as constants;
import '../model/messageContent.dart';
import '../model/notificationResult.dart';
import '../model/notification_ontap_req.dart';
import '../model/payload.dart';
import '../services/notification_services.dart';
import '../viewModel/fetchNotificationViewModel.dart';

class NotificationScreen extends StatefulWidget {
  bool isFromQurday;

  NotificationScreen({Key? key, this.isFromQurday = false}) : super(key: key);

  @override
  _NotificationScreen createState() => _NotificationScreen();
}

class _NotificationScreen extends State<NotificationScreen> {
  FlutterToast toast = FlutterToast();
  late CancelAppointmentViewModel cancelAppointmentViewModel;
  FetchNotificationViewModel? notificationData;

  final qurhomeController = Get.put(QurhomeDashboardController());

  @override
  void initState() {
    qurhomeController.setActiveQurhomeDashboardToChat(
      status: false,
    );
    FABService.trackCurrentScreen(FBANotificationsListScreen);
    Provider.of<FetchNotificationViewModel>(context, listen: false)
        .pagingController
        .addPageRequestListener((pageKey) {
      Provider.of<FetchNotificationViewModel>(context, listen: false)
          .fetchPage(pageKey);
    });
    cancelAppointmentViewModel =
        Provider.of<CancelAppointmentViewModel>(context, listen: false);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    notificationData?.pagingController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    notificationData = Provider.of<FetchNotificationViewModel>(context);
    return WillPopScope(
        onWillPop: () => onBackPressed(context),
        child: Scaffold(
          appBar: notificationAppBar(context) as PreferredSizeWidget?,
          body: notificationBodyView(),
        ));
  }

  showDeleteAlert(BuildContext context) {
    showCupertinoDialog(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          content: Text(
            'Are you sure to delete ?',
            style: TextStyle(
              fontSize: 16,
            ),
          ),
          actions: [
            CupertinoDialogAction(
              child: Text(
                'Cancel',
                style: TextStyle(
                  color: Colors.grey,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                notificationData!.fetchNotifications();
              },
            ),
            CupertinoDialogAction(
              child: Text(
                'Delete',
                style: TextStyle(
                  color: mAppThemeProvider.primaryColor,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                notificationData!.deleteTheSelectedNotifiations();
              },
            ),
          ],
        );
      },
    );
  }

  Widget notificationAppBar(BuildContext context) {
    return AppBar(
      flexibleSpace:
          widget.isFromQurday ? GradientAppBarQurhome() : GradientAppBar(),
      leading: IconWidget(
        icon: Icons.arrow_back_ios,
        colors: Colors.white,
        size: 24.0.sp,
        onTap: () => onBackPressed(context),
      ),
      title: TextWidget(
        text: constants.lblNotifications,
        colors: Colors.white,
        overflow: TextOverflow.visible,
        fontWeight: FontWeight.w600,
        fontsize: 18.0.sp,
        softwrap: true,
      ),
      actions: [
        PopupMenuButton<String>(
          onSelected: handleClick,
          itemBuilder: (BuildContext context) {
            return {'Mark All as Read', 'Clear All'}.map((String choice) {
              return PopupMenuItem<String>(
                value: choice,
                child: Text(choice),
              );
            }).toList();
          },
        ),
      ],
    );
  }

  Future<bool> onBackPressed(BuildContext context) async {
    try {
      if (Navigator.canPop(context)) {
        Get.back();
      } else {
        Get.offAllNamed(
          router.rt_Landing,
          arguments: LandingArguments(
            needFreshLoad: false,
          ),
        );
      }
    } catch (e, stackTrace) {
      CommonUtil().appLogs(message: e, stackTrace: stackTrace);
    }
    return true;
  }

  Future<void> _showNotificationClearDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Alert',
            style: TextStyle(
                fontSize: CommonUtil().isTablet! ? tabHeader1 : mobileHeader1),
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Would you like to clear the notifications?',
                    style: CommonUtil().getDefaultStyle()),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Ok',
                  style: TextStyle(
                      fontSize:
                          CommonUtil().isTablet! ? tabHeader3 : mobileHeader3)),
              onPressed: () {
                callClearAllApi();
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Cancel',
                  style: TextStyle(
                      fontSize:
                          CommonUtil().isTablet! ? tabHeader3 : mobileHeader3)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void callClearAllApi() {
    var body = {};
    body["medium"] = "Push";
    body["clearIds"] = [];
    body["isClearAll"] = true;
    FetchNotificationService().clearNotifications(body).then((data) {
      if (data != null && data) {
        Provider.of<FetchNotificationViewModel>(context, listen: false)
          ..fetchNotifications();
      } else {
        Provider.of<FetchNotificationViewModel>(context, listen: false)
          ..fetchNotifications();
      }
    });
  }

  void handleClick(String value) {
    switch (value) {
      case 'Mark All as Read':
        NotificationOntapRequest req = NotificationOntapRequest();
        req.logIds = [];
        req.isMarkAllRead = true;
        final body = req.toJson();
        FetchNotificationService().updateNsOnTapAction(body).then((data) {
          if (data != null && data['isSuccess']) {
            Provider.of<FetchNotificationViewModel>(context, listen: false)
              ..fetchNotifications();
          } else {
            Provider.of<FetchNotificationViewModel>(context, listen: false)
              ..fetchNotifications();
          }
        });
        break;
      case 'Clear All':
        _showNotificationClearDialog();

        break;
    }
  }

  Widget notificationBodyView() {
    if (notificationData == null) {
      notificationData = Provider.of<FetchNotificationViewModel>(context);
    }
    return listView(notificationData!.pagingController.itemList);
  }

  Widget listView(List<NotificationResult>? notification) {
    return PagedListView(
      pagingController: notificationData!.pagingController,
      builderDelegate: PagedChildBuilderDelegate<NotificationResult>(
        itemBuilder: (context, item, index) =>
            notificationView(notification: item),
        noItemsFoundIndicatorBuilder: (_) => emptyNotification(),
        newPageErrorIndicatorBuilder: (_) => emptyNotification(),
        firstPageErrorIndicatorBuilder: (_) => emptyNotification(),
      ),
    );
  }

  Widget emptyNotification() {
    return Container(
      height: 1.sh,
      alignment: Alignment.center,
      child: Center(
        child: Text(
          constants.lblNoNotification,
        ),
      ),
    );
  }

  Widget notificationView({NotificationResult? notification}) {
    if (notification?.messageDetails != null) {
      Payload? payload = notification?.messageDetails?.payload;
      MessageContent message = notification!.messageDetails!.messageContent!;
      return (message.messageBody == "" || message.messageTitle == "")
          ? Container()
          : InkWell(
              onLongPress: () {},
              splashColor: Color(CommonUtil.secondaryGrey),
              onTap: notificationData!.deleteMode
                  ? () {
                      if (notification.deleteSelected) {
                        notification.deleteSelected = false;
                        notificationData!.removeTheIdToDelete(notification.id);
                      } else {
                        notification.deleteSelected = true;
                        notificationData!.addTheidToDelete(notification.id);
                      }
                    }
                  : (notification.isUnread ?? false)
                      ? () {
                          var tempRedirectTo = (payload?.redirectTo != null &&
                                  payload?.redirectTo != ''
                              ? payload?.redirectTo!.split('|')[0]
                              : '')!;
                          if (tempRedirectTo == 'myRecords') {
                            if ((payload?.healthRecordMetaIds ?? '')
                                .isNotEmpty) {
                              notificationOnTapActions(
                                  notification, tempRedirectTo,
                                  bundles: {
                                    'catName':
                                        payload?.redirectTo!.split('|')[1],
                                    'healthRecordMetaIds':
                                        payload?.healthRecordMetaIds
                                  });
                            } else {
                              final List<String> split =
                                  payload!.redirectTo!.split('|');
                              var redirectData = {
                                for (int i = 0; i < split.length; i++)
                                  i: split[i]
                              };
                              var id = redirectData[2];
                              if (id.runtimeType == String &&
                                  (id ?? '').isNotEmpty) {
                                final userId =
                                    PreferenceUtil.getStringValue(KEY_USERID);
                                if ((payload.userId ?? '') == userId) {
                                  CommonUtil()
                                      .navigateToRecordDetailsScreen(id);
                                } else {
                                  CommonUtil.showFamilyMemberPlanExpiryDialog(
                                    (payload.patientName ?? ''),
                                    redirect: (payload.redirectTo ?? ''),
                                  );
                                }
                              }
                            }
                          } else if (payload?.redirectTo ==
                              'sheela|pushMessage') {
                            notificationOnTapActions(
                              notification,
                              payload?.redirectTo,
                            );
                          } else if (payload?.redirectTo == 'mycart') {
                            notificationOnTapActions(
                              notification,
                              payload?.redirectTo,
                            );
                          } else if (payload?.redirectTo == 'familyProfile') {
                            notificationOnTapActions(
                              notification,
                              payload?.redirectTo,
                            );
                          } else if (payload?.redirectTo ==
                              'escalateToCareCoordinatorToRegimen') {
                            notificationOnTapActions(
                              notification,
                              payload?.redirectTo,
                            );
                          } else if (payload?.redirectTo ==
                              'appointmentPayment') {
                            notificationOnTapActions(
                              notification,
                              payload?.redirectTo,
                            );
                          } else if (payload?.redirectTo ==
                              parameters.strAppointmentDetail) {
                            notificationOnTapActions(
                              notification,
                              payload?.redirectTo,
                            );
                          } else if (payload?.templateName ==
                              'qurbookServiceRequestStatusUpdate') {
                            notificationOnTapActions(
                              notification,
                              payload?.templateName,
                            );
                          } else if (payload?.templateName ==
                              'notifyPatientServiceTicketByCC') {
                            notificationOnTapActions(
                              notification,
                              payload?.templateName,
                            );
                          } else if (payload?.redirectTo ==
                                  constants.strMyCardDetails ||
                              payload?.redirectTo == 'mycartdetails') {
                            // do nothing.
                          } else if (payload?.redirectTo == 'devices_tab') {
                            notificationOnTapActions(
                              notification,
                              payload?.redirectTo,
                            );
                          } else if (payload?.redirectTo == 'regiment_screen') {
                            notificationOnTapActions(
                              notification,
                              payload?.redirectTo,
                            );
                          } else if (payload?.redirectTo ==
                              parameters.myPlanDetails) {
                            notificationOnTapActions(
                              notification,
                              payload?.redirectTo,
                            );
                          } else if (payload?.redirectTo ==
                              parameters.claimList) {
                            notificationOnTapActions(
                              notification,
                              payload?.redirectTo,
                            );
                          } else if (payload?.templateName ==
                              parameters.strPatientReferralAcceptToPatient) {
                            notificationOnTapActions(
                              notification,
                              payload?.templateName,
                            );
                          } else if ([
                            parameters.strVCApproveByProvider,
                            parameters.strVCDeclineByProvider
                          ].contains(payload?.templateName)) {
                            notificationOnTapActions(
                              notification,
                              payload?.templateName,
                            );
                          } else if (payload?.redirectTo ==
                              parameters.strNotificationChat) {
                            if (payload?.templateName ==
                                parameters.strChoosePrefDate) {
                              notificationOnTapActions(
                                notification,
                                payload?.templateName,
                              );
                            } else if (payload?.templateName ==
                                parameters.strMissedCallFromCCToPatient) {
                              notificationOnTapActions(
                                notification,
                                payload?.templateName,
                              );
                            }
                          } else if (payload?.redirectTo ==
                              parameters.strConnectedDevicesScreen) {
                            notificationOnTapActions(
                              notification,
                              payload?.redirectTo,
                            );
                          } else if (payload?.templateName ==
                              strVoiceClonePatientAssignment) {
                            // Skip further processing when the payload templateName is 'voiceClonePatientAssignment'.
                            // This block is intentionally left empty ('do nothing') as no additional actions are required.
                          } else if (payload?.templateName ==
                              parameters
                                  .stringAssignOrUpdatePersonalPlanActivities) {
                            notificationOnTapActions(
                              notification,
                              payload?.templateName,
                            );
                          } else {
                            readUnreadAction(notification);
                          }
                          // notificationOnTapActions(
                          //     notification?.result[index],
                          //     notification?.result[index]?.messageDetails?.content
                          //         ?.templateName);
                        }
                      : () {
                          if (payload?.redirectTo ==
                              parameters.strAppointmentDetail) {
                            notificationOnTapActions(
                              notification,
                              payload?.redirectTo,
                            );
                          }
                        },
              child: Container(
                color: notification.deleteSelected ? Colors.grey : Colors.white,
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(top: 5, bottom: 5),
                      child: Column(
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                flex: 3,
                                child: Container(
                                  padding: EdgeInsets.only(top: 5, left: 10),
                                  width: 1.sw * 0.8,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      TextWidget(
                                        text: message.messageTitle,
                                        colors:
                                            (notification.isUnread == null ||
                                                    !notification.isUnread!)
                                                ? Colors.black
                                                : mAppThemeProvider.primaryColor,
                                        overflow: TextOverflow.visible,
                                        fontWeight: FontWeight.w600,
                                        fontsize: 15.0.sp,
                                        softwrap: true,
                                      ),
                                      SizedBox(
                                        height: 5.0.h,
                                      ),
                                      TextWidget(
                                        text: message.messageBody,
                                        colors: Color(CommonUtil.secondaryGrey),
                                        overflow: TextOverflow.visible,
                                        fontWeight: FontWeight.w500,
                                        fontsize: 14.0.sp,
                                        softwrap: true,
                                      ),
                                      SizedBox(
                                        height: 5.0.h,
                                      ),
                                      createNSActionButton(
                                          payload?.templateName, notification),
                                    ],
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: Container(
                                  padding: EdgeInsets.only(top: 5),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: <Widget>[
                                      TextWidget(
                                        text: constants.notificationDate(
                                            notification.createdOn!),
                                        colors: Colors.black,
                                        overflow: TextOverflow.visible,
                                        fontWeight: FontWeight.w500,
                                        fontsize: 12.0.sp,
                                        softwrap: true,
                                      ),
                                      SizedBox(
                                        height: 5.0.h,
                                      ),
                                      TextWidget(
                                        text: constants.notificationTime(
                                            notification.createdOn!),
                                        colors:
                                            (notification.isUnread == null ||
                                                    !notification.isUnread!)
                                                ? Colors.black
                                                : mAppThemeProvider.primaryColor,
                                        //colors: Color(CommonUtil.primaryColor),
                                        overflow: TextOverflow.visible,
                                        fontWeight: FontWeight.w600,
                                        fontsize: 12.0.sp,
                                        softwrap: true,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Container(
                      height: 0.2.h,
                      color: notification.deleteSelected
                          ? Colors.white
                          : Colors.black,
                    )
                  ],
                ),
              ),
            );
    } else {
      return Container();
    }
  }

  _displayDialog(BuildContext context, List<Past> appointments, dynamic body,
      NotificationResult notification) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            insetPadding: EdgeInsets.symmetric(horizontal: 8),
            backgroundColor: Colors.transparent,
            content: Container(
              width: double.maxFinite,
              height: 250.0.h,
              child: Column(
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4.0),
                        ),
                        child: Container(
                          height: 160.0.h,
                          padding: EdgeInsets.all(8.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              TextWidget(
                                  text: parameters
                                      .cancellationAppointmentConfirmation,
                                  fontsize: 16.0.sp,
                                  fontWeight: FontWeight.w500,
                                  colors: Colors.grey[600]),
                              SizedBoxWidget(
                                height: 10.0.h,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: <Widget>[
                                  SizedBoxWithChild(
                                    width: 90.0.w,
                                    height: 40.0.h,
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(12.0),
                                            side: BorderSide(
                                                color: mAppThemeProvider.primaryColor)),
                                        backgroundColor: Colors.transparent,
                                        foregroundColor: mAppThemeProvider.primaryColor,
                                        padding: EdgeInsets.all(8.0),
                                      ),
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: TextWidget(
                                        text: parameters.no,
                                        fontsize: 14.0.sp,
                                      ),
                                    ),
                                  ),
                                  SizedBoxWithChild(
                                    width: 90.0.w,
                                    height: 40.0.h,
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(12.0),
                                            side: BorderSide(
                                                color: mAppThemeProvider.primaryColor)),
                                        backgroundColor: Colors.transparent,
                                        foregroundColor: mAppThemeProvider.primaryColor,
                                        padding: EdgeInsets.all(8.0),
                                      ),
                                      onPressed: () {
                                        Navigator.pop(
                                            context,
                                            getCancelAppoitment(appointments,
                                                body, notification));
                                      },
                                      child: TextWidget(
                                        text: parameters.yes,
                                        fontsize: 14.0.sp,
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          );
        });
  }

  getCancelAppoitment(
      List<Past> appointments, dynamic body, NotificationResult notification) {
    cancelAppointment(appointments).then((value) {
      if (value == null) {
        toast.getToast(TranslationConstants.bookingCancel.t(), Colors.red);
      } else if (value.isSuccess == true) {
//        widget.onChanged(AppConstants.callBack);
        toast.getToast(
            TranslationConstants.yourBookingSuccess.t(), Colors.green);
        FetchNotificationService().updateNsActionStatus(body).then((data) {
          if (data != null && data['isSuccess']) {
            if (notification.isUnread != null && notification.isUnread!) {
              NotificationOntapRequest req = NotificationOntapRequest();
              req.logIds = [notification.id];
              final body = req.toJson();
              FetchNotificationService().updateNsOnTapAction(body).then((data) {
                if (data != null && data['isSuccess']) {
                  Provider.of<FetchNotificationViewModel>(context,
                      listen: false)
                    //..clearNotifications()
                    ..fetchNotifications();
                } else {
                  Provider.of<FetchNotificationViewModel>(context,
                      listen: false)
                    //..clearNotifications()
                    ..fetchNotifications();
                }
              });
            }
          } else {
            Provider.of<FetchNotificationViewModel>(context, listen: false)
              //..clearNotifications()
              ..fetchNotifications();
          }
        });
      } else {
        toast.getToast(TranslationConstants.bookingCancel.t(), Colors.red);
      }
    });
  }

  Future<CancelAppointmentModel> cancelAppointment(
      List<Past> appointments) async {
    List<String> bookingIds = [];
    List<String> dates = [];
    for (int i = 0; i < appointments.length; i++) {
      bookingIds.add(appointments[i].bookingId!);
      dates.add(appointments[i].plannedStartDateTime!);
    }
    CancelAppointmentModel? cancelAppointment = await cancelAppointmentViewModel
        .fetchCancelAppointment(bookingIds, dates);

    return cancelAppointment!;
  }

  void notificationOnTapActions(
      NotificationResult? result, String? templateName,
      {dynamic bundles}) {
    switch (templateName) {
      case "AppointmentReminder180":
      case "AppointmentReminder1440":
      case "AppointmentReminder30":
      case "AppointmentReminderPost10":
        Get.to(TelehealthProviders(
          arguments: HomeScreenArguments(
              selectedIndex: 0,
              bookingId: result?.messageDetails?.payload?.bookingId,
              date: result?.messageDetails?.payload?.appointmentDate,
              templateName: result?.messageDetails?.content?.templateName),
        ))!
            .then((value) =>
                PageNavigator.goToPermanent(context, router.rt_Landing));
        readUnreadAction(result);
        break;
      case "PaymentReceipt":
      case parameters.strQurbookServiceRequestStatusUpdate:
        Get.to(DetailedTicketView(
            null, true, result?.messageDetails?.payload?.userId));
        readUnreadAction(result);

        break;

      case parameters.strNotifyPatientServiceTicketByCC:
        Get.to(DetailedTicketView(
            null, true, result?.messageDetails?.payload?.eventId));
        readUnreadAction(result);

        break;
      case "appointmentPayment":
        break;
      case "PaymentConfirmation":
        Get.to(TelehealthProviders(
          arguments: HomeScreenArguments(
              selectedIndex: 0,
              bookingId: result?.messageDetails?.payload?.bookingId,
              date: result?.messageDetails?.payload?.appointmentDate,
              templateName: result?.messageDetails?.content?.templateName),
        ))!
            .then((value) =>
                PageNavigator.goToPermanent(context, router.rt_Landing));
        readUnreadAction(result);
        break;
      case "SlotsFull":
        Get.to(TelehealthProviders(
          arguments: HomeScreenArguments(
              selectedIndex: 0,
              bookingId: result?.messageDetails?.payload?.bookingId,
              date: result?.messageDetails?.payload?.appointmentDate,
              templateName: result?.messageDetails?.content?.templateName),
        ))!
            .then((value) =>
                PageNavigator.goToPermanent(context, router.rt_Landing));
        readUnreadAction(result);
        break;
      case "PatientPrescription":
        //* navigate user to prescription page.
        Navigator.pushNamed(
          context,
          router.rt_HomeScreen,
          arguments: HomeScreenArguments(selectedIndex: 1),
        ).then((value) {
          setState(() {});
        });
        readUnreadAction(result);
        break;
      case "escalateToCareCoordinatorToRegimen":
        final userId = PreferenceUtil.getStringValue(KEY_USERID);
        if (result?.messageDetails?.payload?.userId == userId) {
          Get.toNamed(rt_Regimen);
          readUnreadAction(result);
        } else {
          CommonUtil.showFamilyMemberPlanExpiryDialog(
            result?.messageDetails?.payload?.patientName,
            redirect: "caregiver",
          );
        }
        break;
      case "AppointmentTransactionCancelledMidway":
        readUnreadAction(result);
        break;
      case parameters.myPlanDetails:
        final userId = PreferenceUtil.getStringValue(KEY_USERID);
        if ((result?.messageDetails?.payload?.userId == userId) &&
            ((result?.messageDetails?.payload?.planId ?? '').isNotEmpty)) {
          Get.to(
            () => MyPlanDetail(
              packageId: result?.messageDetails?.payload?.planId,
              showRenew: false,
              templateName: result?.messageDetails?.payload?.templateName,
            ),
          );
        } else {
          CommonUtil.showFamilyMemberPlanExpiryDialog(
            result?.messageDetails?.payload?.patientName,
            redirect: parameters.myPlanDetails,
          );
        }
        readUnreadAction(result);
        break;
      case "sheela":
        Get.to(SuperMaya())!.then(
            (value) => PageNavigator.goToPermanent(context, router.rt_Landing));
        readUnreadAction(result);
        break;
      case "profile_page":
        Get.toNamed(router.rt_UserAccounts,
                arguments: UserAccountsArguments(selectedIndex: 0))!
            .then((value) =>
                PageNavigator.goToPermanent(context, router.rt_Landing));
        readUnreadAction(result);
        break;
      case "googlefit":
        Get.toNamed(router.rt_AppSettings)!.then(
            (value) => PageNavigator.goToPermanent(context, router.rt_Landing));
        readUnreadAction(result);
        break;
      case "th_provider":
        Get.toNamed(router.rt_TelehealthProvider,
                arguments: HomeScreenArguments(selectedIndex: 1))!
            .then((value) =>
                PageNavigator.goToPermanent(context, router.rt_Landing));
        readUnreadAction(result);
        break;
      case "my_record":
        getProfileData();
        Get.toNamed(router.rt_HomeScreen,
                arguments: HomeScreenArguments(selectedIndex: 1))!
            .then((value) =>
                PageNavigator.goToPermanent(context, router.rt_Landing));
        readUnreadAction(result);
        break;
      case "myRecords":
        var categoryName = bundles['catName'];
        String? hrmId = bundles['healthRecordMetaIds'];
        List<String?> _listOfhrmId = <String?>[];
        _listOfhrmId.add(hrmId);
        CommonUtil()
            .navigateToMyRecordsCategory(categoryName, _listOfhrmId, false);
        readUnreadAction(result);
        break;
      case "sheela|pushMessage":
        if (result!.messageDetails!.payload!.redirectTo!.contains("sheela")) {
          List<String> redirectArray =
              result.messageDetails!.payload!.redirectTo!.split("|");
          if (redirectArray.length > 1 && redirectArray[1] == "pushMessage") {
            var rawBody, rawTitle;
            rawBody = result.messageDetails?.rawMessage?.messageBody;
            rawTitle = result.messageDetails?.rawMessage?.messageTitle;

            if (rawBody != null && rawBody != '') {
              if (result.messageDetails?.payload?.isSheela ?? false) {
                Get.toNamed(
                  routervariable.rt_Sheela,
                  arguments: SheelaArgument(
                      allowBackBtnPress: true,
                      textSpeechSheela: rawBody,
                      isNeedPreferredLangauge: true),
                )!
                    .then((value) {
                  readUnreadAction(result, isRead: true);
                }); /*
                    .then((value) => PageNavigator.goToPermanent(
                        context, router.rt_Landing))*/
                ;
              } else {
                Get.toNamed(
                  routervariable.rt_Sheela,
                  arguments: SheelaArgument(
                    isSheelaAskForLang: true,
                    rawMessage: rawBody,
                  ),
                )!
                    .then((value) => PageNavigator.goToPermanent(
                        context, router.rt_Landing));
              }

              readUnreadAction(result);
            } else if (result.messageDetails?.payload?.sheelaAudioMsgUrl !=
                    null &&
                result.messageDetails?.payload?.sheelaAudioMsgUrl != '') {
              Get.toNamed(
                routervariable.rt_Sheela,
                arguments: SheelaArgument(
                    audioMessage:
                        result.messageDetails?.payload?.sheelaAudioMsgUrl,
                    allowBackBtnPress: true),
              )!
                  .then((value) {
                readUnreadAction(result, isRead: true);
              });
            }
          } else {
            Get.to(SuperMaya());
          }
        }
        break;
      case "mycart":
        /* Get.to(CheckoutPage(
          isFromNotification: true,
          bookingId: result?.messageDetails?.payload?.bookingId,
          cartUserId: result?.messageDetails?.payload?.userId,
          notificationListId: result?.messageDetails?.payload?.createdBy,
          cartId: result?.messageDetails?.payload?.bookingId,
        )).then(
            (value) => PageNavigator.goToPermanent(context, router.rt_Landing));
        readUnreadAction(result);*/
        break;

      case "familyProfile":
        break;
      case "devices_tab":
        getProfileData();
        Get.toNamed(
          router.rt_HomeScreen,
          arguments: HomeScreenArguments(selectedIndex: 1, thTabIndex: 1),
        )!
            .then(
          (value) => PageNavigator.goToPermanent(
            context,
            router.rt_Landing,
            arguments: LandingArguments(
              needFreshLoad: false,
            ),
          ),
        );
        readUnreadAction(result);
        break;
      case "regiment_screen":
        Provider.of<RegimentViewModel>(
          context,
          listen: false,
        ).regimentMode = RegimentMode.Schedule;
        Provider.of<RegimentViewModel>(context, listen: false).regimentFilter =
            RegimentFilter.Missed;
        Get.toNamed(router.rt_Regimen, arguments: RegimentArguments())
            ?.then((value) {
          readUnreadAction(result, isRead: true);
        });
        break;
      case parameters.stringAssignOrUpdatePersonalPlanActivities:
        Provider.of<RegimentViewModel>(
          context,
          listen: false,
        ).regimentMode = RegimentMode.Schedule;
        Provider.of<RegimentViewModel>(context, listen: false).regimentFilter =
            RegimentFilter.Scheduled;
        Get.toNamed(router.rt_Regimen,
                arguments: RegimentArguments(
                    eventId: result?.messageDetails?.payload?.eventId ?? ""))
            ?.then((value) {
          readUnreadAction(result, isRead: true);
        });
        break;
      case "claimList":
        if ((result?.messageDetails?.payload?.claimId ?? '').isNotEmpty) {
          Get.to(
            () => ClaimRecordDisplay(
              claimID: result?.messageDetails?.payload?.claimId,
            ),
          );
        }
        readUnreadAction(result);
        break;
      case parameters.strAppointmentDetail:
        if ((result?.messageDetails?.payload?.appointmentId ?? '').isNotEmpty) {
          AppointmentDetailsController appointmentDetailsController =
              CommonUtil().onInitAppointmentDetailsController();
          appointmentDetailsController.getAppointmentDetail(
              result?.messageDetails?.payload?.appointmentId ?? '');
          Get.to(() => AppointmentDetailScreen());
        }
        readUnreadAction(result);
        break;
      case parameters.strPatientReferralAcceptToPatient:
        if (CommonUtil.isUSRegion())
          Get.toNamed(router.rt_UserAccounts,
                  arguments: UserAccountsArguments(selectedIndex: 2))
              ?.then((value) =>
                  PageNavigator.goToPermanent(context, router.rt_Landing));
        readUnreadAction(result);
        break;
      case parameters.strChoosePrefDate:
        if (result?.messageDetails?.payload?.careCoordinatorUserId != null &&
            result?.messageDetails?.payload?.careCoordinatorUserId != '') {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ChatDetail(
                    peerId:
                        result?.messageDetails?.payload?.careCoordinatorUserId,
                    peerAvatar:
                        result?.messageDetails?.payload?.senderProfilePic,
                    peerName: result?.messageDetails?.payload?.patientName,
                    patientId: '',
                    patientName: '',
                    patientPicture: '',
                    isFromVideoCall: false,
                    isFromCareCoordinator: result
                            ?.messageDetails?.payload?.isFromCareCoordinator
                            .toLowerCase() ==
                        'true',
                    carecoordinatorId:
                        result?.messageDetails?.payload?.careCoordinatorUserId,
                    isCareGiver: result?.messageDetails?.payload?.isCareGiver
                            .toLowerCase() ==
                        'true',
                    groupId: '',
                    lastDate:
                        result?.messageDetails?.payload?.deliveredDateTime)),
          ).then((value) {});
          readUnreadAction(result);
        }
        break;
      case parameters.strMissedCallFromCCToPatient:
        if (result?.messageDetails?.payload?.careCoordinatorUserId != null &&
            result?.messageDetails?.payload?.careCoordinatorUserId != '') {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ChatDetail(
                      peerId: result
                          ?.messageDetails?.payload?.careCoordinatorUserId,
                      peerAvatar:
                          result?.messageDetails?.payload?.senderProfilePic,
                      peerName: result?.messageDetails?.payload?.senderName,
                      patientId: '',
                      patientName: '',
                      patientPicture: '',
                      isFromVideoCall: false,
                      isFromCareCoordinator: result
                              ?.messageDetails?.payload?.isFromCareCoordinator
                              .toLowerCase() ==
                          'true',
                      carecoordinatorId: result
                          ?.messageDetails?.payload?.careCoordinatorUserId,
                      isCareGiver: result?.messageDetails?.payload?.isCareGiver
                              .toLowerCase() ==
                          'true',
                      groupId: '',
                    )),
          ).then((value) {});
          readUnreadAction(result);
        }
        break;
      case parameters.strConnectedDevicesScreen:
        try {
          //Get.back();
          Get.to(
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
          )?.then((value) {
            readUnreadAction(result, isRead: true);
          });
        } catch (e, stackTrace) {
          CommonUtil().appLogs(message: e, stackTrace: stackTrace);
        }

        break;
      case parameters.strVCApproveByProvider ||
            parameters.strVCDeclineByProvider:
        Get.toNamed(
          rt_VoiceCloningStatus,
          arguments: const VoiceCloneStatusArguments(fromMenu: false),
        )?.then((value) {});
        readUnreadAction(result);
      default:
        readUnreadAction(result);
        break;
    }
  }

  void readUnreadAction(NotificationResult? result, {bool isRead = false}) {
    NotificationOntapRequest req = NotificationOntapRequest();
    req.logIds = [result?.id];
    final body = req.toJson();
    FetchNotificationService().updateNsOnTapAction(body).then((data) {
      if (data != null && data['isSuccess']) {
      } else {}

      if (isRead) {
        Provider.of<FetchNotificationViewModel>(context, listen: false)
          //..clearNotifications()
          ..fetchNotifications();
      }
    });
  }

  void getProfileData() async {
    try {
      await CommonUtil().getUserProfileData();
    } catch (e, stackTrace) {
      CommonUtil().appLogs(message: e, stackTrace: stackTrace);
    }
  }

  Widget createNSActionButton(
      String? templateName, NotificationResult notification) {
    Payload? payload = notification.messageDetails?.payload;
    var message = notification.messageDetails?.messageContent;
    switch (templateName) {
      case constants.strCancelByDoctor:
      case constants.strRescheduleByDoctor:
        return Padding(
          padding: EdgeInsets.only(left: 0, right: 0),
          child: Row(
            children: [
              OutlinedButton(
                onPressed: !notification.isActionDone!
                    ? () {
                        //Reschedule
                        var body = {};
                        body['templateName'] = payload?.templateName;
                        body['contextId'] = payload?.bookingId;
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ResheduleMain(
                                    isFromNotification: false,
                                    isFromFollowUpApp: false,
                                    closePage: (value) {},
                                    isReshedule: true,
                                    doc: Past(
                                        doctor: doctorObj.Doctor(
                                            id: notification.messageDetails!
                                                .payload!.doctorId),
                                        doctorSessionId: notification
                                            .messageDetails!
                                            .payload!
                                            .doctorSessionId,
                                        healthOrganization: City(
                                            id: notification.messageDetails!
                                                .payload!.healthOrganizationId),
                                        bookingId: notification.messageDetails!
                                            .payload!.bookingId),
                                    body: body,
                                  )),
                        ).then((value) {
                          if (notification.isUnread != null &&
                              notification.isUnread!) {
                            NotificationOntapRequest req =
                                NotificationOntapRequest();
                            req.logIds = [notification.id];
                            final body = req.toJson();
                            FetchNotificationService()
                                .updateNsOnTapAction(body)
                                .then((data) {
                              if (data != null && data['isSuccess']) {
                                Provider.of<FetchNotificationViewModel>(context,
                                    listen: false)
                                  //..clearNotifications()
                                  ..fetchNotifications();
                              } else {
                                Provider.of<FetchNotificationViewModel>(context,
                                    listen: false)
                                  //..clearNotifications()
                                  ..fetchNotifications();
                              }
                            });
                          }
                        });
                      }
                    : null,
                style: OutlinedButton.styleFrom(
                  side: !notification.isActionDone!
                      ? BorderSide(
                          color: mAppThemeProvider.primaryColor)
                      : BorderSide(color: Colors.grey),
                ),
                child: TextWidget(
                  text: TranslationConstants.reschedule.t(),
                  colors: !notification.isActionDone!
                      ? mAppThemeProvider.primaryColor
                      : Colors.grey,
                  overflow: TextOverflow.visible,
                  fontWeight: FontWeight.w600,
                  fontsize: 15.0.sp,
                ),
              ),
              SizedBox(
                width: 15.0.w,
              ),
              OutlinedButton(
                onPressed: !notification.isActionDone!
                    ? () {
                        var body = {};
                        body['templateName'] = payload?.templateName;
                        body['contextId'] = payload?.bookingId;
                        _displayDialog(
                            context,
                            [
                              Past(
                                  bookingId: notification
                                      .messageDetails!.payload!.bookingId,
                                  plannedStartDateTime: notification
                                      .messageDetails!
                                      .payload!
                                      .plannedStartDateTime)
                            ],
                            body,
                            notification);
                      }
                    : null,
                style: OutlinedButton.styleFrom(
                  side: !notification.isActionDone!
                      ? BorderSide(
                          color: mAppThemeProvider.primaryColor)
                      : BorderSide(color: Colors.grey),
                ),
                child: TextWidget(
                  text: TranslationConstants.cancel.t(),
                  colors: !notification.isActionDone!
                      ? mAppThemeProvider.primaryColor
                      : Colors.grey,
                  overflow: TextOverflow.visible,
                  fontWeight: FontWeight.w600,
                  fontsize: 15.0.sp,
                ),
              ),
            ],
          ),
        );
        break;
      case constants.strRemiderPreFrequency7:
      case constants.strRemiderPreFrequency3:
      case constants.strRemiderPreFrequency1:
      case constants.strRemiderPostFrequency1:
      case constants.strRemiderPostFrequency3:
      case constants.strRemiderPostFrequency7:
      case constants.strRemiderPostFrequency14:
        return Padding(
          padding: EdgeInsets.only(left: 0, right: 0),
          child: Row(
            children: [
              OutlinedButton(
                onPressed: !notification.isActionDone!
                    ? () {
                        final currentUserId =
                            PreferenceUtil.getStringValue(KEY_USERID);
                        if (currentUserId ==
                            notification.messageDetails?.payload?.userId) {
                          Get.to(
                            MyPlanDetail(
                              packageId:
                                  notification.messageDetails?.payload?.planId,
                              templateName: notification
                                  .messageDetails?.payload?.templateName,
                              showRenew: true,
                            ),
                          )!
                              .then((value) => PageNavigator.goToPermanent(
                                  context, router.rt_Landing));
                        } else {
                          CommonUtil.showFamilyMemberPlanExpiryDialog(
                              notification
                                  .messageDetails?.payload?.patientName);
                        }
                        //readUnreadAction(result);

                        /* if (notification?.isUnread != null &&
                              notification?.isUnread) {
                            NotificationOntapRequest req =
                                NotificationOntapRequest();
                            req.logIds = [notification?.id];
                            final body = req.toJson();
                            FetchNotificationService()
                                .updateNsOnTapAction(body)
                                .then((data) {
                              if (data != null && data['isSuccess']) {
                                Provider.of<FetchNotificationViewModel>(context,
                                    listen: false)
                                  ..clearNotifications()
                                  ..fetchNotifications();
                              } else {
                                Provider.of<FetchNotificationViewModel>(context,
                                    listen: false)
                                  ..clearNotifications()
                                  ..fetchNotifications();
                              }
                            });
                          } */
                      }
                    : null,
                style: OutlinedButton.styleFrom(
                  side: !notification.isActionDone!
                      ? BorderSide(
                          color: mAppThemeProvider.primaryColor)
                      : BorderSide(color: Colors.grey),
                ),
                child: TextWidget(
                  text: TranslationConstants.renew.t(),
                  colors: !notification.isActionDone!
                      ? mAppThemeProvider.primaryColor
                      : Colors.grey,
                  overflow: TextOverflow.visible,
                  fontWeight: FontWeight.w600,
                  fontsize: 15.0.sp,
                ),
              ),
              SizedBox(
                width: 15.0.w,
              ),
              OutlinedButton(
                onPressed: !notification.isActionDone!
                    ? () {
                        CommonUtil().CallbackAPI(
                          notification.messageDetails?.payload?.patientName,
                          notification.messageDetails?.payload?.planId,
                          notification.messageDetails?.payload?.userId,
                        );
                        var body = {};
                        body['templateName'] = payload?.templateName;
                        body['contextId'] =
                            notification.messageDetails?.payload?.planId;
                        FetchNotificationService()
                            .updateNsActionStatus(body)
                            .then((data) {
                          FetchNotificationService()
                              .updateNsOnTapAction(body)
                              .then((data) {
                            if (data != null && data['isSuccess']) {
                              Provider.of<FetchNotificationViewModel>(context,
                                  listen: false)
                                //..clearNotifications()
                                ..fetchNotifications();
                            } else {
                              Provider.of<FetchNotificationViewModel>(context,
                                  listen: false)
                                //..clearNotifications()
                                ..fetchNotifications();
                            }
                          });
                        });
                      }
                    : null,
                style: OutlinedButton.styleFrom(
                  side: !notification.isActionDone!
                      ? BorderSide(
                          color: mAppThemeProvider.primaryColor)
                      : BorderSide(color: Colors.grey),
                ),
                child: TextWidget(
                  text: TranslationConstants.callback.t(),
                  colors: !notification.isActionDone!
                      ? mAppThemeProvider.primaryColor
                      : Colors.grey,
                  overflow: TextOverflow.visible,
                  fontWeight: FontWeight.w600,
                  fontsize: 15.0.sp,
                ),
              ),
            ],
          ),
        );
        break;
      case parameters.familyMemberCaregiverRequest:
        return Padding(
          padding: const EdgeInsets.all(0),
          child: Row(
            children: [
              OutlinedButton(
                onPressed: () async {
                  if ((notification.messageDetails?.payload
                                  ?.patientPhoneNumber ??
                              '')
                          .isNotEmpty &&
                      (notification.messageDetails?.payload?.verificationCode ??
                              '')
                          .isNotEmpty) {
                    CaregiverAPIProvider().approveCareGiver(
                      phoneNumber: notification
                          .messageDetails?.payload?.patientPhoneNumber,
                      code: notification
                          .messageDetails?.payload?.verificationCode,
                    );
                  }
                  Provider.of<FetchNotificationViewModel>(context,
                          listen: false)
                      .fetchNotifications();
                },
                style: OutlinedButton.styleFrom(
                  side: BorderSide(
                    color: mAppThemeProvider.primaryColor,
                  ),
                ),
                child: TextWidget(
                  text: parameters.accept,
                  colors: mAppThemeProvider.primaryColor,
                  overflow: TextOverflow.visible,
                  fontWeight: FontWeight.w600,
                  fontsize: 15.0.sp,
                ),
              ),
              SizedBox(
                width: 15.0.w,
              ),
              OutlinedButton(
                onPressed: () async {
                  if ((notification
                                  .messageDetails?.payload?.caregiverReceiver ??
                              '')
                          .isNotEmpty &&
                      (notification.messageDetails?.payload
                                  ?.caregiverRequestor ??
                              '')
                          .isNotEmpty) {
                    CaregiverAPIProvider().rejectCareGiver(
                      receiver: notification
                          .messageDetails?.payload?.caregiverReceiver,
                      requestor: notification
                          .messageDetails?.payload?.caregiverRequestor,
                    );
                  }
                  Provider.of<FetchNotificationViewModel>(context,
                          listen: false)
                      .fetchNotifications();
                },
                style: OutlinedButton.styleFrom(
                  side: BorderSide(
                    color: mAppThemeProvider.primaryColor,
                  ),
                ),
                child: TextWidget(
                  text: parameters.reject,
                  colors: mAppThemeProvider.primaryColor,
                  overflow: TextOverflow.visible,
                  fontWeight: FontWeight.w600,
                  fontsize: 15.0.sp,
                ),
              ),
            ],
          ),
        );
        break;
      case parameters.associationNotificationToCaregiver:
        return Padding(
          padding: const EdgeInsets.all(0),
          child: Row(
            children: [
              OutlinedButton(
                onPressed: () async {
                  if ((notification
                              .messageDetails?.payload?.caregiverRequestor ??
                          '')
                      .isNotEmpty) {
                    Navigator.pushNamed(
                      context,
                      router.rt_FamilyDetailScreen,
                      arguments: MyFamilyDetailArguments(
                          caregiverRequestor: notification.messageDetails
                                  ?.payload?.caregiverRequestor ??
                              ''),
                    );
                  }
                },
                style: OutlinedButton.styleFrom(
                  side: BorderSide(
                    color: mAppThemeProvider.primaryColor,
                  ),
                ),
                child: TextWidget(
                  text: parameters.viewMember,
                  colors: mAppThemeProvider.primaryColor,
                  overflow: TextOverflow.visible,
                  fontWeight: FontWeight.w600,
                  fontsize: 14.0.sp,
                ),
              ),
              SizedBox(
                width: 15.0.w,
              ),
              Flexible(
                child: OutlinedButton(
                  onPressed: () async {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CareGiverSettings(),
                      ),
                    );
                  },
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(
                      color: mAppThemeProvider.primaryColor,
                    ),
                  ),
                  child: SizedBox(
                    child: TextWidget(
                      text: parameters.communicationSetting,
                      colors: mAppThemeProvider.primaryColor,
                      overflow: TextOverflow.visible,
                      fontWeight: FontWeight.w600,
                      fontsize: 14.0.sp,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
        break;
      case parameters.strCaregiverAppointmentPayment:
        return Padding(
          padding: const EdgeInsets.all(0),
          child: Row(
            children: [
              OutlinedButton(
                onPressed: () async {
                  //await readUnreadAction(notification, isRead: true);

                  var nsBody = {};
                  nsBody['templateName'] =
                      parameters.strCaregiverAppointmentPayment;
                  nsBody['contextId'] =
                      notification.messageDetails?.payload?.bookingId;
                  FetchNotificationService()
                      .updateNsActionStatus(nsBody)
                      .then((data) {
                    FetchNotificationService()
                        .updateNsOnTapAction(nsBody)
                        .then((value) => {});
                  });
                  checkIfPaymentLinkIsExpired(
                          notification.messageDetails!.payload!.appointmentId!)
                      .then((value) {
                    if (value) {
                      Get.to(BookingConfirmation(
                          isFromPaymentNotification: true,
                          appointmentId: notification
                              .messageDetails?.payload?.appointmentId));
                    } else {
                      toast.getToastWithBuildContext(
                          'Payment Link Expired', Colors.red, context);
                    }
                  });
                },
                style: OutlinedButton.styleFrom(
                  side: !notification.isActionDone!
                      ? BorderSide(
                          color: mAppThemeProvider.primaryColor)
                      : BorderSide(color: Colors.grey),
                ),
                child: TextWidget(
                  text: 'Pay Now',
                  colors: !notification.isActionDone!
                      ? mAppThemeProvider.primaryColor
                      : Colors.grey,
                  overflow: TextOverflow.visible,
                  fontWeight: FontWeight.w600,
                  fontsize: 14.0.sp,
                ),
              ),
              SizedBox(
                width: 15.0.w,
              ),
            ],
          ),
        );
        break;

      case parameters.strCaregiverNotifyPlanSubscription:
        return Padding(
          padding: const EdgeInsets.all(0),
          child: Row(
            children: [
              OutlinedButton(
                onPressed: () async {
                  //await readUnreadAction(notification, isRead: true);

                  var nsBody = {};
                  nsBody['templateName'] =
                      parameters.strCaregiverNotifyPlanSubscription;
                  nsBody['contextId'] =
                      notification.messageDetails?.payload?.bookingId;
                  FetchNotificationService()
                      .updateNsActionStatus(nsBody)
                      .then((data) {
                    FetchNotificationService()
                        .updateNsOnTapAction(nsBody)
                        .then((value) => {});
                  });
                  Get.to(CheckoutPage(
                    isFromNotification: true,
                    bookingId: notification.messageDetails?.payload?.bookingId,
                    cartUserId: notification.messageDetails?.payload?.userId,
                    notificationListId:
                        notification.messageDetails?.payload?.createdBy,
                    cartId: notification.messageDetails?.payload?.bookingId,
                    patientName:
                        notification.messageDetails?.payload?.patientName,
                  ))!
                      .then((value) {});
                },
                style: OutlinedButton.styleFrom(
                  side: !notification.isActionDone!
                      ? BorderSide(
                          color: mAppThemeProvider.primaryColor)
                      : BorderSide(color: Colors.grey),
                ),
                child: TextWidget(
                  text: 'Pay Now',
                  colors: !notification.isActionDone!
                      ? mAppThemeProvider.primaryColor
                      : Colors.grey,
                  overflow: TextOverflow.visible,
                  fontWeight: FontWeight.w600,
                  fontsize: 14.0.sp,
                ),
              ),
              SizedBox(
                width: 15.0.w,
              ),
            ],
          ),
        );
        break;
      case parameters.notifyCaregiverForMedicalRecord:
        return Padding(
          padding: EdgeInsets.only(left: 0, right: 0),
          child: Row(
            children: [
              OutlinedButton(
                onPressed: () {
                  readUnreadAction(notification);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ChatDetail(
                            peerId: payload!.userId,
                            peerAvatar: payload.senderProfilePic,
                            peerName: payload.patientName,
                            patientId: '',
                            patientName: '',
                            patientPicture: '',
                            isFromVideoCall: false,
                            isFromFamilyListChat: true,
                            isFromCareCoordinator:
                                payload.isFromCareCoordinator.toLowerCase() ==
                                    'true',
                            carecoordinatorId: payload.careCoordinatorUserId,
                            isCareGiver:
                                payload.isCareGiver.toLowerCase() == 'true',
                            groupId: '',
                            lastDate: payload.deliveredDateTime)),
                  ).then((value) {});
                },
                style: OutlinedButton.styleFrom(
                  side: notification.isUnread!
                      ? BorderSide(
                          color: mAppThemeProvider.primaryColor)
                      : BorderSide(color: Colors.grey),
                ),
                child: TextWidget(
                  text: TranslationConstants.chatwithcc,
                  colors: notification.isUnread!
                      ? mAppThemeProvider.primaryColor
                      : Colors.grey,
                  overflow: TextOverflow.visible,
                  fontWeight: FontWeight.w600,
                  fontsize: 15.0.sp,
                ),
              ),
              SizedBox(
                width: 15.0.w,
              ),
              OutlinedButton(
                onPressed: () {
                  readUnreadAction(notification);

                  var body = {};
                  body['templateName'] = payload?.templateName;
                  final List<String> split = payload!.redirectTo!.split('|');
                  var redirectData = {
                    for (int i = 0; i < split.length; i++) i: split[i]
                  };
                  var id = redirectData[2];
                  if (id.runtimeType == String && (id ?? '').isNotEmpty) {
                    final userId = PreferenceUtil.getStringValue(KEY_USERID);
                    if ((payload.userId ?? '') == userId) {
                      CommonUtil().navigateToRecordDetailsScreen(id);
                    } else {
                      CommonUtil.showFamilyMemberPlanExpiryDialog(
                        (payload.patientName ?? ''),
                        redirect: (payload.redirectTo ?? ''),
                      );
                    }
                  }
                },
                style: OutlinedButton.styleFrom(
                  side: notification.isUnread!
                      ? BorderSide(
                          color: mAppThemeProvider.primaryColor)
                      : BorderSide(color: Colors.grey),
                ),
                child: TextWidget(
                  text: TranslationConstants.viewrecord,
                  colors: notification.isUnread!
                      ? mAppThemeProvider.primaryColor
                      : Colors.grey,
                  overflow: TextOverflow.visible,
                  fontWeight: FontWeight.w600,
                  fontsize: 15.0.sp,
                ),
              ),
            ],
          ),
        );
        break;
      case parameters.strFamilyProfile:
        return Padding(
          padding: const EdgeInsets.all(0),
          child: Row(
            children: [
              OutlinedButton(
                onPressed: () async {
                  readUnreadAction(notification, isRead: true);

                  CommonUtil().getDetailsOfAddedFamilyMember(
                      context, notification.messageDetails!.payload!.userId!);
                },
                style: OutlinedButton.styleFrom(
                  side: !notification.isActionDone!
                      ? BorderSide(
                          color: mAppThemeProvider.primaryColor)
                      : BorderSide(color: Colors.grey),
                ),
                child: TextWidget(
                  text: 'View Details',
                  colors: !notification.isActionDone!
                      ? mAppThemeProvider.primaryColor
                      : Colors.grey,
                  overflow: TextOverflow.visible,
                  fontWeight: FontWeight.w600,
                  fontsize: 14.0.sp,
                ),
              ),
              SizedBox(
                width: 15.0.w,
              ),
            ],
          ),
        );

        break;
      case parameters.careGiverTransportRequestReminder:
      case strVoiceClonePatientAssignment:
        // Check if the 'isAccepted' property is null in the messageDetails
        return (notification.messageDetails?.isAccepted == null)
            ? (notification?.messageDetails?.payload?.templateName ==
                    strVoiceClonePatientAssignment)
                ? getAppointmentAcceptAndReject(notification)
                : (isAppointmentExpired(
                        notification.messageDetails?.payload?.appointmentDate ??
                            '')
                    // Check if the appointment is expired based on the appointmentDate
                    ? getAppointmentAcceptAndReject(notification)
                    : Container())
            // Return an empty Container if 'isAccepted' is not null
            : Container();

        break;
      default:
        return Container();
        break;
    }
  }

  Widget getAppointmentAcceptAndReject(NotificationResult notification) {
    Payload? payload = notification?.messageDetails?.payload;
    bool isEnablebutton = false;

    // Check if the templateName is 'careGiverTransportRequestReminder'
    if (payload?.templateName == parameters.careGiverTransportRequestReminder) {
      isEnablebutton = (!notification.isActionDone!);
    } else if (payload?.templateName == strVoiceClonePatientAssignment) {
      // Check if the templateName is 'strVoiceClonePatientAssignment'

      isEnablebutton = (notification.isUnread ?? false);
    }
    return Padding(
      padding: const EdgeInsets.all(0),
      child: Row(
        children: [
          OutlinedButton(
            onPressed: isEnablebutton
                ? () async {
                    if (payload?.templateName ==
                        parameters.careGiverTransportRequestReminder) {
                      CommonUtil()
                          .acceptCareGiverTransportRequestReminder(
                              context,
                              notification
                                      .messageDetails?.payload?.appointmentId ??
                                  '',
                              notification.messageDetails?.payload?.patientId ??
                                  '',
                              true)
                          .then((value) {
                        readUnreadAction(notification, isRead: true);
                        notification.messageDetails?.setAccepted(true);
                      });
                    } else if (payload?.templateName ==
                        strVoiceClonePatientAssignment) {
                      // Check if the templateName is 'strVoiceClonePatientAssignment'

                      // Save the Voice Clone Patient Assignment accept status using CommonUtil
                      CommonUtil()
                          .saveVoiceClonePatientAssignmentStatus(
                              notification
                                      .messageDetails?.payload?.voiceCloneId ??
                                  '',
                              true)
                          .then((value) {
                        // Perform read/unread action after saving the status
                        readUnreadAction(notification, isRead: true);
                      });
                    }
                  }
                : null,
            style: OutlinedButton.styleFrom(
              side: isEnablebutton
                  ? BorderSide(color: mAppThemeProvider.primaryColor)
                  : BorderSide(color: Colors.grey),
            ),
            child: TextWidget(
              text: 'Accept',
              colors: isEnablebutton
                  ? mAppThemeProvider.primaryColor
                  : Colors.grey,
              overflow: TextOverflow.visible,
              fontWeight: FontWeight.w600,
              fontsize: 14.0.sp,
            ),
          ),
          SizedBox(
            width: 15.0.w,
          ),
          OutlinedButton(
            onPressed: isEnablebutton
                ? () async {
                    if (payload?.templateName ==
                        parameters.careGiverTransportRequestReminder) {
                      CommonUtil()
                          .acceptCareGiverTransportRequestReminder(
                              context,
                              notification
                                      .messageDetails?.payload?.appointmentId ??
                                  '',
                              notification.messageDetails?.payload?.patientId ??
                                  '',
                              false)
                          .then((value) {
                        readUnreadAction(notification, isRead: true);
                        notification.messageDetails?.setAccepted(true);
                      });
                    } else if (payload?.templateName ==
                        strVoiceClonePatientAssignment) {
                      // Check if the templateName is 'strVoiceClonePatientAssignment'

                      // Save the Voice Clone Patient Assignment decline status using CommonUtil
                      CommonUtil()
                          .saveVoiceClonePatientAssignmentStatus(
                              notification
                                      .messageDetails?.payload?.voiceCloneId ??
                                  '',
                              false)
                          .then((value) {
                        // Perform read/unread action after saving the status
                        readUnreadAction(notification, isRead: true);
                      });
                    }
                  }
                : null,
            style: OutlinedButton.styleFrom(
              side: isEnablebutton
                  ? BorderSide(color: mAppThemeProvider.primaryColor)
                  : BorderSide(color: Colors.grey),
            ),
            child: TextWidget(
              text: 'Decline',
              colors: isEnablebutton
                  ? mAppThemeProvider.primaryColor
                  : Colors.grey,
              overflow: TextOverflow.visible,
              fontWeight: FontWeight.w600,
              fontsize: 14.0.sp,
            ),
          ),
        ],
      ),
    );
  }

  bool isAppointmentExpired(String date) {
    if (date.isNotEmpty) {
      try {
        var time = DateTime.parse(date);
        var temp = DateTime.now();
        var d1 = DateTime.utc(temp.year, temp.month, temp.day, temp.hour,
            temp.minute, temp.second);

        if (d1.isAfter(time.toUtc())) {
          return false;
        } else {
          return true;
        }
      } catch (e, stackTrace) {
        return false;
      }
    } else {
      return false;
    }
  }

  Future<bool> checkIfPaymentLinkIsExpired(String appointmentId) async {
    bool paymentStatus = false;
    CreateAppointMentViewModel createAppointMentViewModel =
        CreateAppointMentViewModel();
    AppointmentNotificationPayment? appointmentNotificationPayment =
        await createAppointMentViewModel
            .getAppointmentDetailsUsingId(appointmentId);
    if (appointmentNotificationPayment != null) {
      if (appointmentNotificationPayment.result?.appointment?.status != null) {
        if (appointmentNotificationPayment.result?.appointment?.status!.code ==
            "BOOKIP") {
          paymentStatus = true;
        } else {
          paymentStatus = false;
        }
      } else {
        paymentStatus = false;
      }
    } else {
      paymentStatus = false;
    }
    return paymentStatus;
  }
}
