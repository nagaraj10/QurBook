import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';
import 'package:myfhb/common/PreferenceUtil.dart';
import 'package:myfhb/common/firebase_analytics_service.dart';
import 'package:myfhb/constants/fhb_constants.dart';
import 'package:myfhb/constants/fhb_parameters.dart';
import 'package:myfhb/landing/view/landing_arguments.dart';
import 'package:myfhb/regiment/view_model/regiment_view_model.dart';
import 'package:myfhb/common/CommonUtil.dart';
import 'package:myfhb/src/utils/screenutils/size_extensions.dart';
import 'package:myfhb/widgets/checkout_page.dart';
import 'package:myfhb/widgets/checkout_page_provider.dart';
import 'package:myfhb/widgets/payment_gatway.dart';
import 'package:provider/provider.dart';
import 'package:myfhb/constants/router_variable.dart' as router;
import 'package:myfhb/telehealth/features/Notifications/view/notification_main.dart';

class PaymentResultPage extends StatefulWidget {
  final bool? status;
  final bool? isFromSubscribe;
  final String? refNo;
  final bool isFreePlan;
  Function(String)? closePage;
  final bool? isPaymentFails;
  final String? cartUserId;
  final String? paymentRetryUrl;
  final String? paymentId;
  final bool? isFromRazor;
  final bool isPaymentFromNotification;

  PaymentResultPage(
      {Key? key,
      required this.status,
      this.refNo,
      this.closePage,
      this.isFromSubscribe,
      this.isFreePlan = false,
      this.isPaymentFails = false,
      this.cartUserId = null,
      this.paymentRetryUrl,
      this.paymentId,
      this.isFromRazor,
      this.isPaymentFromNotification = false})
      : super(key: key);

  @override
  _ResultPage createState() => _ResultPage();
}

class _ResultPage extends State<PaymentResultPage> {
  bool? status;

  //bool isFromSubscribe;

  @override
  void initState() {
    mInitialTime = DateTime.now();
    status = widget.status ?? false;
    //isFromSubscribe = widget.isFromSubscribe;
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    fbaLog(eveName: 'qurbook_screen_event', eveParams: {
      'eventTime': '${DateTime.now()}',
      'pageName': 'Payment Done Screen',
      'screenSessionTime':
          '${DateTime.now().difference(mInitialTime).inSeconds} secs'
    });
  }

