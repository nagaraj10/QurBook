import 'dart:async';
import 'dart:convert';
import 'dart:ui';
import 'dart:wasm';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gmiwidgetspackage/widgets/flutterToast.dart';
import 'package:myfhb/authentication/constants/constants.dart';
import 'package:myfhb/authentication/view/authentication_validator.dart';
import 'package:myfhb/common/CommonUtil.dart';
import 'package:myfhb/src/ui/loader_class.dart';
import 'package:myfhb/widgets/checkout_page_provider.dart';
import 'package:myfhb/widgets/checkoutpage_genric_widget.dart';
import 'package:myfhb/widgets/dotted_line.dart';
import 'package:myfhb/widgets/fetching_cart_items_model.dart';
import 'package:myfhb/widgets/shopping_card_provider.dart';
import 'package:myfhb/widgets/shopping_cart_widget.dart';
import 'package:provider/provider.dart';
import 'package:get/get.dart';
import 'package:myfhb/src/utils/screenutils/size_extensions.dart';
import 'package:myfhb/src/resources/network/ApiBaseHelper.dart';

class CheckoutPage extends StatefulWidget {
  CheckoutPage();

  @override
  _CheckoutPageState createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  ScrollController _controller = new ScrollController();

  @override
  void initState() {
    super.initState();
    Provider.of<CheckoutPageProvider>(context, listen: false).cartType =
        CartType.DEFAULT_CART;
    Provider.of<CheckoutPageProvider>(context, listen: false)
        .fetchCartItems(isNeedRelod: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    Provider.of<CheckoutPageProvider>(context, listen: false).dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[100],
      appBar: AppBar(
        title: Text(
          'My Cart',
        ),
        backgroundColor: Color(CommonUtil().getMyPrimaryColor()),
        actions: [ShoppingCartWidget()],
      ),
      body: Consumer<CheckoutPageProvider>(
        builder: (context, value, widget) {
          if (value?.cartStatus == CartStatus.LOADING) {
            return SafeArea(
              child: SizedBox(
                height: 1.sh / 4.5,
                child: new Center(
                  child: SizedBox(
                    width: 30.0.h,
                    height: 30.0.h,
                    child: new CircularProgressIndicator(
                        backgroundColor:
                            Color(new CommonUtil().getMyPrimaryColor())),
                  ),
                ),
              ),
            );
          } else {
            //LoaderClass.hideLoadingDialog(context);
            if (value.cartType == CartType.DEFAULT_CART) {
              //default cart with items
              var cartCount =
                  value?.fetchingCartItemsModel?.result?.productsCount ?? 0;
              value?.updateCartCount(cartCount);
              return !(value?.fetchingCartItemsModel?.isSuccess ?? false)
                  ? Container(
                      alignment: Alignment.center,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.grass_rounded,
                            size: 70,
                          ),
                          Text(
                            'Your cart is empty',
                            style: TextStyle(fontSize: 15),
                          ),
                          Text(
                            'Looks like you haven\'t added any plan to the cart yet.',
                            style: TextStyle(fontSize: 10),
                          ),
                          FlatButton(
                            onPressed: () {
                              //TODO navigate to search wizard screen.
                              Navigator.of(context).pop();
                            },
                            child: Text(
                              'choose plan',
                              style: TextStyle(
                                fontSize: 15,
                                color: Color(
                                  CommonUtil().getMyPrimaryColor(),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  : Stack(
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          child: SingleChildScrollView(
                            controller: _controller,
                            physics: ScrollPhysics(),
                            child: Column(
                              children: [
                                Card(
                                  elevation: 10,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(10),
                                    ),
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 10),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Text(
                                              'Confirm Order',
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 17),
                                            ),
                                            Spacer(),
                                            FlatButton(
                                                onPressed: () {
                                                  Provider.of<CheckoutPageProvider>(
                                                          context,
                                                          listen: false)
                                                      .clearCartItem();
                                                },
                                                child: Text('Clear cart'))
                                          ],
                                        ),
                                        Divider(),
                                        ListView.builder(
                                          physics:
                                              NeverScrollableScrollPhysics(),
                                          itemCount: value
                                                  ?.fetchingCartItemsModel
                                                  ?.result
                                                  ?.productsCount ??
                                              0,
                                          shrinkWrap: true,
                                          itemBuilder: (context, index) {
                                            return _cartItem(
                                                context,
                                                value
                                                    ?.fetchingCartItemsModel
                                                    ?.result
                                                    ?.cart
                                                    ?.productList[index]);
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                // SizedBox(
                                //   height: 10,
                                // ),
                                Card(
                                  elevation: 10,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(10),
                                    ),
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 10),
                                    child: Column(
                                      //mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'PRICE DETAILS',
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 17),
                                        ),
                                        Divider(),
                                        Row(
                                          children: [
                                            Text(
                                                'Price \(${value?.fetchingCartItemsModel?.result?.productsCount} items\)'),
                                            Spacer(),
                                            Text(
                                                '\$${value?.fetchingCartItemsModel?.result?.totalCartAmount}'),
                                          ],
                                        ),
                                        DottedLine(
                                            height: 1, color: Colors.grey[400]),
                                        Row(
                                          children: [
                                            Text(
                                              'Total Amount',
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                            Spacer(),
                                            Text(
                                              '\$${value?.fetchingCartItemsModel?.result?.totalCartAmount}',
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                          ],
                                        ),
                                        Divider(),
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 100,
                                ),
                              ],
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: Card(
                            margin: EdgeInsets.zero,
                            elevation: 10,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(20),
                                topRight: Radius.circular(20),
                              ),
                            ),
                            child: Container(
                              margin: EdgeInsets.symmetric(
                                horizontal: 10,
                              ),
                              height: 100,
                              child: Row(
                                children: [
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        '\$${value?.fetchingCartItemsModel?.result?.totalCartAmount ?? 0}',
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20),
                                      ),
                                      InkWell(
                                        onTap: () {
                                          Timer(Duration(milliseconds: 1000),
                                              () {
                                            if (_controller?.hasClients) {
                                              _controller.jumpTo(_controller
                                                  .position.maxScrollExtent);
                                            }
                                          });
                                        },
                                        child: Text(
                                          'View price details',
                                          style: TextStyle(
                                              color: Color(CommonUtil()
                                                  .getMyPrimaryColor()),
                                              fontWeight: FontWeight.bold,
                                              fontSize: 12),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Spacer(),
                                  Row(
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          AuthenticationValidator()
                                              .checkNetwork()
                                              .then((intenet) {
                                            if (intenet != null && intenet) {
                                              //TODO procced to pay
                                              // TODO check profile validation and all
                                              var body = {
                                                "cartId":
                                                    "${value?.fetchingCartItemsModel?.result?.cart?.id}"
                                              };
                                              CheckoutPageWidgets()
                                                  .showPaymentConfirmationDialog(
                                                      body: body,
                                                      totalCartAmount: value
                                                              ?.fetchingCartItemsModel
                                                              ?.result
                                                              ?.totalCartAmount ??
                                                          0);
                                            } else {
                                              FlutterToast().getToast(
                                                  strNetworkIssue, Colors.red);
                                            }
                                          });
                                        },
                                        child: Container(
                                          height: 50,
                                          padding: EdgeInsets.symmetric(
                                              vertical: 15.0.sp,
                                              horizontal: 15.0.sp),
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(5)),
                                            boxShadow: <BoxShadow>[
                                              BoxShadow(
                                                  color: Colors.grey.shade200,
                                                  offset: Offset(2, 4),
                                                  blurRadius: 5,
                                                  spreadRadius: 2)
                                            ],
                                            gradient: LinearGradient(
                                              begin: Alignment.centerLeft,
                                              end: Alignment.centerRight,
                                              colors: [
                                                Color(new CommonUtil()
                                                    .getMyPrimaryColor()),
                                                Color(new CommonUtil()
                                                    .getMyGredientColor())
                                              ],
                                            ),
                                          ),
                                          child: Text(
                                            strReviewPay,
                                            style: TextStyle(
                                                fontSize: 16.0.sp,
                                                color: Colors.white),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        )
                      ],
                    );
            } else if (value.cartType == CartType.EMPTY_CART) {
              // empty cart flow
            } else if (value.cartType == CartType.PAYMENT_SUCC_CART) {
              // payment success cart
            } else if (value.cartType == CartType.PAYMENT_FAIL_CART) {
              // payment failure cart
            }
          }
        },
      ),
    );
  }

  Widget _cartItem(BuildContext context, ProductList item) {
    return Container(
      child: Column(
        children: [
          Row(
            children: [
              //plan details and all
              Expanded(
                flex: 3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //title of the plan/package
                    Text(
                      '${item?.productDetail?.planName}',
                      style: TextStyle(
                          color: Colors.black54,
                          fontWeight: FontWeight.bold,
                          fontSize: 13),
                    ),
                    //duration
                    Text(
                      'Duration-${item?.productDetail?.packageDuration} days',
                      style: TextStyle(
                          color: Colors.black38,
                          fontWeight: FontWeight.bold,
                          fontSize: 9),
                    ),
                  ],
                ),
              ),
              //plan remove and price options
              Expanded(
                flex: 2,
                child: Row(
                  // mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: Icon(
                        Icons.delete_outline,
                        color: Colors.redAccent[700],
                      ),
                      onPressed: () async {
                        Provider.of<CheckoutPageProvider>(context,
                                listen: false)
                            .removeCartItem(
                                productId: '${item?.productDetail?.id}');
                      },
                    ),
                    Spacer(),
                    Text(
                      '\$${item?.productDetail?.planSubscriptionFee}',
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                          fontSize: 13),
                    ),
                  ],
                ),
              )
            ],
          ),
          Divider(),
        ],
      ),
    );
  }
}
