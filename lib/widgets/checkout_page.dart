import 'dart:math';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:gmiwidgetspackage/widgets/IconWidget.dart';
import 'package:gmiwidgetspackage/widgets/SizeBoxWithChild.dart';
import 'package:gmiwidgetspackage/widgets/flutterToast.dart';
import 'package:gmiwidgetspackage/widgets/sized_box.dart';
import 'package:gmiwidgetspackage/widgets/text_widget.dart';
import 'package:provider/provider.dart';

import '../authentication/constants/constants.dart';
import '../authentication/view/authentication_validator.dart';
import '../colors/fhb_colors.dart';
import '../common/CommonUtil.dart';
import '../common/common_circular_indicator.dart';
import '../common/firebase_analytics_qurbook/firebase_analytics_qurbook.dart';
import '../constants/fhb_constants.dart';
import '../constants/fhb_parameters.dart' as fhb_parameters;
import '../constants/router_variable.dart' as router;
import '../constants/variable_constant.dart' as variable;
import '../landing/view/landing_arguments.dart';
import '../plan_wizard/view_model/plan_wizard_view_model.dart';
import '../src/resources/network/ApiBaseHelper.dart';
import '../src/utils/alert.dart';
import '../src/utils/screenutils/size_extensions.dart';
import 'CartIconWithBadge.dart';
import 'checkout_page_provider.dart';
import 'checkoutpage_genric_widget.dart';
import 'dotted_line.dart';
import 'fetching_cart_items_model.dart';
import 'result_page_new.dart';

class CheckoutPage extends StatefulWidget {
  //final CartType cartType;
  final String? cartUserId;
  final bool isFromNotification;
  final String? bookingId;
  final String? notificationListId;
  final String? cartId;
  final String? patientName;

  //CheckoutPage({this.cartType = CartType.DEFAULT_CART, this.cartUserId});
  CheckoutPage(
      {this.cartUserId,
      this.isFromNotification = false,
      this.bookingId = "",
      this.notificationListId = "",
      this.cartId = "",
      this.patientName = ""});

  @override
  _CheckoutPageState createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  ScrollController _controller = ScrollController();
  final GlobalKey<State> _keyLoader = GlobalKey<State>();

