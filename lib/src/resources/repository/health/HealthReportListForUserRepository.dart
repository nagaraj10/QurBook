import 'dart:convert' as convert;
import 'dart:convert';
import 'dart:io';

import 'package:myfhb/claim/model/claimmodel/ClaimSuccess.dart';
import 'package:myfhb/common/CommonUtil.dart';
import 'package:myfhb/common/PreferenceUtil.dart';
import 'package:myfhb/constants/fhb_constants.dart' as Constants;
import 'package:myfhb/device_integration/model/DeleteDeviceHealthRecord.dart';
import 'package:myfhb/more_menu/models/available_devices/AvailableDevicesResponseModel.dart';
import 'package:myfhb/record_detail/model/DoctorImageResponse.dart';
import 'package:myfhb/record_detail/model/ImageDocumentResponse.dart';
import 'package:myfhb/record_detail/model/MetaDataMovedResponse.dart';
import 'package:myfhb/record_detail/model/UpdateMediaResponse.dart';
import 'package:myfhb/src/model/CreateDeviceSelectionModel.dart';
import 'package:myfhb/src/model/GetDeviceSelectionModel.dart';
import 'package:myfhb/src/model/Health/DigitRecogResponse.dart';
import 'package:myfhb/src/model/Health/MediaMasterIds.dart';
import 'package:myfhb/src/model/Health/PostImageResponse.dart';
import 'package:myfhb/src/model/Health/SavedMetaDataResponse.dart';
import 'package:myfhb/src/model/Health/MediaMetaInfo.dart';
import 'package:myfhb/src/model/Health/UserHealthResponseList.dart';
import 'package:myfhb/src/model/Health/asgard/health_record_list.dart';
import 'package:myfhb/src/model/Health/asgard/health_record_success.dart';
import 'package:myfhb/src/model/UpdatedDeviceModel.dart';
import 'package:myfhb/src/model/common_response.dart';

import 'package:myfhb/src/resources/network/ApiBaseHelper.dart';

import 'package:myfhb/constants/fhb_query.dart' as query;
import 'package:myfhb/constants/fhb_parameters.dart' as parameters;
import 'package:myfhb/src/model/user/Tags.dart';
import 'package:myfhb/src/model/TagsResult.dart';

class HealthReportListForUserRepository {
  ApiBaseHelper _helper = ApiBaseHelper();

  Future<UserHealthResponseList> getHealthReportList(
      {required bool condition}) async {
    String userID = PreferenceUtil.getStringValue(Constants.KEY_USERID)!;

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
    String userID = PreferenceUtil.getStringValue(Constants.KEY_USERID)!;

    final response = await _helper.getDocumentImage(query.qr_mediameta +
        userID +
        query.qr_slash +
        query.qr_rawMedia +
        metaMasterID);
    return ImageDocumentResponse.fromJson(response);
  }

  Future<SavedMetaDataResponse> postMediaData(String jsonString) async {
    String? id;

    try {
      String familyId =
          PreferenceUtil.getStringValue(Constants.KEY_FAMILYMEMBERID)!;
      if (familyId.length > 0) {
        id = familyId;
      } else {
        id = PreferenceUtil.getStringValue(Constants.KEY_USERID);
      }
    } catch (e, stackTrace) {
      CommonUtil().appLogs(message: e, stackTrace: stackTrace);

      id = PreferenceUtil.getStringValue(Constants.KEY_USERID);
    }

    var response = await _helper.saveMediaData(
        query.qr_mediameta + id! + query.qr_slash + query.qr_savedmedia,
        jsonString);
    return SavedMetaDataResponse.fromJson(response);
  }

  Future<DigitRecogResponse> postDevicesData(
      List<String?> fileName, String metaID, String jsonData) async {
    String? userID = PreferenceUtil.getStringValue(Constants.KEY_USERID);

    var response = await _helper.saveImageAndGetDeviceInfo(
        query.qr_health_record +
            query.qr_digit_recog +
            query.qr_save_health_rec,
        fileName,
        metaID,
        jsonData,
        userID);
    return DigitRecogResponse.fromJson(response);
  }

