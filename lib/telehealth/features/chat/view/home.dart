import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gmiwidgetspackage/widgets/sized_box.dart';
import 'package:intl/intl.dart';
import 'package:myfhb/common/PreferenceUtil.dart';
import 'package:myfhb/constants/fhb_constants.dart' as Constants;
import 'package:myfhb/constants/fhb_constants.dart';
import 'package:myfhb/src/model/user/MyProfileModel.dart';
import 'package:myfhb/telehealth/features/chat/constants/const.dart';
import 'package:myfhb/telehealth/features/chat/view/chat.dart';
import 'package:myfhb/telehealth/features/chat/view/loading.dart';
import 'package:myfhb/constants/variable_constant.dart' as variable;

import '../../../../common/CommonUtil.dart';

class ChatHomeScreen extends StatefulWidget {
  ChatHomeScreen({Key key}) : super(key: key);

  @override
  State createState() => HomeScreenState();
}

class HomeScreenState extends State<ChatHomeScreen> {
  HomeScreenState({Key key});

  final FirebaseMessaging firebaseMessaging = FirebaseMessaging();
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  bool isLoading = false;

  String patientId = '';
  String patientName = '';

  @override
  void initState() {
    super.initState();
    registerNotification();
    configLocalNotification();
  }

  Future<String> getPatientDetails() async {
    patientId = PreferenceUtil.getStringValue(Constants.KEY_USERID);
    print(patientId);

    MyProfileModel myProfile =
        PreferenceUtil.getProfileData(Constants.KEY_PROFILE);
    patientName = myProfile.result != null
        ? myProfile.result.firstName + myProfile.result.firstName
        : '';
    return patientId;
  }

  void registerNotification() {
    firebaseMessaging.requestNotificationPermissions();

    firebaseMessaging.configure(onMessage: (Map<String, dynamic> message) {
      Platform.isAndroid
          ? showNotification(message['notification'])
          : showNotification(message['aps']['alert']);
      return;
    }, onResume: (Map<String, dynamic> message) {
      print('onResume: $message');
      return;
    }, onLaunch: (Map<String, dynamic> message) {
      print('onLaunch: $message');
      return;
    });

    firebaseMessaging.getToken().then((token) {
      Firestore.instance
          .collection(STR_USERS)
          .document(patientId)
          .updateData({STR_PUSH_TOKEN: token});
    }).catchError((err) {
      Fluttertoast.showToast(msg: err.message.toString());
    });
  }

  void configLocalNotification() {
    var initializationSettingsAndroid =
        new AndroidInitializationSettings(STR_MIP_MAP_LAUNCHER);
    var initializationSettingsIOS = new IOSInitializationSettings();
    var initializationSettings = new InitializationSettings(
        initializationSettingsAndroid, initializationSettingsIOS);
    flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  void showNotification(message) async {
    var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
      Platform.isAndroid
          ? 'com.ventechsolutions.myFHB'
          : 'com.ventechsolutions.myFHB',
      'Flutter chat demo',
      'your channel description',
      playSound: true,
      enableVibration: true,
      importance: Importance.Max,
      priority: Priority.High,
    );
    var iOSPlatformChannelSpecifics = new IOSNotificationDetails();
    var platformChannelSpecifics = new NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.show(0, message['title'].toString(),
        message['body'].toString(), platformChannelSpecifics,
        payload: json.encode(message));
  }

