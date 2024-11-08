import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gmiwidgetspackage/widgets/FlatButton.dart';
import 'package:gmiwidgetspackage/widgets/flutterToast.dart';
import 'package:myfhb/add_provider_plan/model/ProviderOrganizationResponse.dart';
import 'package:myfhb/add_provider_plan/service/PlanProviderViewModel.dart';
import 'package:myfhb/authentication/constants/constants.dart';
import 'package:myfhb/claim/model/credit/CreditBalanceResult.dart';
import 'package:myfhb/claim/service/ClaimListRepository.dart';
import 'package:myfhb/common/CommonUtil.dart';
import 'package:myfhb/common/PreferenceUtil.dart';
import 'package:myfhb/constants/fhb_constants.dart' as Constants;
import 'package:myfhb/plan_dashboard/model/PlanListModel.dart';
import 'package:myfhb/plan_wizard/model/AddToCartModel.dart';
import 'package:myfhb/plan_wizard/models/DietPlanModel.dart';
import 'package:myfhb/plan_wizard/models/health_condition_response_model.dart';
import 'package:myfhb/plan_wizard/services/PlanWizardService.dart';
import 'package:myfhb/telehealth/features/chat/constants/const.dart';
import 'package:myfhb/widgets/checkout_page.dart';
import 'package:myfhb/widgets/checkout_page_provider.dart';
import 'package:myfhb/widgets/fetching_cart_items_model.dart';
import 'package:provider/provider.dart';

import '../../claim/model/members/MembershipDetails.dart';
import '../../main.dart';

class PlanWizardViewModel extends ChangeNotifier {
  PlanWizardService planWizardService = PlanWizardService();
  final PageController pageController = PageController();
  int currentPage = 0;
  int currentTab = 0;
  int currentTabDiet = 0;

  int planWizardProviderCount = 0;

  List<List<DietPlanResult>>? dietPlanList = [];

  String? currentPackageProviderCareId = '';
  String? currentPackageFreeCareId = '';

  String currentPackageIdDiet = '';

  String? currentPackageProviderDietId = '';
  String? currentPackageFreeDietId = '';

  List<PlanListResult>? providerPlanListResult = [];
  List<PlanListResult>? freePlanListResult = [];

  List<PlanListResult>? providerDietPlanListResult = [];
  List<PlanListResult>? freeDietPlanListResult = [];

  Map<String?, List<MenuItem>> healthConditions = {};
  Map<String?, List<MenuItem>> filteredHealthConditions = {};
  bool isHealthSearch = false;
  bool isDynamicLink = false;
  bool isListEmpty = false;
  bool isDietListEmpty = false;
  int providerHosCount = 0;
  int dynamicLinkPage = 0;
  String? dynamicLinkSearchText = '';
  int dynamicLinkTabIndex = 0;

  List<ProductList> cartList = [];

  String? selectedTag = '';
  String? providerId = '';
  var healthTitle = '';

  var currentCartProviderCarePackageId = '';
  var currentCartFreeCarePackageId = '';

  var currentCartDietPackageId = '';

  var currentCartProviderDietPackageId = '';
  var currentCartFreeDietPackageId = '';

  bool isPlanWizardActive = false;
  CreditBalanceResult? creditBalanceResult;
  int carePlanCount = 0;
  int dietPlanCount = 0;
  bool? isMembershipAVailable = false;
  MemberShipDetails? memberShipDetailsResult;
  
  void updateSingleSelectionProvider(String? packageId) {
    if (packageId == currentPackageProviderCareId) {
      currentPackageProviderCareId = '';
    } else {
      currentPackageProviderCareId = packageId;
    }

    notifyListeners();
  }

  void updateSingleSelectionFree(String? packageId) {
    if (packageId == currentPackageFreeCareId) {
      currentPackageFreeCareId = '';
    } else {
      currentPackageFreeCareId = packageId;
    }

    notifyListeners();
  }

