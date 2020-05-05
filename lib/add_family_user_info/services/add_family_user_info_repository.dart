import 'dart:io';

import 'package:myfhb/add_family_user_info/models/update_add_family_info.dart';
import 'package:myfhb/add_family_user_info/models/updated_add_family_relation_info.dart';
import 'package:myfhb/add_family_user_info/models/verify_email_response.dart';
import 'package:myfhb/common/PreferenceUtil.dart';
import 'package:myfhb/my_family/models/relationship_response_list.dart';
import 'package:myfhb/src/model/user/MyProfile.dart';
import 'package:myfhb/src/resources/network/ApiBaseHelper.dart';
import 'package:myfhb/constants/fhb_constants.dart' as Constants;

class AddFamilyUserInfoRepository {
  ApiBaseHelper _helper = ApiBaseHelper();

  Future<RelationShipResponseList> getCustomRoles() async {
    final response = await _helper
        .getCustomRoles("customRoles/" + "?sortBy=roleName.asc&limit=50");
    return RelationShipResponseList.fromJson(response);
  }

  Future<MyProfile> getMyProfileInfo(String userID) async {
    final response = await _helper.getProfileInfo(
        "userProfiles/$userID/?sections=generalInfo|isOriginalPicRequired=false");
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

    query =
        "generalInfo||gender=$gender|bloodGroup=$bloodGroup|dateOfBirth=$dateOfBirth|name=$name|firstName=$firstName|middleName=$middleName|lastName=$lastName|email=$email";

    var response;

    print('add familyUser $query');

    if (profilePic != null) {
      response = await _helper.saveImageToServerClone1(
          "userProfiles/$userID/?sections=$query", profilePic, '');
    } else {
      response = await _helper
          .updateFamilyUserProfile("userProfiles/$userID/?sections=$query");
    }

    return UpdateAddFamilyInfo.fromJson(response);
  }

  Future<UpdateAddFamilyRelationInfo> updateRelationShip(
      String jsonString) async {
    final response = await _helper.updateRelationShipUserInFamilyLinking(
        "userLinking/", jsonString);
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

    query =
        "generalInfo||gender=$gender|bloodGroup=$bloodGroup|dateOfBirth=$dateOfBirth|name=$name|firstName=$firstName|middleName=$middleName|lastName=$lastName|email=$email";
    // query ="generalInfo||firstName=$firstName|middleName=$middleName|lastName=$lastName";

    var response;

    if (profilePic != null) {
      response = await _helper.saveImageToServerClone1(
          "userProfiles/$userID/?sections=${query}", profilePic, '');
    } else {
      response = await _helper
          .updateFamilyUserProfile("userProfiles/$userID/?sections=${query}");
    }
    print('respponse' + response.toString());

    return UpdateAddFamilyInfo.fromJson(response);
  }

  Future<VerifyEmailResponse> verifyEmail() async {
    String userID = PreferenceUtil.getStringValue(Constants.KEY_USERID);

    var response = await _helper
        .verifyEmail("userProfiles/" + userID + "/sendVerificationMail");
    return VerifyEmailResponse.fromJson(response);
  }
}
