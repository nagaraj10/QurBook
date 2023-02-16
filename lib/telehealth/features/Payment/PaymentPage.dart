
// Copyright 2018 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// ignore_for_file: public_member_api_docs

import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:gmiwidgetspackage/widgets/flutterToast.dart';
import 'package:myfhb/constants/fhb_constants.dart';
import 'package:myfhb/constants/fhb_parameters.dart';
import 'package:myfhb/plan_dashboard/model/UpdatePaymentStatusSubscribe.dart';
import 'package:myfhb/plan_dashboard/viewModel/subscribeViewModel.dart';
import 'package:myfhb/telehealth/features/MyProvider/model/updatePayment/UpdatePaymentModel.dart';
import 'package:myfhb/telehealth/features/MyProvider/viewModel/UpdatePaymentViewModel.dart';
import 'package:myfhb/telehealth/features/Payment/ResultPage.dart';
import 'package:myfhb/widgets/GradientAppBar.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:myfhb/src/utils/screenutils/size_extensions.dart';

class PaymentPage extends StatefulWidget {
  final String? redirectUrl;
  final String? paymentId;
  final String? appointmentId;
  Function(String)? closePage;
  bool isFromSubscribe;
  bool? isFromRazor;
  bool isPaymentFromNotification;

  PaymentPage(
      {Key? key,
      required this.redirectUrl,
      required this.paymentId,
     this.appointmentId,
      required this.isFromSubscribe,
      required this.isFromRazor,
      this.isPaymentFromNotification = false,
      this.closePage})
      : super(key: key);

  @override
  _WebViewExampleState createState() => _WebViewExampleState();
}

class _WebViewExampleState extends State<PaymentPage> {
  String? PAYMENT_URL;
  String? paymentId;
  String? appointmentId;
  late UpdatePaymentViewModel updatePaymentViewModel;
  bool isFromSubscribe = false;
  bool? isFromRazor = false;

  final Completer<WebViewController> _controller =
      Completer<WebViewController>();

  SubscribeViewModel subscribeViewModel = SubscribeViewModel();

  String paymentOrderIdSub = '';

  @override
  void initState() {
    mInitialTime = DateTime.now();
    updatePaymentViewModel = new UpdatePaymentViewModel();
    PAYMENT_URL = widget.redirectUrl;
    paymentId = widget.paymentId;
    appointmentId = widget.appointmentId;
    isFromSubscribe = widget.isFromSubscribe;
    isFromRazor = widget.isFromRazor;

    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
  }

  @override
  void dispose() {
    super.dispose();
    fbaLog(eveName: 'qurbook_screen_event', eveParams: {
      'eventTime': '${DateTime.now()}',
      'pageName': 'Payment Screen',
      'screenSessionTime':
          '${DateTime.now().difference(mInitialTime).inSeconds} secs'
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: AppBar(
          flexibleSpace: GradientAppBar(),
          leading: new IconButton(
            icon: new Icon(
              Icons.arrow_back_ios,
              size: 24.0.sp,
            ),
            onPressed: () {
              _onWillPop();
            },
          ),
          title: const Text(TITLE_BAR),
          actions: <Widget>[
            NavigationControls(_controller.future),
          ],
        ),
        body: isFromRazor!
            ? iosWebview()
            : Platform.isAndroid
                ? androidWebview()
                : iosWebview(),
      ),
    );
  }