  Future<PostImageResponse> postImage(
      String fileName, String metaID, String jsonData) async {
    String userID = PreferenceUtil.getStringValue(Constants.KEY_USERID)!;

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
      String? familyID, String? metaId) async {
    var signInData = {};
    signInData[parameters.strHealthRecordMetaId] = metaId;
    signInData[parameters.strDestinationUserId] = familyID;
    String? userID = await PreferenceUtil.getStringValue(Constants.KEY_USERID);
    signInData[parameters.strSourceUserId] = userID;
    var jsonString = convert.jsonEncode(signInData);

    var response = await _helper.moveMetaDataToOtherUser(
        query.qr_health_record + query.qr_move, jsonString);
    return MetaDataMovedResponse.fromJson(response);
  }

  Future<UpdateMediaResponse> updateMediaData(
      String jsonString, String metaInfoID) async {
    String userID = PreferenceUtil.getStringValue(Constants.KEY_USERID_MAIN)!;

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
    String userID = PreferenceUtil.getStringValue(Constants.KEY_USERID)!;

    final response = await _helper.getDocumentImageList(
        query.qr_mediameta + userID + query.qr_slash + query.qr_rawMedia,
        metaMasterIdList);
    return response;
  }

  Future<List<ImageDocumentResponse>> getDocumentImageList(
      List<MediaMasterIds> metaMasterIdList) async {
    String userID = PreferenceUtil.getStringValue(Constants.KEY_USERID)!;
    var imagesList = <ImageDocumentResponse>[];

    imagesList = await _helper.getDocumentImageList(
        query.qr_mediameta + userID + query.qr_slash + query.qr_rawMedia,
        metaMasterIdList);
    return imagesList;
  }

  Future<HealthRecordList> getHealthReportLists({String? commonUserId}) async {
    String? userID = PreferenceUtil.getStringValue(Constants.KEY_USERID);
    var requestParam = {};
    requestParam[query.qr_userid] =
        (commonUserId != null && commonUserId != '') ? commonUserId : userID;

    var jsonString = convert.jsonEncode(requestParam);
    String queryVal = query.qr_health_record + query.qr_filter;

    final response = await _helper.getHealthRecordLists(jsonString, queryVal);
    return HealthRecordList.fromJson(response);
  }

  Future<HealthRecordSuccess> createMediaData(
      String jsonString, List<String?>? imagePaths, String? audioPath,
      {bool isVital = false}) async {
    String? id;

    try {
      String familyId =
          PreferenceUtil.getStringValue(Constants.KEY_FAMILYMEMBERID)!;
      if (familyId.length > 0) {
        id = familyId;
      } else {
        id = PreferenceUtil.getStringValue(Constants.KEY_USERID);
      }
    } catch (e, stackTrace) {
      CommonUtil().appLogs(message: e, stackTrace: stackTrace);

      id = PreferenceUtil.getStringValue(Constants.KEY_USERID);
    }

    var response = await _helper.createMediaData(
        query.qr_health_record, jsonString, imagePaths, audioPath, id,
        isVital: isVital);
    return HealthRecordSuccess.fromJson(response.data);
  }

  Future<HealthRecordSuccess> createMediaDataClaim(
      String jsonString, List<String?>? imagePaths, String? audioPath) async {
    String? id;

    try {
      String familyId =
          PreferenceUtil.getStringValue(Constants.KEY_FAMILYMEMBERID)!;
      if (familyId.length > 0) {
        id = familyId;
      } else {
        id = PreferenceUtil.getStringValue(Constants.KEY_USERID);
      }
    } catch (e, stackTrace) {
      CommonUtil().appLogs(message: e, stackTrace: stackTrace);

      id = PreferenceUtil.getStringValue(Constants.KEY_USERID);
    }

    var response = await _helper.createMediaDataClaim(
        query.qr_health_record, jsonString, imagePaths, audioPath, id);
    return HealthRecordSuccess.fromJson(response.data);
  }

