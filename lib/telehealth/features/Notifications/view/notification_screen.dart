import 'package:flutter/material.dart';
import 'package:gmiwidgetspackage/widgets/IconWidget.dart';
import 'package:gmiwidgetspackage/widgets/SizeBoxWithChild.dart';
import 'package:gmiwidgetspackage/widgets/flutterToast.dart';
import 'package:gmiwidgetspackage/widgets/sized_box.dart';
import 'package:gmiwidgetspackage/widgets/text_widget.dart';
import 'package:myfhb/common/CommonUtil.dart';
import 'package:myfhb/constants/fhb_constants.dart';
import 'package:myfhb/telehealth/features/MyProvider/view/MyProvidersMain.dart';
import 'package:myfhb/telehealth/features/Notifications/constants/notification_constants.dart'
    as constants;
import 'package:myfhb/src/utils/screenutils/size_extensions.dart';
import 'package:myfhb/constants/fhb_parameters.dart' as parameters;
import 'package:myfhb/telehealth/features/Notifications/model/notificationResult.dart';
import 'package:myfhb/telehealth/features/Notifications/model/notification_ontap_req.dart';
import 'package:myfhb/telehealth/features/Notifications/model/payload.dart';
import 'package:myfhb/telehealth/features/Notifications/services/notification_services.dart';
import 'package:myfhb/telehealth/features/appointments/constants/appointments_constants.dart'
    as AppConstants;
import 'package:myfhb/telehealth/features/Notifications/model/messageContent.dart';
import 'package:myfhb/telehealth/features/Notifications/model/notification_model.dart';
import 'package:myfhb/telehealth/features/Notifications/viewModel/fetchNotificationViewModel.dart';
import 'package:myfhb/telehealth/features/appointments/model/cancelAppointments/cancelModel.dart';
import 'package:myfhb/telehealth/features/appointments/model/fetchAppointments/city.dart';
import 'package:myfhb/telehealth/features/appointments/model/fetchAppointments/doctor.dart';
import 'package:myfhb/telehealth/features/appointments/model/fetchAppointments/past.dart';
import 'package:myfhb/telehealth/features/appointments/view/appointmentsMain.dart';
import 'package:myfhb/telehealth/features/appointments/view/resheduleMain.dart';
import 'package:myfhb/telehealth/features/appointments/viewModel/cancelAppointmentViewModel.dart';
import 'package:myfhb/telehealth/features/chat/view/home.dart';
import 'package:myfhb/widgets/GradientAppBar.dart';
import 'package:provider/provider.dart';
import 'package:get/get.dart';
import 'package:myfhb/telehealth/features/MyProvider/view/TelehealthProviders.dart';
import 'package:myfhb/src/model/home_screen_arguments.dart';
import 'package:myfhb/constants/router_variable.dart' as router;
import 'package:myfhb/src/utils/PageNavigator.dart';
import 'package:myfhb/src/ui/bot/SuperMaya.dart';
import 'package:myfhb/src/model/user/user_accounts_arguments.dart';
import 'package:myfhb/src/blocs/Category/CategoryListBlock.dart';
import 'package:myfhb/src/ui/MyRecord.dart';
import 'package:myfhb/src/ui/MyRecordsArguments.dart';
import 'package:myfhb/src/model/Category/catergory_result.dart';
import 'package:myfhb/constants/fhb_constants.dart' as Constants;

class NotificationScreen extends StatefulWidget {
  @override
  _NotificationScreen createState() => _NotificationScreen();
}

class _NotificationScreen extends State<NotificationScreen> {
  FlutterToast toast = FlutterToast();
  CancelAppointmentViewModel cancelAppointmentViewModel;

