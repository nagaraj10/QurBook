import 'dart:io';

import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myfhb/common/PreferenceUtil.dart';
import 'package:myfhb/constants/fhb_constants.dart' as Constants;
import 'package:myfhb/src/model/home_screen_arguments.dart';
import 'package:myfhb/src/model/user/MyProfile.dart';
import 'package:myfhb/telehealth/features/MyProvider/view/TelehealthProviders.dart';
import 'package:myfhb/telehealth/features/chat/view/chat.dart';
import 'package:myfhb/video_call/utils/callstatus.dart';
import 'package:myfhb/video_call/utils/hideprovider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyControllers extends StatefulWidget {
  CallStatus callStatus;
  ClientRole role;
  bool isAppExists;
  Function(bool, bool) controllerState;
  bool muted;
  bool _isHideMyVideo;
  String doctorId;
  String doctorName;
  String doctorPicUrl;

  MyControllers(this.callStatus, this.role, this.isAppExists, this.doctorId,
      this.controllerState, this.muted, this._isHideMyVideo, this.doctorName,this.doctorPicUrl);

  @override
  _MyControllersState createState() => _MyControllersState();
}

class _MyControllersState extends State<MyControllers> {
  SharedPreferences prefs;
  String patientId;
  String patientName;
  String patientPicUrl;

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => _toolbar(callStatus: widget.callStatus);

  /// Toolbar layout
  Widget _toolbar({CallStatus callStatus, HideProvider hideProvider}) {
    var _firstPress = true ;
    if (widget.role == ClientRole.Audience) return Container();
    return Container(
      color: Colors.black.withOpacity(0.5),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          IconButton(
            onPressed: _onToggleVideo,
            icon: Icon(
              widget._isHideMyVideo ? Icons.videocam_off : Icons.videocam,
              color: Colors.white,
              size: 20.0,
            ),
          ),
          IconButton(
            onPressed: _onToggleMute,
            icon: Icon(
              widget.muted ? Icons.mic_off : Icons.mic,
              color: Colors.white,
              size: 20.0,
            ),
          ),
          IconButton(
            onPressed: () {
              if(_firstPress){
                _firstPress = false ;
                storePatientDetailsToFCM();
              }
            },
            icon: Icon(
              Icons.chat_bubble_outline,
              color: Colors.white,
              size: 20.0,
            ),
          ),
//          IconButton(
//            onPressed: null,
//            icon: Icon(
//              Icons.attach_file,
//              color: Colors.white,
//              size: 20.0,
//            ),
//          ),
          Container(
            color: Colors.redAccent,
            child: IconButton(
              onPressed: () {
//                  callStatus.enCall();
//                  iCallStatus.callNotAlive();
                _onCallEnd(context);
              },
              icon: Icon(
                Icons.call_end,
                color: Colors.white,
                size: 30.0,
              ),
              padding: const EdgeInsets.all(15.0),
            ),
          ),
        ],
      ),
    );
  }

  void _onCallEnd(BuildContext context) async {
    if (Platform.isIOS) {
      Navigator.pop(context);
    } else {
      Get.offAll(TelehealthProviders(
        arguments: HomeScreenArguments(selectedIndex: 0),
      ));
    }
  }

  void _onToggleMute() {
    setState(() {
      widget.muted = !widget.muted;
    });
    widget.controllerState(widget.muted, widget._isHideMyVideo);
    AgoraRtcEngine.muteLocalAudioStream(widget.muted);
  }

  void _onToggleVideo() {
    setState(() {
      widget._isHideMyVideo = !widget._isHideMyVideo;
    });
    widget.controllerState(widget.muted, widget._isHideMyVideo);
    AgoraRtcEngine.muteLocalVideoStream(widget._isHideMyVideo);
  }

  void storePatientDetailsToFCM() {
    Firestore.instance.collection('users').document(widget.doctorId).setData({
      'nickname': widget.doctorName != null ? widget.doctorName : '',
      'photoUrl': widget.doctorPicUrl!=null?widget.doctorPicUrl:'',
      'id': widget.doctorId,
      'createdAt': DateTime.now().millisecondsSinceEpoch.toString(),
      'chattingWith': null
    });

    storeDoctorDetailsToFCM();
  }

  Future<void> storeDoctorDetailsToFCM() async {
    prefs = await SharedPreferences.getInstance();

    patientId = PreferenceUtil.getStringValue(Constants.KEY_USERID);
    patientName = getPatientName();
    patientPicUrl = getProfileURL();

    final QuerySnapshot result = await Firestore.instance
        .collection('users')
        .where('id', isEqualTo: patientId)
        .getDocuments();
    final List<DocumentSnapshot> documents = result.documents;

    if (documents.length == 0) {
      // Update data to server if new user
      Firestore.instance.collection('users').document(patientId).setData({
        'nickname': patientName != null ? patientName : '',
        'photoUrl': patientPicUrl != null ? patientPicUrl : '',
        'id': patientId,
        'createdAt': DateTime.now().millisecondsSinceEpoch.toString(),
        'chattingWith': null
      });

      // Write data to local
      await prefs.setString('id', patientId);
      await prefs.setString('nickname', patientName);
      await prefs.setString('photoUrl', patientPicUrl);
    } else {
      // Write data to local
      await prefs.setString('id', documents[0]['id']);
      await prefs.setString('nickname', documents[0]['nickname']);
      await prefs.setString('photoUrl', documents[0]['photoUrl']);
      await prefs.setString('aboutMe', documents[0]['aboutMe']);
    }

    goToChatPage();
  }

  void goToChatPage() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => Chat(
                  peerId: widget.doctorId,
                  peerAvatar: widget.doctorPicUrl,
                  peerName: widget.doctorName,
                )));
  }

  String getPatientName() {
    MyProfile myProfile = PreferenceUtil.getProfileData(Constants.KEY_PROFILE);
    String patientName =
        myProfile.response.data.generalInfo.qualifiedFullName != null
            ? myProfile.response.data.generalInfo.qualifiedFullName.firstName +
                ' ' +
                myProfile.response.data.generalInfo.qualifiedFullName.lastName
            : '';

    return patientName;
  }

  String getProfileURL() {
    MyProfile myProfile = PreferenceUtil.getProfileData(Constants.KEY_PROFILE);
    String patientPicURL =
        myProfile.response.data.generalInfo.profilePicThumbnailURL;

    return patientPicURL;
  }
}