  Future<bool> onBackPress() {
    Navigator.pop(context);
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
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      EXIT_APP_TO_EXIT,
                      style: TextStyle(color: Colors.white70, fontSize: 14.0),
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
                          color: primaryColor, fontWeight: FontWeight.bold),
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
                          color: primaryColor, fontWeight: FontWeight.bold),
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
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () {
              Navigator.of(context).pop();
            }),
        elevation: 0.0,
        backgroundColor: Color(CommonUtil().getMyPrimaryColor()),
        title: Text(
          CHAT,
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: false,
      ),
      body: WillPopScope(
        child: checkIfDoctorIdExist(),
        onWillPop: onBackPress,
      ),
    );
  }

  Widget checkIfDoctorIdExist() {
    return new FutureBuilder<String>(
      future: getPatientDetails(),
      builder: (BuildContext context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return new Scaffold(
            body: Center(child: new CircularProgressIndicator()),
          );
        } else if (snapshot.hasError) {
          return new Text('Error: ${snapshot.error}');
        } else {
          return getChatList();
        }
      },
    );
  }

  Widget getChatList() {
    return Stack(
      children: <Widget>[
        // List
        Container(
          child: StreamBuilder(
            stream: Firestore.instance
                .collection(STR_CHAT_LIST)
                .document(patientId)
                .collection(STR_USER_LIST)
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(themeColor),
                  ),
                );
              } else {
                return ListView.builder(
                  padding: EdgeInsets.all(10.0),
                  itemBuilder: (context, index) =>
                      buildItem(context, snapshot.data.documents[index]),
                  itemCount: snapshot.data.documents.length,
                );
              }
            },
          ),
        ),

        // Loading
        Positioned(
          child: isLoading ? const Loading() : Container(),
        )
      ],
    );
  }

  Widget buildItem(BuildContext context, DocumentSnapshot document) {
    String lastMessage = document[STR_LAST_MESSAGE];
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
                            peerId: document.documentID,
                            peerAvatar: document[STR_PHOTO_URL],
                            peerName: document[STR_NICK_NAME],
                            lastDate: document[STR_CREATED_AT],
                          )));
            },
            child: Container(
              child: Row(
                children: <Widget>[
                  SizedBox(width: MediaQuery.of(context).size.width * 0.025),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.12,
                    height: MediaQuery.of(context).size.width * 0.12,
                    child: ClipOval(
                      child: document[STR_PHOTO_URL] != null
                          ? CachedNetworkImage(
                              placeholder: (context, url) => Container(
                                child: CircularProgressIndicator(
                                  strokeWidth: 1.0,
                                  valueColor:
                                      AlwaysStoppedAnimation<Color>(themeColor),
                                ),
                                width: 50.0,
                                height: 50.0,
                                padding: EdgeInsets.all(15.0),
                              ),
                              imageUrl: document[STR_PHOTO_URL],
                              width: 50.0,
                              height: 50.0,
                              fit: BoxFit.cover,
                            )
                          : Icon(
                              Icons.account_circle,
                              size: 50.0,
                              color: greyColor,
                            ),
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.055,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(bottom: 4),
                        child: Text(
                          toBeginningOfSentenceCase(document[STR_NICK_NAME]),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 15,
                              fontFamily: variable.font_poppins),
                        ),
                      ),
                      SizedBox(
                        height: 1,
                      ),
                      Container(
                        constraints: BoxConstraints(
                            maxWidth: MediaQuery.of(context).size.width * 0.5),
                        padding: const EdgeInsets.only(bottom: 4),
                        child: lastMessage != null
                            ? lastMessage.contains(STR_HTTPS)
                                ? Row(
                                    children: [
                                      Icon(
                                        Icons.photo,
                                        size: 14,
                                        color: Colors.black54,
                                      ),
                                      SizedBoxWidget(
                                        width: 3,
                                      ),
                                      Text(
                                        STR_FILE,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                            color: Colors.grey[600],
                                            fontSize: 12,
                                            fontFamily: variable.font_poppins),
                                      )
                                    ],
                                  )
                                : Text(
                                    lastMessage,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.grey[600],
                                        fontSize: 12,
                                        fontFamily: variable.font_poppins),
                                  )
                            : '',
                      ),
                      SizedBox(
                        height: 1,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Text(
                          document[STR_CREATED_AT] != null
                              ? LAST_RECEIVED +
                              getFormattedNewDateTime(int.parse(document[STR_CREATED_AT]))
                              : '',
                          style: TextStyle(
                              fontWeight: FontWeight.w300,
                              color: Colors.grey[600],
                              fontSize: 10,
                              fontFamily: variable.font_poppins),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.035,
                  ),
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
  }

  String getFormattedNewDateTime(int timeStamp) {
    var date = DateTime.fromMillisecondsSinceEpoch(timeStamp);
    var formattedDate = DateFormat('MMM d, hh:mm a').format(date);
    return formattedDate;
  }
}