  void updateSingleSelectionProviderDiet(String? packageId) {
    if (packageId == currentPackageProviderDietId) {
      currentPackageProviderDietId = '';
    } else {
      currentPackageProviderDietId = packageId;
    }

    notifyListeners();
  }

  void updateSingleSelectionFreeDiet(String? packageId) {
    if (packageId == currentPackageFreeDietId) {
      currentPackageFreeDietId = '';
    } else {
      currentPackageFreeDietId = packageId;
    }

    notifyListeners();
  }

  void changeCurrentPage(int newPage) {
    FocusManager.instance.primaryFocus!.unfocus();
    if (newPage == 2 && checkCartForBundle()) {
      Get.to(CheckoutPage());
    } else {
      if (pageController.hasClients) {
        pageController.animateToPage(newPage,
            duration: Duration(milliseconds: 100), curve: Curves.easeIn);
      }
      fetchCartItem();
      currentPage = newPage;
    }
    notifyListeners();
  }

  void changeCurrentTab(int newPage) {
    currentTab = newPage;
    notifyListeners();
  }

  void updateBottonLayoutEmptyList(bool isEmptyList, {bool needReload = true}) {
    isListEmpty = isEmptyList;
    if (needReload) {
      notifyListeners();
    }
  }

  void updateBottonLayoutEmptyDietList(bool isEmptyList,
      {bool needReload = true}) {
    isDietListEmpty = isEmptyList;
    if (needReload) {
      notifyListeners();
    }
  }

  void updateProviderHosCount(int count) {
    providerHosCount = count;
    notifyListeners();
  }

  void changeCurrentTabDiet(int newPage) {
    currentTabDiet = newPage;
    notifyListeners();
  }

  Future<PlanListModel?> getCarePlanList(String isFrom,
      {String? conditionChosen}) async {
    ProviderOrganisationResponse providerOrganizationResult;
    try {
      var userId = PreferenceUtil.getStringValue(Constants.KEY_USERID)!;

      if (isFrom == strProviderCare) {
        providerOrganizationResult = (await Provider.of<PlanProviderViewModel>(
                Get.context!,
                listen: false)
            .getCarePlanList(conditionChosen!))!;

        planWizardProviderCount =
            providerOrganizationResult.result?.length ?? 0;
      }

      PlanListModel myPlanListModel =
          await planWizardService.getPlanList(userId, isFrom);

      if (myPlanListModel.isSuccess!) {
        providerPlanListResult = myPlanListModel.result;
        freePlanListResult = myPlanListModel.result;
      } else {
        providerPlanListResult = [];
        freePlanListResult = [];
      }
      return myPlanListModel;
    } catch (e,stackTrace) {
      CommonUtil().appLogs(message: e,stackTrace:stackTrace);
    }
  }

  Future<PlanListModel?> getDietPlanListNew(
      {String? isFrom, bool isVeg = false}) async {
    try {
      var userId = PreferenceUtil.getStringValue(Constants.KEY_USERID)!;
      PlanListModel myPlanListModel = await planWizardService
          .getDietPlanListNew(isFrom: isFrom, patientId: userId, isVeg: isVeg);
      if (myPlanListModel.isSuccess!) {
        providerDietPlanListResult = myPlanListModel.result;
        freeDietPlanListResult = myPlanListModel.result;
      } else {
        providerDietPlanListResult = [];
        freeDietPlanListResult = [];
      }
      return myPlanListModel;
    } catch (e,stackTrace) {
      CommonUtil().appLogs(message: e,stackTrace:stackTrace);
    }
  }

  Future<DietPlanModel?> getDietPlanList({bool isVeg = false}) async {
    try {
      var userid = PreferenceUtil.getStringValue(Constants.KEY_USERID)!;
      DietPlanModel myPlanListModel = await planWizardService.getDietPlanList(
          patientId: userid, isVeg: isVeg);
      if (myPlanListModel.isSuccess!) {
        dietPlanList = myPlanListModel.result;
      } else {
        dietPlanList = [];
      }
      return myPlanListModel;
    } catch (e,stackTrace) {
      CommonUtil().appLogs(message: e,stackTrace:stackTrace);
    }
  }

