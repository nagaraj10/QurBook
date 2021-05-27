import 'package:flutter/cupertino.dart';
import 'package:myfhb/common/PreferenceUtil.dart';
import 'package:myfhb/myPlan/model/myPlanDetailModel.dart';
import 'package:myfhb/myPlan/model/myPlanListModel.dart';
import 'package:myfhb/myPlan/services/myPlanService.dart';
import 'package:myfhb/constants/fhb_constants.dart' as Constants;
import 'package:myfhb/plan_dashboard/model/PlanListModel.dart';
import 'package:myfhb/plan_dashboard/model/SearchListModel.dart';
import 'package:myfhb/plan_dashboard/services/SearchListService.dart';
import 'package:myfhb/plan_dashboard/services/planService.dart';

class PlanViewModel extends ChangeNotifier {

  PlanService myPlanService = new PlanService();
  SearchListService searchListService = new SearchListService();

  List<PlanListResult> myPLanListResult = List();

  Future<PlanListModel> getPlanList(String providerId) async {
    try {
      PlanListModel myPlanListModel =
      await myPlanService.getPlanList(providerId);
      if(myPlanListModel.isSuccess){
        myPLanListResult = myPlanListModel.result;
      }
      return myPlanListModel;
    } catch (e) {}
  }

  List<PlanListResult> getSearchForCategory(String title,List<PlanListResult> planListOld) {
    List<PlanListResult> filterDoctorData = new List();
    for (PlanListResult planList in planListOld) {
      if (planList.catname != null && planList.catname != '') {
        if (planList.catname
            .toLowerCase()
            .trim()
            .contains(title.toLowerCase().trim())) {
          filterDoctorData.add(planList);
        }
      }
    }
    return filterDoctorData;
  }

  List<PlanListResult> getSearchForPlanList(String title,List<PlanListResult> planListOld) {
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

  Future<SearchListModel> getSearchListInit(String title) async {
    try {
      SearchListModel searchListModel =
      await searchListService.getSearchList(title);
      return searchListModel;
    } catch (e) {}
  }

}