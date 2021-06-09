import 'package:myfhb/constants/fhb_query.dart';
import 'package:myfhb/myPlan/model/myPlanDetailModel.dart';
import 'package:myfhb/myPlan/model/myPlanListModel.dart';
import 'package:myfhb/src/resources/network/ApiBaseHelper.dart';
import 'dart:convert' as convert;

class MyPlanService {
  ApiBaseHelper _helper = ApiBaseHelper();

  Future<MyPlanListModel> getMyPlanList(String patientId) async {
    var body = {};
    body['method'] = qr_get;
    body['data'] = qr_getUserPack+qr_patientEqaul+patientId;
    var jsonString = convert.jsonEncode(body);
    final response = await _helper.getPlanList(qr_plan_list,jsonString);
    return MyPlanListModel.fromJson(response);
  }

  Future<MyPlanDetailModel> getMyPlanDetails(String packageId) async {
    var body = {};
    body['method'] = qr_get;
    body['data'] = qr_getUserPackDetail+qr_patientEqaul+packageId;
    var jsonString = convert.jsonEncode(body);
    final response = await _helper.getPlanDetails(qr_plan_list,jsonString);
    return MyPlanDetailModel.fromJson(response);
  }
}
