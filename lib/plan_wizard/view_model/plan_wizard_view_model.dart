import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gmiwidgetspackage/widgets/flutterToast.dart';
import 'package:myfhb/authentication/constants/constants.dart';
import 'package:myfhb/common/PreferenceUtil.dart';
import 'package:myfhb/constants/fhb_constants.dart' as Constants;
import 'package:myfhb/plan_dashboard/model/PlanListModel.dart';
import 'package:myfhb/plan_wizard/model/AddToCartModel.dart';
import 'package:myfhb/plan_wizard/models/DietPlanModel.dart';
import 'package:myfhb/plan_wizard/models/health_condition_response_model.dart';
import 'package:myfhb/plan_wizard/services/PlanWizardService.dart';
import 'package:myfhb/telehealth/features/chat/constants/const.dart';
import 'package:myfhb/widgets/checkout_page_provider.dart';
import 'package:myfhb/widgets/fetching_cart_items_model.dart';
import 'package:provider/provider.dart';

class PlanWizardViewModel extends ChangeNotifier {
  PlanWizardService planWizardService = new PlanWizardService();
  final PageController pageController = PageController();
  int currentPage = 0;
  List<List<DietPlanResult>> dietPlanList = [];
  String currentPackageId = '';
  String currentPackageIdDiet = '';
  List<PlanListResult> planListResult = [];
  Map<String, List<MenuItem>> healthConditions = {};
  Map<String, List<MenuItem>> filteredHealthConditions = {};
  bool isHealthSearch = false;

  List<ProductList> cartList = [];

  var selectedTag = '';
  var providerId = '';

  void updateSingleSelection(String packageId) {
    if (packageId == currentPackageId) {
      currentPackageId = '';
    } else {
      currentPackageId = packageId;
    }

    notifyListeners();
  }

