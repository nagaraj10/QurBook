import 'package:myfhb/constants/fhb_query.dart';
import 'package:myfhb/myPlan/model/myPlanDetailModel.dart';
import 'package:myfhb/myPlan/model/myPlanListModel.dart';
import 'package:myfhb/src/resources/network/ApiBaseHelper.dart';

class MyPlanService{

  ApiBaseHelper _helper = ApiBaseHelper();

  Future<MyPlanListModel> getMyPlanList(
      String patientId) async {
    final response = await _helper.getPlanList(qr_plan_list+patientId);
    return MyPlanListModel.fromJson(response);
  }

  Future<MyPlanDetailModel> getMyPlanDetails(
      String patientId) async {
    final response = await _helper.getPlanDetails(qr_getSlots);
    return MyPlanDetailModel.fromJson(response);
  }
}