  @override
  void initState() {
    mInitialTime = DateTime.now();
    Provider.of<FetchNotificationViewModel>(context, listen: false)
        .fetchNotifications();
    cancelAppointmentViewModel =
        Provider.of<CancelAppointmentViewModel>(context, listen: false);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    fbaLog(eveName: 'qurbook_screen_event', eveParams: {
      'eventTime': '${DateTime.now()}',
      'pageName': 'Notification Screen',
      'screenSessionTime':
          '${DateTime.now().difference(mInitialTime).inSeconds} secs'
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: notificationAppBar(),
      body: notificationBodyView(),
    );
  }

  Widget notificationAppBar() {
    return AppBar(
      flexibleSpace: GradientAppBar(),
      //centerTitle: true,
      leading: IconWidget(
        icon: Icons.arrow_back_ios,
        colors: Colors.white,
        size: 24.0.sp,
        onTap: () {
          Navigator.pop(context);
        },
      ),
      title: TextWidget(
        text: constants.lblNotifications,
        colors: Colors.white,
        overflow: TextOverflow.visible,
        fontWeight: FontWeight.w600,
        fontsize: 18.0.sp,
        softwrap: true,
      ),
    );
  }

  Widget notificationBodyView() {
    var notificationData = Provider.of<FetchNotificationViewModel>(context);
    switch (notificationData.loadingStatus) {
      case LoadingStatus.searching:
        return Center(
          child: CircularProgressIndicator(
            backgroundColor: Colors.grey,
          ),
        );
      case LoadingStatus.completed:
        return (notificationData != null)
            ? (notificationData.notifications != null)
                ? (notificationData.notifications?.result != null) &&
                        (notificationData.notifications?.result.length > 0)
                    ? ListView.builder(
                        itemCount: notificationData.notifications.result.length,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          notificationData.notifications.result.sort(
                              (a, b) => b.createdOn.compareTo(a.createdOn));
                          return notificationView(
                              notification: notificationData.notifications,
                              index: index);
                        })
                    : emptyNotification()
                : emptyNotification()
            : emptyNotification();
      case LoadingStatus.empty:
      default:
        return emptyNotification();
    }
  }

  Widget emptyNotification() {
    return Container(
      height: 1.sh,
      alignment: Alignment.center,
      child: Center(
        child: Text(constants.lblNoNotification),
      ),
    );
  }

