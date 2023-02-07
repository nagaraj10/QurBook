import 'dart:convert';

import 'package:myfhb/my_family/models/DelinkCheckResponse.dart';

import '../../add_family_otp/models/add_family_otp_response.dart';
import '../../common/PreferenceUtil.dart';
import '../../constants/fhb_constants.dart' as Constants;
import '../../constants/fhb_query.dart' as query;
import '../../constants/webservice_call.dart';
import '../models/FamilyMembersRes.dart';
import '../models/FamilyMembersResponse.dart';
import '../models/relationship_response_list.dart';
import '../models/user_delinking_response.dart';
import '../models/user_linking_response_list.dart';
import '../../src/resources/network/ApiBaseHelper.dart';

class FamilyMemberListRepository {
  final ApiBaseHelper _helper = ApiBaseHelper();
  WebserviceCall webserviceCall = WebserviceCall();

  Future<FamilyMembersList> getFamilyMembersList() async {
    final userID = PreferenceUtil.getStringValue(Constants.KEY_USERID_MAIN);

    var response = await _helper
        .getFamilyMembersList(webserviceCall.getQueryForFamilyMemberList());
    return FamilyMembersList.fromJson(response);
  }

  Future<FamilyMembers> getFamilyMembersListNew() async {
    final userID = PreferenceUtil.getStringValue(Constants.KEY_USERID_MAIN);

    var response = await _helper.getFamilyMembersListNew(
        webserviceCall.getQueryForFamilyMemberListNew());
    return FamilyMembers.fromJson(response);
  }

  Future<dynamic> getUserProfile(String doctorsId) async {
    var response = await _helper.getDoctorProfilePic(
        query.qr_doctors + doctorsId + query.qr_profilePic);
    return response;
  }

  Future<RelationShipResponseList> getCustomRoles() async {
    var response = await _helper.getCustomRoles(query.qr_customRole);
    return RelationShipResponseList.fromJson(response);
  }

  Future<UserLinkingResponseList> postUserLinking(String jsonString) async {
    var response =
        await _helper.addUserLinking(query.qr_userlinking, jsonString);
    return UserLinkingResponseList.fromJson(response);
  }

  Future<AddFamilyOTPResponse> postUserLinkingForPrimaryNo(
      String jsonString) async {
    var response =
        await _helper.addUserLinking(query.qr_userlinking, jsonString);
    return AddFamilyOTPResponse.fromJson(response);
  }

  Future<UserDeLinkingResponseList> postUserDeLinking(String jsonString) async {
    var response = await _helper.addUserDeLinking(
        webserviceCall.getQueryForPostUserDelinkingNew(), jsonString);
    return UserDeLinkingResponseList.fromJson(response);
  }

  Future<DelinkCheckResponse> checkDelink(String jsonString) async {
    var response = await _helper.checkUserDelink(
        query.qr_delink_check, jsonString);
    return DelinkCheckResponse.fromJson(response);
  }
}
