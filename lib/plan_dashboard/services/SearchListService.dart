import 'package:myfhb/common/PreferenceUtil.dart';
import 'package:myfhb/constants/fhb_query.dart';
import 'package:myfhb/myPlan/model/myPlanDetailModel.dart';
import 'package:myfhb/myPlan/model/myPlanListModel.dart';
import 'package:myfhb/plan_dashboard/model/PlanListModel.dart';
import 'package:myfhb/plan_dashboard/model/SearchListModel.dart';
import 'package:myfhb/src/resources/network/ApiBaseHelper.dart';
import 'dart:convert' as convert;
import 'package:myfhb/constants/fhb_constants.dart' as Constants;

class SearchListService {
  ApiBaseHelper _helper = ApiBaseHelper();

  Future<SearchListModel> getSearchList(String title) async {
    var userid = PreferenceUtil.getStringValue(Constants.KEY_USERID);
    var body = {};
    body['method'] = qr_get;
    body['data'] = qr_getSearchList+qr_qEqaul+title+qr_patientEqaul+userid;
    var jsonString = convert.jsonEncode(body);
    final response = await _helper.getSearchListApi(qr_plan_list,jsonString);
    return SearchListModel.fromJson(response);
  }

  Future<SearchListModel> getUserProviderList(String patientId) async {
    var body = {};
    body['method'] = qr_get;
    body['data'] = qr_getUserSearchList+qr_patientEqaul+patientId;
    var jsonString = convert.jsonEncode(body);
    final response = await _helper.getSearchListApi(qr_plan_list,jsonString);
    return SearchListModel.fromJson(response);
  }
}