  Future<HealthRecordSuccess> updateHealthRecords(String jsonString,
      List<String?>? imagePaths, String? audioPath, String? metaId) async {
    String? id;

    try {
      String familyId =
          PreferenceUtil.getStringValue(Constants.KEY_FAMILYMEMBERID)!;
      if (familyId.length > 0) {
        id = familyId;
      } else {
        id = PreferenceUtil.getStringValue(Constants.KEY_USERID);
      }
    } catch (e, stackTrace) {
      CommonUtil().appLogs(message: e, stackTrace: stackTrace);

      id = PreferenceUtil.getStringValue(Constants.KEY_USERID);
    }

    var response = await _helper.updateHealthRecords(
        query.qr_health_record, jsonString, imagePaths, audioPath, metaId);
    return HealthRecordSuccess.fromJson(response.data);
  }

  Future<HealthRecordSuccess> updateFileInRecords(
      String? audioPath, HealthResult healthResult) async {
    String? id;

    try {
      String familyId =
          PreferenceUtil.getStringValue(Constants.KEY_FAMILYMEMBERID)!;
      if (familyId.length > 0) {
        id = familyId;
      } else {
        id = PreferenceUtil.getStringValue(Constants.KEY_USERID);
      }
    } catch (e, stackTrace) {
      CommonUtil().appLogs(message: e, stackTrace: stackTrace);

      id = PreferenceUtil.getStringValue(Constants.KEY_USERID);
    }
    var jsonString = healthResult.metadata!.toJson();

    var response = await _helper.updateHealthRecords(query.qr_health_record,
        convert.jsonEncode(jsonString), null, audioPath, healthResult.id);
    return HealthRecordSuccess.fromJson(response.data);
  }

  Future<GetDeviceSelectionModel> getDeviceSelection(
      {String? userIdFromBloc}) async {
    var userId;
    if (userIdFromBloc != null) {
      userId = userIdFromBloc;
    } else {
      userId = PreferenceUtil.getStringValue(Constants.KEY_USERID);
    }
    var myProfile =
        await PreferenceUtil.getProfileData(Constants.KEY_PROFILE_MAIN);
    bool isCareGiver = myProfile?.result?.isCaregiver ?? false;

// added extra query to check if the user is caregiver or not
    final response = await _helper.getDeviceSelection(query.qr_user_profile +
        query.qr_user +
        query.qr_my_profile +
        query.qr_member_id +
        userId +
        query.qr_isCareGiver +
        '${isCareGiver}');
    return GetDeviceSelectionModel.fromJson(response);
  }

  Future<AvailableDevicesResponseModel> getAvailableDevices() async {
    var userId = PreferenceUtil.getStringValue(Constants.KEY_USERID)!;

    final response = await _helper.getAvailableDevices(
        query.external_available_device + query.qr_userId + userId);
    return AvailableDevicesResponseModel.fromJson(response);
  }

  Future<CommonResponse> unPairDexcomm(String? externalId) async {
    var userId = PreferenceUtil.getStringValue(Constants.KEY_USERID);
    var temp = json.encode({
      'id': externalId.toString(),
      'user': {'id': userId.toString()}
    });
    final response = await _helper.unPairDexcomm(query.unpair_dexcomm, temp);
    return CommonResponse.fromJson(response);
  }

