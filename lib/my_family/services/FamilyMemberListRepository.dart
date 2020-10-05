import 'dart:convert';

import 'package:myfhb/add_family_otp/models/add_family_otp_response.dart';
import 'package:myfhb/common/PreferenceUtil.dart';
import 'package:myfhb/constants/fhb_constants.dart' as Constants;
import 'package:myfhb/constants/fhb_query.dart' as query;
import 'package:myfhb/constants/webservice_call.dart';
import 'package:myfhb/my_family/models/FamilyMembersRes.dart';
import 'package:myfhb/my_family/models/FamilyMembersResponse.dart';
import 'package:myfhb/my_family/models/relationship_response_list.dart';
import 'package:myfhb/my_family/models/user_delinking_response.dart';
import 'package:myfhb/my_family/models/user_linking_response_list.dart';
import 'package:myfhb/src/resources/network/ApiBaseHelper.dart';

class FamilyMemberListRepository {
  ApiBaseHelper _helper = ApiBaseHelper();
  WebserviceCall webserviceCall = new WebserviceCall();

  Future<FamilyMembersList> getFamilyMembersList() async {
    String userID = PreferenceUtil.getStringValue(Constants.KEY_USERID_MAIN);

    final response = await _helper
        .getFamilyMembersList(webserviceCall.getQueryForFamilyMemberList());
    return FamilyMembersList.fromJson(response);
  }

  Future<FamilyMembers> getFamilyMembersListNew() async {
    String userID = PreferenceUtil.getStringValue(Constants.KEY_USERID_MAIN);

    final response = await _helper.getFamilyMembersListNew(
        webserviceCall.getQueryForFamilyMemberListNew());
    return FamilyMembers.fromJson(response);
  }

  Future<dynamic> getUserProfile(String doctorsId) async {
    final response = await _helper.getDoctorProfilePic(
        query.qr_doctors + doctorsId + query.qr_profilePic);
    return response;
  }

  Future<RelationShipResponseList> getCustomRoles() async {
    final response = await _helper.getCustomRoles(query.qr_customRole);
    return RelationShipResponseList.fromJson(response);
  }

  Future<UserLinkingResponseList> postUserLinking(String jsonString) async {
    final response =
        await _helper.addUserLinking(query.qr_userlinking, jsonString);
    return UserLinkingResponseList.fromJson(response);
  }

  Future<AddFamilyOTPResponse> postUserLinkingForPrimaryNo(
      String jsonString) async {
    final response =
        await _helper.addUserLinking(query.qr_userlinking, jsonString);
    return AddFamilyOTPResponse.fromJson(response);
  }

  Future<UserDeLinkingResponseList> postUserDeLinking(String jsonString) async {
    final response = await _helper.addUserDeLinking(
        webserviceCall.getQueryForPostUserDelinkingNew(), jsonString);
    return UserDeLinkingResponseList.fromJson(response);
  }
}
