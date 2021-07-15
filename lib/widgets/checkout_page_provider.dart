import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gmiwidgetspackage/widgets/flutterToast.dart';
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

  int _cartCount = 0;

  bool isLoading = false;

  int get currentCartCount => _cartCount;

  void loader(bool currentIsLoading) {
    isLoading = currentIsLoading;
    notifyListeners();
  }

  void updateCartCount(int currentCount) {
    _cartCount = currentCount;
    notifyListeners();
  }

  void setCartType(CartType currentCartType) {
    cartType = currentCartType;
    notifyListeners();
  }

  Future<FetchingCartItemsModel> fetchCartItems(
      {bool isNeedRelod = true, String cartUserId}) async {
    changeCartStatus(CartStatus.LOADING, isNeedRelod: isNeedRelod);
    fetchingCartItemsModel =
        await helper.fetchCartItems(cartUserId: cartUserId);
    changeCartStatus(CartStatus.LOADED, isNeedRelod: isNeedRelod);
    updateCartCount(fetchingCartItemsModel?.result?.productsCount ?? 0);
    return fetchingCartItemsModel;
  }

  Future<void> removeCartItem({String productId, bool needToast = true}) async {
    var body = {'productId': productId};
    var value = await helper.removeCartItems(body);
    if (value.isSuccess) {
      //item removed from cart
      if (needToast) {
        FlutterToast().getToast(value.message, Colors.green);
        await fetchCartItems();
      }

      setCartType(CartType.DEFAULT_CART);
      await clearAllInCareDiet();
    } else {
      //failed to remove from cart
      if (needToast) {
        FlutterToast().getToast(value.message, Colors.red);
      }
    }
  }

  Future<void> clearCartItem() async {
    var value = await helper.clearCartItems();
      if (value.isSuccess) {
        //item removed from cart
        FlutterToast().getToast(value.message, Colors.green);
        await fetchCartItems();
        setCartType(CartType.DEFAULT_CART);
      } else {
        //failed to remove from cart
        FlutterToast().getToast(value.message, Colors.red);
      }
    await clearAllInCareDiet();
  }

  void changeCartStatus(CartStatus currentCartStatus,
      {bool isNeedRelod = true}) async {
    cartStatus = currentCartStatus;
    if (isNeedRelod) {
      notifyListeners();
    }
  }

  Future<void> clearAllInCareDiet() async {
    await Provider.of<PlanWizardViewModel>(Get.context, listen: false)
        ?.fetchCartItem();
    Provider.of<PlanWizardViewModel>(Get.context, listen: false)
        ?.updateSingleSelection('');
    Provider.of<PlanWizardViewModel>(Get.context, listen: false)
        ?.updateSingleSelectionDiet('');
    Provider.of<PlanWizardViewModel>(Get.context, listen: false)
        ?.updateProviderId('');
  }
}
