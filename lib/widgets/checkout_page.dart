import 'dart:async';
import 'dart:convert';
import 'dart:ui';
import 'dart:wasm';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gmiwidgetspackage/widgets/IconWidget.dart';
import 'package:gmiwidgetspackage/widgets/flutterToast.dart';
import 'package:myfhb/authentication/constants/constants.dart';
import 'package:myfhb/authentication/view/authentication_validator.dart';
import 'package:myfhb/colors/fhb_colors.dart';
import 'package:myfhb/common/CommonUtil.dart';
import 'package:myfhb/common/PreferenceUtil.dart';
import 'package:myfhb/constants/fhb_constants.dart';
import 'package:myfhb/landing/view/landing_arguments.dart';
import 'package:myfhb/plan_wizard/view_model/plan_wizard_view_model.dart';
import 'package:myfhb/src/ui/loader_class.dart';
import 'package:myfhb/src/utils/PageNavigator.dart';
import 'package:myfhb/widgets/checkout_page_provider.dart';
import 'package:myfhb/widgets/checkoutpage_genric_widget.dart';
import 'package:myfhb/widgets/dotted_line.dart';
import 'package:myfhb/widgets/fetching_cart_items_model.dart';
import 'package:myfhb/widgets/result_page_new.dart';
import 'package:myfhb/widgets/shopping_card_provider.dart';
import 'package:myfhb/widgets/shopping_cart_widget.dart';
import 'package:provider/provider.dart';
import 'package:get/get.dart';
import 'package:myfhb/src/utils/screenutils/size_extensions.dart';
import 'package:myfhb/src/resources/network/ApiBaseHelper.dart';
import 'package:myfhb/constants/router_variable.dart' as router;
import 'package:myfhb/constants/fhb_constants.dart' as Constants;
import 'package:myfhb/constants/variable_constant.dart' as variable;

class CheckoutPage extends StatefulWidget {
  final CartType cartType;
  final String cartUserId;
  CheckoutPage({this.cartType = CartType.DEFAULT_CART, this.cartUserId});

  @override
  _CheckoutPageState createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  ScrollController _controller = new ScrollController();
  final GlobalKey<State> _keyLoader = new GlobalKey<State>();

  @override
  void initState() {
    super.initState();
    Provider.of<CheckoutPageProvider>(context, listen: false).cartType =
        widget?.cartType;
    Provider.of<CheckoutPageProvider>(context, listen: false)
        .fetchCartItems(isNeedRelod: true, cartUserId: widget?.cartUserId);
    Provider.of<CheckoutPageProvider>(context, listen: false).loader(false);
  }

  @override
  void dispose() {
    _controller.dispose();
    Provider.of<CheckoutPageProvider>(context, listen: false).dispose();
    super.dispose();
  }

