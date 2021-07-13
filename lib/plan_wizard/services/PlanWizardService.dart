import 'package:myfhb/constants/fhb_query.dart';
import 'package:myfhb/plan_dashboard/model/PlanListModel.dart';
import 'package:myfhb/src/resources/network/ApiBaseHelper.dart';
import 'dart:convert' as convert;
import 'package:myfhb/plan_wizard/models/health_condition_response_model.dart';

class PlanWizardService {
  ApiBaseHelper _helper = ApiBaseHelper();

  Future<PlanListModel> getPlanList(String patientId) async {
    var body = {};
    body['method'] = qr_get;
    body['data'] = getMenuCarePlans;
    var jsonString = convert.jsonEncode(body);
    final response = await _helper.getPlanList(qr_plan_list, jsonString);
    return PlanListModel.fromJson(response);
  }

  Future<HealthConditionResponseModel> getHealthConditions(
    String patientId,
  ) async {
    var body = {};
    body['method'] = qr_get;
    body['data'] = qr_health_conditions + qr_patientEqaul + patientId;
    var jsonString = convert.jsonEncode(body);
    final response =
        await _helper.getHealthConditions(qr_plan_list, jsonString);
    print(response);
    return HealthConditionResponseModel.fromJson(response);
  }
}
