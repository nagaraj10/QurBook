import 'package:myfhb/common/PreferenceUtil.dart';
import 'package:myfhb/src/model/Category/CategoryResponseList.dart';
import 'package:myfhb/src/model/Category/catergory_data_list.dart';
import 'package:myfhb/src/model/Health/UserHealthResponseList.dart';
import 'package:myfhb/src/model/Health/asgard/health_record_list.dart';
import 'package:myfhb/src/resources/network/ApiBaseHelper.dart';
import 'package:myfhb/constants/fhb_constants.dart' as Constants;
import 'package:myfhb/constants/fhb_query.dart' as query;
import 'dart:convert' as convert;

class MyFamilyDetailViewRepository {
  ApiBaseHelper _helper = ApiBaseHelper();

  Future<UserHealthResponseList> getHealthReportList(String userID) async {
    //String userID = PreferenceUtil.getStringValue(Constants.KEY_USERID);

    final response = await _helper.getHealthRecordList(
        query.qr_mediameta + userID + query.qr_slash + query.qr_getMediaData,
        condition: false);
    return UserHealthResponseList.fromJson(response);
  }

  Future<CategoryResponseList> getCategoryList() async {
    final response = await _helper
        .getCategoryList(query.qr_categories + query.qr_sortCateories);
    return CategoryResponseList.fromJson(response);
  }

  Future<CategoryDataList> getCategoryLists() async {
    int offset = 0;
    int limit = 100;
    final response = await _helper.getCategoryList("${query.qr_category}");
    return CategoryDataList.fromJson(response);
  }

  Future<HealthRecordList> getHealthReportLists(String userID) async {
    // String userID = PreferenceUtil.getStringValue(Constants.KEY_USERID);
    //String userID = '6aa4195b-56c6-487d-8993-dfd1b39b1a49';
    var requestParam = {};
    requestParam[query.qr_userid] = userID;

    var jsonString = convert.jsonEncode(requestParam);
    String queryVal = query.qr_health_record + query.qr_slash + query.qr_filter;

    final response = await _helper.getHealthRecordLists(jsonString, queryVal);
    return HealthRecordList.fromJson(response);
  }
}
