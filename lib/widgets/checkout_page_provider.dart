import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gmiwidgetspackage/widgets/flutterToast.dart';
import 'package:myfhb/authentication/constants/constants.dart';
import 'package:myfhb/claim/model/credit/CreditBalance.dart';
import 'package:myfhb/claim/model/credit/CreditBalanceResult.dart';
import 'package:myfhb/claim/service/ClaimListRepository.dart';
import 'package:myfhb/plan_wizard/view_model/plan_wizard_view_model.dart';
import 'package:myfhb/src/resources/network/ApiBaseHelper.dart';
import 'package:myfhb/widgets/fetching_cart_items_model.dart';
import 'package:provider/provider.dart';

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
  FetchingCartItemsModel fetchingCartItemsModel;

  bool isMembershipCart = false;

  int _cartCount = 0;

  bool isLoading = false;
  int totalProductCount = 0;
  List<ProductList> productList;
  List<ProductList> cartList = [];

  int get currentCartCount => _cartCount;

  int get _productCount => totalProductCount;

  void loader(bool currentIsLoading, {bool isNeedRelod = false}) {
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
    if (productList != null && productList.length > 0) {
      productList.clear();
      totalProductCount = 0;
    }

    productList = fetchingCartItemsModel?.result?.cart?.productList;
    if (productList != null && productList.length > 0) {
      productList.forEach((product) {
        if (product?.additionalInfo?.isMembershipAvail ?? false) {
          totalProductCount = totalProductCount + 0;
        } else {
          if (product?.productDetail?.planSubscriptionFee != null &&
              product?.productDetail?.planSubscriptionFee != "") {
            int amtToPay =
                double.parse(product?.productDetail?.planSubscriptionFee)
                    .toInt();
            totalProductCount = totalProductCount + amtToPay;
          } else if (product?.additionalInfo?.newFee != null &&
              product?.additionalInfo?.newFee != "") {
            int amtToPay =
                double.parse(product?.additionalInfo?.newFee).toInt();
            totalProductCount = totalProductCount + amtToPay;
          } else if (product?.additionalInfo?.actualFee != null &&
              product?.additionalInfo?.actualFee != "") {
            if (product?.additionalInfo?.actualFee?.contains(".")) {
              int amtToPay =
                  double.parse(product?.additionalInfo?.actualFee).toInt();
              totalProductCount = totalProductCount + amtToPay;
            } else if (!product?.additionalInfo?.actualFee?.contains(".")) {
              int amtToPay = int.parse(product?.additionalInfo?.actualFee);
              totalProductCount = totalProductCount + amtToPay;
            }
          } else if (product?.paidAmount.contains(".")) {
            int amtToPay = double.parse(product?.paidAmount).toInt();
            totalProductCount = totalProductCount + amtToPay;
          } else if (!product?.paidAmount?.contains(".")) {
            int amtToPay = int.parse(product?.paidAmount);
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

  Future<FetchingCartItemsModel> fetchCartItems(
      {bool isNeedRelod = false,
      String cartUserId,
      String notificationListId,
      bool isPaymentLinkViaPush = false,
      String cartId = ""}) async {
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
    updateProductCount();
    return fetchingCartItemsModel;
  }

  Future<void> removeCartItem(
      {String productId,
      bool needToast = true,
      bool isNeedRelod = false,
      ProductList productList,
      String isFrom}) async {
    var body = {'productId': productId};
    var value = await helper.removeCartItems(body);
    if (value.isSuccess) {
      //item removed from cart
      try {
        if ((productList?.additionalInfo?.isMembershipAvail ?? false) &&
            productList?.additionalInfo?.planType == "CARE") {
          updateCarePlanCount(false);
        } else if ((productList?.additionalInfo?.isMembershipAvail ?? false) &&
            productList?.additionalInfo?.planType == "DIET") {
          updateDietPlanCount(false);
        }
      } catch (e) {}
      if (needToast) {
        FlutterToast().getToast(value.message, Colors.green);
        await fetchCartItems(isNeedRelod: isNeedRelod);
      }

      //setCartType(CartType.DEFAULT_CART);
      await clearAllInCareDiet();
    } else {
      //failed to remove from cart
      if (needToast) {
        FlutterToast().getToast(value.message, Colors.red);
      }
    }
  }

  Future<void> clearCartItem({bool isNeedRelod = false}) async {
    var value = await helper.clearCartItems();
    if (value.isSuccess) {
      //item removed from cart
      FlutterToast().getToast(value.message, Colors.green);
      await fetchCartItems(isNeedRelod: isNeedRelod);
      await fetchCartItem();
      await updateProductCount();

      //setCartType(CartType.DEFAULT_CART);
    } else {
      //failed to remove from cart
      FlutterToast().getToast(value.message, Colors.red);
    }
    await clearAllInCareDiet();
  }

  Future<void> updateAmount({
    bool isNeedRelod = false,
    bool isPaymentLinkViaPush = false,
    String cartId = "",
    String cartUserId,
    String notificationListId,
  }) async {
    //item removed from cart
    await fetchCartItems(
        isNeedRelod: isNeedRelod,
        isPaymentLinkViaPush: isPaymentLinkViaPush,
        cartId: cartId,
        cartUserId: cartUserId,
        notificationListId: notificationListId);
    await updateCareCount();
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
    await Provider.of<PlanWizardViewModel>(Get.context, listen: false)
        ?.fetchCartItem();
    Provider.of<PlanWizardViewModel>(Get.context, listen: false)
        ?.updateSingleSelectionProvider('');
    Provider.of<PlanWizardViewModel>(Get.context, listen: false)
        ?.updateSingleSelectionFree('');
    Provider.of<PlanWizardViewModel>(Get.context, listen: false)
        ?.updateSingleSelectionProviderDiet('');
    Provider.of<PlanWizardViewModel>(Get.context, listen: false)
        ?.updateSingleSelectionFreeDiet('');
    Provider.of<PlanWizardViewModel>(Get.context, listen: false)
        ?.updateProviderId('');
  }

  void updateCarePlanCount(bool condition) async {
    int careCount =
        await Provider.of<PlanWizardViewModel>(Get.context, listen: false)
            ?.carePlanCount;

    if (!condition) {
      await Provider.of<PlanWizardViewModel>(Get.context, listen: false)
          ?.carePlanCount++;
    }
    print("carePlanCount incheckout" +
        await Provider.of<PlanWizardViewModel>(Get.context, listen: false)
            ?.carePlanCount
            .toString());

    notifyListeners();
  }

  void updateDietPlanCount(bool condition) async {
    int dietCount =
        await Provider.of<PlanWizardViewModel>(Get.context, listen: false)
            ?.dietPlanCount;

    if (!condition) {
      await Provider.of<PlanWizardViewModel>(Get.context, listen: false)
          ?.dietPlanCount++;
    }
    print("dietPlanCount incheckout" +
        await Provider.of<PlanWizardViewModel>(Get.context, listen: false)
            ?.dietPlanCount
            .toString());

    notifyListeners();
  }

  Future<void> fetchCartItem() async {
    FetchingCartItemsModel fetchingCartItemsModel =
        await Provider.of<CheckoutPageProvider>(Get.context, listen: false)
            .fetchCartItems();
    if (fetchingCartItemsModel?.isSuccess ?? false) {
      Provider.of<PlanWizardViewModel>(Get.context, listen: false).cartList =
          fetchingCartItemsModel?.result?.cart?.productList ?? [];
      cartList = fetchingCartItemsModel?.result?.cart?.productList ?? [];
    } else {
      Provider.of<PlanWizardViewModel>(Get.context, listen: false).cartList =
          [];
      cartList = [];
    }
  }

  ProductList getProductListUsingPackageId(String packageId) {
    ProductList productList;
    print("packageIdpackageId" + packageId);
    cartList?.forEach((cartItem) {
      if ('${cartItem?.productDetail?.id}' == packageId) {
        productList = cartItem;
      }
    });
    return productList;
  }

  void updateCareCount() {
    if (cartList != null && cartList.length > 0) {
      cartList?.forEach((cartItem) {
        if ((cartItem?.additionalInfo?.isMembershipAvail ?? false) &&
            cartItem?.additionalInfo?.planType == "CARE") {
          Provider.of<PlanWizardViewModel>(Get.context, listen: false)
              ?.carePlanCount--;
        } else if ((cartItem?.additionalInfo?.isMembershipAvail ?? false) &&
            cartItem?.additionalInfo?.planType == "DIET") {
          Provider.of<PlanWizardViewModel>(Get.context, listen: false)
              ?.dietPlanCount--;
        }
      });
    } else {
      getCreditBalance();
    }
  }

  Future<void> getCreditBalance() async {
    ClaimListRepository claimListRepository = new ClaimListRepository();
    await claimListRepository.getCreditBalance().then((creditBalance) {
      if (creditBalance.isSuccess && creditBalance.result != null) {
        CreditBalanceResult creditBalanceResult = creditBalance.result;
        Provider.of<PlanWizardViewModel>(Get.context, listen: false)
            ?.carePlanCount = int.parse(creditBalanceResult.balanceCarePlans);
        Provider.of<PlanWizardViewModel>(Get.context, listen: false)
            ?.dietPlanCount = int.parse(creditBalanceResult.balanceDietPlans);
        Provider.of<PlanWizardViewModel>(Get.context, listen: false)
                ?.isMembershipAVailable =
            creditBalanceResult.isMembershipUser ?? false;
      } else {
        Provider.of<PlanWizardViewModel>(Get.context, listen: false)
            ?.carePlanCount = 0;
        Provider.of<PlanWizardViewModel>(Get.context, listen: false)
            ?.dietPlanCount = 0;
        Provider.of<PlanWizardViewModel>(Get.context, listen: false)
            ?.isMembershipAVailable = false;
      }
    });
  }

  Future<FetchingCartItemsModel> updateCartItems(
      {bool isNeedRelod = false,
      String cartUserId,
      String notificationListId,
      bool isPaymentLinkViaPush = false,
      String cartId = ""}) async {
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
}