  Widget notificationView({NotificationModel notification, int index}) {
    if (notification?.result[index]?.messageDetails != null) {
      Payload payload = notification?.result[index]?.messageDetails?.payload;
      MessageContent message =
          notification.result[index].messageDetails?.messageContent;
      return (message.messageBody == "" || message.messageTitle == "")
          ? Container()
          : InkWell(
              splashColor: Color(CommonUtil.secondaryGrey),
              onTap: (notification?.result[index]?.isUnread != null &&
                      notification?.result[index]?.isUnread)
                  ? () {
                      var tempRedirectTo = payload?.redirectTo != null &&
                              payload?.redirectTo != ''
                          ? payload?.redirectTo.split('|')[0]
                          : '';
                      if (tempRedirectTo == 'myRecords') {
                        notificationOnTapActions(
                            notification?.result[index], tempRedirectTo,
                            bundles: {
                              'catName': payload?.redirectTo.split('|')[1],
                              'healthRecordMetaIds':
                                  payload?.healthRecordMetaIds
                            });
                      } else {
                        notificationOnTapActions(
                            notification?.result[index],
                            notification?.result[index]?.messageDetails?.content
                                ?.templateName);
                      }
                      // notificationOnTapActions(
                      //     notification?.result[index],
                      //     notification?.result[index]?.messageDetails?.content
                      //         ?.templateName);
                    }
                  : null,
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
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    TextWidget(
                                      text: message.messageTitle,
                                      colors: (notification?.result[index]
                                                      ?.isUnread ==
                                                  null ||
                                              !notification
                                                  ?.result[index]?.isUnread)
                                          ? Colors.black
                                          : Color(
                                              CommonUtil().getMyPrimaryColor()),
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
                                    (payload?.templateName ==
                                                constants.strCancelByDoctor ||
                                            payload?.templateName ==
                                                constants.strRescheduleByDoctor)
                                        ? Padding(
                                            padding: EdgeInsets.only(
                                                left: 0, right: 0),
                                            child: Row(
                                              children: [
                                                OutlineButton(
                                                  onPressed:
                                                      !notification
                                                              ?.result[index]
                                                              ?.isActionDone
                                                          ? () {
                                                              //Reschedule
                                                              var body = {};
                                                              body['templateName'] =
                                                                  payload
                                                                      ?.templateName;
                                                              body['contextId'] =
                                                                  payload
                                                                      ?.bookingId;
                                                              Navigator.push(
                                                                context,
                                                                MaterialPageRoute(
                                                                    builder:
                                                                        (context) =>
                                                                            ResheduleMain(
                                                                              isFromNotification: false,
                                                                              closePage: (value) {},
                                                                              isReshedule: true,
                                                                              doc: Past(doctor: Doctor(id: notification.result[index].messageDetails.payload.doctorId), doctorSessionId: notification.result[index].messageDetails.payload.doctorSessionId, healthOrganization: City(id: notification.result[index].messageDetails.payload.healthOrganizationId), bookingId: notification.result[index].messageDetails.payload.bookingId),
                                                                              body: body,
                                                                            )),
                                                              ).then((value) {
                                                                if (notification
                                                                            ?.result[
                                                                                index]
                                                                            ?.isUnread !=
                                                                        null &&
                                                                    notification
                                                                        ?.result[
                                                                            index]
                                                                        ?.isUnread) {
                                                                  NotificationOntapRequest
                                                                      req =
                                                                      NotificationOntapRequest();
                                                                  req.logIds = [
                                                                    notification
                                                                        ?.result[
                                                                            index]
                                                                        ?.id
                                                                  ];
                                                                  final body = req
                                                                      .toJson();
                                                                  FetchNotificationService()
                                                                      .updateNsOnTapAction(
                                                                          body)
                                                                      .then(
                                                                          (data) {
                                                                    if (data !=
                                                                            null &&
                                                                        data[
                                                                            'isSuccess']) {
                                                                      Provider.of<
                                                                              FetchNotificationViewModel>(
                                                                          context,
                                                                          listen:
                                                                              false)
                                                                        ..clearNotifications()
                                                                        ..fetchNotifications();
                                                                    } else {
                                                                      Provider.of<
                                                                              FetchNotificationViewModel>(
                                                                          context,
                                                                          listen:
                                                                              false)
                                                                        ..clearNotifications()
                                                                        ..fetchNotifications();
                                                                    }
                                                                  });
                                                                }
                                                              });
                                                            }
                                                          : null,
                                                  borderSide: !notification
                                                          ?.result[index]
                                                          ?.isActionDone
                                                      ? BorderSide(
                                                          color: Color(CommonUtil()
                                                              .getMyPrimaryColor()))
                                                      : BorderSide(
                                                          color: Colors.grey),
                                                  child: TextWidget(
                                                    text: AppConstants
                                                        .Appointments_reshedule,
                                                    colors: !notification
                                                            ?.result[index]
                                                            ?.isActionDone
                                                        ? Color(CommonUtil()
                                                            .getMyPrimaryColor())
                                                        : Colors.grey,
                                                    overflow:
                                                        TextOverflow.visible,
                                                    fontWeight: FontWeight.w600,
                                                    fontsize: 15.0.sp,
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 15.0.w,
                                                ),
                                                OutlineButton(
                                                  onPressed:
                                                      !notification
                                                              ?.result[index]
                                                              ?.isActionDone
                                                          ? () {
                                                              var body = {};
                                                              body['templateName'] =
                                                                  payload
                                                                      ?.templateName;
                                                              body['contextId'] =
                                                                  payload
                                                                      ?.bookingId;
                                                              _displayDialog(
                                                                  context,
                                                                  [
                                                                    Past(
                                                                        bookingId: notification
                                                                            .result[
                                                                                index]
                                                                            .messageDetails
                                                                            .payload
                                                                            .bookingId,
                                                                        plannedStartDateTime: notification
                                                                            .result[index]
                                                                            .messageDetails
                                                                            .payload
                                                                            .plannedStartDateTime)
                                                                  ],
                                                                  body,
                                                                  notification
                                                                          .result[
                                                                      index]);
                                                            }
                                                          : null,
                                                  borderSide: !notification
                                                          ?.result[index]
                                                          ?.isActionDone
                                                      ? BorderSide(
                                                          color: Color(CommonUtil()
                                                              .getMyPrimaryColor()))
                                                      : BorderSide(
                                                          color: Colors.grey),
                                                  child: TextWidget(
                                                    text: AppConstants
                                                        .Appointments_cancel,
                                                    colors: !notification
                                                            ?.result[index]
                                                            ?.isActionDone
                                                        ? Color(CommonUtil()
                                                            .getMyPrimaryColor())
                                                        : Colors.grey,
                                                    overflow:
                                                        TextOverflow.visible,
                                                    fontWeight: FontWeight.w600,
                                                    fontsize: 15.0.sp,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          )
                                        : Container()
                                  ],
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: Container(
                                padding: EdgeInsets.only(top: 5),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    TextWidget(
                                      text: constants.notificationDate(
                                          notification
                                              ?.result[index]?.createdOn),
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
                                          notification
                                              ?.result[index]?.createdOn),
                                      colors: (notification?.result[index]
                                                      ?.isUnread ==
                                                  null ||
                                              !notification
                                                  ?.result[index]?.isUnread)
                                          ? Colors.black
                                          : Color(
                                              CommonUtil().getMyPrimaryColor()),
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
                    color: Colors.black,
                  )
                ],
              ),
            );
      /* : Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 5, bottom: 5),
              child: Column(
                children: [
                  ListTile(
                    onTap: () {},
                    title: TextWidget(
                      text: message.messageTitle,
                      colors: Colors.black,
                      overflow: TextOverflow.visible,
                      fontWeight: FontWeight.w600,
                      fontsize: 15.0.sp,
                      softwrap: true,
                    ),
                    subtitle: TextWidget(
                      text: message.messageBody,
                      colors: Colors.grey,
                      overflow: TextOverflow.visible,
                      fontWeight: FontWeight.w500,
                      fontsize: 14.0.sp,
                      softwrap: true,
                    ),
                    trailing: Column(
                      children: <Widget>[
                        TextWidget(
                          text: constants.notificationDate(
                              notification.result[index].createdOn),
                          colors: Colors.black,
                          overflow: TextOverflow.visible,
                          fontWeight: FontWeight.w500,
                          fontsize: 12.0.sp,
                          softwrap: true,
                        ),
                        TextWidget(
                          text: constants.notificationTime(
                              notification.result[index].createdOn),
                          colors: Color(CommonUtil().getMyPrimaryColor()),
                          overflow: TextOverflow.visible,
                          fontWeight: FontWeight.w600,
                          fontsize: 12.0.sp,
                          softwrap: true,
                        ),
                      ],
                    ),
                  ),
                  (payload?.templateName == constants.strCancelByDoctor ||
                          payload?.templateName ==
                              constants.strRescheduleByDoctor)
                      ? Padding(
                          padding: EdgeInsets.only(left: 20, right: 20),
                          child: Row(
                            children: [
                              OutlineButton(
                                onPressed: !notification
                                        ?.result[index]?.isActionDone
                                    ? () {
                                        var body = {};
                                        body['templateName'] =
                                            payload?.templateName;
                                        body['contextId'] =
                                            payload?.bookingId;
                                        _displayDialog(
                                            context,
                                            [
                                              Past(
                                                  bookingId: notification
                                                      .result[index]
                                                      .messageDetails
                                                      .payload
                                                      .bookingId,
                                                  plannedStartDateTime:
                                                      notification
                                                          .result[index]
                                                          .messageDetails
                                                          .payload
                                                          .plannedStartDateTime)
                                            ],
                                            body);
                                      }
                                    : null,
                                child: TextWidget(
                                  text: AppConstants.Appointments_cancel,
                                  colors: !notification
                                          ?.result[index]?.isActionDone
                                      ? Color(
                                          CommonUtil().getMyPrimaryColor())
                                      : Colors.grey,
                                  overflow: TextOverflow.visible,
                                  fontWeight: FontWeight.w600,
                                  fontsize: 15.0.sp,
                                ),
                              ),
                              SizedBox(
                                width: 15.0.w,
                              ),
                              OutlineButton(
                                onPressed: !notification
                                        ?.result[index]?.isActionDone
                                    ? () {
                                        //Reschedule
                                        var body = {};
                                        body['templateName'] =
                                            payload?.templateName;
                                        body['contextId'] =
                                            payload?.bookingId;
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  ResheduleMain(
                                                    isFromNotification:
                                                        false,
                                                    closePage: (value) {},
                                                    isReshedule: true,
                                                    doc: Past(
                                                        doctor: Doctor(
                                                            id: notification
                                                                .result[
                                                                    index]
                                                                .messageDetails
                                                                .payload
                                                                .doctorId),
                                                        doctorSessionId:
                                                            notification
                                                                .result[
                                                                    index]
                                                                .messageDetails
                                                                .payload
                                                                .doctorSessionId,
                                                        healthOrganization: City(
                                                            id: notification
                                                                .result[
                                                                    index]
                                                                .messageDetails
                                                                .payload
                                                                .healthOrganizationId),
                                                        bookingId: notification
                                                            .result[index]
                                                            .messageDetails
                                                            .payload
                                                            .bookingId),
                                                    body: body,
                                                  )),
                                        ).then((value) {
                                          Provider.of<
                                                  FetchNotificationViewModel>(
                                              context,
                                              listen: false)
                                            ..clearNotifications()
                                            ..fetchNotifications();
                                        });
                                      }
                                    : null,
                                child: TextWidget(
                                  text: AppConstants.Appointments_reshedule,
                                  colors: !notification
                                          ?.result[index]?.isActionDone
                                      ? Color(
                                          CommonUtil().getMyPrimaryColor())
                                      : Colors.grey,
                                  overflow: TextOverflow.visible,
                                  fontWeight: FontWeight.w600,
                                  fontsize: 15.0.sp,
                                ),
                              )
                            ],
                          ),
                        )
                      : Container()
                ],
              ),
            ),
            Container(
              height: 0.2,
              color: Colors.black,
            )
          ],
        ); */
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
                                    child: FlatButton(
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(12.0),
                                          side: BorderSide(
                                              color: Color(CommonUtil()
                                                  .getMyPrimaryColor()))),
                                      color: Colors.transparent,
                                      textColor: Color(
                                          CommonUtil().getMyPrimaryColor()),
                                      padding: EdgeInsets.all(8.0),
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
                                    child: FlatButton(
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(12.0),
                                          side: BorderSide(
                                              color: Color(new CommonUtil()
                                                  .getMyPrimaryColor()))),
                                      color: Colors.transparent,
                                      textColor: Color(
                                          new CommonUtil().getMyPrimaryColor()),
                                      padding: EdgeInsets.all(8.0),
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
        toast.getToast(AppConstants.BOOKING_CANCEL, Colors.red);
      } else if (value.isSuccess == true) {
//        widget.onChanged(AppConstants.callBack);
        toast.getToast(AppConstants.YOUR_BOOKING_SUCCESS, Colors.green);
        FetchNotificationService().updateNsActionStatus(body).then((data) {
          if (data != null && data['isSuccess']) {
            if (notification.isUnread != null && notification.isUnread) {
              NotificationOntapRequest req = NotificationOntapRequest();
              req.logIds = [notification.id];
              final body = req.toJson();
              FetchNotificationService().updateNsOnTapAction(body).then((data) {
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
            }
          } else {
            Provider.of<FetchNotificationViewModel>(context, listen: false)
              ..clearNotifications()
              ..fetchNotifications();
          }
        });
      } else {
        toast.getToast(AppConstants.BOOKING_CANCEL, Colors.red);
      }
    });
  }

  Future<CancelAppointmentModel> cancelAppointment(
      List<Past> appointments) async {
    List<String> bookingIds = new List();
    List<String> dates = new List();
    for (int i = 0; i < appointments.length; i++) {
      bookingIds.add(appointments[i].bookingId);
      dates.add(appointments[i].plannedStartDateTime);
    }
    CancelAppointmentModel cancelAppointment = await cancelAppointmentViewModel
        .fetchCancelAppointment(bookingIds, dates);

    return cancelAppointment;
  }

  void notificationOnTapActions(NotificationResult result, String templateName,
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
        )).then((value) =>
            PageNavigator.goToPermanent(context, router.rt_Dashboard));
        readUnreadAction(result);
        break;
      case "PaymentReceipt":
      case "PaymentConfirmation":
        Get.to(TelehealthProviders(
          arguments: HomeScreenArguments(
              selectedIndex: 0,
              bookingId: result?.messageDetails?.payload?.bookingId,
              date: result?.messageDetails?.payload?.appointmentDate,
              templateName: result?.messageDetails?.content?.templateName),
        )).then((value) =>
            PageNavigator.goToPermanent(context, router.rt_Dashboard));
        readUnreadAction(result);
        break;
      case "SlotsFull":
        Get.to(TelehealthProviders(
          arguments: HomeScreenArguments(
              selectedIndex: 0,
              bookingId: result?.messageDetails?.payload?.bookingId,
              date: result?.messageDetails?.payload?.appointmentDate,
              templateName: result?.messageDetails?.content?.templateName),
        )).then((value) =>
            PageNavigator.goToPermanent(context, router.rt_Dashboard));
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
      case "AppointmentTransactionCancelledMidway":
        readUnreadAction(result);
        break;
      case "sheela":
        Get.to(SuperMaya()).then((value) =>
            PageNavigator.goToPermanent(context, router.rt_Dashboard));
        readUnreadAction(result);
        break;
      case "profile_page":
        Get.toNamed(router.rt_UserAccounts,
                arguments: UserAccountsArguments(selectedIndex: 0))
            .then((value) =>
                PageNavigator.goToPermanent(context, router.rt_Dashboard));
        readUnreadAction(result);
        break;
      case "googlefit":
        Get.toNamed(router.rt_AppSettings).then((value) =>
            PageNavigator.goToPermanent(context, router.rt_Dashboard));
        readUnreadAction(result);
        break;
      case "th_provider":
        Get.toNamed(router.rt_TelehealthProvider,
                arguments: HomeScreenArguments(selectedIndex: 1))
            .then((value) =>
                PageNavigator.goToPermanent(context, router.rt_Dashboard));
        readUnreadAction(result);
        break;
      case "my_record":
        getProfileData();
        Get.toNamed(router.rt_HomeScreen,
                arguments: HomeScreenArguments(selectedIndex: 1))
            .then((value) =>
                PageNavigator.goToPermanent(context, router.rt_Dashboard));
        readUnreadAction(result);
        break;
      case "myRecords":
        var categoryName = bundles['catName'];
        String hrmId = bundles['healthRecordMetaIds'];
        List<String> _listOfhrmId = List<String>();
        _listOfhrmId.add(hrmId);
        CommonUtil()
            .navigateToMyRecordsCategory(categoryName, _listOfhrmId, false);
        readUnreadAction(result);
        break;
      default:
        readUnreadAction(result);
        break;
    }
  }

  void readUnreadAction(NotificationResult result) {
    NotificationOntapRequest req = NotificationOntapRequest();
    req.logIds = [result?.id];
    final body = req.toJson();
    FetchNotificationService().updateNsOnTapAction(body).then((data) {
      if (data != null && data['isSuccess']) {
      } else {}
      Provider.of<FetchNotificationViewModel>(context, listen: false)
        ..clearNotifications()
        ..fetchNotifications();
    });
  }

  void getProfileData() async {
    try {
      await new CommonUtil().getUserProfileData();
    } catch (e) {}
  }
}