  @override
  void initState() {
    super.initState();
    FABService.trackCurrentScreen(FBAMyCartScreen);
    Provider.of<CheckoutPageProvider>(context, listen: false).fetchCartItems(
        isNeedRelod: true,
        cartUserId: widget.cartUserId,
        notificationListId: widget.notificationListId,
        isPaymentLinkViaPush: widget.isFromNotification,
        cartId: widget.cartId,
        firstTym: true);
    Provider.of<CheckoutPageProvider>(context, listen: false).getMemberShip();
    // WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
    Provider.of<CheckoutPageProvider>(context, listen: false)
        .loader(false, isNeedRelod: false);
    //});
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<bool> onBackPressed(BuildContext context) async {
    // if (widget?.cartType == CartType.RETRY_CART) {
    //   PageNavigator.goToPermanent(context, router.rt_Landing);
    // }
    // Navigator.of(context).pop(true);

    if (widget.isFromNotification) {
      Get.offAllNamed(router.rt_notification_main);
    } else if (Navigator.canPop(context)) {
      Get.back();
    } else {
      Get.offAllNamed(
        router.rt_Landing,
        arguments: LandingArguments(
          needFreshLoad: false,
        ),
      );
    }
    return true;
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
            style: TextStyle(
                fontSize: (CommonUtil().isTablet ?? false)
                    ? tabFontTitle
                    : mobileFontTitle),
          ),
          backgroundColor: Color(CommonUtil().getMyPrimaryColor()),
          actions: [
            Center(
              child: Container(
                margin: EdgeInsets.only(right: 10.0.sp),
                // or ClipRRect if you need to clip the content
                child: CartIconWithBadge(color: Colors.white, size: 35.sp),
              ),
            ),
          ],
          leading: IconWidget(
            icon: Icons.arrow_back_ios,
            colors: Colors.white,
            size: 24.0.sp,
            onTap: () => onBackPressed(context),
          ),
        ),
        body: Consumer<CheckoutPageProvider>(
          builder: (context, value, widgetObj) {
            if (value.cartStatus == CartStatus.LOADING) {
              return SafeArea(
                child: SizedBox(
                  height: 1.sh / 4.5,
                  child: Center(
                    child: SizedBox(
                      width: 30.0.h,
                      height: 30.0.h,
                      child: CommonCircularIndicator(),
                    ),
                  ),
                ),
              );
            } else {
              //LoaderClass.hideLoadingDialog(context);
              // if (value.cartType == CartType.DEFAULT_CART ||
              //     value.cartType == CartType.RETRY_CART) {
              //default cart with items
              int? cartCount = // FUcrash var to int?
                  value.fetchingCartItemsModel!.result?.productsCount ?? 0;
              //value?.updateCartCount(cartCount,isNeedRelod: true);
              return (!(value.fetchingCartItemsModel!.isSuccess ?? false) ||
                      cartCount == 0)
                  ? widget.isFromNotification
                      ? Container(
                          alignment: Alignment.center,
                          child: Text(
                            'Payment Link Expired',
                            style: TextStyle(fontSize: 15),
                          ),
                        )
                      : Container(
                          alignment: Alignment.center,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SvgPicture.asset(
                                ic_empty_cart,
                                width: 70.0.sp,
                                height: 70.0.sp,
                              ),
                              Text(
                                'Your cart is empty',
                                style: TextStyle(
                                    fontSize: CommonUtil().isTablet!
                                        ? tabHeader2
                                        : mobileHeader2),
                              ),
                              Text(
                                'Looks like you haven\'t added any plan to the cart yet.',
                                style: TextStyle(
                                    fontSize: CommonUtil().isTablet!
                                        ? tabHeader3
                                        : mobileHeader3),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  if (widget.isFromNotification == false) {
                                    Provider.of<PlanWizardViewModel>(context,
                                            listen: false)
                                        .changeCurrentPage(0);
                                    if (Provider.of<PlanWizardViewModel>(
                                            context,
                                            listen: false)
                                        .isPlanWizardActive) {
                                      Get.back();
                                    } else {
                                      Get.offAndToNamed(router.rt_PlanWizard);
                                    }
                                  }
                                },
                                child: Text(
                                  'Choose Plan',
                                  style: TextStyle(
                                    fontSize: CommonUtil().isTablet!
                                        ? tabHeader2
                                        : mobileHeader2,
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
                                                  fontSize:
                                                      CommonUtil().isTablet!
                                                          ? tabHeader1
                                                          : mobileHeader1),
                                            ),
                                            Spacer(),
                                            TextButton(
                                              onPressed: () {
                                                if (widget.isFromNotification ==
                                                    false) {
                                                  showDialog(
                                                      barrierDismissible: false,
                                                      context: Get.context!,
                                                      builder: (context) {
                                                        return AlertDialog(
                                                          insetPadding:
                                                              EdgeInsets
                                                                  .symmetric(
                                                                      horizontal:
                                                                          8),
                                                          backgroundColor:
                                                              Colors
                                                                  .transparent,
                                                          content: Container(
                                                            width: double
                                                                .maxFinite,
                                                            height: 250.0,
                                                            child: Column(
                                                              children: <Widget>[
                                                                Column(
                                                                  children: <Widget>[
                                                                    Card(
                                                                      shape:
                                                                          RoundedRectangleBorder(
                                                                        borderRadius:
                                                                            BorderRadius.circular(4.0),
                                                                      ),
                                                                      child:
                                                                          Container(
                                                                        height:
                                                                            160,
                                                                        padding:
                                                                            EdgeInsets.all(8.0),
                                                                        child:
                                                                            Column(
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.spaceEvenly,
                                                                          children: <Widget>[
                                                                            Center(
                                                                              child: Text(
                                                                                fhb_parameters.CLEAR_CART_MSG,
                                                                                style: TextStyle(fontSize: CommonUtil().isTablet! ? tabHeader3 : mobileHeader3, fontWeight: FontWeight.w500),
                                                                                textAlign: TextAlign.center,
                                                                              ),
                                                                            ),
                                                                            SizedBoxWidget(
                                                                              height: 10,
                                                                            ),
                                                                            Row(
                                                                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                                              children: <Widget>[
                                                                                SizedBoxWithChild(
                                                                                  width: CommonUtil().isTablet! ? 120 : 90,
                                                                                  height: CommonUtil().isTablet! ? 50 : 40,
                                                                                  child: ElevatedButton(
                                                                                    style: ElevatedButton.styleFrom(
                                                                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0), side: BorderSide(color: Color(CommonUtil().getMyPrimaryColor()))),
                                                                                      backgroundColor: Colors.transparent,
                                                                                      foregroundColor: Color(CommonUtil().getMyPrimaryColor()),
                                                                                      padding: EdgeInsets.all(8.0),
                                                                                    ),
                                                                                    onPressed: () {
                                                                                      try {
                                                                                        Navigator.pop(context);
                                                                                      } catch (e, stackTrace) {
                                                                                        //print(e);
                                                                                        CommonUtil().appLogs(message: e, stackTrace: stackTrace);
                                                                                      }
                                                                                    },
                                                                                    child: TextWidget(
                                                                                      text: 'Cancel',
                                                                                      fontsize: 14.0.sp,
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                                SizedBoxWithChild(
                                                                                  width: CommonUtil().isTablet! ? 120 : 90,
                                                                                  height: CommonUtil().isTablet! ? 50 : 40,
                                                                                  child: ElevatedButton(
                                                                                    style: ElevatedButton.styleFrom(
                                                                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0), side: BorderSide(color: Color(CommonUtil().getMyPrimaryColor()))),
                                                                                      backgroundColor: Colors.transparent,
                                                                                      foregroundColor: Color(CommonUtil().getMyPrimaryColor()),
                                                                                      padding: EdgeInsets.all(8.0),
                                                                                    ),
                                                                                    onPressed: () {
                                                                                      try {
                                                                                        if (widget.isFromNotification == false) {
                                                                                          Provider.of<CheckoutPageProvider>(context, listen: false).clearCartItem(isNeedRelod: true);
                                                                                          Navigator.pop(context);
                                                                                        }
                                                                                      } catch (e, stackTrace) {
                                                                                        //print(e);
                                                                                        CommonUtil().appLogs(message: e, stackTrace: stackTrace);
                                                                                      }
                                                                                    },
                                                                                    child: TextWidget(
                                                                                      text: fhb_parameters.ok,
                                                                                      fontsize: 14.0.sp,
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                              ],
                                                                            ),
                                                                            CommonUtil().isTablet!
                                                                                ? SizedBoxWidget(
                                                                                    height: 8.0.h,
                                                                                  )
                                                                                : SizedBox.shrink(),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                )
                                                              ],
                                                            ),
                                                          ),
                                                        );
                                                      });
                                                }
                                              },
                                              child: Text('Clear cart',
                                                  style: TextStyle(
                                                      fontSize:
                                                          CommonUtil().isTablet!
                                                              ? tabTitle
                                                              : mobileHeader1)),
                                              style: TextButton.styleFrom(
                                                foregroundColor:
                                                    widget.isFromNotification
                                                        ? Colors.grey
                                                        : Colors.redAccent[700],
                                              ),
                                            )
                                          ],
                                        ),
                                        Divider(),
                                        widget.isFromNotification
                                            ? Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  Container(
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      children: <Widget>[
                                                        Text("Member Name :",
                                                            style: TextStyle(
                                                                fontSize:
                                                                    14.0.sp,
                                                                color: Colors
                                                                    .grey)),
                                                        SizedBox(
                                                          width: 10,
                                                        ),
                                                        Text(
                                                            widget.patientName!,
                                                            style: TextStyle(
                                                                fontSize:
                                                                    18.0.sp,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold)),
                                                      ],
                                                    ),
                                                  )
                                                ],
                                              )
                                            : SizedBox(),
                                        SizedBoxWidget(
                                          height: 8.0,
                                        ),
                                        ListView.builder(
                                          physics:
                                              NeverScrollableScrollPhysics(),
                                          itemCount: value
                                                  .fetchingCartItemsModel!
                                                  .result!
                                                  .productsCount ??
                                              0,
                                          shrinkWrap: true,
                                          itemBuilder: (context, index) {
                                            return _cartItem(
                                                context,
                                                value
                                                    .fetchingCartItemsModel!
                                                    .result!
                                                    .cart!
                                                    .productList![index]);
                                          },
                                        ),
                                        // Add Checkbox for Membership discount apply
                                        Row(
                                          children: [
                                            SizedBox(
                                              width: 35.0.w,
                                              height: 25.0.w,
                                              child: Container(
                                                margin: const EdgeInsets.only(
                                                  right: 10,
                                                ),
                                                child: Checkbox(
                                                  activeColor: Color(
                                                    CommonUtil()
                                                        .getMyPrimaryColor(),
                                                  ),
                                                  checkColor: Colors.white,
                                                  value:  value.
                                                      checkedMembershipBenefits,
                                                  onChanged: (newValue) {
                                                    setState(() {
                                                      value.checkedMembershipBenefits =
                                                          newValue ?? false;
                                                    });
                                                    value.updateProductCountBasedOnCondiiton(isNeedRelod: true, firstTym: false);
                                                  },
                                                ),
                                              ),
                                            ),
                                            Flexible(
                                              child: Wrap(
                                                children: [
                                                  Text(
                                                    getMembershipDiscount(
                                                        value),
                                                    style: TextStyle(
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        )
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
                                              fontSize: CommonUtil().isTablet!
                                                  ? tabHeader2
                                                  : mobileHeader2),
                                        ),
                                        Divider(),
                                        Row(
                                          children: [
                                            Text(
                                                'Price \(${value.fetchingCartItemsModel?.result!.productsCount ?? 0} items\)',
                                                style: TextStyle(
                                                    fontSize:
                                                        CommonUtil().isTablet!
                                                            ? tabHeader3
                                                            : mobileHeader3)),
                                            Spacer(),
                                            Text(
                                              //to showcase subtotal of product
                                              '${CommonUtil.CURRENCY}${value.subTotalProductCount}',
                                              style: TextStyle(
                                                  fontSize:
                                                      CommonUtil().isTablet!
                                                          ? tabHeader3
                                                          : mobileHeader3),
                                            ),
                                          ],
                                        ),
                                        /// if Apply Membership Benefits then transactionlimit amount Deduct from subtotal
                                        Visibility(
                                          visible:
                                              value.checkedMembershipBenefits,
                                          child: const Divider(),
                                        ),
                                        Visibility(
                                          visible:
                                              value.checkedMembershipBenefits,
                                          child: Row(
                                            children: [
                                              Text(
                                                getMembershipDiscount(value),
                                                style: TextStyle(
                                                  fontSize:
                                                      CommonUtil().isTablet!
                                                          ? tabHeader2
                                                          : mobileHeader2,
                                                ),
                                              ),
                                              const Spacer(),
                                              Text(
                                                getMembershipDiscountWithCurrency(value),
                                                style: TextStyle(
                                                  fontSize:
                                                      CommonUtil().isTablet!
                                                          ? tabHeader3
                                                          : mobileHeader3,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        DottedLine(
                                            height: 1,
                                            color: Colors.grey[400]!),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            Text(
                                              'Total Amount',
                                              style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                            SizedBox(
                                              width: 20.0.w,
                                            ),
                                            Text(
                                              '${CommonUtil.CURRENCY}${value.totalProductCount}',
                                              style: TextStyle(
                                                  fontSize:
                                                      CommonUtil().isTablet!
                                                          ? tabHeader3
                                                          : mobileHeader3,
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
                                        '${CommonUtil.CURRENCY}${value.totalProductCount}',
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                            fontSize: CommonUtil().isTablet!
                                                ? tabHeader2
                                                : mobileHeader2),
                                      ),
                                    ],
                                  ),
                                  Spacer(),
                                  Row(
                                    children: [
                                      InkWell(
                                        onTap: value.isLoading
                                            ? null
                                            : () async {
                                                AuthenticationValidator()
                                                    .checkNetwork()
                                                    .then((intenet) async {
                                                  if (intenet != null &&
                                                      intenet) {
                                                    methodToCheckIfCartIsUpdated(
                                                        value);
                                                  } else {
                                                    Provider.of<CheckoutPageProvider>(
                                                            context,
                                                            listen: false)
                                                        .loader(false,
                                                            isNeedRelod: true);
                                                    FlutterToast().getToast(
                                                        strNetworkIssue,
                                                        Colors.red);
                                                  }
                                                });
                                              },
                                        child: ConstrainedBox(
                                          constraints: BoxConstraints(
                                              minWidth: CommonUtil().isTablet!
                                                  ? 230
                                                  : 200),
                                          child: Container(
                                            height: CommonUtil().isTablet!
                                                ? 60
                                                : 50,
                                            padding: EdgeInsets.symmetric(
                                              vertical: 5.0.sp,
                                              horizontal: 20.0.sp,
                                            ),
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
                                                  Color(CommonUtil()
                                                      .getMyPrimaryColor()),
                                                  Color(CommonUtil()
                                                      .getMyGredientColor())
                                                ],
                                              ),
                                            ),
                                            child: value.isLoading
                                                ? SizedBox(
                                                    width: 20,
                                                    height: 20,
                                                    child:
                                                        CommonCircularIndicator())
                                                : Text( value.cartType ==
                                                            CartType.RETRY_CART
                                                        ? strRetryPay
                                                        : (value.totalProductCount) >
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
              // } else if (value.cartType == CartType.PAYMENT_SUCC_CART) {
              //   // payment success cart
              // } else if (value.cartType == CartType.PAYMENT_FAIL_CART) {
              //   // payment failure cart
              // } else if (value.cartType == CartType.SUBSCRIBTION_SUMMARY) {
              //   // subscribtion cart

              // }
            }
          },
        ),
      ),
    );
  }

  void planSubLogic(CheckoutPageProvider value) async {
    await Provider.of<CheckoutPageProvider>(context, listen: false)
        .loader(true);

    Provider.of<CheckoutPageProvider>(context, listen: false).isMembershipCart =
        Provider.of<PlanWizardViewModel>(context, listen: false)
            .checkCartForBundle();
    var mCartTotal = value.totalProductCount;

    var body = {
      "cartId": "${value.fetchingCartItemsModel!.result!.cart!.id}",
      "isQurbook": true
    };
    /// Add `walletDeductionAmount` parameter only if patient apply Membership benefits checked
    if (value.checkedMembershipBenefits) {
      final maxMembershipAmountLimit = getMembershipAmountLimit(value);

    final finalAmount = min(maxMembershipAmountLimit,
        value.totalProductCount);
      body['walletDeductionAmount'] = finalAmount;
    }
    FetchingCartItemsModel? fetchingCartItemsModel =
        await Provider.of<CheckoutPageProvider>(Get.context!, listen: false)
            .updateCartItems(
                isNeedRelod: false,
                cartUserId: widget.cartUserId,
                notificationListId: widget.notificationListId,
                isPaymentLinkViaPush: widget.isFromNotification,
                cartId: widget.cartId);

    if (mCartTotal > 0) {
      CheckoutPageWidgets().showPaymentConfirmationDialog(
          body: body,
          totalCartAmount: mCartTotal,
          isPaymentNotification: widget.isFromNotification,
          fetchingCartItemsModel: fetchingCartItemsModel,
          isSuccess: (value) {
            if (value!) {
              Provider.of<CheckoutPageProvider>(context, listen: false)
                  .loader(false, isNeedRelod: true);
              Provider.of<CheckoutPageProvider>(context, listen: false)
                  .updateAmount(
                      isNeedRelod: true,
                      cartId: widget.cartId,
                      notificationListId: widget.notificationListId,
                      isPaymentLinkViaPush: widget.isFromNotification,
                      cartUserId: widget.cartUserId,
                      firstTym: false);

              Provider.of<CheckoutPageProvider>(Get.context!, listen: false)
                  .fetchCartItems(
                      isNeedRelod: true,
                      cartUserId: widget.cartUserId,
                      notificationListId: widget.notificationListId,
                      isPaymentLinkViaPush: widget.isFromNotification,
                      cartId: widget.cartId,
                      firstTym: false);
            }
          });
    } else {
      ApiBaseHelper().makePayment(body).then((value) {
        if (value != null) {
          if (value.isSuccess! && !(value.result != null)) {
            Alert.displayConfirmation(Get.context!,
                confirm: "Update Cart",
                title: "Update",
                content: value.message!, onPressedConfirm: () {
              ApiBaseHelper()
                  .updateCartIcon(fetchingCartItemsModel?.result)
                  .then((value) {
                Provider.of<CheckoutPageProvider>(context, listen: false)
                    .loader(false, isNeedRelod: true);
                Navigator.of(Get.context!).pop();
                if (value['isSuccess']) {
                  Navigator.pop(context);
                }
              });
            });
          } else if ((value.isSuccess ?? false) && value.result != null) {
            Get.off(
              PaymentResultPage(
                refNo: value.result!.orderId,
                status: value.isSuccess,
                isFreePlan: true,
                isPaymentFromNotification: widget.isFromNotification,
              ),
            );
          } else {
            Provider.of<CheckoutPageProvider>(context, listen: false)
                .loader(false, isNeedRelod: true);
            FlutterToast()..getToast('Subscribe Failed', Colors.red);
          }
        }
      });
    }
  }

  Widget _cartItem(BuildContext context, ProductList item,
      {bool isFirsTym = true}) {
    int productValue = 0;

    if (!isFirsTym) {
      if (item.productDetail?.planSubscriptionFee != null &&
          item.productDetail?.planSubscriptionFee != "") {
        if (item.additionalInfo?.isMembershipAvail ?? false) {
          productValue = 0;
        } else {
          productValue =
              double.parse(item.productDetail!.planSubscriptionFee!).toInt();
        }
      }
    } else {
      if (item.additionalInfo?.newFee != null &&
          item.additionalInfo?.newFee != "") {
        if (item.additionalInfo?.isMembershipAvail ?? false) {
          productValue = 0;
        } else {
          productValue = double.parse(item.additionalInfo?.newFee).toInt();
        }
      } else if (item.additionalInfo?.actualFee != null &&
          item.additionalInfo?.actualFee != "") {
        if (item.additionalInfo?.isMembershipAvail ?? false) {
          productValue = 0;
        } else {
          productValue = double.parse(item.additionalInfo?.actualFee).toInt();
        }
      } else if (item.paidAmount!.contains(".")) {
        if (item.additionalInfo?.isMembershipAvail ?? false) {
          productValue = 0;
        } else {
          productValue = double.parse(item.paidAmount!).toInt();
        }
      } else {
        if (item.additionalInfo?.isMembershipAvail ?? false) {
          productValue = 0;
        } else {
          productValue = int.parse(item.paidAmount!);
        }
      }
    }
    return Container(
      padding: EdgeInsets.only(top: 10),
      child: Column(
        children: [
          item.additionalInfo?.isMembershipAvail ?? false
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          border: Border.all(
                            color: Color(CommonUtil().getMyPrimaryColor()),
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(5))),
                      child: Container(
                        color: Color(CommonUtil().getMyPrimaryColor()),
                        padding: EdgeInsets.all(5.0),
                        child: Text("Membership Applied",
                            style: TextStyle(
                                color: Colors.white70,
                                // fontWeight: FontWeight.bold,
                                fontSize: 9)),
                      ),
                    ),
                  ],
                )
              : SizedBox(),
          Row(
            children: [
              //plan details and all
              Expanded(
                flex: 3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //title of the plan/package
                    Wrap(
                      //mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '${item.productDetail?.planName}',
                          style: TextStyle(
                              color: Colors.black54,
                              // fontWeight: FontWeight.bold,
                              fontSize: CommonUtil().isTablet!
                                  ? tabHeader2
                                  : mobileHeader2),
                        ),
                        item.additionalInfo!.isRenewal!
                            ? Text(
                                strRenewal,
                                style: TextStyle(
                                    color: Colors.black54,
                                    // fontWeight: FontWeight.bold,
                                    fontSize: CommonUtil().isTablet!
                                        ? tabHeader2
                                        : mobileHeader2),
                              )
                            : Container()
                      ],
                    ),

                    //duration
                    Text(
                      'Duration-${getDurationBasedOnCondition(item, firstTym: isFirsTym)} days',
                      style: TextStyle(
                          color: Colors.black38,
                          // fontWeight: FontWeight.bold,
                          fontSize: CommonUtil().isTablet!
                              ? tabHeader4
                              : mobileHeader4),
                    ),
                    Text(
                      'Offered By: ${item.productDetail?.healthOrganizationName}',
                      style: TextStyle(
                          color: Colors.black54,
                          // fontWeight: FontWeight.bold,
                          fontSize: CommonUtil().isTablet!
                              ? tabHeader3
                              : mobileHeader3),
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
                        color: widget.isFromNotification ? Colors.grey : null,
                      ),
                      onPressed: () {
                        if (widget.isFromNotification == false) {
                          showDialog(
                              barrierDismissible: false,
                              context: Get.context!,
                              builder: (context) => AlertDialog(
                                    insetPadding:
                                        EdgeInsets.symmetric(horizontal: 8),
                                    backgroundColor: Colors.transparent,
                                    content: Container(
                                      width: double.maxFinite,
                                      height: 250.0,
                                      child: Column(
                                        children: <Widget>[
                                          Column(
                                            children: <Widget>[
                                              Card(
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          4.0),
                                                ),
                                                child: Container(
                                                  height: 160,
                                                  padding: EdgeInsets.all(8.0),
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceEvenly,
                                                    children: <Widget>[
                                                      Container(
                                                        margin: EdgeInsets
                                                            .symmetric(
                                                          vertical: 5,
                                                        ),
                                                        child: RichText(
                                                          textAlign:
                                                              TextAlign.center,
                                                          text: TextSpan(
                                                            text: 'Remove ',
                                                            style: TextStyle(
                                                              fontSize: 16.0.sp,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              color:
                                                                  Colors.black,
                                                            ),
                                                            children: <TextSpan>[
                                                              TextSpan(
                                                                text:
                                                                    '${item.productDetail?.planName!.toLowerCase()}',
                                                                style:
                                                                    TextStyle(
                                                                  fontSize:
                                                                      16.0.sp,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                  // fontStyle:
                                                                  //     FontStyle
                                                                  //         .italic,
                                                                  color: Colors
                                                                      .black,
                                                                ),
                                                              ),
                                                              TextSpan(
                                                                text:
                                                                    ' from cart?',
                                                                style:
                                                                    TextStyle(
                                                                  fontSize:
                                                                      16.0.sp,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                  color: Colors
                                                                      .black,
                                                                ),
                                                              )
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                      SizedBoxWidget(
                                                        height: 10,
                                                      ),
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceEvenly,
                                                        children: <Widget>[
                                                          SizedBoxWithChild(
                                                            width: CommonUtil()
                                                                    .isTablet!
                                                                ? 120
                                                                : 90,
                                                            height: CommonUtil()
                                                                    .isTablet!
                                                                ? 50
                                                                : 40,
                                                            child:
                                                                ElevatedButton(
                                                              style:
                                                                  ElevatedButton
                                                                      .styleFrom(
                                                                shape: RoundedRectangleBorder(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            12.0),
                                                                    side: BorderSide(
                                                                        color: Color(
                                                                            CommonUtil().getMyPrimaryColor()))),
                                                                backgroundColor:
                                                                    Colors
                                                                        .transparent,
                                                                foregroundColor:
                                                                    Color(CommonUtil()
                                                                        .getMyPrimaryColor()),
                                                                padding:
                                                                    EdgeInsets
                                                                        .all(
                                                                            8.0),
                                                              ),
                                                              onPressed: () {
                                                                try {
                                                                  Navigator.pop(
                                                                      context);
                                                                } catch (e, stackTrace) {
                                                                  //print(e);
                                                                  CommonUtil().appLogs(
                                                                      message: e
                                                                          .toString());
                                                                }
                                                              },
                                                              child: TextWidget(
                                                                text: 'Cancel',
                                                                fontsize:
                                                                    14.0.sp,
                                                              ),
                                                            ),
                                                          ),
                                                          SizedBoxWithChild(
                                                            width: CommonUtil()
                                                                    .isTablet!
                                                                ? 120
                                                                : 90,
                                                            height: CommonUtil()
                                                                    .isTablet!
                                                                ? 50
                                                                : 40,
                                                            child:
                                                                ElevatedButton(
                                                              style:
                                                                  ElevatedButton
                                                                      .styleFrom(
                                                                shape:
                                                                    RoundedRectangleBorder(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              12.0),
                                                                  side:
                                                                      BorderSide(
                                                                    color:
                                                                        Color(
                                                                      CommonUtil()
                                                                          .getMyPrimaryColor(),
                                                                    ),
                                                                  ),
                                                                ),
                                                                backgroundColor:
                                                                    Colors
                                                                        .transparent,
                                                                foregroundColor:
                                                                    Color(CommonUtil()
                                                                        .getMyPrimaryColor()),
                                                                padding:
                                                                    const EdgeInsets
                                                                        .all(
                                                                        8.0),
                                                              ),
                                                              onPressed:
                                                                  () async {
                                                                try {
                                                                  await Provider.of<
                                                                              CheckoutPageProvider>(
                                                                          context,
                                                                          listen:
                                                                              false)
                                                                      .fetchCartItem();

                                                                  ProductList? productList = Provider.of<
                                                                              CheckoutPageProvider>(
                                                                          context,
                                                                          listen:
                                                                              false)
                                                                      .getProductListUsingPackageId(
                                                                          '${item.productDetail?.id}');
                                                                  await Provider.of<CheckoutPageProvider>(context, listen: false).removeCartItem(
                                                                      productId:
                                                                          '${item.productDetail?.id}',
                                                                      isNeedRelod:
                                                                          true,
                                                                      productList:
                                                                          productList,
                                                                      isFrom:
                                                                          "Cart");

                                                                  Navigator.pop(
                                                                      context);
                                                                } catch (e, stackTrace) {
                                                                  //print(e);
                                                                  CommonUtil().appLogs(
                                                                      message: e
                                                                          .toString());
                                                                }
                                                              },
                                                              child: TextWidget(
                                                                text: fhb_parameters.ok,
                                                                fontsize:
                                                                    14.0.sp,
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      CommonUtil().isTablet!
                                                          ? SizedBoxWidget(
                                                              height: 8.0.h,
                                                            )
                                                          : SizedBox.shrink(),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                  ));
                        }
                      },
                    ),
                    Spacer(),
                    Text(
                      '${CommonUtil.CURRENCY}${productValue}',
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                          fontSize: CommonUtil().isTablet!
                              ? tabHeader2
                              : mobileHeader2),
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

  int? getDurationBasedOnCondition(ProductList item, {bool firstTym = true}) {
    int? planDuration = 0;
    if (!firstTym) {
      if (item.productDetail?.packageDuration != null &&
          item.productDetail?.packageDuration != "") {
        if (item.additionalInfo?.isMembershipAvail ?? false) {
          planDuration = 0;
        } else {
          planDuration = item.productDetail?.packageDuration;
        }
      }
    } else {
      if (item.additionalInfo?.duration != null &&
          item.additionalInfo?.duration != "") {
        if (item.additionalInfo?.isMembershipAvail ?? false) {
          planDuration = 0;
        } else {
          planDuration = item.additionalInfo?.duration!.toInt();
        }
      } else {
        if (item.additionalInfo?.isMembershipAvail ?? false) {
          planDuration = 0;
        } else {
          planDuration = item.productDetail?.packageDuration;
        }
      }
    }

    return planDuration;
  }

  void methodToCheckIfCartIsUpdated(CheckoutPageProvider value) async {
    await Provider.of<CheckoutPageProvider>(context, listen: false)
        .loader(true);
    CommonUtil.showLoadingDialog(context, _keyLoader, variable.Please_Wait);

    Provider.of<CheckoutPageProvider>(context, listen: false).isMembershipCart =
        Provider.of<PlanWizardViewModel>(context, listen: false)
            .checkCartForBundle();

    var body = {
      "cartId": "${value.fetchingCartItemsModel!.result!.cart!.id}",
      "isQurbook": true
    };
    /// Add `walletDeductionAmount` parameter only if patient apply Membership benefits checked
    if (value.checkedMembershipBenefits) {
      final maxMembershipAmountLimit = getMembershipAmountLimit(value);
      final finalAmount =
          min(maxMembershipAmountLimit, value.totalProductCount);
      body['walletDeductionAmount'] = finalAmount;
    }
    FetchingCartItemsModel? fetchingCartItemsModel =
        await Provider.of<CheckoutPageProvider>(Get.context!, listen: false)
            .updateCartItems(
                isNeedRelod: false,
                cartUserId: widget.cartUserId,
                notificationListId: widget.notificationListId,
                isPaymentLinkViaPush: widget.isFromNotification,
                cartId: widget.cartId);

    ApiBaseHelper().makePayment(body).then((result) async {
      await Provider.of<CheckoutPageProvider>(context, listen: false)
          .loader(false, isNeedRelod: false);
      if (result != null) {
        if (result.isSuccess!) {
          Navigator.of(_keyLoader.currentContext!, rootNavigator: true).pop();

          if (result.result != null) {
            var checkValidation = await CheckoutPageWidgets()
                .profileValidationCheckOnCart(context,
                    feeZero: (value.totalProductCount) > 0 ? false : true);
            if (checkValidation ?? false) {
              planSubLogic(value);
            }
          } else {
            Alert.displayConfirmProceed(Get.context!,
                confirm: variable.stringUpdateCart,
                title: "Update",
                content: result.message ?? '', onPressedConfirm: () {
              ApiBaseHelper()
                  .updateCartIcon(fetchingCartItemsModel?.result)
                  .then((value) {
                Navigator.of(Get.context!).pop();
                if (value['isSuccess']) {
                  Provider.of<CheckoutPageProvider>(context, listen: false)
                      .loader(false, isNeedRelod: true);
                  Provider.of<CheckoutPageProvider>(context, listen: false)
                      .updateAmount(
                          isNeedRelod: true,
                          cartId: widget.cartId,
                          notificationListId: widget.notificationListId,
                          isPaymentLinkViaPush: widget.isFromNotification,
                          cartUserId: widget.cartUserId,
                          firstTym: false);

                  Provider.of<CheckoutPageProvider>(Get.context!, listen: false)
                      .fetchCartItems(
                          isNeedRelod: true,
                          cartUserId: widget.cartUserId,
                          notificationListId: widget.notificationListId,
                          isPaymentLinkViaPush: widget.isFromNotification,
                          cartId: widget.cartId,
                          firstTym: false);
                }
              });
            });
          }
        } else {
          Navigator.of(_keyLoader.currentContext!, rootNavigator: true).pop();
          FlutterToast()..getToast('Subscribe Failed', Colors.red);
        }
      } else {
        var result = await CheckoutPageWidgets().profileValidationCheckOnCart(
            context,
            feeZero: (value.totalProductCount) > 0 ? false : true);
        if (result ?? false) {
          planSubLogic(value);
        }
      }
    });
  }

  /// Returns the membership discount title string, appending the
  /// maximum membership discount amount if applicable.
  ///
  /// Parameters:
  /// - value: The CheckoutPageProvider value.
  ///
  /// Returns: The membership discount title string.
  String getMembershipDiscount(CheckoutPageProvider value) {
    final maxMembershipAmountLimit = getMembershipAmountLimit(value);
    var basedtitle = variable.strMembershipDiscount;
    if (maxMembershipAmountLimit > 0) {
      basedtitle += ' (Max. $maxMembershipAmountLimit)';
    }
    return basedtitle;
  }

  /// Returns the maximum membership discount amount limit based on the
  /// membership details in the provided CheckoutPageProvider value.
  ///
  /// Checks the membership additional info for the 'benefitType' field
  /// with name 'benefitCareDietPlans', and returns its 'transactionLimit'
  /// value if available. Otherwise returns 0.
  int getMembershipAmountLimit(CheckoutPageProvider value) {
    return value.memberShipDetailsResult?.additionalInfo?.benefitType
            ?.lastWhere((element) =>
                element.fieldName == variable.strBenefitCareDietPlans)
            .transactionLimit ??
        0;
  }
  /// Returns the membership discount title string with currency formatting,
  /// capping the discount at the maximum membership amount limit if applicable.
  ///
  /// Gets the maximum membership amount limit using getMembershipAmountLimit().
  /// Then calculates the actual discount amount by taking the min of the
  /// limit and total product count. Formats the amount with currency and minus sign.
  /// So this shows the membership discount up to the max limit.
  ///
  /// Parameters:
  /// - value: The CheckoutPageProvider value.
  ///
  /// Returns: The membership discount title string with currency formatting.
  String getMembershipDiscountWithCurrency(CheckoutPageProvider value) {
    final maxMembershipAmountLimit = getMembershipAmountLimit(value);

    final finalAmount = min(maxMembershipAmountLimit, value.totalProductCount);

    return '-${CommonUtil.CURRENCY}$finalAmount';
  }
}