  Future<Map<String?, List<MenuItem>>?> getHealthConditions() async {
    healthConditions = {};
    try {
      var userid = PreferenceUtil.getStringValue(Constants.KEY_USERID)!;
      HealthConditionResponseModel healthConditionResponseModel =
          await planWizardService.getHealthConditions(userid);
      String? currentSeperator = '';
      if (healthConditionResponseModel.isSuccess ?? false) {
        healthConditionResponseModel.healthConditionData?.menuitems
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
    } catch (e,stackTrace) {
      CommonUtil().appLogs(message: e,stackTrace:stackTrace);
    }
  }

  void getFilteredHealthConditions(
    String filterText,
  ) async {
    if ((filterText).isNotEmpty) {
      isHealthSearch = true;
      filteredHealthConditions = {};
      healthConditions.forEach((categoryName, menuItemsList) {
        menuItemsList.forEach((menuItem) {
          if (menuItem.menuitemtype != Menuitemtype.SEPERATOR &&
              (menuItem.title!.toLowerCase().trim())
                  .contains(filterText.toLowerCase().trim())) {
            filteredHealthConditions.putIfAbsent(categoryName, () => []);
            filteredHealthConditions[categoryName]!.add(menuItem);
          }
        });
      });
    } else {
      isHealthSearch = false;
    }
    notifyListeners();
  }

  List<PlanListResult> filterPlanNameProvider(String title) {
    List<PlanListResult> filterSearch = [];
    for (PlanListResult searchList in providerPlanListResult!) {
      if (searchList.title != null && searchList.title != '') {
        if (searchList.title!
                .toLowerCase()
                .trim()
                .contains(title.toLowerCase().trim()) ||
            searchList.providerName!
                .toLowerCase()
                .trim()
                .contains(title.toLowerCase().trim())) {
          filterSearch.add(searchList);
        }
      }
    }
    return filterSearch;
  }

  List<PlanListResult> filterPlanNameProviderDiet(String title) {
    List<PlanListResult> filterSearch = [];
    for (PlanListResult searchList in providerDietPlanListResult!) {
      if (searchList.title != null && searchList.title != '') {
        if (searchList.title!
                .toLowerCase()
                .trim()
                .contains(title.toLowerCase().trim()) ||
            searchList.providerName!
                .toLowerCase()
                .trim()
                .contains(title.toLowerCase().trim())) {
          filterSearch.add(searchList);
        }
      }
    }
    return filterSearch;
  }

  List<PlanListResult> filterPlanNameFree(String title) {
    List<PlanListResult> filterSearch = [];
    for (PlanListResult searchList in freePlanListResult!) {
      if (searchList.title != null && searchList.title != '') {
        if (searchList.title!
                .toLowerCase()
                .trim()
                .contains(title.toLowerCase().trim()) ||
            searchList.providerName!
                .toLowerCase()
                .trim()
                .contains(title.toLowerCase().trim())) {
          filterSearch.add(searchList);
        }
      }
    }
    return filterSearch;
  }

  List<PlanListResult> filterPlanNameFreeDiet(String title) {
    List<PlanListResult> filterSearch = [];
    for (PlanListResult searchList in freeDietPlanListResult!) {
      if (searchList.title != null && searchList.title != '') {
        if (searchList.title!
                .toLowerCase()
                .trim()
                .contains(title.toLowerCase().trim()) ||
            searchList.providerName!
                .toLowerCase()
                .trim()
                .contains(title.toLowerCase().trim())) {
          filterSearch.add(searchList);
        }
      }
    }
    return filterSearch;
  }

  List<PlanListResult> filterSortingForProvider(String filter) {
    List<PlanListResult> planListLocal = [];
    List<PlanListResult> planLisDefault = List.from(providerPlanListResult!);
    if (filter == popUpChoicePrice) {
      if (planLisDefault != null && planLisDefault.length > 0) {
        planLisDefault.sort((a, b) {
          var priceA = double.tryParse(a.price ?? 0 as String) ?? 0;
          var priceB = double.tryParse(b.price ?? 0 as String) ?? 0;
          return priceA.compareTo(priceB);
        });
      }
      planListLocal = List.from(planLisDefault);
    } else if (filter == popUpChoiceDura) {
      if (planLisDefault != null && planLisDefault.length > 0) {
        planLisDefault.sort((a, b) {
          var duraA = double.tryParse(a.packageDuration ?? 0 as String) ?? 0;
          var duraB = double.tryParse(b.packageDuration ?? 0 as String) ?? 0;
          return duraA.compareTo(duraB);
        });
        planListLocal = List.from(planLisDefault);
      }
    } else if (filter == popUpChoiceDefault) {
      if (providerPlanListResult != null &&
          providerPlanListResult!.length > 0) {
        planListLocal = List.from(providerPlanListResult!);
      }
    } else {
      planListLocal = List.from(providerPlanListResult!);
    }

    return planListLocal;
  }

  List<PlanListResult> filterSortingForFree(String filter) {
    List<PlanListResult> planListLocal = [];
    List<PlanListResult> planLisDefault = List.from(freePlanListResult!);
    if (filter == popUpChoicePrice) {
      if (planLisDefault != null && planLisDefault.length > 0) {
        planLisDefault.sort((a, b) {
          var priceA = double.tryParse(a.price ?? 0 as String) ?? 0;
          var priceB = double.tryParse(b.price ?? 0 as String) ?? 0;
          return priceA.compareTo(priceB);
        });
      }
      planListLocal = List.from(planLisDefault);
    } else if (filter == popUpChoiceDura) {
      if (planLisDefault != null && planLisDefault.length > 0) {
        planLisDefault.sort((a, b) {
          var duraA = double.tryParse(a.packageDuration ?? 0 as String) ?? 0;
          var duraB = double.tryParse(b.packageDuration ?? 0 as String) ?? 0;
          return duraA.compareTo(duraB);
        });
        planListLocal = List.from(planLisDefault);
      }
    } else if (filter == popUpChoiceDefault) {
      if (freePlanListResult != null && freePlanListResult!.length > 0) {
        planListLocal = List.from(freePlanListResult!);
      }
    } else {
      planListLocal = List.from(freePlanListResult!);
    }

    return planListLocal;
  }

  List<PlanListResult> filterSortingForProviderDiet(String filter) {
    List<PlanListResult> planListLocal = [];
    List<PlanListResult> planLisDefault =
        List.from(providerDietPlanListResult!);
    if (filter == popUpChoicePrice) {
      if (planLisDefault != null && planLisDefault.length > 0) {
        planLisDefault.sort((a, b) {
          var priceA = double.tryParse(a.price ?? 0 as String) ?? 0;
          var priceB = double.tryParse(b.price ?? 0 as String) ?? 0;
          return priceA.compareTo(priceB);
        });
      }
      planListLocal = List.from(planLisDefault);
    } else if (filter == popUpChoiceDura) {
      if (planLisDefault != null && planLisDefault.length > 0) {
        planLisDefault.sort((a, b) {
          var duraA = double.tryParse(a.packageDuration ?? 0 as String) ?? 0;
          var duraB = double.tryParse(b.packageDuration ?? 0 as String) ?? 0;
          return duraA.compareTo(duraB);
        });
        planListLocal = List.from(planLisDefault);
      }
    } else if (filter == popUpChoiceDefault) {
      if (providerDietPlanListResult != null &&
          providerDietPlanListResult!.length > 0) {
        planListLocal = List.from(providerDietPlanListResult!);
      }
    } else {
      planListLocal = List.from(providerDietPlanListResult!);
    }

    return planListLocal;
  }

  List<PlanListResult> filterSortingForFreeDiet(String filter) {
    List<PlanListResult> planListLocal = [];
    List<PlanListResult> planLisDefault = List.from(freeDietPlanListResult!);
    if (filter == popUpChoicePrice) {
      if (planLisDefault != null && planLisDefault.length > 0) {
        planLisDefault.sort((a, b) {
          var priceA = double.tryParse(a.price ?? 0 as String) ?? 0;
          var priceB = double.tryParse(b.price ?? 0 as String) ?? 0;
          return priceA.compareTo(priceB);
        });
      }
      planListLocal = List.from(planLisDefault);
    } else if (filter == popUpChoiceDura) {
      if (planLisDefault != null && planLisDefault.length > 0) {
        planLisDefault.sort((a, b) {
          var duraA = double.tryParse(a.packageDuration ?? 0 as String) ?? 0;
          var duraB = double.tryParse(b.packageDuration ?? 0 as String) ?? 0;
          return duraA.compareTo(duraB);
        });
        planListLocal = List.from(planLisDefault);
      }
    } else if (filter == popUpChoiceDefault) {
      if (freeDietPlanListResult != null &&
          freeDietPlanListResult!.length > 0) {
        planListLocal = List.from(freeDietPlanListResult!);
      }
    } else {
      planListLocal = List.from(freeDietPlanListResult!);
    }

    return planListLocal;
  }

  /*List<List<DietPlanResult>> filterDietProviderSorting(String filter) {
    List<List<DietPlanResult>> planListAll = [];
    List<List<DietPlanResult>> planListDiet = List.from(dietPlanList);

    planListDiet?.forEach((planListDefault) {
      List<DietPlanResult> planListLocal = [];
      if (filter == popUpChoicePrice) {
        if (planListDefault != null && planListDefault.length > 0) {
          planListDefault?.sort((a, b) {
            var priceA = double.tryParse(a?.price ?? 0) ?? 0;
            var priceB = double.tryParse(b?.price ?? 0) ?? 0;
            return priceA?.compareTo(priceB ?? 0);
          });

          planListLocal = List.from(planListDefault);
        }
      } else if (filter == popUpChoiceDura) {
        if (planListDefault != null && planListDefault.length > 0) {
          planListDefault?.sort((a, b) {
            var duraA = double.tryParse(a?.packageDuration ?? 0) ?? 0;
            var duraB = double.tryParse(b?.packageDuration ?? 0) ?? 0;
            return duraA?.compareTo(duraB ?? 0);
          });

          planListLocal = List.from(planListDefault);
        }
      } else if (filter == popUpChoiceDefault) {
        if (dietPlanList != null && dietPlanList.length > 0) {
          planListAll = List.from(dietPlanList);
          return planListAll;
        }
      } else {
        planListAll = List.from(dietPlanList);
        return planListAll;
      }

      planListAll.add(planListLocal);
    });

    return planListAll;
  }*/

  /*List<List<DietPlanResult>> filterPlanNameProviderDiet(String title) {
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
  }*/

  String getTag(String? isFromAdd) {
    String tag = '';

    if (isFromAdd == strProviderCare) {
      tag = selectedTag! + ',' + strProviderCare;
    } else if (isFromAdd == strFreeCare) {
      tag = selectedTag! + ',' + strFreeCare;
    } else if (isFromAdd == strProviderDiet) {
      tag = selectedTag! + ',' + strProviderDiet;
    } else if (isFromAdd == strFreeDiet) {
      tag = selectedTag! + ',' + strFreeDiet;
    } else {
      tag = '';
    }

    return tag;
  }

  Future<AddToCartModel?> addToCartItem(
      {String? packageId,
      String? price,
      required bool isRenew,
      String? providerId,
      String? isFromAdd,
      String? remarks,
      bool? isMemberShipAvail,
      String? actualFee,
      String? planType,
      String? packageDuration}) async {
    try {
      AddToCartModel addToCartModel = await planWizardService.addToCartService(
          packageId: packageId,
          price: price,
          isRenew: isRenew,
          tag: getTag(isFromAdd),
          remarks: remarks,
          isMemberShipAvail: isMemberShipAvail,
          actualFee: actualFee,
          planType: planType,
          packageDuration: packageDuration);

      if (addToCartModel.isSuccess!) {
        if (isFromAdd == strProviderDiet) {
          updateSingleSelectionProviderDiet(packageId);
          if (isMemberShipAvail!) {
            updateDietPlanCount(true);
          }
        } else if (isFromAdd == strFreeDiet) {
          updateSingleSelectionFreeDiet(packageId);
        } else if (isFromAdd == strProviderCare) {
          updateSingleSelectionProvider(packageId);
          updateProviderId(providerId);
          if (isMemberShipAvail!) {
            updateCarePlanCount(true);
          }
        } else if (isFromAdd == strFreeCare) {
          updateSingleSelectionFree(packageId);
          updateProviderId(providerId);
        }
        await fetchCartItem();
        //await updateCareCount();
        FlutterToast().getToast('Added to Cart', Colors.green);
      } else {
        if (isFromAdd == strProviderDiet) {
          updateSingleSelectionProviderDiet('');
        } else if (isFromAdd == strFreeDiet) {
          updateSingleSelectionFreeDiet('');
        } else if (isFromAdd == strProviderCare) {
          updateSingleSelectionProvider('');
          updateProviderId('');
        } else if (isFromAdd == strFreeCare) {
          updateSingleSelectionFree('');
          updateProviderId('');
        }

        Get.snackbar('', (addToCartModel.message ?? 'Adding Failed! Try again'),
            backgroundColor:
                mAppThemeProvider.primaryColor.withOpacity(0.9),
            colorText: Colors.white);
      }

      return addToCartModel;
    } catch (e,stackTrace) {
      CommonUtil().appLogs(message: e,stackTrace:stackTrace);
    }
  }

  Future<void> removeCart(
      {String? packageId, String? isFrom, ProductList? productList}) async {
    try {
      await Provider.of<CheckoutPageProvider>(Get.context!, listen: false)
          .removeCartItem(
              productId: packageId,
              needToast: false,
              isFrom: isFrom,
              productList: productList);
      await fetchCartItem();
      //await updateCareCount();

      FlutterToast().getToast('Removed from Cart', Colors.green);
      if (isFrom == strProviderCare) {
        updateSingleSelectionProvider('');
        updateProviderId('');
      } else if (isFrom == strFreeCare) {
        updateSingleSelectionFree('');
        updateProviderId('');
      } else if (isFrom == strProviderDiet) {
        updateSingleSelectionProviderDiet('');
        updateProviderId('');
      } else if (isFrom == strFreeDiet) {
        updateSingleSelectionFreeDiet('');
        updateProviderId('');
      }
    } catch (e,stackTrace) {
      CommonUtil().appLogs(message: e,stackTrace:stackTrace);
    }
  }

  void updateProviderId(String? providerIdNew) {
    providerId = providerIdNew;
  }

  Future<void> fetchCartItem() async {
    FetchingCartItemsModel? fetchingCartItemsModel =
        await Provider.of<CheckoutPageProvider>(Get.context!, listen: false)
            .fetchCartItems(firstTym: true);
    if (fetchingCartItemsModel?.isSuccess ?? false) {
      cartList = fetchingCartItemsModel?.result?.cart?.productList ?? [];
    } else {
      cartList = [];
    }
  }

  Future<void> getCreditBalance() async {
    ClaimListRepository claimListRepository = ClaimListRepository();
    await claimListRepository.getCreditBalance().then((creditBalance) {
      if (creditBalance.isSuccess! && creditBalance.result != null) {
        creditBalanceResult = creditBalance.result;
        carePlanCount = int.parse(creditBalanceResult!.balanceCarePlans!);
        dietPlanCount = int.parse(creditBalanceResult!.balanceDietPlans!);
        isMembershipAVailable = creditBalanceResult!.isMembershipUser;
      } else {
        creditBalanceResult = null;
        carePlanCount = 0;
        dietPlanCount = 0;
        isMembershipAVailable = false;
      }
    });
  }

  /// Fetches the member ship details for the logged in user.
  ///
  /// Gets the user id from shared preferences. Calls the planWizardService
  /// getMemberShip method passing the user id. Handles any errors by logging them.
  /// Updates the memberShipDetailsResult with the api response.
  Future<void> getMemberShip() async {
    final userId = PreferenceUtil.getStringValue(Constants.KEY_USERID_MAIN);
    if (userId != null) {
      try {
        memberShipDetailsResult = await planWizardService.getMemberShip(userId);
      } catch (e, stackTrace) {
        CommonUtil().appLogs(message: e, stackTrace: stackTrace);
      }
    }
  }

  updateCarePlanCount(bool isAdd) {
    if (isAdd && carePlanCount > 0) {
      carePlanCount = carePlanCount - 1;
    } else if (!isAdd) {
      carePlanCount = carePlanCount + 1;
    }
    print("carePlanCount" + carePlanCount.toString());
    notifyListeners();
  }

  updateDietPlanCount(bool isAdd) {
    if (isAdd) {
      dietPlanCount = dietPlanCount - 1;
    } else {
      dietPlanCount = dietPlanCount + 1;
    }
    print("dietPlanCount" + dietPlanCount.toString());
    notifyListeners();
  }

  bool checkItemInCart(String? packageId, String? tag, {String? providerId}) {
    bool isItemInCart = false;

    cartList.forEach((element) {
      if ('${element.productDetail?.id}' == packageId) {
        if (tag == strProviderCare) {
          currentPackageProviderCareId = packageId;
          updateProviderId(providerId);
        } else if (tag == strFreeCare) {
          currentPackageFreeCareId = packageId;
          updateProviderId(providerId);
        } else if (tag == strProviderDiet) {
          currentPackageProviderDietId = packageId;
          //updateProviderId(providerId);
        } else if (tag == strFreeDiet) {
          currentPackageFreeDietId = packageId;
          //updateProviderId(providerId);
        }

        isItemInCart = true;
      }
    });

    return isItemInCart;
  }

  bool checkAllItemsForProviderCare() {
    bool isCarePlanInCart = false;
    cartList.forEach((cartItem) {
      if ('${cartItem.additionalInfo?.tag ?? ''}' ==
          (selectedTag ?? '') + ',' + strProviderCare) {
        isCarePlanInCart = true;
        currentCartProviderCarePackageId = '${cartItem.productDetail?.id}';
        /*FlutterToast().getToast(
            'Only one care plan can be added for a health condition',
            Colors.red);*/
      }
    });

    if (!isCarePlanInCart) {
      currentCartProviderCarePackageId = '';
    }

    return isCarePlanInCart;
  }

  bool checkAllItemsForProviderDiet() {
    bool isCarePlanInCart = false;
    cartList.forEach((cartItem) {
      if ('${cartItem.additionalInfo?.tag ?? ''}' ==
          (selectedTag ?? '') + ',' + strProviderDiet) {
        isCarePlanInCart = true;
        currentCartProviderDietPackageId = '${cartItem.productDetail?.id}';
        /*FlutterToast().getToast(
            'Only one care plan can be added for a health condition',
            Colors.red);*/
      }
    });

    if (!isCarePlanInCart) {
      currentCartProviderDietPackageId = '';
    }

    return isCarePlanInCart;
  }

  bool checkAllItemsForFreeCare() {
    bool isCarePlanInCart = false;
    cartList.forEach((cartItem) {
      if ('${cartItem.additionalInfo?.tag ?? ''}' ==
          (selectedTag ?? '') + ',' + strFreeCare) {
        isCarePlanInCart = true;
        currentCartFreeCarePackageId = '${cartItem.productDetail?.id}';
        /*FlutterToast().getToast(
            'Only one care plan can be added for a health condition',
            Colors.red);*/
      }
    });

    if (!isCarePlanInCart) {
      currentCartFreeCarePackageId = '';
    }

    return isCarePlanInCart;
  }

  bool checkAllItemsForFreeDiet() {
    bool isCarePlanInCart = false;
    cartList.forEach((cartItem) {
      if ('${cartItem.additionalInfo?.tag ?? ''}' ==
          (selectedTag ?? '') + ',' + strFreeDiet) {
        isCarePlanInCart = true;
        currentCartFreeDietPackageId = '${cartItem.productDetail?.id}';
        /*FlutterToast().getToast(
            'Only one care plan can be added for a health condition',
            Colors.red);*/
      }
    });

    if (!isCarePlanInCart) {
      currentCartFreeDietPackageId = '';
    }

    return isCarePlanInCart;
  }

  bool checkAllItemsDiet() {
    bool isCarePlanInCart = false;
    cartList.forEach((cartItem) {
      if ('${cartItem.additionalInfo?.tag ?? ''}' ==
          (selectedTag ?? '') + ',' + strDiet) {
        isCarePlanInCart = true;
        currentCartDietPackageId = '${cartItem.productDetail?.id}';
        /*FlutterToast().getToast(
            'Only one diet plan can be added for a health condition',
            Colors.red);*/
      }
    });

    if (!isCarePlanInCart) {
      currentCartDietPackageId = '';
    }

    return isCarePlanInCart;
  }

  bool checkCartForBundle() {
    bool isBundlePlanInCart = false;
    cartList.forEach((cartItem) {
      if (('${cartItem.additionalInfo?.tag ?? ''}').contains(strMembership)) {
        isBundlePlanInCart = true;
      }
    });
    return isBundlePlanInCart;
  }

  Future<bool> handleBundlePlans() async {
    var canProceed = true;

    var isBundlePlan = (selectedTag?.contains(strMembership) ?? false);

    var isCartEmpty = (cartList.length) == 0;

    if (!isCartEmpty) {
      var isBundlePlanInCart = checkCartForBundle();

      if ((isBundlePlanInCart && !isBundlePlan) ||
          (isBundlePlan && !isBundlePlanInCart)) {
        await showDialog(
          context: Get.context!,
          builder: (context) => AlertDialog(
            title: Text('Are you sure?'),
            content: Text(
                'Membership plans cannot be subscribed together with other plans. Clear cart to proceed?'),
            actions: <Widget>[
              FlatButtonWidget(
                bgColor: Colors.transparent,
                isSelected: true,
                onPress: () {
                  canProceed = false;
                  Navigator.pop(context);
                },
                title: 'Cancel',
              ),
              FlatButtonWidget(
                bgColor: Colors.transparent,
                isSelected: true,
                onPress: () async {
                  canProceed = true;
                  await Provider.of<CheckoutPageProvider>(Get.context!,
                          listen: false)
                      .clearCartItem();
                  await fetchCartItem();
                  //await updateCareCount();

                  Navigator.pop(context);
                },
                title: 'Clear Cart',
              ),
            ],
          ),
        );
      }
    }

    return canProceed;
  }

  ProductList? getProductListUsingPackageId(String packageId) {
    ProductList? productList;
    print("packageIdpackageId" + packageId);
    Provider.of<PlanWizardViewModel>(Get.context!, listen: false)
        .cartList
        .forEach((cartItem) {
      if ('${cartItem.productDetail?.id}' == packageId) {
        productList = cartItem;
      }
    });
    return productList;
  }

  void updateCareCount() {
    if (cartList != null && cartList.length > 0)
      cartList.forEach((cartItem) {
        if ((cartItem.additionalInfo?.isMembershipAvail ?? false) &&
            cartItem.additionalInfo?.planType == "CARE") {
          carePlanCount--;
        }
      });
  }

  void updateDietCount() {
    if (cartList != null && cartList.length > 0)
      cartList.forEach((cartItem) {
        if ((cartItem.additionalInfo?.isMembershipAvail ?? false) &&
            cartItem.additionalInfo?.planType == "DIET") {
          dietPlanCount--;
        }
      });
  }
}