  Future<CreateDeviceSelectionModel> createDeviceSelection(
      bool? allowDigit,
      bool? allowDevice,
      bool? sheelaLiveReminders,
      bool? googleFit,
      bool? healthFit,
      bool? bpMonitor,
      bool? gluco,
      bool? pulseOximeter,
      bool? thermo,
      bool? weighScale,
      String? userId,
      String? preferred_language,
      String? qa_subscription,
      int? priColor,
      int? greColor,
      List<Tags>? tags,
      bool? allowAppointmentALert,
      bool? allowVitalALerts,
      bool? allowsymptomsAlert,
      bool? voiceCloning,
      bool? useClonedVoice) async {
    var userIDMain =
        await PreferenceUtil.getStringValue(Constants.KEY_USERID_MAIN);
    var body = jsonEncode({
      "userId": userIDMain,
      'profileSetting': {
        'allowDigit': allowDigit,
        'allowDevice': allowDevice,
        'isSheelaLiveReminder': sheelaLiveReminders,
        'googleFit': googleFit,
        'healthFit': healthFit,
        'bpMonitor': bpMonitor,
        'glucoMeter': gluco,
        'pulseOximeter': pulseOximeter,
        'thermoMeter': thermo,
        'weighScale': weighScale,
        "greColor": greColor,
        "priColor": priColor,
        "voiceCloning": bpMonitor,
        "useClonedVoice":useClonedVoice,
        'preferred_language': preferred_language,
        'qa-subscription': qa_subscription,
        'qurhome_ui': PreferenceUtil.getIfQurhomeisDefaultUI(),
        'caregiverCommunicationSetting': {
          "vitals": allowVitalALerts ?? true,
          "symptoms": allowsymptomsAlert ?? true,
          "appointments": allowAppointmentALert ?? true
        }
      },
      'tags': tags
    });

    final response = await _helper.createDeviceSelection(
        query.qr_user_profile_no_slash, body);
    return CreateDeviceSelectionModel.fromJson(response ?? {});
  }

  Future<UpdateDeviceModel> updateDeviceModel(
      userMappingId,
      bool? allowDigit,
      bool? allowDevice,
      bool? sheelaLiveReminders,
      bool? googleFit,
      bool? healthFit,
      bool? bpMonitor,
      bool? gluco,
      bool? pulseOximeter,
      bool? thermo,
      bool? weighScale,
      String? preferred_language,
      String? qa_subscription,
      int? priColor,
      int? greColor,
      List<Tags>? tagsList,
      bool? allowAppointmentALert,
      bool? allowVitalALerts,
      bool? allowsymptomsAlert,
      PreferredMeasurement? preferredMeasurement,
      bool? voiceCloning,
      // should pass when voice clone is changed otherwise it null.
      bool? isVoiceCloningChanged,
      bool? useClonedVoice) async {
    var body = jsonEncode({
      'id': userMappingId,
      'profileSetting': {
        'allowDigit': allowDigit,
        'allowDevice': allowDevice,
        'isSheelaLiveReminder': sheelaLiveReminders,
        'googleFit': googleFit,
        'healthFit': healthFit,
        'bpMonitor': bpMonitor,
        'glucoMeter': gluco,
        'pulseOximeter': pulseOximeter,
        'thermoMeter': thermo,
        'weighScale': weighScale,
        "greColor": greColor,
        "priColor": priColor,
        "useClonedVoice":useClonedVoice,
        'preferred_language': preferred_language,
        'qa-subscription': qa_subscription,
        'voiceCloning': voiceCloning,
        'qurhome_ui': PreferenceUtil.getIfQurhomeisDefaultUI(),
        'preferred_measurement': {
          'height': {
            'unitCode': preferredMeasurement?.height?.unitCode ?? '',
            'unitName': preferredMeasurement?.height?.unitName ?? ''
          },
          'weight': {
            'unitCode': preferredMeasurement?.weight?.unitCode ?? '',
            'unitName': preferredMeasurement?.weight?.unitName ?? ''
          },
          'temperature': {
            'unitCode': preferredMeasurement?.temperature?.unitCode ?? '',
            'unitName': preferredMeasurement?.temperature?.unitName ?? ''
          },
        },
        'caregiverCommunicationSetting': {
          "vitals": allowVitalALerts ?? true,
          "symptoms": allowsymptomsAlert ?? true,
          "appointments": allowAppointmentALert ?? true
        }
      },
      'tags': tagsList
    });
    final response = await _helper.updateDeviceSelection(
        query.qr_user_profile_no_slash +
            ((isVoiceCloningChanged != null) ? '?toogleVoiceClone=true' : ''),
        body);
    return UpdateDeviceModel.fromJson(response);
  }

