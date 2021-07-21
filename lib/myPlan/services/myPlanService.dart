import '../../constants/fhb_query.dart';
import '../model/myPlanDetailModel.dart';
import '../model/myPlanListModel.dart';
import '../../src/resources/network/ApiBaseHelper.dart';
import 'dart:convert' as convert;

class MyPlanService {
  final ApiBaseHelper _helper = ApiBaseHelper();

  Future<MyPlanListModel> getMyPlanList(String patientId) async {
    final body = {};
    body['method'] = qr_get;
    body['data'] = qr_getUserPack+qr_patientEqaul+patientId;
    final jsonString = convert.jsonEncode(body);
    var response = await _helper.getPlanList(qr_plan_list,jsonString);
    return MyPlanListModel.fromJson(response);
  }

  Future<MyPlanDetailModel> getMyPlanDetails(String packageId) async {
    final body = {};
    body['method'] = qr_get;
    body['data'] = qr_getUserPackDetail+qr_patientEqaul+packageId;
    final jsonString = convert.jsonEncode(body);
    var response = await _helper.getPlanDetails(qr_plan_list,jsonString);
    return MyPlanDetailModel.fromJson(response);
  }
}
