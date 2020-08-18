import 'package:myfhb/common/PreferenceUtil.dart';
import 'package:myfhb/src/model/Category/CategoryResponseList.dart';
import 'package:myfhb/src/model/Health/UserHealthResponseList.dart';
import 'package:myfhb/src/resources/network/ApiBaseHelper.dart';
import 'package:myfhb/constants/fhb_constants.dart' as Constants;
import 'package:myfhb/constants/fhb_query.dart' as query;

class MyFamilyDetailViewRepository {
  ApiBaseHelper _helper = ApiBaseHelper();

  Future<UserHealthResponseList> getHealthReportList(String userID) async {
  //String userID = PreferenceUtil.getStringValue(Constants.KEY_USERID);

    final response = await _helper.getHealthRecordList(
        query.qr_mediameta + userID + query.qr_slash + query.qr_getMediaData,condition: false);
    return UserHealthResponseList.fromJson(response);
  }

  Future<CategoryResponseList> getCategoryList() async {
    final response = await _helper.getCategoryList(
           query.qr_categories+query.qr_sortCateories
);
    return CategoryResponseList.fromJson(response);
  }
}
