
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:myfhb/chat_socket/constants/const_socket.dart';
import 'package:myfhb/common/CommonUtil.dart';
import 'package:myfhb/common/PreferenceUtil.dart';
import 'package:myfhb/constants/fhb_parameters.dart';
import 'package:myfhb/my_providers/services/providers_repository.dart';
import 'package:myfhb/src/model/user/MyProfileModel.dart';
import 'package:myfhb/src/resources/network/ApiBaseHelper.dart';
import 'package:myfhb/telehealth/features/appointments/model/fetchAppointments/healthRecord.dart';
import 'package:myfhb/telehealth/features/chat/model/AppointmentDetailModel.dart';
import 'package:myfhb/telehealth/features/chat/view/chat.dart';
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:myfhb/constants/fhb_constants.dart' as Constants;

class ChatViewModel extends ChangeNotifier {
  ProvidersListRepository _providersListRepository = ProvidersListRepository();

  late SharedPreferences prefs;

  AppointmentResult? appointments;

  Future<void> storePatientDetailsToFCM(
      String doctorId,
      String doctorName,
      String doctorPic,
      String patientId,
      String patientName,
      String patientPicUrl,
      BuildContext context,
      bool isFromVideoCall) async {
    FirebaseFirestore.instance.collection('users').doc(doctorId).set({
      NICK_NAME: doctorName != null ? doctorName : '',
      PHOTO_URL: doctorPic != null ? doctorPic : '',
      ID: doctorId,
      CREATED_AT: DateTime.now().millisecondsSinceEpoch.toString(),
      CHATTING_WITH: null
    });

    storeDoctorDetailsToFCM(doctorId, doctorName, doctorPic, patientId,
        patientName, patientPicUrl, context, isFromVideoCall);
  }

  Future<void> storeDoctorDetailsToFCM(
      String doctorId,
      String doctorName,
      String doctorPic,
      String? patientId,
      String patientName,
      String? patientPicUrl,
      BuildContext context,
      bool isFromVideoCall) async {
    prefs = await SharedPreferences.getInstance();

    if (patientId == null || patientId == '') {
      patientId = PreferenceUtil.getStringValue(Constants.KEY_USERID);
    }
    if (patientName == null || patientName == '') {
      patientName = getPatientName();
    }
    if (patientPicUrl == null || patientPicUrl == '') {
      patientPicUrl = getProfileURL();
    }

    final QuerySnapshot result = await FirebaseFirestore.instance
        .collection(USERS)
        .where(ID, isEqualTo: patientId)
        .get();
    final List<DocumentSnapshot> documents = result.docs;

    if (documents.length == 0) {
      // Update data to server if new user
      FirebaseFirestore.instance.collection(USERS).doc(patientId).set({
        NICK_NAME: patientName != null ? patientName : '',
        PHOTO_URL: patientPicUrl != null ? patientPicUrl : '',
        ID: patientId,
        CREATED_AT: DateTime.now().millisecondsSinceEpoch.toString(),
        CHATTING_WITH: null
      });

      // Write data to local
      await prefs.setString(ID, patientId!);
      await prefs.setString(NICK_NAME, patientName);
      await prefs.setString(PHOTO_URL, patientPicUrl!);
    } else {
      // Write data to local
      await prefs.setString(ID, documents[0][ID]);
      await prefs.setString(NICK_NAME, documents[0][NICK_NAME]);
      await prefs.setString(PHOTO_URL, documents[0][PHOTO_URL]);
      //await prefs.setString(ABOUT_ME, documents[0][ABOUT_ME]);
    }

    goToChatPage(doctorId, doctorName, doctorPic, patientId!, patientName,
        patientPicUrl!, context, isFromVideoCall);
  }

