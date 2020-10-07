import 'dart:convert' as convert;
import 'dart:io';

import 'package:myfhb/common/PreferenceUtil.dart';
import 'package:myfhb/constants/fhb_constants.dart' as Constants;
import 'package:myfhb/record_detail/model/DoctorImageResponse.dart';
import 'package:myfhb/record_detail/model/ImageDocumentResponse.dart';
import 'package:myfhb/record_detail/model/MetaDataMovedResponse.dart';
import 'package:myfhb/record_detail/model/UpdateMediaResponse.dart';
import 'package:myfhb/src/model/Health/DigitRecogResponse.dart';
import 'package:myfhb/src/model/Health/MediaMasterIds.dart';
import 'package:myfhb/src/model/Health/PostImageResponse.dart';
import 'package:myfhb/src/model/Health/SavedMetaDataResponse.dart';
import 'package:myfhb/src/model/Health/MediaMetaInfo.dart';
import 'package:myfhb/src/model/Health/UserHealthResponseList.dart';
import 'package:myfhb/src/model/Health/asgard/health_record_list.dart';
import 'package:myfhb/src/model/Health/asgard/health_record_success.dart';

import 'package:myfhb/src/resources/network/ApiBaseHelper.dart';

import 'package:myfhb/constants/fhb_query.dart' as query;
import 'package:myfhb/constants/fhb_parameters.dart' as parameters;

class HealthReportListForUserRepository {
  ApiBaseHelper _helper = ApiBaseHelper();

  Future<UserHealthResponseList> getHealthReportList({bool condition}) async {
    String userID = PreferenceUtil.getStringValue(Constants.KEY_USERID);

    final response = await _helper.getHealthRecordList(
        query.qr_mediameta + userID + query.qr_slash + query.qr_getMediaData,
        condition: condition);
    return UserHealthResponseList.fromJson(response);
  }

  Future<DoctorImageResponse> getDoctorProfile(String doctorsId) async {
    final response = await _helper.getDoctorProfilePic(query.qr_doctors +
        doctorsId +
        query.qr_profilePic +
        query.qr_ques +
        query.qr_isOriginalPicRequiredTrue);
    return DoctorImageResponse.fromJson(response);
  }

  Future<ImageDocumentResponse> getDocumentImage(String metaMasterID) async {
    String userID = PreferenceUtil.getStringValue(Constants.KEY_USERID);

    final response = await _helper.getDocumentImage(query.qr_mediameta +
        userID +
        query.qr_slash +
        query.qr_rawMedia +
        metaMasterID);
    return ImageDocumentResponse.fromJson(response);
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
        query.qr_mediameta + id + query.qr_slash + query.qr_savedmedia,
        jsonString);
    return SavedMetaDataResponse.fromJson(response);
  }

  Future<DigitRecogResponse> postDevicesData(
      String fileName, String metaID, String jsonData) async {
    String userID = PreferenceUtil.getStringValue(Constants.KEY_USERID);

    var response = await _helper.saveImageAndGetDeviceInfo(
        query.qr_ai + userID + query.qr_slash + query.qr_savehealth,
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
        query.qr_mediamaster +
            userID +
            query.qr_slash +
            query.qr_savedmediamaster,
        File(fileName.trim()),
        fileName.trim(),
        metaID,
        jsonData);
    return PostImageResponse.fromJson(response);
  }

  Future<MetaDataMovedResponse> moveDataToOtherUser(
      String familyID, String metaID) async {
    var signInData = {};
    signInData[parameters.strmediaMetaId] = metaID;
    signInData[parameters.strdestinationId] = familyID;
    var jsonString = convert.jsonEncode(signInData);
    String userID = PreferenceUtil.getStringValue(Constants.KEY_USERID);

    var response = await _helper.moveMetaDataToOtherUser(
        query.qr_mediameta + userID + query.qr_move, jsonString);
    return MetaDataMovedResponse.fromJson(response);
  }

  Future<UpdateMediaResponse> updateMediaData(
      String jsonString, String metaInfoID) async {
    String userID = PreferenceUtil.getStringValue(Constants.KEY_USERID_MAIN);

    var response = await _helper.updateMediaData(
        query.qr_mediameta +
            userID +
            query.qr_slash +
            query.qr_updatemediameta +
            metaInfoID,
        jsonString);
    return UpdateMediaResponse.fromJson(response);
  }

  Future<List<dynamic>> getDocumentImageListOld(
      List<MediaMasterIds> metaMasterIdList) async {
    String userID = PreferenceUtil.getStringValue(Constants.KEY_USERID);

    final response = await _helper.getDocumentImageList(
        query.qr_mediameta + userID + query.qr_slash + query.qr_rawMedia,
        metaMasterIdList);
    return response;
  }

  Future<List<ImageDocumentResponse>> getDocumentImageList(
      List<MediaMasterIds> metaMasterIdList) async {
    String userID = PreferenceUtil.getStringValue(Constants.KEY_USERID);
    var imagesList = new List<ImageDocumentResponse>();

    imagesList = await _helper.getDocumentImageList(
        query.qr_mediameta + userID + query.qr_slash + query.qr_rawMedia,
        metaMasterIdList);
    return imagesList;
  }

  Future<HealthRecordList> getHealthReportLists() async {
    String userID = PreferenceUtil.getStringValue(Constants.KEY_USERID);
    //String userID = '6aa4195b-56c6-487d-8993-dfd1b39b1a49';
    var requestParam = {};
    requestParam[query.qr_userid] = userID;

    var jsonString = convert.jsonEncode(requestParam);
    String queryVal = query.qr_health_record + query.qr_slash + query.qr_filter;

    final response = await _helper.getHealthRecordLists(jsonString, queryVal);
    return HealthRecordList.fromJson(response);
  }

  Future<HealthRecordSuccess> createMediaData(
      String jsonString, List<String> imagePaths, String audioPath) async {
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

    var response = await _helper.createMediaData(
        query.qr_health_record, jsonString, imagePaths, audioPath);
    return HealthRecordSuccess.fromJson(response.data);
  }
}
