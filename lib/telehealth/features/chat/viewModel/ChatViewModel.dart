import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:myfhb/common/PreferenceUtil.dart';
import 'package:myfhb/src/model/user/MyProfile.dart';
import 'package:myfhb/src/resources/network/ApiBaseHelper.dart';
import 'package:myfhb/telehealth/features/chat/view/chat.dart';
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:myfhb/constants/fhb_constants.dart' as Constants;

class ChatViewModel extends ChangeNotifier {

  SharedPreferences prefs;

  Future<void> storePatientDetailsToFCM(
      String doctorId, String doctorName, String doctorPic,BuildContext context) async {
    Firestore.instance.collection('users').document(doctorId).setData({
      'nickname': doctorName != null ? doctorName : '',
      'photoUrl': doctorPic != null ? doctorPic : '',
      'id': doctorId,
      'createdAt': DateTime.now().millisecondsSinceEpoch.toString(),
      'chattingWith': null
    });

    storeDoctorDetailsToFCM(doctorId, doctorName, doctorPic,context);
  }

  Future<void> storeDoctorDetailsToFCM(
      String doctorId, String doctorName, String doctorPic,BuildContext context) async {
    prefs = await SharedPreferences.getInstance();

    String patientId = PreferenceUtil.getStringValue(Constants.KEY_USERID);
    String patientName = getPatientName();
    String patientPicUrl = getProfileURL();

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

    goToChatPage(doctorId, doctorName, doctorPic,context);
  }

  void goToChatPage(String doctorId, String doctorName, String doctorPic,BuildContext context) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => Chat(
              peerId: doctorId,
              peerAvatar: doctorPic != null ? doctorPic : '',
              peerName: doctorName,
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