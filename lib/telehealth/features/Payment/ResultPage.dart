import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gmiwidgetspackage/widgets/flutterToast.dart';

import '../../../../landing/view/landing_arguments.dart';
import '../../../common/CommonUtil.dart';
import '../../../constants/fhb_constants.dart';
import '../../../constants/fhb_parameters.dart';
import '../../../constants/router_variable.dart' as router;
import '../../../main.dart';
import '../../../src/model/home_screen_arguments.dart';
import '../../../src/utils/screenutils/size_extensions.dart';
import '../MyProvider/model/updatePayment/PaymentFailureRetryModel.dart';
import '../MyProvider/view/TelehealthProviders.dart';
import '../MyProvider/viewModel/UpdatePaymentViewModel.dart';
import 'PaymentPage.dart';

class ResultPage extends StatefulWidget {
  final bool status;
  final bool? isFromSubscribe;
  final String? refNo;
  Function(String)? closePage;
  final String? paymentRetryUrl;
  final String? paymentId;
  final String? appointmentId;
  final bool? isFromRazor;
  final bool isPaymentFromNotification;

  ResultPage(
      {Key? key,
      required this.status,
      this.refNo,
      this.closePage,
      this.isFromSubscribe,
      this.paymentRetryUrl,
      this.paymentId,
      this.appointmentId,
      this.isFromRazor,
      this.isPaymentFromNotification = false})
      : super(key: key);

  @override
  _ResultPage createState() => _ResultPage();
}

class _ResultPage extends State<ResultPage> {
  late bool status;
  bool? isFromSubscribe;

  bool isShowRetry = false;

  late UpdatePaymentViewModel updatePaymentViewModel;

  @override
  void initState() {
    updatePaymentViewModel = UpdatePaymentViewModel();
    status = widget.status;
    isFromSubscribe = widget.isFromSubscribe;

    if (!status) {
      if (widget.appointmentId != null && widget.appointmentId != '') {
        checkSlotsRetry(widget.appointmentId!).then((value) {
          if (value != null) {
            if (value.isSuccess!) {
              callRefreshButtonState(true);
            } else {
              callRefreshButtonState(false);
            }
          } else {
            callRefreshButtonState(false);
          }
        });
      } else {
        if (widget.isPaymentFromNotification) {
          FlutterToast().getToast(slotsAreNotAvailable, Colors.red);
        } else {
          goToSlotPage();
        }
      }
    }

    super.initState();
  }

  callRefreshButtonState(bool condition) {
    setState(() {
      isShowRetry = condition;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Center(
          child: Container(
            child: SingleChildScrollView(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Image.asset(
                        status ? PAYMENT_SUCCESS_PNG : PAYMENT_FAILURE_PNG,
                        width: 120.0.h,
                        height: 120.0.h,
                        color: status
                            ? mAppThemeProvider.primaryColor
                            : Colors.red),
                    SizedBox(height: 15.0.h),
                    Text(status ? PAYMENT_SUCCESS_MSG : PAYMENT_FAILURE_MSG,
                        style: TextStyle(
                            fontSize: 22.0.sp,
                            color: mAppThemeProvider.primaryColor,
                            fontWeight: FontWeight.bold)),
                    SizedBox(height: 10.0.h),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Text(
                        isFromSubscribe!
                            ? PLAN_CONFIRM
                            : status
                                ? APPOINTMENT_CONFIRM
                                : PAYMENT_FAILURE_CONTENT,
                        style: TextStyle(
                            fontSize: 12.0.sp,
                            color: mAppThemeProvider.primaryColor,
                            fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    status
                        ? Text(
                            widget.refNo != null
                                ? 'Ref.no: ' + widget.refNo!
                                : '',
                            style: TextStyle(
                                fontSize: 16.0.sp,
                                color: mAppThemeProvider.primaryColor,
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
                                mAppThemeProvider.primaryColor,
                            foregroundColor: Colors.white,
                            padding: EdgeInsets.all(12.0),
                          ),
                          onPressed: () {
                            status
                                ? widget.closePage!(STR_SUCCESS)
                                : widget.closePage!(STR_FAILED);
                            if (widget.isPaymentFromNotification) {
                              status && !isFromSubscribe!
                                  ? Get.offAllNamed(
                                      router.rt_Landing,
                                      arguments: LandingArguments(
                                        needFreshLoad: false,
                                      ),
                                    )
                                  : Get.offNamed(router.rt_notification_main);
                            } else {
                              status && !isFromSubscribe!
                                  ? Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              TelehealthProviders(
                                                arguments: HomeScreenArguments(
                                                    selectedIndex: 0),
                                              )))
                                  : Navigator.pop(context);
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
                        isShowRetry ? getRetryButton() : SizedBox.shrink(),
                      ],
                    ),
                  ]),
            ),
          ),
        ),
      ),
    );
  }

  Widget getRetryButton() {
    if (!status) {
      return ElevatedButton(
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
              side: BorderSide(color: Colors.white)),
          backgroundColor: mAppThemeProvider.primaryColor,
          foregroundColor: Colors.white,
          padding: EdgeInsets.all(12.0),
        ),
        onPressed: () {
          if (widget.appointmentId != null && widget.appointmentId != '') {
            checkSlotsRetry(widget.appointmentId!).then((value) {
              if (value != null) {
                if (value.isSuccess!) {
                  goToPaymentPage();
                } else {
                  if (widget.isPaymentFromNotification) {
                    FlutterToast().getToast(slotsAreNotAvailable, Colors.red);
                  } else {
                    goToSlotPage();
                  }
                }
              }
            });
          } else {
            if (widget.isPaymentFromNotification) {
              FlutterToast().getToast(slotsAreNotAvailable, Colors.red);
            } else {
              goToSlotPage();
            }
          }
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

  goToPaymentPage() {
    Navigator.pop(context);
    Navigator.pushReplacement(
      Get.context!,
      MaterialPageRoute(
        builder: (context) => PaymentPage(
          redirectUrl: widget.paymentRetryUrl,
          paymentId: widget.paymentId,
          appointmentId: widget.appointmentId,
          isFromSubscribe: false,
          isFromRazor: widget.isFromRazor,
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
  }

  goToSlotPage() {
    Navigator.pop(context);
    widget.closePage!(STR_FAILED);
  }

  Future<PaymentFailureRetryModel> checkSlotsRetry(String appointmentId) async {
    PaymentFailureRetryModel? paymentRetry =
        await updatePaymentViewModel.checkSlotsRetry(appointmentId);

    return paymentRetry!;
  }
}
