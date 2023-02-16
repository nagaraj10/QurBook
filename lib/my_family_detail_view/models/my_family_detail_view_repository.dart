import '../../common/PreferenceUtil.dart';
import '../../src/model/Category/CategoryResponseList.dart';
import '../../src/model/Category/catergory_data_list.dart';
import '../../src/model/Health/UserHealthResponseList.dart';
import '../../src/model/Health/asgard/health_record_list.dart';
import '../../src/resources/network/ApiBaseHelper.dart';
import '../../constants/fhb_constants.dart' as Constants;
import '../../constants/fhb_query.dart' as query;
import 'dart:convert' as convert;

class MyFamilyDetailViewRepository {
  final ApiBaseHelper _helper = ApiBaseHelper();

  Future<UserHealthResponseList> getHealthReportList(String userID) async {
    //String userID = PreferenceUtil.getStringValue(Constants.KEY_USERID);

    var response = await _helper.getHealthRecordList(
        query.qr_mediameta + userID + query.qr_slash + query.qr_getMediaData,
        condition: false);
    return UserHealthResponseList.fromJson(response);
  }

  Future<CategoryResponseList> getCategoryList() async {
    var response = await _helper
        .getCategoryList(query.qr_categories + query.qr_sortCateories);
    return CategoryResponseList.fromJson(response);
  }

  Future<CategoryDataList> getCategoryLists() async {
    final offset = 0;
    final limit = 100;
    var response = await _helper.getCategoryList('${query.qr_category}');
    return CategoryDataList.fromJson(response);
  }

  Future<HealthRecordList> getHealthReportLists(String userID) async {
    // String userID = PreferenceUtil.getStringValue(Constants.KEY_USERID);
    //String userID = '6aa4195b-56c6-487d-8993-dfd1b39b1a49';
    final requestParam = {};
    requestParam[query.qr_userid] = userID;

    final jsonString = convert.jsonEncode(requestParam);
    final queryVal = query.qr_health_record + query.qr_slash + query.qr_filter;

    var response = await _helper.getHealthRecordLists(jsonString, queryVal);
    return HealthRecordList.fromJson(response);
  }
}