  void goToChatPage(
      String doctorId,
      String doctorName,
      String doctorPic,
      String patientId,
      String patientName,
      String patientPicUrl,
      BuildContext context,
      bool isFromVideoCall) {
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
                  isCareGiver: false,
                )));
  }

  String getPatientName() {
    MyProfileModel myProfile =
        PreferenceUtil.getProfileData(Constants.KEY_PROFILE)!;
    String patientName = myProfile.result != null
        ? myProfile.result!.firstName! + ' ' + myProfile.result!.lastName!
        : '';

    return patientName;
  }

  String? getProfileURL() {
    MyProfileModel myProfile =
        PreferenceUtil.getProfileData(Constants.KEY_PROFILE)!;
    String? patientPicURL = myProfile.result!.profilePicThumbnailUrl;

    return patientPicURL;
  }

  Future<int?> getUnreadMSGCount([String? patientId]) async {
    try {
      int unReadMSGCount = 0;
      String targetID = '';
      SharedPreferences prefs = await SharedPreferences.getInstance();

      patientId == null
          ? targetID = (prefs.get('userId') as String? ?? 'NoId')
          : targetID = patientId;
//      if (targetID != 'NoId') {
      final QuerySnapshot chatListResult = await FirebaseFirestore.instance
          .collection('chat_list')
          .doc(targetID)
          .collection('user_list')
          .get();
      final List<DocumentSnapshot> chatListDocuments = chatListResult.docs;
      for (var data in chatListDocuments) {
        String groupId = createGroupId(patientId, data['id']);
        print('checkGroup' + groupId);
        final QuerySnapshot unReadMSGDocument = await FirebaseFirestore.instance
            .collection('messages')
            .doc(groupId)
            .collection(groupId)
            .where('idTo', isEqualTo: targetID)
            .where('isread', isEqualTo: false)
            .get();

        final List<DocumentSnapshot> unReadMSGDocuments =
            unReadMSGDocument.docs;
        unReadMSGCount = unReadMSGCount + unReadMSGDocuments.length;
      }
      print('unread MSG count is $unReadMSGCount');
//      }
      if (patientId == null) {
        //FlutterAppBadger.updateBadgeCount(unReadMSGCount);
        return null;
      } else {
        return unReadMSGCount;
      }
    } catch (e,stackTrace) {
      print(e.toString());
                  CommonUtil().appLogs(message: e,stackTrace:stackTrace);

    }
  }

  String createGroupId(String? patientId, String? peerId) {
    String groupId = '';

    if (patientId.hashCode <= peerId.hashCode) {
      groupId = '$patientId-$peerId';
    } else {
      groupId = '$peerId-$patientId';
    }

    return groupId;
  }

  void setCurrentChatRoomID(value) async {
    // To know where I am in chat room. Avoid local notification.
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('currentChatRoom', value);
  }

  Future<AppointmentResult?> fetchAppointmentDetail(
      String doctorId, String patientId, String? careCoorId,String isNormalChatUserList) async {
    try {
      AppointmentDetailModel appointmentModel = await _providersListRepository
          .getAppointmentDetail(doctorId, patientId, careCoorId,isNormalChatUserList);
      appointments = appointmentModel.result;
      return appointments;
    } catch (e,stackTrace) {
                  CommonUtil().appLogs(message: e,stackTrace:stackTrace);

    }
  }

  Future<void> upateUserNickname(String? patientId, String patientName) async {
    final QuerySnapshot result = await FirebaseFirestore.instance
        .collection(USERS)
        .where(ID, isEqualTo: patientId)
        .get();
    final List<DocumentSnapshot> documents = result.docs;

    if (documents.length > 0) {
      // Update data to fire store
      FirebaseFirestore.instance
          .collection(USERS)
          .doc(patientId)
          .update({NICK_NAME: patientName != null ? patientName : ''});
    }
  }

/*goToChatSocket(String patientId, String patientName, String patientUrl,
      BuildContext context, bool isFromVideoCall, String groupId,
      {HealthRecord healthRecord,
      @required PatientInfo patientInfo,
      @required DailyListAppointmentModel dailyListAppointmentModel}) {
    List<String> associateRecords = List();

    if (healthRecord.associatedRecords != null &&
        healthRecord.associatedRecords.length > 0) {
      associateRecords.addAll(healthRecord.associatedRecords);
    }

    metaIds = associateRecords;

    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ChatDetail(
                  peerId: patientId,
                  peerAvatar: patientUrl,
                  peerName: patientName,
                  isFromVideoCall: isFromVideoCall,
                  metaIds: metaIds,
                  patientInfo: patientInfo,
                  dailyListAppointmentModel: dailyListAppointmentModel,
                  groupId: groupId,
                )));
  }*/
}
