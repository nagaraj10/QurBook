import 'package:flutter/cupertino.dart';
import '../../common/PreferenceUtil.dart';
import '../../myPlan/model/myPlanDetailModel.dart';
import '../../myPlan/model/myPlanListModel.dart';
import '../../myPlan/services/myPlanService.dart';
import '../../constants/fhb_constants.dart' as Constants;
import '../model/PlanListModel.dart';
import '../model/SearchListModel.dart';
import '../services/SearchListService.dart';
import '../services/planService.dart';

class PlanViewModel extends ChangeNotifier {
  PlanService myPlanService = PlanService();
  SearchListService searchListService = SearchListService();

  List<PlanListResult> myPLanListResult = [];

  Future<PlanListModel> getPlanList(String providerId) async {
    try {
      final userid = PreferenceUtil.getStringValue(Constants.KEY_USERID);
      final myPlanListModel =
          await myPlanService.getPlanList(providerId, userid);
      if (myPlanListModel.isSuccess) {
        myPLanListResult = myPlanListModel.result;
      }
      return myPlanListModel;
    } catch (e) {}
  }

  List<PlanListResult> getSearchForCategory(
      String title, List<PlanListResult> planListOld) {
    final filterDoctorData = List<PlanListResult>();
    for (var planList in planListOld) {
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

  List<PlanListResult> getSearchDiseases(
      String title, List<PlanListResult> planListOld) {
    final filterDoctorData = List<PlanListResult>();
    for (var planList in planListOld) {
      if (planList?.metadata?.diseases != null &&
          planList?.metadata?.diseases != '') {
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

  List<PlanListResult> getSearchForPlanList(
      String title, List<PlanListResult> planListOld) {
    var filterDoctorData = List<PlanListResult>();
    for (final planList in planListOld) {
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
      var searchListModel = await searchListService.getSearchList(title);
      return searchListModel;
    } catch (e) {}
  }

  Future<SearchListModel> getUserSearchListInit() async {
    try {
      final userid = PreferenceUtil.getStringValue(Constants.KEY_USERID);
      var searchListModel = await searchListService.getUserProviderList(userid);
      return searchListModel;
    } catch (e) {}
  }

  List<PlanListResult> getFilterForProvider(
      String title, List<PlanListResult> planListOld) {
    var filterSearch = List<PlanListResult>();
    for (final searchList in planListOld) {
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

  Future<PlanListModel> getPlanDetail(String packageId) async {
    final userid = PreferenceUtil.getStringValue(Constants.KEY_USERID);
    if (userid != null) {
      try {
        var planListModel =
        await myPlanService.getPlanDetailById(userid, packageId);
        return planListModel;
      } catch (e) {}
    }
  }
}