  Widget paidPlanContent() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(status! ? PAYMENT_SUCCESS_MSG : PAYMENT_FAILURE_MSG,
            style: TextStyle(
                fontSize: 22.0.sp,
                color:Color(CommonUtil().getMyPrimaryColor()),
                fontWeight: FontWeight.bold)),
        SizedBox(height: 10.0.h),
        status!
            ? Text(PLAN_CONFIRM,
                style: TextStyle(
                    fontSize: 16.0.sp,
                    color: Color(CommonUtil().getMyPrimaryColor()),
                    fontWeight: FontWeight.bold))
            : Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Text(
                  PAYMENT_FAILURE_CONTENT, // TODO this need to confirm with Bussiness
                  style: TextStyle(
                      fontSize: 12.0.sp,
                      color: Color(CommonUtil().getMyPrimaryColor()),
                      fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        body: Container(
          child: Center(
            child: Container(
              child: SingleChildScrollView(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Image.asset(
                          status! ? PAYMENT_SUCCESS_PNG : PAYMENT_FAILURE_PNG,
                          width: 120.0.h,
                          height: 120.0.h,
                          color: status! ? Color(CommonUtil().getMyPrimaryColor()) : Colors.red),
                      SizedBox(height: 15.0.h),
                      (widget.isFreePlan)
                          ? Text(
                              status!
                                  ? 'Plan Subscription/Renewal Successful'
                                  : 'Plan Subscription/Renewal Failed',
                              // TODO this need to confirm with bussinees
                              style: TextStyle(
                                  fontSize: 18.0.sp,
                                  color:Color(CommonUtil().getMyPrimaryColor()),
                                  fontWeight: FontWeight.bold))
                          : paidPlanContent(),
                      //status
                      ((widget.refNo ?? '').isNotEmpty)
                          ? Text('Order ID : ' + widget.refNo!,
                              style: TextStyle(
                                  fontSize: 16.0.sp,
                                  color: Color(CommonUtil().getMyPrimaryColor()),
                                  fontWeight: FontWeight.bold))
                          : SizedBox(),
                      SizedBox(height: 30.0.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                  side: BorderSide(color: Colors.white)),
                              backgroundColor:
                                  Color(CommonUtil().getMyPrimaryColor()),
                              foregroundColor: Colors.white,
                              padding: EdgeInsets.all(12.0),
                            ),
                            onPressed: () {
                              Provider.of<CheckoutPageProvider>(context,
                                      listen: false)
                                  .loader(false, isNeedRelod: true);
                              var firebase = FirebaseAnalyticsService();
                              firebase.trackEvent("on_payment_done", {
                                "user_id": PreferenceUtil.getStringValue(
                                    KEY_USERID_MAIN),
                                "status": status
                              });
                              if (status!) {
                                //widget.closePage(STR_SUCCESS);
                                SchedulerBinding.instance!
                                    .addPostFrameCallback((_) async {
                                  if (widget.isPaymentFromNotification) {
                                    Get.offAllNamed(
                                      router.rt_Landing,
                                      arguments: LandingArguments(
                                        needFreshLoad: false,
                                      ),
                                    );
                                  } else {
                                    Get.offAllNamed(router.rt_MyPlans);
                                  }
                                });
                              } else {
                                if (widget.isFreePlan) {
                                  Get.back();
                                } else {
                                  SchedulerBinding.instance!
                                      .addPostFrameCallback((_) async {
                                    if (widget.isPaymentFromNotification) {
                                      Get.offAll(NotificationMain());
                                    } else {
                                      Get.offAllNamed(
                                        router.rt_Landing,
                                        arguments: LandingArguments(
                                          needFreshLoad: false,
                                        ),
                                      );
                                    }
                                  });
                                }
                              }
                            },
                            child: Text(
                              STR_DONE.toUpperCase(),
                              style: TextStyle(
                                fontSize: 16.0.sp,
                              ),
                            ),
                          ),
                          SizedBox(width: 15.w),
                          getRetryButton(),
                        ],
                      ),
                      SizedBox(height: 20.0.h),
                      status!
                          ? Visibility(
                              visible: !(Provider.of<CheckoutPageProvider>(
                                      context,
                                      listen: false)
                                  .isMembershipCart),
                              child: ElevatedButton(
  style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                    side: BorderSide(color: Colors.white)),
                                backgroundColor:
                                    Color(CommonUtil().getMyPrimaryColor()),
                                foregroundColor: Colors.white,
                                padding: EdgeInsets.all(12.0),),
                                onPressed: () async {
                                  if (widget.isPaymentFromNotification) {
                                    Get.offAllNamed(
                                      router.rt_Landing,
                                      arguments: LandingArguments(
                                        needFreshLoad: false,
                                      ),
                                    );
                                  } else {
                                    Provider.of<CheckoutPageProvider>(context,
                                            listen: false)
                                        .loader(false, isNeedRelod: true);
                                    Provider.of<RegimentViewModel>(
                                      Get.context!,
                                      listen: false,
                                    ).regimentMode = RegimentMode.Schedule;
                                    Provider.of<RegimentViewModel>(
                                      Get.context!,
                                      listen: false,
                                    ).regimentFilter = RegimentFilter.Scheduled;
                                    SchedulerBinding.instance!
                                        .addPostFrameCallback((_) async {
                                      await Get.offAllNamed(router.rt_Regimen);
                                    });
                                  }
                                },
                                child: Text(
                                  STR_REGIMENT.toUpperCase(),
                                  style: TextStyle(
                                    fontSize: 16.0.sp,
                                  ),
                                ),
                              ),
                            )
                          : SizedBox.shrink(),
                      ((widget.isPaymentFails ?? false) &&
                              ((widget.cartUserId ?? '').isNotEmpty))
                          ? ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                    side: BorderSide(color: Colors.white)),
                                backgroundColor:
                                    Color(CommonUtil().getMyPrimaryColor()),
                                foregroundColor: Colors.white,
                                padding: EdgeInsets.all(12.0),
                              ),
                              onPressed: () {
                                if (widget.isPaymentFromNotification) {
                                  Get.offAllNamed(
                                    router.rt_Landing,
                                    arguments: LandingArguments(
                                      needFreshLoad: false,
                                    ),
                                  );
                                } else {
                                  Provider.of<CheckoutPageProvider>(context,
                                          listen: false)
                                      .loader(false, isNeedRelod: true);

                                  Get.offAll(CheckoutPage(
                                    //cartType: CartType.RETRY_CART,
                                    cartUserId: widget.cartUserId,
                                  ));
                                }
                              },
                              child: Text(
                                'Retry Payment'.toUpperCase(),
                                style: TextStyle(
                                  fontSize: 16.0.sp,
                                ),
                              ),
                            )
                          : SizedBox.shrink(),
                    ]),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget getRetryButton() {
    if (!status! && !widget.isFreePlan) {
      return ElevatedButton( style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
            side: BorderSide(color: Colors.white)),
        backgroundColor: Color(CommonUtil().getMyPrimaryColor()),
        foregroundColor: Colors.white,
        padding: EdgeInsets.all(12.0),),
        onPressed: () {
          Provider.of<CheckoutPageProvider>(context, listen: false)
              .loader(false, isNeedRelod: true);

          Navigator.pop(context);
          Navigator.pushReplacement(
            Get.context!,
            MaterialPageRoute(
              builder: (context) => PaymentGatwayPage(
                redirectUrl: widget.paymentRetryUrl,
                paymentId: widget.paymentId,
                isFromSubscribe: true,
                isFromRazor: widget.isFromRazor,
                isPaymentFromNotification: widget.isPaymentFromNotification,
                closePage: (value) {
                  if (value == 'success') {
                    Get.back();
                  } else {
                    Navigator.pop(context);
                  }
                },
              ),
            ),
          );
        },
        child: Text(
          STR_RETRY.toUpperCase(),
          style: TextStyle(
            fontSize: 16.0.sp,
          ),
        ),
      );
    } else {
      return SizedBox.shrink();
    }
  }
}
