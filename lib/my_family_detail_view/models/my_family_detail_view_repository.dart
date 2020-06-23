import 'package:myfhb/src/model/Category/CategoryResponseList.dart';
import 'package:myfhb/src/model/Health/UserHealthResponseList.dart';
import 'package:myfhb/src/resources/network/ApiBaseHelper.dart';

class MyFamilyDetailViewRepository {
  ApiBaseHelper _helper = ApiBaseHelper();

  Future<UserHealthResponseList> getHealthReportList(String userID) async {
//    String userID = PreferenceUtil.getStringValue(Constants.KEY_USERID);

    final response = await _helper
        .getHealthRecordList("mediameta/" + userID + "/getmediameta/");
    return UserHealthResponseList.fromJson(response);
  }

  Future<CategoryResponseList> getCategoryList() async {
    final response = await _helper.getCategoryList(
        "categories/?sortBy=categoryName.asc&offset=0&limit=10");
    return CategoryResponseList.fromJson(response);
  }
}
