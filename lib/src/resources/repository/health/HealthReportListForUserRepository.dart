import 'dart:convert' as convert;
import 'dart:io';

import 'package:myfhb/common/PreferenceUtil.dart';
import 'package:myfhb/constants/fhb_constants.dart' as Constants;
import 'package:myfhb/record_detail/model/MetaDataMovedResponse.dart';
import 'package:myfhb/record_detail/model/UpdateMediaResponse.dart';
import 'package:myfhb/src/model/Health/DigitRecogResponse.dart';
import 'package:myfhb/src/model/Health/PostImageResponse.dart';
import 'package:myfhb/src/model/Health/SavedMetaDataResponse.dart';
import 'package:myfhb/src/model/Health/UserHealthResponseList.dart';
import 'package:myfhb/src/resources/network/ApiBaseHelper.dart';

class HealthReportListForUserRepository {
  ApiBaseHelper _helper = ApiBaseHelper();

  Future<UserHealthResponseList> getHealthReportList() async {
    String userID = PreferenceUtil.getStringValue(Constants.KEY_USERID);

    final response = await _helper
        .getHealthRecordList("mediameta/" + userID + "/getmediameta/");
    return UserHealthResponseList.fromJson(response);
  }

  Future<dynamic> getDoctorProfile(String doctorsId) async {
    final response = await _helper
        .getDoctorProfilePic("doctors/" + doctorsId + "/getprofilepic/");
    return response;
  }

  Future<dynamic> getDocumentImage(String metaMasterID) async {
    String userID = PreferenceUtil.getStringValue(Constants.KEY_USERID);

    final response = await _helper.getDocumentImage(
        "mediameta/" + userID + "/getRawMedia/" + metaMasterID);
    return response;
  }

  Future<SavedMetaDataResponse> postMediaData(String jsonString) async {
    String id;

    try {
      String familyId =
          PreferenceUtil.getStringValue(Constants.KEY_FAMILYMEMBERID);
      if (familyId.length > 0) {
        id = familyId;
      } else {
        id = PreferenceUtil.getStringValue(Constants.KEY_USERID);
      }
    } catch (e) {
      id = PreferenceUtil.getStringValue(Constants.KEY_USERID);
    }

    var response = await _helper.saveMediaData(
        "mediameta/" + id + "/savemediameta/", jsonString);
    return SavedMetaDataResponse.fromJson(response);
  }

  Future<DigitRecogResponse> postDevicesData(
      String fileName, String metaID, String jsonData) async {
    String userID = PreferenceUtil.getStringValue(Constants.KEY_USERID);

    var response = await _helper.saveImageAndGetDeviceInfo(
        "ai/" + userID + "/saveHealthRecord/",
        File(fileName),
        fileName,
        metaID,
        jsonData);
    return DigitRecogResponse.fromJson(response);
  }

  Future<PostImageResponse> postImage(
      String fileName, String metaID, String jsonData) async {
    String userID = PreferenceUtil.getStringValue(Constants.KEY_USERID);

    var response = await _helper.saveImageToServerClone(
        "mediamaster/" + userID + "/savemediamaster/",
        File(fileName),
        fileName,
        metaID,
        jsonData);
    return PostImageResponse.fromJson(response);
  }

  Future<MetaDataMovedResponse> moveDataToOtherUser(
      String familyID, String metaID) async {
    var signInData = {};
    signInData['mediaMetaId'] = metaID;
    signInData['destinationId'] = familyID;
    var jsonString = convert.jsonEncode(signInData);
    String userID = PreferenceUtil.getStringValue(Constants.KEY_USERID);

    var response = await _helper.moveMetaDataToOtherUser(
        "mediameta/" + userID + "/move", jsonString);
    return MetaDataMovedResponse.fromJson(response);
  }

  Future<UpdateMediaResponse> updateMediaData(
      String jsonString, String metaInfoID) async {
    String userID = PreferenceUtil.getStringValue(Constants.KEY_USERID_MAIN);

    var response = await _helper.updateMediaData(
        "mediameta/" + userID + "/updatemediameta/" + metaInfoID, jsonString);
    return UpdateMediaResponse.fromJson(response);
  }

  Future<List<dynamic>> getDocumentImageList(
      List<MediaMasterIds> metaMasterIdList) async {
    String userID = PreferenceUtil.getStringValue(Constants.KEY_USERID);

    final response = await _helper.getDocumentImageList(
        "mediameta/" + userID + "/getRawMedia/", metaMasterIdList);
    return response;
  }
}
