import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gmiwidgetspackage/widgets/SizeBoxWithChild.dart';
import 'package:gmiwidgetspackage/widgets/flutterToast.dart';
import 'package:gmiwidgetspackage/widgets/sized_box.dart';
import 'package:gmiwidgetspackage/widgets/text_widget.dart';
import 'package:myfhb/common/CommonUtil.dart';
import 'package:myfhb/common/PreferenceUtil.dart';
import 'package:myfhb/constants/fhb_parameters.dart';
import 'package:myfhb/plan_dashboard/model/CreateSubscribeModel.dart';
import 'package:myfhb/src/resources/network/ApiBaseHelper.dart';
import 'package:myfhb/src/utils/screenutils/size_extensions.dart';
import 'package:myfhb/constants/variable_constant.dart' as variable;
import 'package:myfhb/constants/fhb_constants.dart' as Constants;
import 'package:myfhb/telehealth/features/Payment/PaymentPage.dart';
import 'package:myfhb/widgets/payment_gatway.dart';
import 'package:myfhb/widgets/result_page_new.dart';

class CheckoutPageWidgets {
  final GlobalKey<State> _keyLoader = new GlobalKey<State>();
  Future<dynamic> showPaymentConfirmationDialog(
      {dynamic body, dynamic totalCartAmount, Function(String) closePage}) {
    return showDialog(
        context: Get.context,
        builder: (context) {
          return AlertDialog(
            insetPadding: EdgeInsets.symmetric(horizontal: 8),
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
                          borderRadius: BorderRadius.circular(4.0),
                        ),
                        child: Container(
                          height: 160,
                          padding: EdgeInsets.all(8.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              Center(
                                child: TextWidget(
                                    text: redirectedToPaymentMessage,
                                    fontsize: 16.0.sp,
                                    fontWeight: FontWeight.w500,
                                    colors: Colors.grey[600]),
                              ),
                              SizedBoxWidget(
                                height: 10,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: <Widget>[
                                  SizedBoxWithChild(
                                    width: 90,
                                    height: 40,
                                    child: FlatButton(
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(12.0),
                                          side: BorderSide(
                                              color: Color(new CommonUtil()
                                                  .getMyPrimaryColor()))),
                                      color: Colors.transparent,
                                      textColor: Color(
                                          new CommonUtil().getMyPrimaryColor()),
                                      padding: EdgeInsets.all(8.0),
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: TextWidget(
                                        text: 'Cancel',
                                        fontsize: 14.0.sp,
                                      ),
                                    ),
                                  ),
                                  SizedBoxWithChild(
                                    width: 90,
                                    height: 40,
                                    child: FlatButton(
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(12.0),
                                          side: BorderSide(
                                              color: Color(new CommonUtil()
                                                  .getMyPrimaryColor()))),
                                      color: Colors.transparent,
                                      textColor: Color(
                                          new CommonUtil().getMyPrimaryColor()),
                                      padding: EdgeInsets.all(8.0),
                                      onPressed: () {
                                        Navigator.pop(context);
                                        CommonUtil.showLoadingDialog(context,
                                            _keyLoader, variable.Please_Wait);
                                        String userId =
                                            PreferenceUtil.getStringValue(
                                                Constants.KEY_USERID);

                                        ApiBaseHelper()
                                            .makePayment(body)
                                            .then((value) {
                                          if (value != null) {
                                            if (value?.isSuccess) {
                                              if (value?.result != null) {
                                                if (value?.result?.payment !=
                                                    null) {
                                                  if (value
                                                          ?.result
                                                          ?.payment
                                                          ?.paymentStatus
                                                          ?.code ==
                                                      'PAYITA') {
                                                    if (value?.result
                                                            ?.paymentGatewayDetail !=
                                                        null) {
                                                      if (value
                                                              ?.result
                                                              ?.paymentGatewayDetail
                                                              ?.responseInfo !=
                                                          null) {
                                                        if (value
                                                                    ?.result
                                                                    ?.paymentGatewayDetail
                                                                    ?.responseInfo
                                                                    ?.longurl !=
                                                                null &&
                                                            value
                                                                    ?.result
                                                                    ?.paymentGatewayDetail
                                                                    ?.responseInfo
                                                                    ?.longurl !=
                                                                '') {
                                                          Navigator
                                                              .pushReplacement(
                                                            Get.context,
                                                            MaterialPageRoute(
                                                              builder: (context) =>
                                                                  PaymentGatwayPage(
                                                                redirectUrl: value
                                                                    ?.result
                                                                    ?.paymentGatewayDetail
                                                                    ?.responseInfo
                                                                    ?.longurl,
                                                                paymentId: value
                                                                    ?.result
                                                                    ?.payment
                                                                    ?.id
                                                                    ?.toString(),
                                                                isFromSubscribe:
                                                                    true,
                                                                closePage:
                                                                    (value) {
                                                                  if (value ==
                                                                      'success') {
                                                                    Get.back();
                                                                  } else {
                                                                    Navigator.pop(
                                                                        context);
                                                                  }
                                                                },
                                                              ),
                                                            ),
                                                          );
                                                        }
                                                      } else {
                                                        Navigator.of(
                                                                _keyLoader
                                                                    .currentContext,
                                                                rootNavigator:
                                                                    true)
                                                            .pop();
                                                        FlutterToast()
                                                          ..getToast(
                                                              'Subscribe Failed',
                                                              Colors.red);
                                                      }
                                                    }
                                                  } else {
                                                    Navigator.of(
                                                            _keyLoader
                                                                .currentContext,
                                                            rootNavigator: true)
                                                        .pop();
                                                    FlutterToast()
                                                      ..getToast(
                                                          'Subscribe Failed',
                                                          Colors.red);
                                                  }
                                                } else {
                                                  Navigator.of(
                                                          _keyLoader
                                                              .currentContext,
                                                          rootNavigator: true)
                                                      .pop();
                                                  FlutterToast()
                                                    ..getToast(
                                                        'Subscribe Failed',
                                                        Colors.red);
                                                }
                                              }
                                            } else {
                                              Navigator.of(
                                                      _keyLoader.currentContext,
                                                      rootNavigator: true)
                                                  .pop();
                                              FlutterToast()
                                                ..getToast('Subscribe Failed',
                                                    Colors.red);
                                            }
                                          }
                                        });
                                      },
                                      child: TextWidget(
                                        text: ok,
                                        fontsize: 14.0.sp,
                                      ),
                                    ),
                                  ),
                                ],
                              )
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
}
