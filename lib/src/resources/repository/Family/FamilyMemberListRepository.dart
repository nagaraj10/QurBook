import 'package:myfhb/src/model/Family/FamilyMembersResponse.dart';
import 'package:myfhb/src/resources/network/ApiBaseHelper.dart';
import 'package:myfhb/constants/fhb_constants.dart' as Constants;

class FamilyMemberListRepository {
  ApiBaseHelper _helper = ApiBaseHelper();

  Future<FamilyMembersList> getFamilyMembersList() async {
    final response = await _helper.getFamilyMembersList(
        "userProfiles/${Constants.USER_ID}/myconnection?isOriginalPicRequired=false");
    return FamilyMembersList.fromJson(response);
  }

  Future<dynamic> getUserProfile(String doctorsId) async {
    final response = await _helper
        .getDoctorProfilePic("doctors/" + doctorsId + "/getprofilepic");
    return response;
  }
}