  void updateSingleSelectionDiet(String packageId) {
    if (packageId == currentPackageIdDiet) {
      currentPackageIdDiet = '';
    } else {
      currentPackageIdDiet = packageId;
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

  Future<PlanListModel> getCarePlanList() async {
    try {
      var userid = PreferenceUtil.getStringValue(Constants.KEY_USERID);
      PlanListModel myPlanListModel =
          await planWizardService.getPlanList(userid);
      if (myPlanListModel.isSuccess) {
        planListResult = myPlanListModel.result;
      } else {
        planListResult = [];
      }
      return myPlanListModel;
    } catch (e) {}
  }

  Future<DietPlanModel> getDietPlanList() async {
    try {
      var userid = PreferenceUtil.getStringValue(Constants.KEY_USERID);
      DietPlanModel myPlanListModel =
          await planWizardService.getDietPlanList(userid);
      if (myPlanListModel.isSuccess) {
        dietPlanList = myPlanListModel.result;
      } else {
        dietPlanList = [];
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

  List<List<DietPlanResult>> filterDietSorting(String filter) {
    List<List<DietPlanResult>> planListAll = [];
    List<List<DietPlanResult>> planListDiet = List.from(dietPlanList);

    planListDiet?.forEach((planListDefault) {
      List<DietPlanResult> planListLocal = [];
      if (filter == popUpChoicePrice) {
        if (planListDefault != null && planListDefault.length > 0) {
          planListDefault?.sort((a, b) => b.price.compareTo(a.price));
          planListLocal = List.from(planListDefault);
        }
      } else if (filter == popUpChoiceDura) {
        if (planListDefault != null && planListDefault.length > 0) {
          planListDefault
              ?.sort((a, b) => a.packageDuration.compareTo(b.packageDuration));
          planListLocal = List.from(planListDefault);
        }
      } else if (filter == popUpChoiceDefault) {
        if (dietPlanList != null && dietPlanList.length > 0) {
          planListLocal = List.from(dietPlanList);
        }
      } else {
        planListLocal = List.from(dietPlanList);
      }

      planListAll.add(planListLocal);
    });

    return planListAll;
  }

  List<List<DietPlanResult>> filterPlanNameProviderDiet(String title) {
    List<List<DietPlanResult>> filterSearchAll = [];
    List<List<DietPlanResult>> searchListAll = List.from(dietPlanList);
    searchListAll.forEach((searchList) {
      List<DietPlanResult> filterSearch = [];
      for (int i = 0; i < searchList.length; i++) {
        if (searchList[i]?.title != null && searchList[i]?.title != '') {
          if (searchList[i]
                  ?.title
                  .toLowerCase()
                  .trim()
                  .contains(title.toLowerCase().trim()) ||
              searchList[i]
                  ?.providerName
                  .toLowerCase()
                  .trim()
                  .contains(title.toLowerCase().trim())) {
            filterSearch.add(searchList[i]);
          }
        }
      }
      filterSearchAll.add(filterSearch);
    });
    return filterSearchAll;
  }

  Future<AddToCartModel> addToCartItem(
      {String packageId,
      String price,
      bool isRenew,
      String providerId,
      String isFromAdd}) async {
    try {
      AddToCartModel addToCartModel = await planWizardService.addToCartService(
          packageId: packageId, price: price, isRenew: isRenew);

      if (addToCartModel.isSuccess) {
        if (isFromAdd == strDiet) {
          updateSingleSelectionDiet(packageId);
        } else if (isFromAdd == strCare) {
          updateSingleSelection(packageId);
          updateProviderId(providerId);
        }
        await fetchCartItem();
        FlutterToast().getToast('Added to Cart', Colors.green);
      } else {
        if (isFromAdd == strDiet) {
          updateSingleSelectionDiet('');
        } else if (isFromAdd == strCare) {
          updateSingleSelection('');
          updateProviderId('');
        }

        FlutterToast().getToast(
            addToCartModel?.message != null
                ? addToCartModel?.message
                : 'Adding Failed! Try again',
            Colors.green);
      }

      return addToCartModel;
    } catch (e) {}
  }

  Future<void> removeCart({String packageId, bool isFromDiet = false}) async {
    try {
      await Provider.of<CheckoutPageProvider>(Get.context, listen: false)
          .removeCartItem(productId: packageId, needToast: false);
      await fetchCartItem();
      if (isFromDiet) {
        updateSingleSelectionDiet('');
      } else {
        updateSingleSelection('');
        updateProviderId('');
      }
    } catch (e) {}
  }

  void updateProviderId(String providerIdNew) {
    providerId = providerIdNew;
  }

  Future<void> fetchCartItem() async {
    FetchingCartItemsModel fetchingCartItemsModel =
        await Provider.of<CheckoutPageProvider>(Get.context, listen: false)
            .fetchCartItems();
    if (fetchingCartItemsModel?.isSuccess ?? false) {
      cartList = fetchingCartItemsModel?.result?.cart?.productList ?? [];
    } else {
      cartList = [];
    }
  }

  bool checkItemInCart(String packageId, String tag, {String providerId}) {
    bool isItemInCart = false;

    cartList?.forEach((element) {
      if ('${element?.productDetail?.id}' == packageId) {
        if (tag == 'Care') {
          currentPackageId = packageId;
          updateProviderId(providerId);
        } else {
          currentPackageIdDiet = packageId;
        }

        isItemInCart = true;
      }
    });

    return isItemInCart;
  }

  /*bool checkAllItems() {
    bool isCarePlanInCart = false;
    planListResult?.forEach((planItem) {
      cartList.forEach((cartItem) {
        if ('${cartItem?.productDetail?.id ?? ''}' ==
            (planItem?.packageid ?? '')) {
          isCarePlanInCart = true;
          FlutterToast()
              .getToast('Already a care plan available in cart', Colors.red);
        }
      });
    });

    return isCarePlanInCart;
  }*/

  bool checkAllItemsDiet() {
    bool isCarePlanInCart = false;
    dietPlanList?.forEach((planItem) {
      for (int i = 0; i < cartList.length; i++) {
        if ('${cartList[i]?.productDetail?.id ?? ''}' ==
            (planItem[i]?.packageid ?? '')) {
          isCarePlanInCart = true;
          FlutterToast()
              .getToast('Already a diet plan available in cart', Colors.red);
        }
      }
    });

    return isCarePlanInCart;
  }
}
