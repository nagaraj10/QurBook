import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gmiwidgetspackage/widgets/IconWidget.dart';
import 'package:gmiwidgetspackage/widgets/SizeBoxWithChild.dart';
import 'package:gmiwidgetspackage/widgets/flutterToast.dart';
import 'package:gmiwidgetspackage/widgets/sized_box.dart';
import 'package:gmiwidgetspackage/widgets/text_widget.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:myfhb/caregiverAssosication/caregiverAPIProvider.dart';
import 'package:myfhb/constants/router_variable.dart';
import 'package:myfhb/my_family_detail/models/my_family_detail_arguments.dart';
import 'package:myfhb/src/ui/settings/CaregiverSettng.dart';
import 'package:myfhb/telehealth/features/MyProvider/view/BookingConfirmation.dart';
import 'package:myfhb/telehealth/features/MyProvider/viewModel/CreateAppointmentViewModel.dart';

import '../../../../claim/screen/ClaimRecordDisplay.dart';
import '../../../../common/CommonUtil.dart';
import '../../../../common/PreferenceUtil.dart';
import '../../../../constants/fhb_constants.dart';
import '../../../../constants/fhb_parameters.dart';
import '../../../../landing/view/landing_arguments.dart';
import '../../../../myPlan/view/myPlanDetail.dart';
import '../../../../regiment/models/regiment_arguments.dart';
import '../../../../regiment/view_model/regiment_view_model.dart';
import '../../../../src/ui/bot/view/sheela_arguments.dart';
import '../../../../src/ui/bot/viewmodel/chatscreen_vm.dart';
import '../../../../src/utils/language/language_utils.dart';
import '../../MyProvider/view/MyProvidersMain.dart';
import '../constants/notification_constants.dart' as constants;
import '../../../../common/common_circular_indicator.dart';
import '../../../../src/utils/screenutils/size_extensions.dart';
import '../../../../constants/fhb_parameters.dart' as parameters;
import '../model/notificationResult.dart';
import '../model/notification_ontap_req.dart';
import '../model/payload.dart';
import '../services/notification_services.dart';
import '../../appointments/constants/appointments_constants.dart'
    as AppConstants;
import '../model/messageContent.dart';
import '../model/notification_model.dart';
import '../viewModel/fetchNotificationViewModel.dart';
import '../../appointments/model/cancelAppointments/cancelModel.dart';
import '../../appointments/model/fetchAppointments/city.dart';
import '../../appointments/model/fetchAppointments/doctor.dart' as doctorObj;
import '../../appointments/model/fetchAppointments/past.dart';
import '../../appointments/view/appointmentsMain.dart';
import '../../appointments/view/resheduleMain.dart';
import '../../appointments/viewModel/cancelAppointmentViewModel.dart';
import '../../chat/view/home.dart';
import '../../../../widgets/GradientAppBar.dart';
import '../../../../widgets/checkout_page.dart';
import 'package:provider/provider.dart';
import 'package:get/get.dart';
import '../../MyProvider/view/TelehealthProviders.dart';
import '../../../../src/model/home_screen_arguments.dart';
import '../../../../constants/router_variable.dart' as router;
import '../../../../src/utils/PageNavigator.dart';
import '../../../../src/ui/bot/SuperMaya.dart';
import '../../../../src/model/user/user_accounts_arguments.dart';
import '../../../../src/blocs/Category/CategoryListBlock.dart';
import '../../../../src/ui/MyRecord.dart';
import '../../../../src/ui/MyRecordsArguments.dart';
import '../../../../src/model/Category/catergory_result.dart';
import '../../../../constants/fhb_constants.dart' as Constants;
import '../../../../constants/router_variable.dart' as routervariable;
import 'package:myfhb/telehealth/features/MyProvider/model/appointments/AppointmentNotificationPayment.dart';

class NotificationScreen extends StatefulWidget {
  @override
  _NotificationScreen createState() => _NotificationScreen();
}

