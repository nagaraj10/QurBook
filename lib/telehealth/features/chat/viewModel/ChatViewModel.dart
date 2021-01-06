import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:myfhb/common/PreferenceUtil.dart';
import 'package:myfhb/constants/fhb_parameters.dart';
import 'package:myfhb/src/model/user/MyProfileModel.dart';
import 'package:myfhb/src/resources/network/ApiBaseHelper.dart';
import 'package:myfhb/telehealth/features/chat/view/chat.dart';
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:myfhb/constants/fhb_constants.dart' as Constants;

class ChatViewModel extends ChangeNotifier {

  SharedPreferences prefs;

  Future<void> storePatientDetailsToFCM(
      String doctorId, String doctorName, String doctorPic,
      String patientId,String patientName,String patientPicUrl,
      BuildContext context,bool isFromVideoCall) async {
    Firestore.instance.collection('users').document(doctorId).setData({
      NICK_NAME: doctorName != null ? doctorName : '',
      PHOTO_URL: doctorPic != null ? doctorPic : '',
      ID: doctorId,
      CREATED_AT: DateTime.now().millisecondsSinceEpoch.toString(),
      CHATTING_WITH: null
    });

    storeDoctorDetailsToFCM(doctorId, doctorName, doctorPic,patientId,patientName,patientPicUrl,context,isFromVideoCall);
  }

  Future<void> storeDoctorDetailsToFCM(
      String doctorId, String doctorName, String doctorPic,
      String patientId,String patientName,String patientPicUrl,BuildContext context,bool isFromVideoCall) async {
    prefs = await SharedPreferences.getInstance();

    if(patientId==null || patientId==''){
      patientId = PreferenceUtil.getStringValue(Constants.KEY_USERID);
    }
    if(patientName==null || patientName==''){
      patientName = getPatientName();
    }
    if(patientPicUrl==null || patientPicUrl==''){
      patientPicUrl = getProfileURL();
    }


    final QuerySnapshot result = await Firestore.instance
        .collection(USERS)
        .where(ID, isEqualTo: patientId)
        .getDocuments();
    final List<DocumentSnapshot> documents = result.documents;

    if (documents.length == 0) {
      // Update data to server if new user
      Firestore.instance.collection(USERS).document(patientId).setData({
        NICK_NAME: patientName != null ? patientName : '',
        PHOTO_URL: patientPicUrl != null ? patientPicUrl : '',
        ID: patientId,
        CREATED_AT: DateTime.now().millisecondsSinceEpoch.toString(),
        CHATTING_WITH: null
      });

      // Write data to local
      await prefs.setString(ID, patientId);
      await prefs.setString(NICK_NAME, patientName);
      await prefs.setString(PHOTO_URL, patientPicUrl);
    } else {
      // Write data to local
      await prefs.setString(ID, documents[0][ID]);
      await prefs.setString(NICK_NAME, documents[0][NICK_NAME]);
      await prefs.setString(PHOTO_URL, documents[0][PHOTO_URL]);
      await prefs.setString(ABOUT_ME, documents[0][ABOUT_ME]);
    }

    goToChatPage(doctorId, doctorName, doctorPic,patientId,patientName,patientPicUrl,context,isFromVideoCall);
  }

  void goToChatPage(String doctorId, String doctorName, String doctorPic,String patientId,String patientName,String patientPicUrl,BuildContext context,bool isFromVideoCall) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => Chat(
              peerId: doctorId,
              peerAvatar: doctorPic != null ? doctorPic : '',
              peerName: doctorName,
              patientId: patientId,
              patientName: patientName,
              patientPicture: patientPicUrl,
              isFromVideoCall: isFromVideoCall,
            )));
  }

  String getPatientName() {
    MyProfileModel myProfile = PreferenceUtil.getProfileData(Constants.KEY_PROFILE);
    String patientName =
    myProfile.result != null
        ? myProfile.result.firstName +
        ' ' +
        myProfile.result.lastName
        : '';

    return patientName;
  }

  String getProfileURL() {
    MyProfileModel myProfile = PreferenceUtil.getProfileData(Constants.KEY_PROFILE);
    String patientPicURL =
        myProfile.result.profilePicThumbnailUrl;

    return patientPicURL;
  }

}