  Future<UpdateDeviceModel> updateUnitPreferences(
      String? userMappingId,
      ProfileSetting profileSetting,
      PreferredMeasurement preferredMeasurement,
      List<Tags>? tagsList) async {
    var body = jsonEncode({
      'id': userMappingId,
      'profileSetting': {
        'allowDigit': profileSetting.allowDigit,
        'allowDevice': profileSetting.allowDevice,
        'googleFit': profileSetting.googleFit,
        'healthFit': profileSetting.healthFit,
        'bpMonitor': profileSetting.bpMonitor,
        'glucoMeter': profileSetting.glucoMeter,
        'pulseOximeter': profileSetting.pulseOximeter,
        'thermoMeter': profileSetting.thermoMeter,
        'weighScale': profileSetting.weighScale,
        "greColor": profileSetting.greColor,
        "priColor": profileSetting.preColor,
        'preferred_language': profileSetting.preferred_language,
        'qa-subscription': profileSetting.qa_subscription,
        'preferred_measurement': {
          'height': {
            'unitCode': preferredMeasurement.height!.unitCode,
            'unitName': preferredMeasurement.height!.unitName
          },
          'weight': {
            'unitCode': preferredMeasurement.weight!.unitCode,
            'unitName': preferredMeasurement.weight!.unitName
          },
          'temperature': {
            'unitCode': preferredMeasurement.temperature!.unitCode,
            'unitName': preferredMeasurement.temperature!.unitName
          },
        },
        'caregiverCommunicationSetting': {
          "vitals":
              profileSetting.caregiverCommunicationSetting?.vitals ?? true,
          "symptoms":
              profileSetting.caregiverCommunicationSetting?.symptoms ?? true,
          "appointments":
              profileSetting.caregiverCommunicationSetting?.appointments ?? true
        }
      },
      'tags': tagsList
    });

    final response = await _helper.updateDeviceSelection(
        query.qr_user_profile_no_slash, body);
    return UpdateDeviceModel.fromJson(response);
  }

  Future<TagsResult> getTags() async {
    TagsResult tagResult;
    var addressQuery = [query.qr_code_tags];

    final response = await _helper.getTags(addressQuery.toString());
    return TagsResult.fromJson(response);
  }

  /* Future<CreateDeviceSelectionModel> createAppColorSelection(
      int priColor,
      int greColor,String userId) async {
    var body = jsonEncode({
      "userId": userId,
      'profileSetting': {
        'priColor': priColor,
        'greColor': greColor
      }
    });

    final response = await _helper.createDeviceSelection(
        query.qr_user_profile_no_slash, body);
    return CreateDeviceSelectionModel.fromJson(response);
  }

  Future<UpdateDeviceModel> updateAppColorModel(
      userMappingId,
      int priColor,
      int greColor) async {
    var body = jsonEncode({
      'id': userMappingId,
      'profileSetting': {
        'priColor': priColor,
        'greColor': greColor
      }
    });
    final response = await _helper.updateDeviceSelection(
        query.qr_user_profile_no_slash, body);
    return UpdateDeviceModel.fromJson(response);
  }*/

  Future<DeleteDeviceHealthRecord> deleteDeviceRecords(String deviceId) async {
    final response =
        await _helper.deleteDeviceRecords(query.device_health + deviceId);
    return DeleteDeviceHealthRecord.fromJson(response);
  }

  Future<ClaimSuccess> createClaimRecord(String jsonString) async {
    var response = await _helper.createClaimRecord(query.qr_claim, jsonString);
    return ClaimSuccess.fromJson(response);
  }
}
