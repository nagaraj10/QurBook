import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gmiwidgetspackage/widgets/flutterToast.dart';
import 'package:myfhb/claim/model/credit/CreditBalanceResult.dart';
import 'package:myfhb/claim/service/ClaimListRepository.dart';
import 'package:myfhb/common/CommonUtil.dart';
import 'package:myfhb/constants/fhb_constants.dart' ;
import 'package:myfhb/plan_wizard/view_model/plan_wizard_view_model.dart';
import 'package:myfhb/src/resources/network/ApiBaseHelper.dart';
import 'package:myfhb/widgets/fetching_cart_items_model.dart';
import 'package:provider/provider.dart';

import '../../constants/fhb_query.dart' as variable;
import '../claim/model/members/MembershipDetails.dart';
import '../claim/model/members/MembershipResult.dart';
import '../common/PreferenceUtil.dart';
import '../constants/variable_constant.dart' as constant;

enum CartType {
  DEFAULT_CART,
  RETRY_CART,
  PAYMENT_SUCC_CART,
  PAYMENT_FAIL_CART,
  SUBSCRIBTION_SUMMARY
}
enum CartStatus { LOADING, LOADED }

class CheckoutPageProvider extends ChangeNotifier {
  CartType cartType = CartType.DEFAULT_CART;
  CartStatus cartStatus = CartStatus.LOADED;
  ApiBaseHelper helper = ApiBaseHelper();
  FetchingCartItemsModel? fetchingCartItemsModel;
  MemberShipResult? memberShipDetailsResult;

  bool checkedMembershipBenefits = false;

  bool isMembershipCart = false;

  int _cartCount = 0;

  bool isLoading = false;
  bool isFirstTym = true;

  num totalProductCount = 0;
  num subTotalProductCount = 0;
  List<ProductList>? productList;
  List<ProductList> cartList = [];

  int get currentCartCount => _cartCount;

  num get _productCount => totalProductCount;

  Future<void> loader(bool currentIsLoading, {bool isNeedRelod = false}) async{
    isLoading = currentIsLoading;
    if (isNeedRelod) {
      notifyListeners();
    }
  }

  void updateCartCount(int currentCount, {bool isNeedRelod = true}) {
    _cartCount = currentCount;
    // if (isNeedRelod) {
    notifyListeners();
    // }
  }

  void updateProductCount({bool isNeedRelod = true}) {
    if (productList != null && productList!.length > 0) {
      productList!.clear();
      totalProductCount = 0;
    }

    productList = fetchingCartItemsModel?.result?.cart?.productList;
    if (productList != null && productList!.length > 0) {
      productList!.forEach((product) {
        if (product.additionalInfo!.isMembershipAvail ?? false) {
          totalProductCount = totalProductCount + 0;
        } else {
          if (product.productDetail!.planSubscriptionFee != null &&
              product.productDetail!.planSubscriptionFee != "") {
            int amtToPay =
                double.parse(product.productDetail!.planSubscriptionFee!)
                    .toInt();
            totalProductCount = totalProductCount + amtToPay;
          } else if (product.additionalInfo!.newFee != null &&
              product.additionalInfo!.newFee != "") {
            int amtToPay =
                double.parse(product.additionalInfo!.newFee).toInt();
            totalProductCount = totalProductCount + amtToPay;
          } else if (product.additionalInfo!.actualFee != null &&
              product.additionalInfo!.actualFee != "") {
            if (product.additionalInfo!.actualFee?.contains(".")) {
              int amtToPay =
                  double.parse(product.additionalInfo!.actualFee).toInt();
              totalProductCount = totalProductCount + amtToPay;
            } else if (!product.additionalInfo!.actualFee?.contains(".")) {
              int amtToPay = int.parse(product.additionalInfo!.actualFee);
              totalProductCount = totalProductCount + amtToPay;
            }
          } else if (product.paidAmount!.contains(".")) {
            int amtToPay = double.parse(product.paidAmount!).toInt();
            totalProductCount = totalProductCount + amtToPay;
          } else if (!product.paidAmount!.contains(".")) {
            int amtToPay = int.parse(product.paidAmount!);
            totalProductCount = totalProductCount + amtToPay;
          }
        }
      });
    }
    notifyListeners();
  }

  void setCartType(CartType currentCartType) {
    cartType = currentCartType;
  }

