import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:myfhb/common/PreferenceUtil.dart';
import 'package:myfhb/constants/fhb_constants.dart' as Constants;
import 'package:myfhb/plan_dashboard/model/PlanListModel.dart';
import 'package:myfhb/plan_wizard/model/AddToCartModel.dart';
import 'package:myfhb/plan_wizard/models/health_condition_response_model.dart';
import 'package:myfhb/plan_wizard/services/PlanWizardService.dart';
import 'package:myfhb/telehealth/features/chat/constants/const.dart';

class PlanWizardViewModel extends ChangeNotifier {
  PlanWizardService planWizardService = new PlanWizardService();
  final PageController pageController = PageController();
  int currentPage = 0;
  List<PlanListResult> carePlanList = [];
  List<PlanListResult> dietPlanList = [];
  List<PlanListResult> cartItemsList = [];
  String currentPackageId = '';
  List<PlanListResult> planListResult = [];
  List<PlanListResult> cartList = [];
  List<PlanListResult> planSearchList = [];
  List<PlanListResult> healthConditionsList = [];
  Map<String, List<MenuItem>> healthConditions = {};
  Map<String, List<MenuItem>> filteredHealthConditions = {};
  bool isHealthSearch = false;

  void updateSingleSelection(String packageId) {
    if (packageId == currentPackageId) {
      currentPackageId = '';
    } else {
      currentPackageId = packageId;
    }

    notifyListeners();
  }

  void changeCurrentPage(int newPage) {
    FocusManager.instance.primaryFocus.unfocus();
    pageController.animateToPage(newPage,
        duration: Duration(milliseconds: 100), curve: Curves.easeIn);
    currentPage = newPage;
    notifyListeners();
  }

  Future<PlanListModel> getPlanList() async {
    try {
      var userid = PreferenceUtil.getStringValue(Constants.KEY_USERID);
      PlanListModel myPlanListModel =
          await planWizardService.getPlanList(userid);
      if (myPlanListModel.isSuccess) {
        planListResult = myPlanListModel.result;
      }
      return myPlanListModel;
    } catch (e) {}
  }

  Future<Map<String, List<MenuItem>>> getHealthConditions() async {
    healthConditions = {};
    try {
      var userid = PreferenceUtil.getStringValue(Constants.KEY_USERID);
      HealthConditionResponseModel healthConditionResponseModel =
          await planWizardService.getHealthConditions(userid);
      var currentSeperator = '';
      if (healthConditionResponseModel?.isSuccess ?? false) {
        healthConditionResponseModel?.healthConditionData?.menuitems
            ?.forEach((menuItem) {
          if (menuItem.menuitemtype == Menuitemtype.SEPERATOR) {
            currentSeperator = menuItem.title;
            healthConditions.putIfAbsent(currentSeperator, () => []);
          } else {
            healthConditions[currentSeperator]?.add(menuItem);
          }
        });
      } else {
        healthConditions = {};
      }
      notifyListeners();
      return healthConditions;
    } catch (e) {}
  }

  void getFilteredHealthConditions(
    String filterText,
  ) async {
    if ((filterText ?? '')?.isNotEmpty ?? false) {
      isHealthSearch = true;
      filteredHealthConditions = {};
      healthConditions?.forEach((categoryName, menuItemsList) {
        menuItemsList?.forEach((menuItem) {
          if (menuItem.menuitemtype != Menuitemtype.SEPERATOR &&
              (menuItem?.title?.toLowerCase()?.trim() ?? '')
                  .contains(filterText?.toLowerCase()?.trim())) {
            filteredHealthConditions.putIfAbsent(categoryName, () => []);
            filteredHealthConditions[categoryName ?? ''].add(menuItem);
          }
        });
      });
    } else {
      isHealthSearch = false;
    }
    notifyListeners();
  }

  List<PlanListResult> filterPlanNameProvider(String title) {
    List<PlanListResult> filterSearch = new List();
    for (PlanListResult searchList in planListResult) {
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

  List<PlanListResult> filterSorting(String filter) {
    List<PlanListResult> planListLocal = [];
    List<PlanListResult> planLisDefault = List.from(planListResult);
    if (filter == popUpChoicePrice) {
      if (planLisDefault != null && planLisDefault.length > 0) {
        planLisDefault?.sort((a, b) => a.price.compareTo(b.price));
        planListLocal = List.from(planLisDefault);
      }
    } else if (filter == popUpChoiceDura) {
      if (planLisDefault != null && planLisDefault.length > 0) {
        planLisDefault
            ?.sort((a, b) => a.packageDuration.compareTo(b.packageDuration));
        planListLocal = List.from(planLisDefault);
      }
    } else if (filter == popUpChoiceDefault) {
      if (planListResult != null && planListResult.length > 0) {
        planListLocal = List.from(planListResult);
      }
    } else {
      planListLocal = List.from(planListResult);
    }

    return planListLocal;
  }

  Future<AddToCartModel> addToCartItem(
      {String packageId, String price, bool isRenew}) async {
    try {
      AddToCartModel addToCartModel = await planWizardService.addToCartService(
          packageId: packageId, price: price, isRenew: isRenew);
      return addToCartModel;
    } catch (e) {}
  }
}
