import 'package:myfhb/constants/fhb_query.dart';
import 'package:myfhb/plan_dashboard/model/subscribeModel.dart';
import 'package:myfhb/src/resources/network/ApiBaseHelper.dart';
import 'dart:convert' as convert;

class SubscribeService {
  ApiBaseHelper _helper = ApiBaseHelper();

  Future<SubscribeModel> subscribePlan(String packageId,String patientId) async {
    var body = {};
    body['method'] = qr_get;
    body['data'] = qr_subscribePlan+packageId+qr_patientEqaul+patientId;
    var jsonString = convert.jsonEncode(body);
    final response = await _helper.getPlanList(qr_plan_list,jsonString);
    return SubscribeModel.fromJson(response);
  }

  Future<SubscribeModel> UnsubscribePlan(String packageId,String patientId) async {
    var body = {};
    body['method'] = qr_get;
    body['data'] = qr_UnsubscribePlan+packageId+qr_patientEqaul+patientId;
    var jsonString = convert.jsonEncode(body);
    final response = await _helper.getPlanList(qr_plan_list,jsonString);
    return SubscribeModel.fromJson(response);
  }
}