  Widget androidWebview() {
    return SingleChildScrollView(
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height + 200,
        child: WebView(
          initialUrl: PAYMENT_URL,
          javascriptMode: JavascriptMode.unrestricted,
          onWebViewCreated: (WebViewController webViewController) {
            _controller.complete(webViewController);
          },
          // ignore: prefer_collection_literals
          javascriptChannels: <JavascriptChannel>[
            _toasterJavascriptChannel(context),
          ].toSet(),
          navigationDelegate: (NavigationRequest request) {
            String finalUrl = request.url.toString();
            if (finalUrl.contains(CHECK_URL)) {
              String? paymentOrderId = '';
              String? paymentRequestId = '';
              String? signature = '';
              String? paymentStatus = '';
              Uri uri = Uri.parse(finalUrl);

              if (isFromRazor!) {
                paymentStatus = uri.queryParameters[RAZOR_PAYMENT_STATUS];
                paymentOrderId = uri.queryParameters[RAZOR_PAYMENT_ID];
                paymentRequestId = uri.queryParameters[RAZOR_PAYMENT_REQ_ID];
                signature = uri.queryParameters[SIGNATURE];
              } else {
                paymentStatus = uri.queryParameters[PAYMENT_STATUS];
                paymentOrderId = uri.queryParameters[PAYMENT_ID];
                paymentRequestId = uri.queryParameters[PAYMENT_REQ_ID];
              }

              if (paymentStatus != null && paymentStatus == CREDIT ||
                  paymentStatus != null && paymentStatus == PAID) {
                if (isFromSubscribe) {
                  updatePaymentSubscribe(paymentId!, paymentOrderId!,
                          paymentRequestId!, isFromRazor!, signature!)
                      .then((value) {
                    if (value?.isSuccess == true &&
                        value?.result?.paymentStatus == PAYSUC) {
                      paymentOrderIdSub = value?.result?.paymentOrderId ?? '';
                      subscribeViewModel
                          .subScribePlan(
                              value.result!.planPackage!.packageid.toString())
                          .then((value) {
                        if (value!.isSuccess!) {
                          if (value.result?.result == 'Done') {
                            callResultPage(true, paymentOrderIdSub);
                          } else {
                            FlutterToast().getToast(
                                (value != null && value?.result?.message != null
                                    ? value?.result?.message!
                                    : 'Subscribe Failed')!,
                                Colors.red);
                            callResultPage(false, '');
                          }
                        } else {
                          FlutterToast().getToast(
                              (value != null && value?.result?.message != null
                                  ? value?.result?.message!
                                  : 'Subscribe Failed')!,
                              Colors.red);
                          callResultPage(false, '');
                        }
                      });
                    } else {
                      callResultPage(false, '');
                    }
                  });
                } else {
                  updatePayment(paymentId!, paymentOrderId!, paymentRequestId!,
                      isFromRazor!, signature!);
                }
              } else {
                if (isFromSubscribe) {
                  updatePaymentSubscribe(paymentId!, paymentOrderId!,
                          paymentRequestId!, isFromRazor!, signature!)
                      .then((value) {
                    if (value?.isSuccess == true) {
                      callResultPage(false, '');
                    } else {
                      callResultPage(false, '');
                    }
                  });
                } else {
                  updatePayment(paymentId!, paymentOrderId!, paymentRequestId!,
                      isFromRazor!, signature!);
                }
              }
            } else if (finalUrl.contains(STATUS_FAILED)) {
              callResultPage(false, '');
            }
            return NavigationDecision.navigate;
          },
          onPageStarted: (String url) {
            //print('Page started loading: $url');
          },
          onPageFinished: (String url) {
            //print('Page finished loading: $url');
          },
          gestureNavigationEnabled: true,
        ),
      ),
    );
  }

  Widget iosWebview() {
    return Builder(builder: (BuildContext context) {
      return WebView(
        initialUrl: PAYMENT_URL,
        javascriptMode: JavascriptMode.unrestricted,
        onWebViewCreated: (WebViewController webViewController) {
          _controller.complete(webViewController);
        },
        // ignore: prefer_collection_literals
        javascriptChannels: <JavascriptChannel>[
          _toasterJavascriptChannel(context),
        ].toSet(),
        navigationDelegate: (NavigationRequest request) {
          String finalUrl = request.url.toString();
          if (finalUrl.contains(CHECK_URL)) {
            String? paymentOrderId = '';
            String? paymentRequestId = '';
            String? signature = '';
            String? paymentStatus = '';
            Uri uri = Uri.parse(finalUrl);

            if (isFromRazor!) {
              paymentStatus = uri.queryParameters[RAZOR_PAYMENT_STATUS];
              paymentOrderId = uri.queryParameters[RAZOR_PAYMENT_ID];
              paymentRequestId = uri.queryParameters[RAZOR_PAYMENT_REQ_ID];
              signature = uri.queryParameters[SIGNATURE];
            } else {
              paymentStatus = uri.queryParameters[PAYMENT_STATUS];
              paymentOrderId = uri.queryParameters[PAYMENT_ID];
              paymentRequestId = uri.queryParameters[PAYMENT_REQ_ID];
            }
            if (paymentStatus != null && paymentStatus == CREDIT ||
                paymentStatus != null && paymentStatus == PAID) {
              if (isFromSubscribe) {
                updatePaymentSubscribe(paymentId!, paymentOrderId!,
                        paymentRequestId!, isFromRazor!, signature!)
                    .then((value) {
                  if (value?.isSuccess == true &&
                      value?.result?.paymentStatus == PAYSUC) {
                    paymentOrderIdSub = value?.result?.paymentOrderId ?? '';
                    subscribeViewModel
                        .subScribePlan(
                            value.result!.planPackage!.packageid.toString())
                        .then((value) {
                      if (value!.isSuccess!) {
                        if (value?.result?.result == 'Done') {
                          callResultPage(true, paymentOrderIdSub);
                        } else {
                          FlutterToast().getToast(
                              (value != null && value?.result?.message != null
                                  ? value?.result?.message!
                                  : 'Subscribe Failed')!,
                              Colors.red);
                          callResultPage(false, '');
                        }
                      } else {
                        FlutterToast().getToast(
                            (value != null && value?.result?.message != null
                                ? value?.result?.message!
                                : 'Subscribe Failed')!,
                            Colors.red);
                        callResultPage(false, '');
                      }
                    });
                  } else {
                    callResultPage(false, '');
                  }
                });
              } else {
                updatePayment(paymentId!, paymentOrderId!, paymentRequestId!,
                    isFromRazor!, signature!);
              }
            } else {
              if (isFromSubscribe) {
                updatePaymentSubscribe(paymentId!, paymentOrderId!,
                        paymentRequestId!, isFromRazor!, signature!)
                    .then((value) {
                  if (value?.isSuccess == true) {
                    callResultPage(false, '');
                  } else {
                    callResultPage(false, '');
                  }
                });
              } else {
                updatePayment(paymentId!, paymentOrderId!, paymentRequestId!,
                    isFromRazor!, signature!);
              }
            }
          } else if (finalUrl.contains(STATUS_FAILED)) {
            callResultPage(false, '');
          }
          return NavigationDecision.navigate;
        },
        onPageStarted: (String url) {
          //print('Page started loading: $url');
        },
        onPageFinished: (String url) {
          //print('Page finished loading: $url');
        },
        gestureNavigationEnabled: true,
      );
    });
  }

  Future<bool> _onWillPop() {
    return showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(STR_ARE_SURE),
            content: Text(STR_SURE_CANCEL_PAY),
            actions: <Widget>[
              FlatButton(
                onPressed: () => Navigator.pop(context),
                child: Text('No'),
              ),
              FlatButton(
                onPressed: () {
                  if (!isFromSubscribe) {
                    widget.closePage!(STR_FAILED);
                    Navigator.pop(context);
                    Navigator.pop(context);
                  } else {
                    Navigator.pop(context);
                    Navigator.pop(context);
                  }
                },
                child: Text('Yes'),
              ),
            ],
          ),
        ).then((value) => value as bool) ??
        false as Future<bool>;
  }

  void callResultPage(bool status, String? refNo) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ResultPage(
                  status: status,
                  refNo: refNo,
                  isFromSubscribe: isFromSubscribe,
                  closePage: (value) {
                    if (widget.isPaymentFromNotification == false) {
                      widget.closePage!(value);
                      Navigator.pop(context);
                    }
                  },
                  isFromRazor: isFromRazor,
                  paymentRetryUrl: PAYMENT_URL,
                  paymentId: paymentId,
                  appointmentId: appointmentId,
                  isPaymentFromNotification: widget.isPaymentFromNotification,
                )));
  }

  JavascriptChannel _toasterJavascriptChannel(BuildContext context) {
    return JavascriptChannel(
        name: 'Toaster',
        onMessageReceived: (JavascriptMessage message) {
          Scaffold.of(context).showSnackBar(
            SnackBar(content: Text(message.message)),
          );
        });
  }

  updatePayment(String paymentId, String paymentOrderId,
      String paymentRequestId, bool isFromRazor, String signature) {
    updatePaymentStatus(
            paymentId, paymentOrderId, paymentRequestId, isFromRazor, signature)
        .then((value) {
      if (value.isSuccess == true &&
          value.result!.paymentStatus!.code == PAYSUC) {
        callResultPage(true, value.result!.paymentOrderId);
      } else {
        callResultPage(false, '');
      }
    });
  }

  Future<UpdatePaymentModel> updatePaymentStatus(
      String paymentId,
      String paymentOrderId,
      String paymentRequestId,
      bool isFromRazor,
      String signature) async {
    UpdatePaymentModel? updatePaymentModel =
        await updatePaymentViewModel.updatePaymentStatus(paymentId,
            paymentOrderId, paymentRequestId, isFromRazor, signature);

    return updatePaymentModel!;
  }

  Future<UpdatePaymentStatusSubscribe> updatePaymentSubscribe(
      String paymentId,
      String paymentOrderId,
      String paymentRequestId,
      bool isFromRazor,
      String signature) async {
    UpdatePaymentStatusSubscribe? updatePaymentModel =
        await updatePaymentViewModel.updatePaymentSubscribe(paymentId,
            paymentOrderId, paymentRequestId, isFromRazor, signature);

    return updatePaymentModel!;
  }
}

class NavigationControls extends StatelessWidget {
  const NavigationControls(this._webViewControllerFuture)
      : assert(_webViewControllerFuture != null);

  final Future<WebViewController> _webViewControllerFuture;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<WebViewController>(
      future: _webViewControllerFuture,
      builder:
          (BuildContext context, AsyncSnapshot<WebViewController> snapshot) {
        final bool webViewReady =
            snapshot.connectionState == ConnectionState.done;
        final WebViewController? controller = snapshot.data;
        return Row(
          children: <Widget>[],
        );
      },
    );
  }
}
