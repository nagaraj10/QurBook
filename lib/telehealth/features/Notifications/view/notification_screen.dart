import 'package:flutter/material.dart';
import 'package:gmiwidgetspackage/widgets/IconWidget.dart';
import 'package:gmiwidgetspackage/widgets/text_widget.dart';
import 'package:myfhb/common/CommonUtil.dart';
import 'package:myfhb/telehealth/features/Notifications/constants/notification_constants.dart'
    as constants;
import 'package:myfhb/telehealth/features/Notifications/model/messageContent.dart';
import 'package:myfhb/telehealth/features/Notifications/model/notification_model.dart';
import 'package:myfhb/telehealth/features/Notifications/viewModel/fetchNotificationViewModel.dart';
import 'package:myfhb/widgets/GradientAppBar.dart';
import 'package:provider/provider.dart';

class NotificationScreen extends StatefulWidget {
  @override
  _NotificationScreen createState() => _NotificationScreen();
}

class _NotificationScreen extends State<NotificationScreen> {
  @override
  void initState() {
    // TODO: implement initState
    Provider.of<FetchNotificationViewModel>(context, listen: false)
        .fetchNotifications();
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
          Provider.of<FetchNotificationViewModel>(context, listen: false)
            ..clearNotifications();
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
        return  Center(
          child:  CircularProgressIndicator(
            backgroundColor: Colors.grey,
          ),
        );
      case LoadingStatus.completed:
        return (notificationData.notifications != null)
            ? notificationData.notifications.result.length != 0
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
    if (notification.result[index].messageDetails.messageContent != null) {
      MessageContent message =
          notification.result[index].messageDetails.messageContent;
      return Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 5, bottom: 5),
            child: ListTile(
              onTap: () {},
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
                    text: constants
                        .notificationDate(notification.result[index].createdOn),
                    colors: Colors.black,
                    overflow: TextOverflow.visible,
                    fontWeight: FontWeight.w500,
                    fontsize: 10,
                    softwrap: true,
                  ),
                  TextWidget(
                    text: constants
                        .notificationTime(notification.result[index].createdOn),
                    colors: Color(CommonUtil().getMyPrimaryColor()),
                    overflow: TextOverflow.visible,
                    fontWeight: FontWeight.w600,
                    fontsize: 10,
                    softwrap: true,
                  ),
                ],
              ),
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
}
