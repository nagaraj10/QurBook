import '../../constants/fhb_query.dart';
import '../../myPlan/model/myPlanDetailModel.dart';
import '../../myPlan/model/myPlanListModel.dart';
import '../model/PlanListModel.dart';
import '../../src/resources/network/ApiBaseHelper.dart';
import 'dart:convert' as convert;

class PlanService {
  final ApiBaseHelper _helper = ApiBaseHelper();

  Future<PlanListModel> getPlanList(String providerId,String patientId) async {
    final body = {};
    body['method'] = qr_get;
    body['data'] = qr_getPack+qr_providerEqaul+providerId+qr_patientEqaul+patientId;
    final jsonString = convert.jsonEncode(body);
    var response = await _helper.getPlanList(qr_plan_list,jsonString);
    return PlanListModel.fromJson(response);
  }

  Future<PlanListModel> getPlanDetailById(String patientId,String packageId) async {
    final body = {};
    body['method'] = qr_get;
    body['data'] = qr_getPack_details+packageId+qr_patientEqaul+patientId;
    final jsonString = convert.jsonEncode(body);
    var response = await _helper.getPlanList(qr_plan_list,jsonString);
    return PlanListModel.fromJson(response);
  }
}
