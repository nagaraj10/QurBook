import 'dart:convert';
import 'dart:io';

import '../models/CityListModel.dart';
import '../models/address_type_list.dart';
import '../models/update_add_family_info.dart';
import '../models/update_relatiosnship_model.dart';
import '../models/update_self_profile_model.dart';
import '../models/updated_add_family_relation_info.dart';
import '../models/verify_email_response.dart';
import '../../common/CommonConstants.dart';
import '../../common/PreferenceUtil.dart';
import '../../constants/fhb_constants.dart' as Constants;
import '../../constants/fhb_query.dart' as query;
import '../../constants/webservice_call.dart';
import '../../my_family/models/relationship_response_list.dart';
import '../../src/model/common_response.dart';
import '../../src/model/user/MyProfileModel.dart';
import '../../src/model/user/city_list_model.dart';
import '../../src/model/user/state_list_model.dart';
import '../../src/resources/network/ApiBaseHelper.dart';

class AddFamilyUserInfoRepository {
  final ApiBaseHelper _helper = ApiBaseHelper();
  WebserviceCall webserviceCall = WebserviceCall();

  Future<RelationShipResponseList> getCustomRoles() async {
    var response = await _helper.getCustomRoles(query.qr_customRole);
    return RelationShipResponseList.fromJson(response);
  }

  Future<MyProfileModel> getMyProfileInfo(String userID) async {
    var response = await _helper.getProfileInfo(query.qr_Userprofile +
        userID +
        query.qr_slash +
        query.qr_sections +
        query.qr_generalInfo +
        query.qr_OSlash +
        query.qr_isOriginalPicRequired);
    return MyProfileModel.fromJson(response);
  }

  Future<MyProfileModel> getMyProfileInfoNew(String userID) async {
    var response;
    if (userID != null) {
      response = await _helper.getProfileInfo(
          query.qr_user + userID + query.qr_sections + query.qr_generalInfo);
    }
    return MyProfileModel.fromJson(response);
  }

  Future<UpdateAddFamilyInfo> updateUserProfileInfo(
      String userID,
      String name,
      String phoneNo,
      String email,
      String gender,
      String bloodGroup,
      String dateOfBirth,
      File profilePic,
      String firstName,
      String middleName,
      String lastName,
      String cityId,
      String stateId,
      String addressLine1,
      String addressLine2,
      String zipcode,
      bool fromFamily) async {
    final query = '';

    var response;

    if (profilePic != null) {
      response = await _helper.saveImageToServerClone1(
          webserviceCall.getQueryToUpdateProfile(
              userID,
              name,
              phoneNo,
              email,
              gender,
              bloodGroup,
              dateOfBirth,
              profilePic,
              firstName,
              middleName,
              lastName,
              cityId,
              stateId,
              addressLine1,
              addressLine2,
              zipcode,
              fromFamily),
          profilePic,
          webserviceCall.getUrlToUpdateDoctor(userID));
    } else {
      response = await _helper.updateFamilyUserProfile(
          webserviceCall.getUrlToUpdateDoctor(userID),
          webserviceCall.getQueryToUpdateProfile(
              userID,
              name,
              phoneNo,
              email,
              gender,
              bloodGroup,
              dateOfBirth,
              profilePic,
              firstName,
              middleName,
              lastName,
              cityId,
              stateId,
              addressLine1,
              addressLine2,
              zipcode,
              fromFamily));
    }

    return UpdateAddFamilyInfo.fromJson(response);
  }

  Future<UpdateSelfProfileModel> updateUserInfoNew(
      String userID,
      String name,
      String phoneNo,
      String email,
      String gender,
      String bloodGroup,
      String dateOfBirth,
      File profilePic,
      String firstName,
      String middleName,
      String lastName,
      String cityId,
      String stateId,
      bool isUpdate,
      String addressLine1,
      String addressLine2,
      String zipcode,
      bool fromFamily,
      MyProfileModel myProfileModel,
      UpdateRelationshipModel relationship) async {
    var query = '';

    var response;

    if (profilePic != null) {
      response = await _helper.saveImageToServerClone1(
          webserviceCall.getQueryToUpdateProfile(
              userID,
              name,
              phoneNo,
              email,
              gender,
              bloodGroup,
              dateOfBirth,
              profilePic,
              firstName,
              middleName,
              lastName,
              cityId,
              stateId,
              addressLine1,
              addressLine2,
              zipcode,
              fromFamily),
          profilePic,
          webserviceCall.getUrlToUpdateDoctor(userID));
    } else {
      response = await _helper.updateSelfProfileNew(
          webserviceCall.getQueryDoctorUpdate(userID),
          webserviceCall.makeJsonForUpdateProfile(
              userID,
              name,
              phoneNo,
              email,
              gender,
              bloodGroup,
              dateOfBirth,
              profilePic,
              firstName,
              middleName,
              lastName,
              cityId,
              stateId,
              isUpdate,
              addressLine1,
              addressLine2,
              zipcode,
              myProfileModel,
              relationship));
    }

    return UpdateSelfProfileModel.fromJson(response);
  }

