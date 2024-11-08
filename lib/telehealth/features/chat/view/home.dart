import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:gmiwidgetspackage/widgets/sized_box.dart';
import 'package:intl/intl.dart';

import '../../../../common/CommonUtil.dart';
import '../../../../common/PreferenceUtil.dart';
import '../../../../common/common_circular_indicator.dart';
import '../../../../common/errors_widget.dart';
import '../../../../constants/fhb_constants.dart' as Constants;
import '../../../../constants/fhb_constants.dart';
import '../../../../constants/router_variable.dart';
import '../../../../constants/variable_constant.dart' as variable;
import '../../../../landing/model/qur_plan_dashboard_model.dart';
import '../../../../landing/view/landing_arguments.dart';
import '../../../../main.dart';
import '../../../../src/model/user/MyProfileModel.dart';
import '../../../../src/utils/screenutils/size_extensions.dart';
import '../../../../widgets/GradientAppBar.dart';
import '../constants/const.dart';
import '../viewModel/ChatViewModel.dart';
import 'chat.dart';

import '../../../../services/notification_helper.dart';

class ChatHomeScreen extends StatefulWidget {
  ChatHomeScreen({
    Key? key,
    this.isHome = false,
    this.onBackPressed,
    this.careGiversList,
    this.isDynamicLink = false,
  }) : super(key: key);

  final bool isHome;
  final Function? onBackPressed;
  final List<CareGiverInfo>? careGiversList;
  final bool isDynamicLink;

  @override
  State createState() => HomeScreenState();
}

class HomeScreenState extends State<ChatHomeScreen> {
  HomeScreenState({Key? key});

  final FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  bool isLoading = false;

  String? patientId = '';
  String patientName = '';

  ChatViewModel chatViewModel = ChatViewModel();

  Future<String?> getPatientDetails() async {
    patientId = PreferenceUtil.getStringValue(Constants.KEY_USERID);
    print(patientId);

    MyProfileModel myProfile =
        PreferenceUtil.getProfileData(Constants.KEY_PROFILE)!;
    patientName = myProfile.result != null
        ? myProfile.result!.firstName! + myProfile.result!.firstName!
        : '';
    return patientId;
  }

  void registerNotification() {
    firebaseMessaging.requestPermission();

    FirebaseMessaging.onMessage.listen(
      (RemoteMessage message) {
        Platform.isAndroid
            ? showNotification(message.notification)
            : showNotification(message.data['aps']['alert']);
        return;
      },
    );
    FirebaseMessaging.onMessageOpenedApp.listen(
      (RemoteMessage message) {
        print('onResume: $message');
        return;
      },
    );

    firebaseMessaging.getToken().then((token) {
      print('FCMToken: ' + token!);

      FirebaseFirestore.instance
          .collection(STR_USERS)
          .doc(patientId)
          .update({STR_PUSH_TOKEN: token});
    }).catchError((err) {
      Fluttertoast.showToast(msg: err.message.toString());
    });
  }

  void configLocalNotification() {
    var initializationSettingsAndroid =
        AndroidInitializationSettings(STR_MIP_MAP_LAUNCHER);
    var initializationSettingsIOS = DarwinInitializationSettings(
        notificationCategories: darwinIOSCategories);
    var initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
    flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  void showNotification(message) async {
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      Platform.isAndroid
          ? 'com.ventechsolutions.myFHB'
          : 'com.ventechsolutions.myFHB',
      'Flutter chat demo',
      channelDescription: 'your channel description',
      playSound: true,
      enableVibration: true,
      importance: Importance.max,
      priority: Priority.high,
    );
    var iOSPlatformChannelSpecifics = DarwinNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: iOSPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.show(0, message['title'].toString(),
        message['body'].toString(), platformChannelSpecifics,
        payload: json.encode(message));
  }

  Future<bool> onBackPress() {
    if (!widget.isHome) {
      if (Navigator.canPop(context)) {
        Get.back();
      } else {
        Get.offAllNamed(
          rt_Landing,
          arguments: const LandingArguments(
            needFreshLoad: false,
          ),
        );
      }
    } else {
      widget.onBackPressed!();
    }
    return Future.value(false);
  }