class _NotificationScreen extends State<NotificationScreen> {
  FlutterToast toast = FlutterToast();
  CancelAppointmentViewModel cancelAppointmentViewModel;
  FetchNotificationViewModel notificationData;

  @override
  void initState() {
    mInitialTime = DateTime.now();
    // Provider.of<FetchNotificationViewModel>(context, listen: false)
    //     .fetchNotifications();
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
    fbaLog(eveName: 'qurbook_screen_event', eveParams: {
      'eventTime': '${DateTime.now()}',
      'pageName': 'Notification Screen',
      'screenSessionTime':
          '${DateTime.now().difference(mInitialTime).inSeconds} secs'
    });
    notificationData?.pagingController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    notificationData = Provider.of<FetchNotificationViewModel>(context);
    return Scaffold(
      appBar: notificationAppBar(context),
      body: notificationBodyView(),
    );
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
                notificationData.fetchNotifications();
              },
            ),
            CupertinoDialogAction(
              child: Text(
                'Delete',
                style: TextStyle(
                  color: Color(
                    CommonUtil().getMyPrimaryColor(),
                  ),
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                notificationData.deleteTheSelectedNotifiations();
              },
            ),
          ],
        );
      },
    );
  }

  Widget notificationAppBar(BuildContext context) {
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

      // (notificationData?.deleteMode ?? false)
      //     ? [
      //         InkWell(
      //           onTap: () {
      //             notificationData.selectOrDeselectAllTapped();
      //           },
      //           child: Center(
      //             child: Text(
      //               'Select All',
      //               style: TextStyle(
      //                 color: Colors.white,
      //               ),
      //             ),
      //           ),
      //         ),
      //         SizedBox(
      //           width: 16,
      //         ),
      //         IconWidget(
      //           icon: Icons.delete,
      //           colors: Colors.white,
      //           size: 24.0.sp,
      //           onTap: () {
      //             showDeleteAlert(context);
      //           },
      //         ),
      //         SizedBox(
      //           width: 16,
      //         )
      //       ]
      //     : [],
    );
  }

  Future<void> _showNotificationClearDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Alert'),
          content: SingleChildScrollView(
            child: ListBody(
              children: const <Widget>[
                Text('Would you like to clear the notifications?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Ok'),
              onPressed: () {
                callClearAllApi();
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Cancel'),
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
    print(body);
    FetchNotificationService().clearNotifications(body).then((data) {
      if (data != null && data) {
        Provider.of<FetchNotificationViewModel>(context, listen: false)
          //..clearNotifications()
          ..fetchNotifications();
      } else {
        Provider.of<FetchNotificationViewModel>(context, listen: false)
          //..clearNotifications()
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
        print(body);
        FetchNotificationService().updateNsOnTapAction(body).then((data) {
          if (data != null && data['isSuccess']) {
            Provider.of<FetchNotificationViewModel>(context, listen: false)
              //..clearNotifications()
              ..fetchNotifications();
          } else {
            Provider.of<FetchNotificationViewModel>(context, listen: false)
              //..clearNotifications()
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
    return listView(notificationData.pagingController.itemList);
    // switch (notificationData.loadingStatus) {
    //   case LoadingStatus.searching:
    //     return CommonCircularIndicator();
    //   case LoadingStatus.completed:
    //     return (notificationData != null)
    //         ? (notificationData.pagingController.itemList != null)
    //             ? (notificationData.pagingController.itemList != null) &&
    //                     (notificationData.pagingController.itemList.length > 0)
    //                 ? listView(notificationData.pagingController.itemList)
    //                 : emptyNotification()
    //             : emptyNotification()
    //         : emptyNotification();
    //   case LoadingStatus.empty:
    //   default:
    //     return emptyNotification();
    // }
  }

  Widget listView(List<NotificationResult> notification) {
    // List<NotificationResult> pendingNotification = new List();
    // List<NotificationResult> readNotification = new List();
    // List<NotificationResult> mainNotificationList = new List();

    // notification.result.sort((a, b) => b.createdOn.compareTo(a.createdOn));

    // for (int i = 0; i < notification.result.length; i++) {
    //   if (!notification?.result[i]?.isActionDone &&
    //       notification?.result[i]?.isUnread) {
    //     //this is for action button notification
    //     pendingNotification.add(notification.result[i]);
    //   } else if (notification?.result[i]?.isUnread) {
    //     //this is for normal notification
    //     pendingNotification.add(notification.result[i]);
    //   } else {
    //     readNotification.add(notification.result[i]);
    //   }

    //   mainNotificationList = []
    //     ..addAll(pendingNotification)
    //     ..addAll(readNotification);
    // }
    return PagedListView(
      pagingController: notificationData.pagingController,
      builderDelegate: PagedChildBuilderDelegate<NotificationResult>(
        itemBuilder: (context, item, index) =>
            notificationView(notification: item),
        noItemsFoundIndicatorBuilder: (_) => emptyNotification(),
        newPageErrorIndicatorBuilder: (_) => emptyNotification(),
        firstPageErrorIndicatorBuilder: (_) => emptyNotification(),
      ),
    );
    // return ListView.builder(
    //     itemCount: notification.length,
    //     shrinkWrap: true,
    //     itemBuilder: (context, index) {
    //       return notificationView(notification: notification[index]);
    //     });
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

  Widget notificationView({NotificationResult notification}) {
    if (notification?.messageDetails != null) {
      Payload payload = notification?.messageDetails?.payload;
      MessageContent message = notification.messageDetails?.messageContent;
      return (message.messageBody == "" || message.messageTitle == "")
          ? Container()
          : InkWell(
              onLongPress: () {
                // if ((notificationData?.deleteLogId?.length ?? 0) == 0) {
                //   notificationData.deleteMode = true;
                //   notification.deleteSelected = true;
                //   notificationData.addTheidToDelete(notification.id);
                // }
              },
              splashColor: Color(CommonUtil.secondaryGrey),
              onTap: notificationData.deleteMode
                  ? () {
                      if (notification.deleteSelected) {
                        notification.deleteSelected = false;

                        notificationData.removeTheIdToDelete(notification.id);
                      } else {
                        notification.deleteSelected = true;
                        notificationData.addTheidToDelete(notification.id);
                      }
                    }
                  : (notification?.isUnread ?? false)
                      ? () {
                          var tempRedirectTo = payload?.redirectTo != null &&
                                  payload?.redirectTo != ''
                              ? payload?.redirectTo.split('|')[0]
                              : '';
                          if (tempRedirectTo == 'myRecords') {
                            if ((payload?.healthRecordMetaIds ?? '')
                                .isNotEmpty) {
                              notificationOnTapActions(
                                  notification, tempRedirectTo,
                                  bundles: {
                                    'catName':
                                        payload?.redirectTo.split('|')[1],
                                    'healthRecordMetaIds':
                                        payload?.healthRecordMetaIds
                                  });
                            } else {
                              final split = payload?.redirectTo?.split('|');
                              var redirectData = {
                                for (int i = 0; i < split.length; i++)
                                  i: split[i]
                              };
                              var id = redirectData[2];
                              if (id.runtimeType == String &&
                                  (id ?? '').isNotEmpty) {
                                final userId =
                                    PreferenceUtil.getStringValue(KEY_USERID);
                                if ((payload?.userId ?? '') == userId) {
                                  CommonUtil()
                                      .navigateToRecordDetailsScreen(id);
                                } else {
                                  CommonUtil.showFamilyMemberPlanExpiryDialog(
                                    (payload?.patientName ?? ''),
                                    redirect: (payload?.redirectTo ?? ''),
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
                          } else {
                            readUnreadAction(notification);
                          }
                          // notificationOnTapActions(
                          //     notification?.result[index],
                          //     notification?.result[index]?.messageDetails?.content
                          //         ?.templateName);
                        }
                      : null,
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
                                            (notification?.isUnread == null ||
                                                    !notification?.isUnread)
                                                ? Colors.black
                                                : Color(CommonUtil()
                                                    .getMyPrimaryColor()),
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
                                            notification?.createdOn),
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
                                            notification?.createdOn),
                                        colors:
                                            (notification?.isUnread == null ||
                                                    !notification?.isUnread)
                                                ? Colors.black
                                                : Color(CommonUtil()
                                                    .getMyPrimaryColor()),
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
                                  text: AppConstants.cancel,
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
                                  text: AppConstants.reschedule,
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
        toast.getToast(TranslationConstants.bookingCancel.t(), Colors.red);
      } else if (value.isSuccess == true) {
//        widget.onChanged(AppConstants.callBack);
        toast.getToast(
            TranslationConstants.yourBookingSuccess.t(), Colors.green);
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
        )).then(
            (value) => PageNavigator.goToPermanent(context, router.rt_Landing));
        readUnreadAction(result);
        break;
      case "PaymentReceipt":
      case "appointmentPayment":
        Get.to(BookingConfirmation(
            isFromPaymentNotification: true,
            appointmentId: result?.messageDetails?.payload?.appointmentId));
        readUnreadAction(result);

        break;
      case "PaymentConfirmation":
        Get.to(TelehealthProviders(
          arguments: HomeScreenArguments(
              selectedIndex: 0,
              bookingId: result?.messageDetails?.payload?.bookingId,
              date: result?.messageDetails?.payload?.appointmentDate,
              templateName: result?.messageDetails?.content?.templateName),
        )).then(
            (value) => PageNavigator.goToPermanent(context, router.rt_Landing));
        readUnreadAction(result);
        break;
      case "SlotsFull":
        Get.to(TelehealthProviders(
          arguments: HomeScreenArguments(
              selectedIndex: 0,
              bookingId: result?.messageDetails?.payload?.bookingId,
              date: result?.messageDetails?.payload?.appointmentDate,
              templateName: result?.messageDetails?.content?.templateName),
        )).then(
            (value) => PageNavigator.goToPermanent(context, router.rt_Landing));
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
      case myPlanDetails:
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
        Get.to(SuperMaya()).then(
            (value) => PageNavigator.goToPermanent(context, router.rt_Landing));
        readUnreadAction(result);
        break;
      case "profile_page":
        Get.toNamed(router.rt_UserAccounts,
                arguments: UserAccountsArguments(selectedIndex: 0))
            .then((value) =>
                PageNavigator.goToPermanent(context, router.rt_Landing));
        readUnreadAction(result);
        break;
      case "googlefit":
        Get.toNamed(router.rt_AppSettings).then(
            (value) => PageNavigator.goToPermanent(context, router.rt_Landing));
        readUnreadAction(result);
        break;
      case "th_provider":
        Get.toNamed(router.rt_TelehealthProvider,
                arguments: HomeScreenArguments(selectedIndex: 1))
            .then((value) =>
                PageNavigator.goToPermanent(context, router.rt_Landing));
        readUnreadAction(result);
        break;
      case "my_record":
        getProfileData();
        Get.toNamed(router.rt_HomeScreen,
                arguments: HomeScreenArguments(selectedIndex: 1))
            .then((value) =>
                PageNavigator.goToPermanent(context, router.rt_Landing));
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
      case "sheela|pushMessage":
        if (result?.messageDetails?.payload?.redirectTo?.contains("sheela")) {
          var redirectArray =
              result?.messageDetails?.payload?.redirectTo?.split("|");
          if (redirectArray.length > 1 && redirectArray[1] == "pushMessage") {
            var rawBody, rawTitle;
            rawBody = result?.messageDetails?.rawMessage?.messageBody;
            rawTitle = result?.messageDetails?.rawMessage?.messageTitle;

            fbaLog(eveParams: {
              'eventTime': '${DateTime.now()}',
              'ns_type': 'sheela',
              'navigationPage': 'Sheela Start Page',
            });

            String sheela_lang =
                PreferenceUtil.getStringValue(Constants.SHEELA_LANG);
            if ((Provider.of<ChatScreenViewModel>(context, listen: false)
                        ?.conversations
                        ?.length ??
                    0) >
                0) {
              Provider.of<ChatScreenViewModel>(context, listen: false)
                  ?.startMayaAutomatically(message: rawBody);
            } else if (sheela_lang != null && sheela_lang != '') {
              Get.toNamed(
                routervariable.rt_Sheela,
                arguments: SheelaArgument(
                  isSheelaAskForLang: false,
                  langCode: sheela_lang,
                  rawMessage: rawBody,
                ),
              ).then((value) =>
                  PageNavigator.goToPermanent(context, router.rt_Landing));
              readUnreadAction(result);
            } else {
              Get.toNamed(
                routervariable.rt_Sheela,
                arguments: SheelaArgument(
                  isSheelaAskForLang: true,
                  rawMessage: rawBody,
                ),
              ).then((value) =>
                  PageNavigator.goToPermanent(context, router.rt_Landing));
              readUnreadAction(result);
            }
          } else {
            Get.to(SuperMaya());
          }
        }
        break;
      case "mycart":
        Get.to(CheckoutPage(
          isFromNotification: true,
          bookingId: result?.messageDetails?.payload?.bookingId,
          cartUserId: result?.messageDetails?.payload?.userId,
          notificationListId: result?.messageDetails?.payload?.createdBy,
        )).then(
            (value) => PageNavigator.goToPermanent(context, router.rt_Landing));
        readUnreadAction(result);
        break;
      case "devices_tab":
        getProfileData();
        Get.toNamed(
          router.rt_HomeScreen,
          arguments: HomeScreenArguments(selectedIndex: 1, thTabIndex: 1),
        ).then(
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
        )?.regimentMode = RegimentMode.Schedule;
        Provider.of<RegimentViewModel>(context, listen: false)?.regimentFilter =
            RegimentFilter.Missed;
        Get.toNamed(router.rt_Regimen, arguments: RegimentArguments()).then(
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
      // Provider.of<FetchNotificationViewModel>(context, listen: false)
      //   //..clearNotifications()
      //   ..fetchNotifications();
    });
  }

  void getProfileData() async {
    try {
      await new CommonUtil().getUserProfileData();
    } catch (e) {}
  }

  Widget createNSActionButton(
      String templateName, NotificationResult notification) {
    Payload payload = notification.messageDetails?.payload;
    var message = notification.messageDetails?.messageContent;
    switch (templateName) {
      case constants.strCancelByDoctor:
      case constants.strRescheduleByDoctor:
        return Padding(
          padding: EdgeInsets.only(left: 0, right: 0),
          child: Row(
            children: [
              OutlineButton(
                onPressed: !notification?.isActionDone
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
                                            id: notification.messageDetails
                                                .payload.doctorId),
                                        doctorSessionId: notification
                                            .messageDetails
                                            .payload
                                            .doctorSessionId,
                                        healthOrganization: City(
                                            id: notification.messageDetails
                                                .payload.healthOrganizationId),
                                        bookingId: notification
                                            .messageDetails.payload.bookingId),
                                    body: body,
                                  )),
                        ).then((value) {
                          if (notification?.isUnread != null &&
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
                borderSide: !notification?.isActionDone
                    ? BorderSide(color: Color(CommonUtil().getMyPrimaryColor()))
                    : BorderSide(color: Colors.grey),
                child: TextWidget(
                  text: TranslationConstants.reschedule.t(),
                  colors: !notification?.isActionDone
                      ? Color(CommonUtil().getMyPrimaryColor())
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
                onPressed: !notification?.isActionDone
                    ? () {
                        var body = {};
                        body['templateName'] = payload?.templateName;
                        body['contextId'] = payload?.bookingId;
                        _displayDialog(
                            context,
                            [
                              Past(
                                  bookingId: notification
                                      .messageDetails.payload.bookingId,
                                  plannedStartDateTime: notification
                                      .messageDetails
                                      .payload
                                      .plannedStartDateTime)
                            ],
                            body,
                            notification);
                      }
                    : null,
                borderSide: !notification?.isActionDone
                    ? BorderSide(color: Color(CommonUtil().getMyPrimaryColor()))
                    : BorderSide(color: Colors.grey),
                child: TextWidget(
                  text: TranslationConstants.cancel.t(),
                  colors: !notification?.isActionDone
                      ? Color(CommonUtil().getMyPrimaryColor())
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
              OutlineButton(
                onPressed: !notification?.isActionDone
                    ? () {
                        final currentUserId =
                            PreferenceUtil.getStringValue(KEY_USERID);
                        if (currentUserId ==
                            notification?.messageDetails?.payload?.userId) {
                          Get.to(
                            MyPlanDetail(
                              packageId:
                                  notification?.messageDetails?.payload?.planId,
                              templateName: notification
                                  ?.messageDetails?.payload?.templateName,
                              showRenew: true,
                            ),
                          ).then((value) => PageNavigator.goToPermanent(
                              context, router.rt_Landing));
                        } else {
                          CommonUtil.showFamilyMemberPlanExpiryDialog(
                              notification
                                  ?.messageDetails?.payload?.patientName);
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
                borderSide: !notification?.isActionDone
                    ? BorderSide(color: Color(CommonUtil().getMyPrimaryColor()))
                    : BorderSide(color: Colors.grey),
                child: TextWidget(
                  text: TranslationConstants.renew.t(),
                  colors: !notification?.isActionDone
                      ? Color(CommonUtil().getMyPrimaryColor())
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
                onPressed: !notification?.isActionDone
                    ? () {
                        CommonUtil().CallbackAPI(
                          notification?.messageDetails?.payload?.patientName,
                          notification?.messageDetails?.payload?.planId,
                          notification?.messageDetails?.payload?.userId,
                        );
                        var body = {};
                        body['templateName'] = payload?.templateName;
                        body['contextId'] =
                            notification?.messageDetails?.payload?.planId;
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
                borderSide: !notification?.isActionDone
                    ? BorderSide(color: Color(CommonUtil().getMyPrimaryColor()))
                    : BorderSide(color: Colors.grey),
                child: TextWidget(
                  text: TranslationConstants.callback.t(),
                  colors: !notification?.isActionDone
                      ? Color(CommonUtil().getMyPrimaryColor())
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
              OutlineButton(
                onPressed: () async {
                  if ((notification?.messageDetails?.payload
                                  ?.patientPhoneNumber ??
                              '')
                          .isNotEmpty &&
                      (notification
                                  ?.messageDetails?.payload?.verificationCode ??
                              '')
                          .isNotEmpty) {
                    CaregiverAPIProvider().approveCareGiver(
                      phoneNumber: notification
                          ?.messageDetails?.payload?.patientPhoneNumber,
                      code: notification
                          ?.messageDetails?.payload?.verificationCode,
                    );
                  }
                  Provider.of<FetchNotificationViewModel>(context,
                          listen: false)
                      .fetchNotifications();
                },
                borderSide: BorderSide(
                  color: Color(
                    CommonUtil().getMyPrimaryColor(),
                  ),
                ),
                child: TextWidget(
                  text: parameters.accept,
                  colors: Color(CommonUtil().getMyPrimaryColor()),
                  overflow: TextOverflow.visible,
                  fontWeight: FontWeight.w600,
                  fontsize: 15.0.sp,
                ),
              ),
              SizedBox(
                width: 15.0.w,
              ),
              OutlineButton(
                onPressed: () async {
                  if ((notification?.messageDetails?.payload
                                  ?.caregiverReceiver ??
                              '')
                          .isNotEmpty &&
                      (notification?.messageDetails?.payload
                                  ?.caregiverRequestor ??
                              '')
                          .isNotEmpty) {
                    CaregiverAPIProvider().rejectCareGiver(
                      receiver: notification
                          ?.messageDetails?.payload?.caregiverReceiver,
                      requestor: notification
                          ?.messageDetails?.payload?.caregiverRequestor,
                    );
                  }
                  Provider.of<FetchNotificationViewModel>(context,
                          listen: false)
                      .fetchNotifications();
                },
                borderSide: BorderSide(
                  color: Color(
                    CommonUtil().getMyPrimaryColor(),
                  ),
                ),
                child: TextWidget(
                  text: parameters.reject,
                  colors: Color(
                    CommonUtil().getMyPrimaryColor(),
                  ),
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
              OutlineButton(
                onPressed: () async {
                  if ((notification
                              ?.messageDetails?.payload?.caregiverRequestor ??
                          '')
                      .isNotEmpty) {
                    Navigator.pushNamed(
                      context,
                      router.rt_FamilyDetailScreen,
                      arguments: MyFamilyDetailArguments(
                          caregiverRequestor: notification?.messageDetails
                                  ?.payload?.caregiverRequestor ??
                              ''),
                    );
                  }
                },
                borderSide: BorderSide(
                  color: Color(
                    CommonUtil().getMyPrimaryColor(),
                  ),
                ),
                child: TextWidget(
                  text: parameters.viewMember,
                  colors: Color(CommonUtil().getMyPrimaryColor()),
                  overflow: TextOverflow.visible,
                  fontWeight: FontWeight.w600,
                  fontsize: 14.0.sp,
                ),
              ),
              SizedBox(
                width: 15.0.w,
              ),
              OutlineButton(
                onPressed: () async {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CareGiverSettings(),
                    ),
                  );
                },
                borderSide: BorderSide(
                  color: Color(
                    CommonUtil().getMyPrimaryColor(),
                  ),
                ),
                child: TextWidget(
                  text: parameters.communicationSetting,
                  colors: Color(
                    CommonUtil().getMyPrimaryColor(),
                  ),
                  overflow: TextOverflow.visible,
                  fontWeight: FontWeight.w600,
                  fontsize: 14.0.sp,
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
              OutlineButton(
                onPressed: () async {
                  checkIfPaymentLinkIsExpired(
                          notification?.messageDetails?.payload?.appointmentId)
                      .then((value) {
                    if (value) {
                      Get.to(BookingConfirmation(
                          isFromPaymentNotification: true,
                          appointmentId: notification
                              ?.messageDetails?.payload?.appointmentId));
                    } else {
                      toast.getToast('Payment Link Expired', Colors.red);
                    }
                  });
                },
                borderSide: BorderSide(
                  color: Color(
                    CommonUtil().getMyPrimaryColor(),
                  ),
                ),
                child: TextWidget(
                  text: 'PAY',
                  colors: Color(CommonUtil().getMyPrimaryColor()),
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
              OutlineButton(
                onPressed: () async {
                  checkIfPaymentLinkIsExpired(
                          notification?.messageDetails?.payload?.bookingId)
                      .then((value) {
                    if (value) {
                      Get.to(CheckoutPage(
                        isFromNotification: true,
                        bookingId:
                            notification?.messageDetails?.payload?.bookingId,
                        cartUserId:
                            notification?.messageDetails?.payload?.userId,
                        notificationListId:
                            notification?.messageDetails?.payload?.createdBy,
                      )).then((value) => PageNavigator.goToPermanent(
                          context, router.rt_Landing));
                    } else {
                      toast.getToast('Payment Link Expired', Colors.red);
                    }
                  });
                },
                borderSide: BorderSide(
                  color: Color(
                    CommonUtil().getMyPrimaryColor(),
                  ),
                ),
                child: TextWidget(
                  text: 'PAY',
                  colors: Color(CommonUtil().getMyPrimaryColor()),
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

      default:
        return Container();
        break;
    }
  }

  Future<bool> checkIfPaymentLinkIsExpired(String appointmentId) async {
    bool paymentStatus = false;
    CreateAppointMentViewModel createAppointMentViewModel =
        new CreateAppointMentViewModel();
    AppointmentNotificationPayment appointmentNotificationPayment =
        await createAppointMentViewModel
            .getAppointmentDetailsUsingId(appointmentId);
    if (appointmentNotificationPayment != null) {
      if (appointmentNotificationPayment?.result?.appointment?.status != null) {
        if (appointmentNotificationPayment?.result?.appointment?.status.code ==
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