  Future<UpdateAddFamilyRelationInfo> updateRelationShip(
      String jsonString) async {
    var response = await _helper.updateRelationShipUserInFamilyLinking(
        query.qr_userlinking, jsonString);
    return UpdateAddFamilyRelationInfo.fromJson(response);
  }

  Future<UpdateSelfProfileModel> updateSelfProfileInfo(
      String userID,
      String name,
      String phoneNo,
      String email,
      String gender,
      String bloodGroup,
      String dateOfBirth,
      File profilePic,
      String firstName,
      String middleName,
      String lastName,
      String cityId,
      String stateId,
      String addressLine1,
      String addressLine2,
      String zipcode,
      bool fromFamily) async {
    var query = '';

    var response;

    if (profilePic != null) {
      response = await _helper.saveImageToServerClone1(
          webserviceCall.getQueryToUpdateProfile(
              userID,
              name,
              phoneNo,
              email,
              gender,
              bloodGroup,
              dateOfBirth,
              profilePic,
              firstName,
              middleName,
              lastName,
              cityId,
              stateId,
              addressLine1,
              addressLine2,
              zipcode,
              fromFamily),
          profilePic,
          webserviceCall.getQueryForUserUpdate(userID));
    } else {
      response = await _helper.updateFamilyUserProfile(
          webserviceCall.getQueryForUserUpdate(userID),
          webserviceCall.getQueryToUpdateProfile(
              userID,
              name,
              phoneNo,
              email,
              gender,
              bloodGroup,
              dateOfBirth,
              profilePic,
              firstName,
              middleName,
              lastName,
              cityId,
              stateId,
              addressLine1,
              addressLine2,
              zipcode,
              fromFamily));
    }

    return UpdateSelfProfileModel.fromJson(response);
  }

  Future<VerifyEmailResponse> verifyEmail() async {
    final userID = PreferenceUtil.getStringValue(Constants.KEY_USERID);

    final response = await _helper.verifyEmail(
        query.qr_Userprofile + userID + query.qr_sendVerificationMail);
    return VerifyEmailResponse.fromJson(response);
  }

  Future<CityModel> getValuesBaseOnSearch(
      String cityname, String apibody) async {
    final response = await _helper.getValueBasedOnSearch(cityname, apibody);
    return CityModel.fromJson(response);
  }

  Future<StateModel> getStateValuesBaseOnSearch(
      String stateName, String apibody) async {
    final response = await _helper.getValueBasedOnSearch(stateName, apibody);
    return StateModel.fromJson(response);
  }

  Future<AddressTypeResult> getAddressTypeResult(String codeType) async {
    final responseQuery = CommonConstants.strReferenceValue +
        CommonConstants.strSlash +
        CommonConstants.strDataCodes;
    var response = await _helper.fetchAddressType(responseQuery);

    return response;
  }

  Future<CommonResponse> getUserProfilePic(String userId) async {
    final responseQuery =
        '${CommonConstants.strUserQuery}$userId${CommonConstants.strQueryString}${CommonConstants.strGetProfilePic}';
    final CommonResponse response =
        await _helper.getUserProfilePic(responseQuery);

    return response;
  }

  Future<CommonResponse> updateUserProfilePic(String userId, File image) async {
    var responseQuery =
        '${CommonConstants.strUserQuery}$userId${CommonConstants.strQueryString}${CommonConstants.strGetProfilePic}';
    final res =
        await _helper.uploadUserProfilePicToServer(responseQuery, image);
    final response = CommonResponse.fromJson(res);
    return response;
  }
}
