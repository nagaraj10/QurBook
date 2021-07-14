import 'package:flutter/material.dart';
import 'package:gmiwidgetspackage/widgets/flutterToast.dart';
import 'package:myfhb/src/resources/network/ApiBaseHelper.dart';
import 'package:myfhb/widgets/fetching_cart_items_model.dart';

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

  Future<void> fetchCartItems({bool isNeedRelod = true}) async {
    changeCartStatus(CartStatus.LOADING, isNeedRelod: isNeedRelod);
    fetchingCartItemsModel = await helper.fetchCartItems();
    changeCartStatus(CartStatus.LOADED, isNeedRelod: isNeedRelod);
  }

  void removeCartItem({String productId}) {
    var body = {'productId': productId};
    helper.removeCartItems(body).then((value) async {
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
