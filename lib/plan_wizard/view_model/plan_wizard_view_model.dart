import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:myfhb/common/PreferenceUtil.dart';
import 'package:myfhb/myPlan/model/myPlanListModel.dart';
import 'package:myfhb/plan_dashboard/model/PlanListModel.dart';
import 'package:myfhb/constants/fhb_constants.dart' as Constants;
import 'package:myfhb/plan_wizard/services/PlanWizardService.dart';

class PlanWizardViewModel extends ChangeNotifier {
  PlanWizardService myPlanService = new PlanWizardService();
  final PageController pageController = PageController();
  int currentPage = 0;
  List<MyPlanListResult> carePlanList = [];
  List<MyPlanListResult> dietPlanList = [];
  List<MyPlanListResult> cartItemsList = [];
  String currentPackageId = '';
  List<PlanListResult> planSearchList = [];

  void updateSingleSelection(String packageId) {
    if (packageId == currentPackageId) {
      currentPackageId = '';
    } else {
      currentPackageId = packageId;
    }

    notifyListeners();
  }

  void changeCurrentPage(int newPage) {
    pageController.animateToPage(newPage,
        duration: Duration(milliseconds: 100), curve: Curves.easeIn);
    currentPage = newPage;
    notifyListeners();
  }

  void addCarePlan(MyPlanListResult newPlan) {
    carePlanList.clear();
    carePlanList.add(newPlan);
    updateCart();
  }

  void addDietPlan(MyPlanListResult newPlan) {
    dietPlanList.clear();
    dietPlanList.add(newPlan);
    updateCart();
  }

  void updateCart() {
    cartItemsList.clear();
    cartItemsList.addAll(carePlanList);
    cartItemsList.addAll(dietPlanList);
    notifyListeners();
  }

  Future<PlanListModel> getPlanList() async {
    try {
      var userid = PreferenceUtil.getStringValue(Constants.KEY_USERID);
      PlanListModel myPlanListModel = await myPlanService.getPlanList(userid);
      return myPlanListModel;
    } catch (e) {}
  }

  List<PlanListResult> filterPlanNameProvider(
      String title, List<PlanListResult> planListOld) {
    List<PlanListResult> filterSearch = new List();
    for (PlanListResult searchList in planListOld) {
      if (searchList?.title != null && searchList?.title != '') {
        if (searchList?.title
            .toLowerCase()
            .trim()
            .contains(title.toLowerCase().trim()) ||
            searchList?.providerName
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
