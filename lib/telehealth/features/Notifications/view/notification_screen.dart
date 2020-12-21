import 'package:flutter/material.dart';
import 'package:gmiwidgetspackage/widgets/IconWidget.dart';
import 'package:gmiwidgetspackage/widgets/SizeBoxWithChild.dart';
import 'package:gmiwidgetspackage/widgets/flutterToast.dart';
import 'package:gmiwidgetspackage/widgets/sized_box.dart';
import 'package:gmiwidgetspackage/widgets/text_widget.dart';
import 'package:myfhb/common/CommonUtil.dart';
import 'package:myfhb/telehealth/features/MyProvider/view/MyProvidersMain.dart';
import 'package:myfhb/telehealth/features/Notifications/constants/notification_constants.dart'
    as constants;
import 'package:myfhb/constants/fhb_parameters.dart' as parameters;
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

class NotificationScreen extends StatefulWidget {
  @override
  _NotificationScreen createState() => _NotificationScreen();
}

class _NotificationScreen extends State<NotificationScreen> {
  FlutterToast toast = FlutterToast();
  CancelAppointmentViewModel cancelAppointmentViewModel;

  @override
  void initState() {
    // TODO: implement initState
    Provider.of<FetchNotificationViewModel>(context, listen: false)
        .fetchNotifications();
    cancelAppointmentViewModel =
        Provider.of<CancelAppointmentViewModel>(context, listen: false);
    super.initState();
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
      centerTitle: true,
      leading: IconWidget(
        icon: Icons.arrow_back_ios,
        colors: Colors.white,
        size: 20,
        onTap: () {
          Navigator.pop(context);
        },
      ),
      title: TextWidget(
        text: constants.lblNotifications,
        colors: Colors.white,
        overflow: TextOverflow.visible,
        fontWeight: FontWeight.w600,
        fontsize: 18,
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
        return (notificationData.notifications != null)
            ? notificationData.notifications?.result != null
                ? ListView.builder(
                    itemCount: notificationData.notifications.result.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      notificationData.notifications.result
                          .sort((a, b) => b.createdOn.compareTo(a.createdOn));
                      return notificationView(
                          notification: notificationData.notifications,
                          index: index);
                    })
                : emptyNotification()
            : emptyNotification();
      case LoadingStatus.empty:
      default:
        return emptyNotification();
    }
  }

  Widget emptyNotification() {
    return Container(
      height: MediaQuery.of(context).size.height,
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
          : Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 5, bottom: 5),
                  child: Column(
                    children: [
                      ListTile(
                        onTap: () {
//                          if (message.messageBody
//                              .toLowerCase()
//                              .contains('book appointments')) {
//                            Navigator.push(
//                              context,
//                              MaterialPageRoute(
//                                  builder: (context) => MyProvidersMain()),
//                            );
//                          } else if (message.messageBody
//                                  .toLowerCase()
//                                  .contains("unread messages") ||
//                              message.messageTitle
//                                  .toLowerCase()
//                                  .contains('connection lost')) {
//                            Navigator.push(
//                              context,
//                              MaterialPageRoute(
//                                  builder: (context) => ChatHomeScreen()),
//                            );
//                          } else if (message.messageTitle
//                                  .toLowerCase()
//                                  .contains('appointment reminder') ||
//                              message.messageTitle
//                                  .toLowerCase()
//                                  .contains('confirmation') ||
//                              message.messageTitle
//                                  .toLowerCase()
//                                  .contains('rescheduled') ||
//                              message.messageTitle
//                                  .toLowerCase()
//                                  .contains('missed call')) {
//                            Navigator.push(
//                              context,
//                              MaterialPageRoute(
//                                  builder: (context) => AppointmentsMain()),
//                            );
//                          }
                        },
                        title: TextWidget(
                          text: message.messageTitle,
                          colors: Colors.black,
                          overflow: TextOverflow.visible,
                          fontWeight: FontWeight.w600,
                          fontsize: 13,
                          softwrap: true,
                        ),
                        subtitle: TextWidget(
                          text: message.messageBody,
                          colors: Colors.grey,
                          overflow: TextOverflow.visible,
                          fontWeight: FontWeight.w500,
                          fontsize: 12,
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
                              fontsize: 10,
                              softwrap: true,
                            ),
                            TextWidget(
                              text: constants.notificationTime(
                                  notification.result[index].createdOn),
                              colors: Color(CommonUtil().getMyPrimaryColor()),
                              overflow: TextOverflow.visible,
                              fontWeight: FontWeight.w600,
                              fontsize: 10,
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
                                                notification
                                                    ?.result[index]?.id);
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
                                      fontsize: 13,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 15,
                                  ),
                                  OutlineButton(
                                    onPressed: !notification
                                            ?.result[index]?.isActionDone
                                        ? () {
                                            //Reschedule
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
                                                        notificationId:
                                                            notification
                                                                ?.result[index]
                                                                ?.id,
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
                                      fontsize: 13,
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
            );
    } else {
      return Container();
    }
  }

  _displayDialog(
      BuildContext context, List<Past> appointments, String id) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            insetPadding: EdgeInsets.symmetric(horizontal: 8),
            backgroundColor: Colors.transparent,
            content: Container(
              width: double.maxFinite,
              height: 250.0,
              child: Column(
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4.0),
                        ),
                        child: Container(
                          height: 160,
                          padding: EdgeInsets.all(8.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              TextWidget(
                                  text: parameters
                                      .cancellationAppointmentConfirmation,
                                  fontsize: 14,
                                  fontWeight: FontWeight.w500,
                                  colors: Colors.grey[600]),
                              SizedBoxWidget(
                                height: 10,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: <Widget>[
                                  SizedBoxWithChild(
                                    width: 90,
                                    height: 40,
                                    child: FlatButton(
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(12.0),
                                          side: BorderSide(color: Colors.grey)),
                                      color: Colors.transparent,
                                      textColor: Colors.grey,
                                      padding: EdgeInsets.all(8.0),
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: TextWidget(
                                          text: parameters.no, fontsize: 12),
                                    ),
                                  ),
                                  SizedBoxWithChild(
                                    width: 90,
                                    height: 40,
                                    child: FlatButton(
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(12.0),
                                          side: BorderSide(
                                              color: Colors.blue[800])),
                                      color: Colors.transparent,
                                      textColor: Colors.blue[800],
                                      padding: EdgeInsets.all(8.0),
                                      onPressed: () {
                                        Navigator.pop(
                                            context,
                                            getCancelAppoitment(
                                                appointments, id));
                                      },
                                      child: TextWidget(
                                          text: parameters.yes, fontsize: 12),
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

  getCancelAppoitment(List<Past> appointments, String id) {
    cancelAppointment(appointments).then((value) {
      if (value == null) {
        toast.getToast(AppConstants.BOOKING_CANCEL, Colors.red);
      } else if (value.isSuccess == true) {
//        widget.onChanged(AppConstants.callBack);
        toast.getToast(AppConstants.YOUR_BOOKING_SUCCESS, Colors.green);
        //TODO call the ns action api
        FetchNotificationService().updateNsActionStatus(id).then((data) {
          if (data['isSuccess']) {
            print('ns actions has been updated');
          } else {
            print('ns actions not being updated');
          }
          Provider.of<FetchNotificationViewModel>(context, listen: false)
            ..clearNotifications()
            ..fetchNotifications();
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
}
