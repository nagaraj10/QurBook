import 'package:flutter/cupertino.dart';
import 'package:myfhb/common/PreferenceUtil.dart';
import 'package:myfhb/myPlan/model/myPlanDetailModel.dart';
import 'package:myfhb/myPlan/model/myPlanListModel.dart';
import 'package:myfhb/myPlan/services/myPlanService.dart';
import 'package:myfhb/constants/fhb_constants.dart' as Constants;

class MyPlanViewModel extends ChangeNotifier {

  MyPlanService myPlanService = new MyPlanService();

  Future<MyPlanListModel> getMyPlanList() async {
    try {
      String patientId = PreferenceUtil.getStringValue(Constants.KEY_USERID);
      MyPlanListModel myPlanListModel =
      await myPlanService.getMyPlanList(patientId);
      return myPlanListModel;
    } catch (e) {}
  }

  Future<MyPlanDetailModel> getMyPlanDetails(String patientId) async {
    try {
      MyPlanDetailModel myPlanDetailModel =
      await myPlanService.getMyPlanDetails(patientId);
      return myPlanDetailModel;
    } catch (e) {}
  }

}