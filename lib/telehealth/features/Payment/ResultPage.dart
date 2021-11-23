import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gmiwidgetspackage/widgets/flutterToast.dart';
import 'package:myfhb/constants/fhb_constants.dart';
import 'package:myfhb/constants/fhb_parameters.dart';
import 'package:myfhb/regiment/view_model/regiment_view_model.dart';
import 'package:myfhb/src/model/home_screen_arguments.dart';
import 'package:myfhb/telehealth/features/MyProvider/model/updatePayment/PaymentFailureRetryModel.dart';
import 'package:myfhb/telehealth/features/MyProvider/view/TelehealthProviders.dart';
import 'package:myfhb/common/CommonUtil.dart';
import 'package:myfhb/src/utils/screenutils/size_extensions.dart';
import 'package:myfhb/telehealth/features/MyProvider/viewModel/UpdatePaymentViewModel.dart';
import 'package:provider/provider.dart';
import 'package:myfhb/constants/router_variable.dart' as router;

import 'PaymentPage.dart';

class ResultPage extends StatefulWidget {
  final bool status;
  final bool isFromSubscribe;
  final String refNo;
  Function(String) closePage;
  final String paymentRetryUrl;
  final String paymentId;
  final String appointmentId;
  final bool isFromRazor;

  ResultPage({Key key,
    @required this.status,
    this.refNo,
    this.closePage,
    this.isFromSubscribe,
    this.paymentRetryUrl,
    this.paymentId,
    this.appointmentId,
    this.isFromRazor})
      : super(key: key);

  @override
  _ResultPage createState() => _ResultPage();
}

class _ResultPage extends State<ResultPage> {
  bool status;
  bool isFromSubscribe;

  bool isShowRetry = false;

  UpdatePaymentViewModel updatePaymentViewModel;

  @override
  void initState() {
    mInitialTime = DateTime.now();
    updatePaymentViewModel = new UpdatePaymentViewModel();
    status = widget.status;
    isFromSubscribe = widget.isFromSubscribe;

    if (!status) {
      if (widget.appointmentId != null && widget.appointmentId != '') {
        checkSlotsRetry(widget.appointmentId).then((value) {
          if (value != null) {
            if (value?.isSuccess) {
              callRefreshButtonState(true);
            } else {
              callRefreshButtonState(false);
            }
          } else {
            callRefreshButtonState(false);
          }
        });
      } else {
        goToSlotPage();
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
  void dispose() {
    super.dispose();
    fbaLog(eveName: 'qurbook_screen_event', eveParams: {
      'eventTime': '${DateTime.now()}',
      'pageName': 'Payment Done Screen',
      'screenSessionTime':
      '${DateTime
          .now()
          .difference(mInitialTime)
          .inSeconds} secs'
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: Container(
        color: Color(new CommonUtil().getMyPrimaryColor()),
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
                        color: status ? Colors.white : Colors.red),
                    SizedBox(height: 15.0.h),
                    Text(status ? PAYMENT_SUCCESS_MSG : PAYMENT_FAILURE_MSG,
                        style: TextStyle(
                            fontSize: 22.0.sp,
                            color: Colors.white,
                            fontWeight: FontWeight.bold)),
                    SizedBox(height: 10.0.h),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Text(
                        isFromSubscribe
                            ? PLAN_CONFIRM
                            : status
                            ? APPOINTMENT_CONFIRM
                            : PAYMENT_FAILURE_CONTENT,
                        style: TextStyle(
                            fontSize: 12.0.sp,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    status
                        ? Text(
                        widget.refNo != null
                            ? 'Ref.no: ' + widget.refNo
                            : '',
                        style: TextStyle(
                            fontSize: 16.0.sp,
                            color: Colors.white,
                            fontWeight: FontWeight.bold))
                        : SizedBox(),
                    SizedBox(height: 30.0.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        FlatButton(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                              side: BorderSide(color: Colors.white)),
                          color: Color(new CommonUtil().getMyPrimaryColor()),
                          textColor: Colors.white,
                          padding: EdgeInsets.all(12.0),
                          onPressed: () {
                            status
                                ? widget.closePage(STR_SUCCESS)
                                : widget.closePage(STR_FAILED);
                            status && !isFromSubscribe
                                ? Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        TelehealthProviders(
                                          arguments: HomeScreenArguments(
                                              selectedIndex: 0),
                                        )))
                                : Navigator.pop(context);
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
      return FlatButton(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
            side: BorderSide(color: Colors.white)),
        color: Color(new CommonUtil().getMyPrimaryColor()),
        textColor: Colors.white,
        padding: EdgeInsets.all(12.0),
        onPressed: () {
          if (widget.appointmentId != null && widget.appointmentId != '') {
            checkSlotsRetry(widget.appointmentId).then((value) {
              if (value != null) {
                if (value?.isSuccess) {
                  goToPaymentPage();
                } else {
                  goToSlotPage();
                }
              }
            });
          } else {
            goToSlotPage();
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
      Get.context,
      MaterialPageRoute(
        builder: (context) =>
            PaymentPage(
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
    widget.closePage(STR_FAILED);
  }

  Future<PaymentFailureRetryModel> checkSlotsRetry(String appointmentId) async {
    PaymentFailureRetryModel paymentRetry =
    await updatePaymentViewModel.checkSlotsRetry(appointmentId);

    return paymentRetry;
  }
}