  Future<FetchingCartItemsModel?> fetchCartItems(
      {bool isNeedRelod = false,
      String? cartUserId,
      String? notificationListId,
      bool isPaymentLinkViaPush = false,
      String? cartId = "",
      bool firstTym = true}) async {
    changeCartStatus(CartStatus.LOADING, isNeedRelod: false);
    if (isPaymentLinkViaPush) {
      fetchingCartItemsModel = await helper.fetchCartItems(
          cartUserId: cartUserId,
          notificationListId: notificationListId,
          isPaymentLinkViaPush: isPaymentLinkViaPush,
          cartId: cartId);
    } else {
      fetchingCartItemsModel = await helper.fetchCartItems(
        cartUserId: cartUserId,
        notificationListId: notificationListId,
        isPaymentLinkViaPush: isPaymentLinkViaPush,
      );
    }
    changeCartStatus(CartStatus.LOADED, isNeedRelod: isNeedRelod);

    updateCartCount(fetchingCartItemsModel?.result?.productsCount ?? 0,
        isNeedRelod: isNeedRelod);
    updateProductCountBasedOnCondiiton(firstTym: firstTym);
    return fetchingCartItemsModel;
  }

  /**
   * Fetches membership details for the logged in user from the API.
   * 
   * Gets the user ID from preferences, executes a GraphQL query to get the membership details, 
   * and updates the memberShipDetailsResult with the last membership with additional info.
   */
  Future<void> getMemberShip() async {
    final userId = PreferenceUtil.getStringValue(KEY_USERID_MAIN);
    if (userId != null) {
      try {
        final responseQuery = '${variable.qr_membership}$userId';
        var response = await helper.getMemberShipDetails(responseQuery);
        final memberShipDetailsResponse = MemberShipDetails.fromJson(response);
        memberShipDetailsResult = memberShipDetailsResponse.result
            ?.lastWhere((element) => element.additionalInfo != null);
        notifyListeners();
      } catch (e, stackTrace) {
        CommonUtil().appLogs(message: e, stackTrace: stackTrace);
      }
    }
  }

  Future<void> removeCartItem(
      {String? productId,
      bool needToast = true,
      bool isNeedRelod = false,
      ProductList? productList,
      String? isFrom}) async {
    var body = {'productId': productId};
    var value = await helper.removeCartItems(body);
    if (value!.isSuccess!) {
      //item removed from cart
      try {
        if ((productList?.additionalInfo?.isMembershipAvail ?? false) &&
            productList?.additionalInfo?.planType == "CARE") {
          updateCarePlanCount(false);
        } else if ((productList?.additionalInfo?.isMembershipAvail ?? false) &&
            productList?.additionalInfo?.planType == "DIET") {
          updateDietPlanCount(false);
        }
      } catch (e,stackTrace) {
                                CommonUtil().appLogs(message: e,stackTrace:stackTrace);
      }
      if (needToast) {
        FlutterToast().getToast(value.message!, Colors.green);
        await fetchCartItems(isNeedRelod: isNeedRelod);
      }

      //setCartType(CartType.DEFAULT_CART);
      await clearAllInCareDiet();
    } else {
      //failed to remove from cart
      if (needToast) {
        FlutterToast().getToast(value.message!, Colors.red);
      }
    }
  }

  Future<void> clearCartItem({bool isNeedRelod = false}) async {
    var value = await helper.clearCartItems();
    if (value!.isSuccess!) {
      //item removed from cart
      FlutterToast().getToast(value.message!, Colors.green);
      await fetchCartItems(isNeedRelod: isNeedRelod);
      await fetchCartItem();
      updateProductCountBasedOnCondiiton();

      //setCartType(CartType.DEFAULT_CART);
    } else {
      //failed to remove from cart
      FlutterToast().getToast(value.message!, Colors.red);
    }
    await clearAllInCareDiet();
  }

  Future<void> updateAmount(
      {bool isNeedRelod = false,
      bool isPaymentLinkViaPush = false,
      String? cartId = "",
      String? cartUserId,
      String? notificationListId,
      bool firstTym = true}) async {
    //item removed from cart
    await fetchCartItems(
        isNeedRelod: isNeedRelod,
        isPaymentLinkViaPush: isPaymentLinkViaPush,
        cartId: cartId,
        cartUserId: cartUserId,
        notificationListId: notificationListId,
        firstTym: firstTym);
    updateCareCount();
    //setCartType(CartType.DEFAULT_CART);
  }

  void changeCartStatus(CartStatus currentCartStatus,
      {bool isNeedRelod = false}) async {
    cartStatus = currentCartStatus;
    if (isNeedRelod) {
      notifyListeners();
    }
  }

  Future<void> clearAllInCareDiet() async {
    await Provider.of<PlanWizardViewModel>(Get.context!, listen: false)
        .fetchCartItem();
    Provider.of<PlanWizardViewModel>(Get.context!, listen: false)
        .updateSingleSelectionProvider('');
    Provider.of<PlanWizardViewModel>(Get.context!, listen: false)
        .updateSingleSelectionFree('');
    Provider.of<PlanWizardViewModel>(Get.context!, listen: false)
        .updateSingleSelectionProviderDiet('');
    Provider.of<PlanWizardViewModel>(Get.context!, listen: false)
        .updateSingleSelectionFreeDiet('');
    Provider.of<PlanWizardViewModel>(Get.context!, listen: false)
        .updateProviderId('');
  }

