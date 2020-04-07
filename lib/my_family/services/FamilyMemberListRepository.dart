import 'package:myfhb/add_family_otp/models/add_family_otp_response.dart';
import 'package:myfhb/common/PreferenceUtil.dart';
import 'package:myfhb/constants/fhb_constants.dart' as Constants;
import 'package:myfhb/my_family/models/FamilyMembersResponse.dart';
import 'package:myfhb/my_family/models/relationship_response_list.dart';
import 'package:myfhb/my_family/models/user_delinking_response.dart';
import 'package:myfhb/my_family/models/user_linking_response_list.dart';
import 'package:myfhb/src/resources/network/ApiBaseHelper.dart';

class FamilyMemberListRepository {
  ApiBaseHelper _helper = ApiBaseHelper();

  Future<FamilyMembersList> getFamilyMembersList() async {
    String userID = PreferenceUtil.getStringValue(Constants.KEY_USERID_MAIN);

    final response = await _helper.getFamilyMembersList(
        "userProfiles/$userID/myconnection?isOriginalPicRequired=false");
    return FamilyMembersList.fromJson(response);
  }

  Future<dynamic> getUserProfile(String doctorsId) async {
    final response = await _helper
        .getDoctorProfilePic("doctors/" + doctorsId + "/getprofilepic");
    return response;
  }

  Future<RelationShipResponseList> getCustomRoles() async {
    final response = await _helper
        .getCustomRoles("customRoles/" + "?sortBy=roleName.asc&limit=50");
    return RelationShipResponseList.fromJson(response);
  }

  Future<UserLinkingResponseList> postUserLinking(String jsonString) async {
    final response = await _helper.addUserLinking("userLinking/", jsonString);
    return UserLinkingResponseList.fromJson(response);
  }

  Future<AddFamilyOTPResponse> postUserLinkingForPrimaryNo(
      String jsonString) async {
    final response = await _helper.addUserLinking("userLinking/", jsonString);
    return AddFamilyOTPResponse.fromJson(response);
  }

  Future<UserDeLinkingResponseList> postUserDeLinking(String jsonString) async {
    String userID = PreferenceUtil.getStringValue(Constants.KEY_USERID);
    final response =
        await _helper.addUserDeLinking("userDelinking/$userID/", jsonString);
    return UserDeLinkingResponseList.fromJson(response);
  }
}
