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
      var userid = PreferenceUtil.getStringValue(Constants.KEY_USERID);
      PlanListModel myPlanListModel =
      await myPlanService.getPlanList(providerId,userid);
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

  List<PlanListResult> getSearchDiseases(String title,List<PlanListResult> planListOld) {
    List<PlanListResult> filterDoctorData = new List();
    for (PlanListResult planList in planListOld) {
      if (planList?.metadata?.diseases != null && planList?.metadata?.diseases != '') {
        if (planList?.metadata?.diseases
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
      if (planList.providerName != null && planList.providerName != '') {
        if (planList.providerName
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


  Future<SearchListModel> getUserSearchListInit() async {
    try {
      var userid = PreferenceUtil.getStringValue(Constants.KEY_USERID);
      SearchListModel searchListModel =
      await searchListService.getUserProviderList(userid);
      return searchListModel;
    } catch (e) {}
  }

  List<PlanListResult> getFilterForProvider(
      String title, List<PlanListResult> planListOld) {
    List<PlanListResult> filterSearch = new List();
    for (PlanListResult searchList in planListOld) {
      if (searchList?.providerName != null && searchList?.providerName != '') {
        if (searchList?.providerName
            .toLowerCase()
            .trim()
            .contains(title.toLowerCase().trim()) ||
            searchList?.providerDesc
                .toLowerCase()
                .trim()
                .contains(title.toLowerCase().trim())) {
          filterSearch.add(searchList);
        }
      }
    }
    return filterSearch;
  }

}