  Future<bool> onBackPressed(BuildContext context) {
    // if (widget?.cartType == CartType.RETRY_CART) {
    //   PageNavigator.goToPermanent(context, router.rt_Landing);
    // }
    // Navigator.of(context).pop(true);

    if (Navigator.canPop(context)) {
      Get.back();
    } else {
      Get.offAllNamed(
        router.rt_Landing,
        arguments: LandingArguments(
          needFreshLoad: true,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => onBackPressed(context),
      child: Scaffold(
        backgroundColor: const Color(bgColorContainer),
        appBar: AppBar(
          title: Text(
            'My Cart',
          ),
          backgroundColor: Color(CommonUtil().getMyPrimaryColor()),
          actions: [ShoppingCartWidget()],
          leading: IconWidget(
            icon: Icons.arrow_back_ios,
            colors: Colors.white,
            size: 24.0.sp,
            onTap: () => onBackPressed(context),
          ),
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
              if (value.cartType == CartType.DEFAULT_CART ||
                  value.cartType == CartType.RETRY_CART) {
                //default cart with items
                var cartCount =
                    value?.fetchingCartItemsModel?.result?.productsCount ?? 0;
                value?.updateCartCount(cartCount);
                return (!(value?.fetchingCartItemsModel?.isSuccess ?? false) ||
                        cartCount == 0)
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
                                Provider.of<PlanWizardViewModel>(context,
                                        listen: false)
                                    ?.changeCurrentPage(0);
                                Navigator.of(context).pop();
                              },
                              child: Text(
                                'Choose Plan',
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
                                                'Confirm Order'.toUpperCase(),
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
                                                  child: Text(
                                                    'Clear cart',
                                                    style: TextStyle(
                                                        color: Colors
                                                            .redAccent[700]),
                                                  ))
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
                                            'PRICE DETAILS'.toUpperCase(),
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 17),
                                          ),
                                          Divider(),
                                          Row(
                                            children: [
                                              Text(
                                                  'Price \(${value?.fetchingCartItemsModel?.result?.productsCount ?? 0} items\)'),
                                              Spacer(),
                                              Text(
                                                  'INR ${value?.fetchingCartItemsModel?.result?.totalCartAmount ?? 0}'),
                                            ],
                                          ),
                                          DottedLine(
                                              height: 1,
                                              color: Colors.grey[400]),
                                          Row(
                                            children: [
                                              Text(
                                                'Total Amount',
                                                style: TextStyle(
                                                    fontSize: 14,
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ),
                                              Spacer(),
                                              Text(
                                                'INR ${value?.fetchingCartItemsModel?.result?.totalCartAmount ?? 0}',
                                                style: TextStyle(
                                                    fontSize: 14,
                                                    fontWeight:
                                                        FontWeight.w500),
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'INR ${value?.fetchingCartItemsModel?.result?.totalCartAmount ?? 0}',
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
                                          onTap: value?.isLoading
                                              ? null
                                              : () async {
                                                  //! check for address to show disclaimar dialog
                                                  AuthenticationValidator()
                                                      .checkNetwork()
                                                      .then((intenet) async {
                                                    if (intenet != null &&
                                                        intenet) {
                                                      if ((value
                                                              ?.isProfileValid ??
                                                          false)) {
                                                        Provider.of<CheckoutPageProvider>(
                                                                context,
                                                                listen: false)
                                                            .loader(true);

                                                        var mCartTotal = value
                                                                ?.fetchingCartItemsModel
                                                                ?.result
                                                                ?.totalCartAmount ??
                                                            0;
                                                        var body = {
                                                          "cartId":
                                                              "${value?.fetchingCartItemsModel?.result?.cart?.id}"
                                                        };
                                                        if (mCartTotal > 0) {
                                                          CheckoutPageWidgets()
                                                              .showPaymentConfirmationDialog(
                                                                  body: body,
                                                                  totalCartAmount:
                                                                      mCartTotal);
                                                        } else {
                                                          ApiBaseHelper()
                                                              .makePayment(body)
                                                              .then((value) {
                                                            if (value != null) {
                                                              if (value
                                                                  ?.isSuccess) {
                                                                Get.off(
                                                                  PaymentResultPage(
                                                                    refNo: value
                                                                        ?.result
                                                                        ?.orderId,
                                                                    status: value
                                                                        ?.isSuccess,
                                                                    isFreePlan:
                                                                        true,
                                                                  ),
                                                                );
                                                              } else {
                                                                Provider.of<CheckoutPageProvider>(
                                                                        context,
                                                                        listen:
                                                                            false)
                                                                    .loader(
                                                                        false);
                                                                FlutterToast()
                                                                  ..getToast(
                                                                      'Subscribe Failed',
                                                                      Colors
                                                                          .red);
                                                              }
                                                            }
                                                          });
                                                        }
                                                      } else {
                                                        var result =
                                                            await CheckoutPageWidgets()
                                                                .profileValidationCheckOnCart(
                                                                    context);

                                                        FlutterToast().getToast(
                                                            'value-- $result',
                                                            Colors.green);
                                                      }
                                                    } else {
                                                      //show alert for profile check

                                                      Provider.of<CheckoutPageProvider>(
                                                              context,
                                                              listen: false)
                                                          .loader(false);
                                                      FlutterToast().getToast(
                                                          strNetworkIssue,
                                                          Colors.red);
                                                    }
                                                  });
                                                },
                                          child: ConstrainedBox(
                                            constraints:
                                                BoxConstraints(minWidth: 200),
                                            child: Container(
                                              height: 50,
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 5.0.sp,
                                                  horizontal: 5.0.sp),
                                              alignment: Alignment.center,
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(5)),
                                                boxShadow: <BoxShadow>[
                                                  BoxShadow(
                                                      color:
                                                          Colors.grey.shade200,
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
                                              child: value?.isLoading
                                                  ? SizedBox(
                                                      width: 20,
                                                      height: 20,
                                                      child:
                                                          CircularProgressIndicator(
                                                        strokeWidth: 3,
                                                      ))
                                                  : Text(
                                                      value.cartType ==
                                                              CartType
                                                                  .RETRY_CART
                                                          ? strRetryPay
                                                          : (value?.fetchingCartItemsModel?.result
                                                                          ?.totalCartAmount ??
                                                                      0) >
                                                                  0
                                                              ? strReviewPay
                                                              : strFreePlan,
                                                      style: TextStyle(
                                                          fontSize: 16.0.sp,
                                                          color: Colors.white),
                                                    ),
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
              } else if (value.cartType == CartType.PAYMENT_SUCC_CART) {
                // payment success cart
              } else if (value.cartType == CartType.PAYMENT_FAIL_CART) {
                // payment failure cart
              } else if (value.cartType == CartType.SUBSCRIBTION_SUMMARY) {
                // subscribtion cart

              }
            }
          },
        ),
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
                          // fontWeight: FontWeight.bold,
                          fontSize: 13),
                    ),
                    //duration
                    Text(
                      'Duration-${item?.productDetail?.packageDuration} days',
                      style: TextStyle(
                          color: Colors.black38,
                          // fontWeight: FontWeight.bold,
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
                      // icon: Icon(
                      //   Icons.delete_outline,
                      //   color: Colors.redAccent[700],
                      // ),
                      icon: SvgPicture.asset(
                        ic_cart_delete,
                        width: 20.0.sp,
                        height: 20.0.sp,
                      ),
                      onPressed: () {
                        Provider.of<CheckoutPageProvider>(context,
                                listen: false)
                            .removeCartItem(
                                productId: '${item?.productDetail?.id}');
                      },
                    ),
                    Spacer(),
                    Text(
                      'INR ${item?.productDetail?.planSubscriptionFee}',
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
