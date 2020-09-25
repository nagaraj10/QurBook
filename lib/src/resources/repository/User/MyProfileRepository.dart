import 'package:myfhb/common/PreferenceUtil.dart';
import 'package:myfhb/src/model/user/MyProfileModel.dart';
import 'package:myfhb/src/model/user/ProfileCompletedata.dart';
import 'package:myfhb/src/resources/network/ApiBaseHelper.dart';
import 'package:myfhb/constants/fhb_constants.dart' as Constants;
import 'package:myfhb/constants/fhb_query.dart' as query;
import 'package:myfhb/constants/fhb_parameters.dart' as parameters;

class MyProfileRepository {
  ApiBaseHelper _helper = ApiBaseHelper();

  Future<MyProfileModel> getMyProfileInfo(String profileKey) async {
    if (profileKey == null || profileKey == '') {
      profileKey = Constants.KEY_USERID_MAIN;
    }
    String userID = PreferenceUtil.getStringValue(profileKey);
    final response = await _helper.getProfileInfo(query.qr_user +
        userID +
        query.qr_slash +
        query.qr_sections +
        query.qr_generalInfo);

    return MyProfileModel.fromJson(response);
  }

  Future<ProfileCompleteData> getCompleteMyProfileInfo(
      String profileKey) async {
    if (profileKey == null || profileKey == '') {
      profileKey = Constants.KEY_USERID_MAIN;
    }
    String userID = PreferenceUtil.getStringValue(profileKey);

    final response = await _helper.getProfileInfo(query.qr_user +
        userID +
        query.qr_slash); //?sections=generalInfo"
    return ProfileCompleteData.fromJson(response);
  }
}
