import 'package:myfhb/constants/fhb_query.dart';
import 'package:myfhb/myPlan/model/myPlanDetailModel.dart';
import 'package:myfhb/myPlan/model/myPlanListModel.dart';
import 'package:myfhb/plan_dashboard/model/PlanListModel.dart';
import 'package:myfhb/plan_dashboard/model/SearchListModel.dart';
import 'package:myfhb/src/resources/network/ApiBaseHelper.dart';
import 'dart:convert' as convert;

class SearchListService {
  ApiBaseHelper _helper = ApiBaseHelper();

  Future<SearchListModel> getSearchList(String title) async {
    var body = {};
    body['method'] = qr_get;
    body['data'] = qr_getSearchList+qr_qEqaul+title;
    var jsonString = convert.jsonEncode(body);
    final response = await _helper.getSearchListApi(qr_plan_list,jsonString);
    return SearchListModel.fromJson(response);
  }

  Future<SearchListModel> getUserProviderList() async {
    var body = {};
    body['method'] = qr_get;
    body['data'] = qr_getUserSearchList;
    var jsonString = convert.jsonEncode(body);
    final response = await _helper.getSearchListApi(qr_plan_list,jsonString);
    return SearchListModel.fromJson(response);
  }
}
