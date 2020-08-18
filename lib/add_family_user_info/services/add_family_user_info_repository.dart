import 'dart:io';

import 'package:myfhb/add_family_user_info/models/update_add_family_info.dart';
import 'package:myfhb/add_family_user_info/models/updated_add_family_relation_info.dart';
import 'package:myfhb/add_family_user_info/models/verify_email_response.dart';
import 'package:myfhb/common/PreferenceUtil.dart';
import 'package:myfhb/constants/webservice_call.dart';
import 'package:myfhb/my_family/models/relationship_response_list.dart';
import 'package:myfhb/src/model/user/MyProfile.dart';
import 'package:myfhb/src/resources/network/ApiBaseHelper.dart';
import 'package:myfhb/constants/fhb_constants.dart' as Constants;
import 'package:myfhb/constants/fhb_query.dart' as query;


class AddFamilyUserInfoRepository {
  ApiBaseHelper _helper = ApiBaseHelper();
  WebserviceCall webserviceCall = new WebserviceCall();

  Future<RelationShipResponseList> getCustomRoles() async {
    final response = await _helper
        .getCustomRoles(query.qr_customRole + query.qr_sort);
    return RelationShipResponseList.fromJson(response);
  }

  Future<MyProfile> getMyProfileInfo(String userID) async {
    final response = await _helper.getProfileInfo(
        query.qr_Userprofile+userID+query.qr_slash+query.qr_sections+query.qr_generalInfo+query.qr_OSlash+query.qr_isOriginalPicRequired);
    return MyProfile.fromJson(response);
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
      String lastName) async {
    String query = '';

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
              lastName),
          profilePic,
          webserviceCall.getUrlToUpdateDoctor(userID));
    } else {
      response = await _helper.updateFamilyUserProfile(webserviceCall.getUrlToUpdateDoctor(userID),
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
              lastName));
    }

    return UpdateAddFamilyInfo.fromJson(response);
  }

  Future<UpdateAddFamilyRelationInfo> updateRelationShip(
      String jsonString) async {
    final response = await _helper.updateRelationShipUserInFamilyLinking(
        query.qr_userlinking, jsonString);
    return UpdateAddFamilyRelationInfo.fromJson(response);
  }

  Future<UpdateAddFamilyInfo> updateSelfProfileInfo(
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
      String lastName) async {
    String query = '';


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
              lastName),
          profilePic,
          webserviceCall.getUrlToUpdateDoctor(userID));
    } else {
      response = await _helper.updateFamilyUserProfile(webserviceCall.getUrlToUpdateDoctor(userID),
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
              lastName));
    }

    return UpdateAddFamilyInfo.fromJson(response);
  }

  Future<VerifyEmailResponse> verifyEmail() async {
    String userID = PreferenceUtil.getStringValue(Constants.KEY_USERID);

    var response = await _helper
        .verifyEmail(query.qr_Userprofile + userID + query.qr_sendVerificationMail);
    return VerifyEmailResponse.fromJson(response);
  }
}
