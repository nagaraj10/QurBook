import 'package:myfhb/common/PreferenceUtil.dart';
import 'package:myfhb/src/model/user/MyProfile.dart';
import 'package:myfhb/src/model/user/ProfileCompletedata.dart';
import 'package:myfhb/src/resources/network/ApiBaseHelper.dart';
import 'package:myfhb/constants/fhb_constants.dart' as Constants;

class MyProfileRepository {
  ApiBaseHelper _helper = ApiBaseHelper();

  Future<MyProfile> getMyProfileInfo(String profileKey) async {
    if (profileKey == null || profileKey == '') {
      profileKey = Constants.KEY_USERID_MAIN;
    }
    String userID = PreferenceUtil.getStringValue(profileKey);
    final response = await _helper
        .getProfileInfo("userProfiles/${userID}/?sections=generalInfo");

    return MyProfile.fromJson(response);
  }


  Future<ProfileCompleteData> getCompleteMyProfileInfo(
      String profileKey) async {
    if (profileKey == null || profileKey == '') {
      profileKey = Constants.KEY_USERID_MAIN;
    }
    String userID = PreferenceUtil.getStringValue(profileKey);

    final response = await _helper
        .getProfileInfo("userProfiles/${userID}/"); //?sections=generalInfo"
    return ProfileCompleteData.fromJson(response);
  }
}
