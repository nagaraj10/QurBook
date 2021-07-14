import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gmiwidgetspackage/widgets/flutterToast.dart';
import 'package:myfhb/plan_wizard/view_model/plan_wizard_view_model.dart';
import 'package:myfhb/src/resources/network/ApiBaseHelper.dart';
import 'package:myfhb/widgets/fetching_cart_items_model.dart';
import 'package:provider/provider.dart';

enum CartType { DEFAULT_CART, EMPTY_CART, PAYMENT_SUCC_CART, PAYMENT_FAIL_CART }
enum CartStatus { LOADING, LOADED }

class CheckoutPageProvider extends ChangeNotifier {
  CartType cartType = CartType.DEFAULT_CART;
  CartStatus cartStatus = CartStatus.LOADED;
  ApiBaseHelper helper = ApiBaseHelper();
  FetchingCartItemsModel fetchingCartItemsModel;

  int _cartCount = 0;

  int get currentCartCount => _cartCount;

  void updateCartCount(int currentCount) {
    _cartCount = currentCount;
    notifyListeners();
  }

  void setCartType(CartType currentCartType) {
    cartType = currentCartType;
    notifyListeners();
  }

  Future<FetchingCartItemsModel> fetchCartItems(
      {bool isNeedRelod = true}) async {
    changeCartStatus(CartStatus.LOADING, isNeedRelod: isNeedRelod);
    fetchingCartItemsModel = await helper.fetchCartItems();
    updateCartCount(fetchingCartItemsModel?.result?.productsCount ?? 0);
    changeCartStatus(CartStatus.LOADED, isNeedRelod: isNeedRelod);

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
      await Provider.of<PlanWizardViewModel>(Get.context, listen: false)
          ?.fetchCartItem();
      Provider.of<PlanWizardViewModel>(Get.context, listen: false)
          ?.updateSingleSelection('');
      Provider.of<PlanWizardViewModel>(Get.context, listen: false)
          ?.updateProviderId('');
    } else {
      //failed to remove from cart
      if (needToast) {
        FlutterToast().getToast(value.message, Colors.red);
      }
    }
  }

  void clearCartItem() {
    helper.clearCartItems().then((value) async {
      if (value.isSuccess) {
        //item removed from cart
        FlutterToast().getToast(value.message, Colors.green);
        await fetchCartItems();
        setCartType(CartType.DEFAULT_CART);
      } else {
        //failed to remove from cart
        FlutterToast().getToast(value.message, Colors.red);
      }
    });
  }

  void changeCartStatus(CartStatus currentCartStatus,
      {bool isNeedRelod = true}) async {
    cartStatus = currentCartStatus;
    if (isNeedRelod) {
      notifyListeners();
    }
  }
}