  void updateCarePlanCount(bool condition) async {
    int careCount =
        await Provider.of<PlanWizardViewModel>(Get.context!, listen: false)
            .carePlanCount;

    if (!condition) {
      await Provider.of<PlanWizardViewModel>(Get.context!, listen: false)
          .carePlanCount++;
    }
    print("carePlanCount incheckout" +
        await Provider.of<PlanWizardViewModel>(Get.context!, listen: false)
            .carePlanCount
            .toString());

    notifyListeners();
  }

  void updateDietPlanCount(bool condition) async {
    int dietCount =
        await Provider.of<PlanWizardViewModel>(Get.context!, listen: false)
            .dietPlanCount;

    if (!condition) {
      await Provider.of<PlanWizardViewModel>(Get.context!, listen: false)
          .dietPlanCount++;
    }
    print("dietPlanCount incheckout" +
        await Provider.of<PlanWizardViewModel>(Get.context!, listen: false)
            .dietPlanCount
            .toString());

    notifyListeners();
  }

  Future<void> fetchCartItem() async {
    FetchingCartItemsModel? fetchingCartItemsModel =
        await Provider.of<CheckoutPageProvider>(Get.context!, listen: false)
            .fetchCartItems();
    if (fetchingCartItemsModel?.isSuccess ?? false) {
      Provider.of<PlanWizardViewModel>(Get.context!, listen: false).cartList =
          fetchingCartItemsModel?.result?.cart?.productList ?? [];
      cartList = fetchingCartItemsModel?.result?.cart?.productList ?? [];
    } else {
      Provider.of<PlanWizardViewModel>(Get.context!, listen: false).cartList =
          [];
      cartList = [];
    }
  }

  ProductList? getProductListUsingPackageId(String packageId) {
    ProductList? productList;
    print("packageIdpackageId" + packageId);
    cartList.forEach((cartItem) {
      if ('${cartItem.productDetail?.id}' == packageId) {
        productList = cartItem;
      }
    });
    return productList;
  }

  void updateCareCount() {
    if (cartList != null && cartList.length > 0) {
      cartList.forEach((cartItem) {
        if ((cartItem.additionalInfo?.isMembershipAvail ?? false) &&
            cartItem.additionalInfo?.planType == "CARE") {
          Provider.of<PlanWizardViewModel>(Get.context!, listen: false)
              .carePlanCount--;
        } else if ((cartItem.additionalInfo?.isMembershipAvail ?? false) &&
            cartItem.additionalInfo?.planType == "DIET") {
          Provider.of<PlanWizardViewModel>(Get.context!, listen: false)
              .dietPlanCount--;
        }
      });
    } else {
      getCreditBalance();
    }
  }

  Future<void> getCreditBalance() async {
    ClaimListRepository claimListRepository = ClaimListRepository();
    await claimListRepository.getCreditBalance().then((creditBalance) {
      if (creditBalance.isSuccess! && creditBalance.result != null) {
        CreditBalanceResult creditBalanceResult = creditBalance.result!;
        Provider.of<PlanWizardViewModel>(Get.context!, listen: false)
            .carePlanCount = int.parse(creditBalanceResult.balanceCarePlans!);
        Provider.of<PlanWizardViewModel>(Get.context!, listen: false)
            .dietPlanCount = int.parse(creditBalanceResult.balanceDietPlans!);
        Provider.of<PlanWizardViewModel>(Get.context!, listen: false)
                .isMembershipAVailable =
            creditBalanceResult.isMembershipUser ?? false;
      } else {
        Provider.of<PlanWizardViewModel>(Get.context!, listen: false)
            .carePlanCount = 0;
        Provider.of<PlanWizardViewModel>(Get.context!, listen: false)
            .dietPlanCount = 0;
        Provider.of<PlanWizardViewModel>(Get.context!, listen: false)
            .isMembershipAVailable = false;
      }
    });
  }

  Future<FetchingCartItemsModel?> updateCartItems(
      {bool isNeedRelod = false,
      String? cartUserId,
      String? notificationListId,
      bool isPaymentLinkViaPush = false,
      String? cartId = ""}) async {
    changeCartStatus(CartStatus.LOADING, isNeedRelod: false);
    if (isPaymentLinkViaPush) {
      fetchingCartItemsModel = await helper.fetchCartItems(
          cartUserId: cartUserId,
          notificationListId: notificationListId,
          isPaymentLinkViaPush: isPaymentLinkViaPush,
          cartId: cartId);
    } else {
      fetchingCartItemsModel = await helper.fetchCartItems(
        cartUserId: cartUserId,
        notificationListId: notificationListId,
        isPaymentLinkViaPush: isPaymentLinkViaPush,
      );
    }
    changeCartStatus(CartStatus.LOADED, isNeedRelod: isNeedRelod);

    return fetchingCartItemsModel;
  }

