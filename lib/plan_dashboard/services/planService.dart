import 'package:myfhb/constants/fhb_query.dart';
import 'package:myfhb/myPlan/model/myPlanDetailModel.dart';
import 'package:myfhb/myPlan/model/myPlanListModel.dart';
import 'package:myfhb/plan_dashboard/model/PlanListModel.dart';
import 'package:myfhb/src/resources/network/ApiBaseHelper.dart';
import 'dart:convert' as convert;

class PlanService {
  ApiBaseHelper _helper = ApiBaseHelper();

  Future<PlanListModel> getPlanList(String providerId,String patientId) async {
    var body = {};
    body['method'] = qr_get;
    body['data'] = qr_getPack+qr_providerEqaul+providerId+qr_patientEqaul+patientId;
    var jsonString = convert.jsonEncode(body);
    final response = await _helper.getPlanList(qr_plan_list,jsonString);
    return PlanListModel.fromJson(response);
  }
}