  Future<Null> openDialog() async {
    switch (await showDialog(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
            contentPadding:
                EdgeInsets.only(left: 0.0, right: 0.0, top: 0.0, bottom: 0.0),
            children: <Widget>[
              Container(
                color: themeColor,
                margin: EdgeInsets.all(0.0),
                padding: EdgeInsets.only(bottom: 10.0, top: 10.0),
                height: 100.0,
                child: Column(
                  children: <Widget>[
                    Container(
                      child: Icon(
                        Icons.exit_to_app,
                        size: 30.0,
                        color: Colors.white,
                      ),
                      margin: EdgeInsets.only(bottom: 10.0),
                    ),
                    Text(
                      EXIT_APP,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 18.0.sp,
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      EXIT_APP_TO_EXIT,
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 16.0.sp,
                      ),
                    ),
                  ],
                ),
              ),
              SimpleDialogOption(
                onPressed: () {
                  Navigator.pop(context, 0);
                },
                child: Row(
                  children: <Widget>[
                    Container(
                      child: Icon(
                        Icons.cancel,
                        color: primaryColor,
                      ),
                      margin: EdgeInsets.only(right: 10.0),
                    ),
                    Text(
                      CANCEL,
                      style: TextStyle(
                        color: primaryColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0.sp,
                      ),
                    )
                  ],
                ),
              ),
              SimpleDialogOption(
                onPressed: () {
                  Navigator.pop(context, 1);
                },
                child: Row(
                  children: <Widget>[
                    Container(
                      child: Icon(
                        Icons.check_circle,
                        color: primaryColor,
                      ),
                      margin: EdgeInsets.only(right: 10.0),
                    ),
                    Text(
                      YES,
                      style: TextStyle(
                        color: primaryColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0.sp,
                      ),
                    )
                  ],
                ),
              ),
            ],
          );
        })) {
      case 0:
        break;
      case 1:
        exit(0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: widget.isHome
          ? null
          : AppBar(
              flexibleSpace: GradientAppBar(),
              leading: IconButton(
                  icon: Icon(
                    Icons.arrow_back_ios,
                    size: 24.0.sp,
                  ),
                  onPressed: () {
                    onBackPress();
                  }),
              elevation: 0.0,
              backgroundColor: Colors.transparent,
              title: Text(
                ((widget.careGiversList?.length ?? 0) > 0 ||
                        widget.isDynamicLink)
                    ? CAREPROVIDERS
                    : CHAT,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16.0.sp,
                ),
              ),
              centerTitle: true,
              actions: [
                Center(child: CommonUtil().getNotificationIcon(context)),
                SizedBoxWidget(
                  width: 10,
                ),
              ],
            ),
      body: WillPopScope(
        child: checkIfDoctorIdExist(),
        onWillPop: onBackPress,
      ),
    );
  }

  Widget checkIfDoctorIdExist() {
    return FutureBuilder<String?>(
      future: getPatientDetails(),
      builder: (BuildContext context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            body: CommonCircularIndicator(),
          );
        } else if (snapshot.hasError) {
          return ErrorsWidget();
        } else {
          return getChatList();
        }
      },
    );
  }

  Widget getChatList() {
    Stream<QuerySnapshot> stream;

    var careGiverIds = [];

    if ((widget.careGiversList?.length ?? 0) > 0) {
      widget.careGiversList?.forEach((careGiver) {
        careGiverIds.add(careGiver.doctorId);
      });
      stream = FirebaseFirestore.instance
          .collection(STR_CHAT_LIST)
          .doc(patientId)
          .collection(STR_USER_LIST)
          .where(
            'id',
            whereIn: careGiverIds,
          )
          .orderBy(STR_CREATED_AT, descending: true)
          .snapshots();
    } else {
      stream = FirebaseFirestore.instance
          .collection(STR_CHAT_LIST)
          .doc(patientId)
          .collection(STR_USER_LIST)
          .orderBy(STR_CREATED_AT, descending: true)
          .snapshots();
    }
    return Stack(
      children: <Widget>[
        // List
        Container(
          child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
            stream: stream as Stream<QuerySnapshot<Map<String, dynamic>>>?,
            builder: (context,
                AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
              if (!snapshot.hasData) {
                return CommonCircularIndicator();
              } else {
                return countChatListUsers(patientId, snapshot)! > 0
                    ? ListView.builder(
                        padding: EdgeInsets.all(10.0),
                        itemBuilder: (context, index) => buildItem(
                            context,
                            snapshot.data!.docs[index],
                            snapshot,
                            index,
                            careGiverIds),
                        itemCount: snapshot.data!.docs.length,
                      )
                    : Container(
                        child: Center(
                            child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              'No Messages',
                              style: TextStyle(
                                  fontSize: 16.0.sp, color: Colors.grey[800]),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        )),
                      );
              }
            },
          ),
        ),

        // Loading
        Positioned(
          child: isLoading ? CommonCircularIndicator() : Container(),
        )
      ],
    );
  }

  Widget buildItem(BuildContext context, DocumentSnapshot document,
      chatListSnapshot, int index, List careGiverIds) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection(STR_USERS)
          .doc(document.id)
          .snapshots(),
      builder: (context, AsyncSnapshot<DocumentSnapshot> snapshotUser) {
        if (snapshotUser.hasData) {
          String? lastMessage = document[STR_LAST_MESSAGE];
          if (document[STR_ID] == patientId) {
            return Container();
          } else {
            return Column(
              children: <Widget>[
                InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Chat(
                                  peerId: document.id,
                                  peerAvatar: document[STR_PHOTO_URL],
                                  peerName:
                                      snapshotUser.data![STR_NICK_NAME] != ''
                                          ? snapshotUser.data![STR_NICK_NAME]
                                          : '',
                                  lastDate: getFormattedDateTime(
                                      (document[STR_CREATED_AT] as Timestamp)
                                          .toDate()
                                          .toString()),
                                  patientId: '',
                                  patientName: '',
                                  patientPicture: '',
                                  isFromVideoCall: false,
                                  isCareGiver:
                                      careGiverIds.length > 0 ? true : false,
                                )));
                  },
                  child: Container(
                    child: Row(
                      children: <Widget>[
                        SizedBox(width: 1.sw * 0.025),
                        Container(
                          width: 1.sw * 0.12,
                          height: 1.sw * 0.12,
                          child: Row(
                            children: [
                              Expanded(
                                child: ClipOval(
                                  child: document[STR_PHOTO_URL] != null
                                      ? CachedNetworkImage(
                                          placeholder: (context, url) =>
                                              Container(
                                                child:
                                                    CommonCircularIndicator(),
                                                width: 50.0,
                                                height: 50.0,
                                                padding: EdgeInsets.all(15.0),
                                              ),
                                          imageUrl: document[STR_PHOTO_URL],
                                          width: 50.0,
                                          height: 50.0,
                                          fit: BoxFit.cover,
                                          errorWidget: (context, url, error) =>
                                              Container(
                                                height: 50.0.h,
                                                width: 50.0.h,
                                                color: Colors.grey[200],
                                                child: Center(
                                                    child: Text(
                                                  snapshotUser.data![
                                                              STR_NICK_NAME] !=
                                                          ''
                                                      ? snapshotUser
                                                          .data![STR_NICK_NAME]
                                                              [0]
                                                          .toString()
                                                          .toUpperCase()
                                                      : '',
                                                  style: TextStyle(
                                                    color: mAppThemeProvider.primaryColor,
                                                    fontSize: 16.0.sp,
                                                    fontWeight: FontWeight.w400,
                                                  ),
                                                )),
                                              ))
                                      : Icon(
                                          Icons.account_circle,
                                          size: 50.0,
                                          color: greyColor,
                                        ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          width: 1.sw * 0.055,
                        ),
                        Container(
                          child: Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 4),
                                  child: Text(
                                    /* toBeginningOfSentenceCase(
                                        snapshotUser.data[STR_NICK_NAME]), */
                                    (snapshotUser.data![STR_NICK_NAME] != '' &&
                                            snapshotUser.data![STR_NICK_NAME] !=
                                                null
                                        ? snapshotUser.data![STR_NICK_NAME]
                                            ?.toString()
                                            .capitalizeFirstofEach
                                        : '')!,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                    style: TextStyle(
                                        fontWeight: FontWeight.w400,
                                        fontSize: 15.0.sp,
                                        fontFamily: variable.font_poppins),
                                  ),
                                ),
                                SizedBox(
                                  height: 1,
                                ),
                                Container(
                                  constraints:
                                      BoxConstraints(maxWidth: 1.sw * 0.5),
                                  padding: const EdgeInsets.only(bottom: 4),
                                  child: lastMessage != null
                                      ? lastMessage.contains(STR_HTTPS)
                                          ? Row(
                                              children: [
                                                Icon(
                                                  Icons.photo,
                                                  size: 16.0.sp,
                                                  color: Colors.black54,
                                                ),
                                                SizedBoxWidget(
                                                  width: 3,
                                                ),
                                                Text(
                                                  STR_FILE,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                      color: Colors.grey[600],
                                                      fontSize: 14.0.sp,
                                                      fontFamily: variable
                                                          .font_poppins),
                                                )
                                              ],
                                            )
                                          : Text(
                                              lastMessage,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.grey[600],
                                                  fontSize: 14.0.sp,
                                                  fontFamily:
                                                      variable.font_poppins),
                                            )
                                      : '' as Widget?,
                                ),
                                SizedBox(
                                  height: 1,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 4),
                                  child: Text(
                                    document[STR_CREATED_AT] != null
                                        ? LAST_RECEIVED +
                                            getFormattedDateTime(
                                                (document[STR_CREATED_AT]
                                                        as Timestamp)
                                                    .toDate()
                                                    .toString())
                                        : '',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w300,
                                        color: Colors.grey[600],
                                        fontSize: 12.0.sp,
                                        fontFamily: variable.font_poppins),
                                  ),
                                ),
                                getisDisabled(document),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 1.sw * 0.035,
                        ),
                        Container(
                          child: Column(
                            children: [
                              Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(0, 8, 4, 4),
                                  child: (chatListSnapshot.hasData &&
                                          chatListSnapshot.data.docs.length > 0)
                                      ? StreamBuilder<QuerySnapshot>(
                                          stream: FirebaseFirestore.instance
                                              .collection('messages')
                                              .doc(chatViewModel.createGroupId(
                                                  patientId,
                                                  chatListSnapshot
                                                      .data.docs[index]['id']))
                                              .collection(
                                                  chatViewModel.createGroupId(
                                                      patientId,
                                                      chatListSnapshot.data
                                                          .docs[index]['id']))
                                              .where('idTo',
                                                  isEqualTo: patientId)
                                              .where('isread', isEqualTo: false)
                                              .snapshots(),
                                          builder:
                                              (context, notReadMSGSnapshot) {
                                            return Container(
                                              width: 60,
                                              height: 50,
                                              child: Column(
                                                children: <Widget>[
                                                  Padding(
                                                      padding: const EdgeInsets
                                                          .fromLTRB(0, 5, 0, 0),
                                                      child: CircleAvatar(
                                                        radius: 10,
                                                        child: Text(
                                                          (chatListSnapshot
                                                                      .hasData &&
                                                                  chatListSnapshot
                                                                          .data
                                                                          .docs
                                                                          .length >
                                                                      0)
                                                              ? ((notReadMSGSnapshot
                                                                          .hasData &&
                                                                      notReadMSGSnapshot
                                                                              .data!
                                                                              .docs
                                                                              .length >
                                                                          0)
                                                                  ? '${notReadMSGSnapshot.data!.docs.length}'
                                                                  : '')
                                                              : '',
                                                          style: TextStyle(
                                                            fontSize: 12.0.sp,
                                                          ),
                                                        ),
                                                        backgroundColor: (notReadMSGSnapshot.hasData &&
                                                                notReadMSGSnapshot
                                                                        .data!
                                                                        .docs
                                                                        .length >
                                                                    0 &&
                                                                notReadMSGSnapshot
                                                                    .hasData &&
                                                                notReadMSGSnapshot
                                                                        .data!
                                                                        .docs
                                                                        .length >
                                                                    0)
                                                            ? mAppThemeProvider.primaryColor
                                                            : Colors
                                                                .transparent,
                                                        foregroundColor:
                                                            Colors.white,
                                                      )),
                                                ],
                                              ),
                                            );
                                          })
                                      : Text(''))
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                Container(
                  color: Colors.grey,
                  height: 0.5,
                  margin: EdgeInsets.only(bottom: 6),
                )
              ],
            );
          }
        } else {
          return SizedBox.shrink();
        }
      },
    );
  }

  Widget getisDisabled(DocumentSnapshot document) {
    try {
      bool isDisable = document[STR_IS_DISABLE] ?? false;
      if ((widget.careGiversList?.length ?? 0) > 0 && isDisable) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Text(
            STR_NOT_AVAILABLE,
            style: TextStyle(
                color: Colors.redAccent,
                fontSize: 14.0.sp,
                fontFamily: variable.font_poppins),
          ),
        );
      }
      return SizedBox.shrink();
    } catch (err) {
      return SizedBox.shrink();
    }
  }

  String getFormattedDateTime(String datetime) {
    DateTime dateTimeStamp = DateTime.parse(datetime);
    String formattedDate = DateFormat('MMM d, hh:mm a').format(dateTimeStamp);
    return formattedDate;
  }

  int? countChatListUsers(myID, snapshot) {
    int? resultInt = snapshot.data.docs.length;
    for (var data in snapshot.data.docs) {
      if (data[STR_ID] == myID && resultInt != null) {
        resultInt--;
      }
    }
    return resultInt;
  }
}
