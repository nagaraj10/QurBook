import 'package:flutter/cupertino.dart';
import 'package:myfhb/common/PreferenceUtil.dart';
import 'package:myfhb/myPlan/model/myPlanDetailModel.dart';
import 'package:myfhb/myPlan/model/myPlanListModel.dart';
import 'package:myfhb/myPlan/services/myPlanService.dart';
import 'package:myfhb/constants/fhb_constants.dart' as Constants;
import 'package:myfhb/plan_dashboard/model/PlanListModel.dart';
import 'package:myfhb/plan_dashboard/services/planService.dart';

class PlanViewModel extends ChangeNotifier {

  PlanService myPlanService = new PlanService();

  List<PlanListResult> myPLanListResult = List();

  Future<PlanListModel> getPlanList() async {
    try {
      PlanListModel myPlanListModel =
      await myPlanService.getPlanList();
      if(myPlanListModel.isSuccess){
        myPLanListResult = myPlanListModel.result;
      }
      return myPlanListModel;
    } catch (e) {}
  }

  List<PlanListResult> getSearch(String title,List<PlanListResult> planListOld) {
    List<PlanListResult> filterDoctorData = new List();
    for (PlanListResult planList in planListOld) {
      if (planList.title != null && planList.title != '') {
        if (planList.title
            .toLowerCase()
            .trim()
            .contains(title.toLowerCase().trim())) {
          filterDoctorData.add(planList);
        }
      }
    }
    return filterDoctorData;
  }

}