  void updateProductCountBasedOnCondiiton(
      {bool isNeedRelod = true, bool firstTym = true}) {
    if (productList?.isNotEmpty ?? false) {
        productList = [];
        totalProductCount = 0;
      }

    productList = fetchingCartItemsModel?.result?.cart?.productList;
    if (productList != null && (productList?.length ?? 0) > 0) {
      productList?.forEach((product) {
        if (product.additionalInfo!.isMembershipAvail ?? false) {
          totalProductCount = totalProductCount + 0;
        } else {
          if (!firstTym) {
            if (product.productDetail!.planSubscriptionFee != null &&
                product.productDetail!.planSubscriptionFee != "") {
              int amtToPay =
                  double.parse(product.productDetail!.planSubscriptionFee!)
                      .toInt();
              totalProductCount = totalProductCount + amtToPay;
            }
          } else {
            if (product.additionalInfo!.newFee != null &&
                product.additionalInfo!.newFee != "") {
              if (product.additionalInfo!.newFee?.contains(".")) {
                int amtToPay =
                    double.parse(product.additionalInfo!.newFee).toInt();
                totalProductCount = totalProductCount + amtToPay;
              } else if (!product.additionalInfo!.newFee?.contains(".")) {
                int amtToPay = int.parse(product.additionalInfo!.newFee);
                totalProductCount = totalProductCount + amtToPay;
              }
            } else if (product.additionalInfo!.actualFee != null &&
                product.additionalInfo!.actualFee != "") {
              if (product.additionalInfo!.actualFee?.contains(".")) {
                int amtToPay =
                    double.parse(product.additionalInfo!.actualFee).toInt();
                totalProductCount = totalProductCount + amtToPay;
              } else if (!product.additionalInfo!.actualFee?.contains(".")) {
                int amtToPay = int.parse(product.additionalInfo!.actualFee);
                totalProductCount = totalProductCount + amtToPay;
              }
            } else if ((product.paidAmount ?? "").isNotEmpty) {
              var amtToPay = 0;
              if (product.paidAmount!.contains(".")) {
                amtToPay = double.parse(product.paidAmount!).toInt();
              } else {
                amtToPay = int.parse(product.paidAmount!);
              }
              totalProductCount = totalProductCount + amtToPay;
            }
          }
        }
      });
    }
    subTotalProductCount = totalProductCount;
    if (checkedMembershipBenefits) {
      final transactionLimit = getFinalMembershipAmountLimit();
      totalProductCount = max(totalProductCount - transactionLimit.toInt(), 0);
    }
    notifyListeners();
  }

  /// Returns the final membership amount limit based on the membership details.
  /// Checks the membership amount limit from getMembershipAmountLimit(),
  /// and falls back to
  /// the number of care plans from the memberShipDetailsResult
  /// if the limit is null.
  num getFinalMembershipAmountLimit() {
    var transactionLimit = getMembershipAmountLimit() ?? 0;
    if (transactionLimit > (memberShipDetailsResult?.noOfCarePlans ?? 0)) {
      transactionLimit = memberShipDetailsResult?.noOfCarePlans ?? 0;
    }
    if (transactionLimit == 0) {
      transactionLimit = memberShipDetailsResult?.noOfCarePlans ?? 0;
    }
    return transactionLimit;
  }

  /// Returns the transaction limit for care diet plans from
  /// the membership benefits details, if available.
  /// Checks the additionalInfo.benefitType list for the care diet plan benefit
  /// and returns its transactionLimit field.
  num? getMembershipAmountLimit() {
    final benefitCareDietPlans =
        memberShipDetailsResult?.additionalInfo?.benefitType?.firstWhereOrNull(
      (element) => element.fieldName == constant.strBenefitCareDietPlans,
    );
    return benefitCareDietPlans?.transactionLimit;
  }

  /// Returns the pre-membership discount amount based on the
  /// calculated membership transaction limit.
  ///
  /// If membership benefits are checked, returns the difference
  /// between the subtotal and total product counts.
  ///
  /// Otherwise, returns the minimum of the total product count
  /// and the final membership transaction limit.
  ///
  num getPreMembershipDiscount() {
    if (checkedMembershipBenefits) {
      return subTotalProductCount - totalProductCount;
    } else {
      final transactionLimit = getFinalMembershipAmountLimit();
      return min(totalProductCount, transactionLimit.toInt());
    }
  }
}
