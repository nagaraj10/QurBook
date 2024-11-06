import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../constants/fhb_constants.dart';
import '../constants/fhb_parameters.dart';
import '../plan_dashboard/viewModel/subscribeViewModel.dart';
import '../src/resources/network/ApiBaseHelper.dart';
import '../src/utils/screenutils/size_extensions.dart';
import '../telehealth/features/MyProvider/viewModel/UpdatePaymentViewModel.dart';
import 'GradientAppBar.dart';
import 'checkout_page_provider.dart';
import 'result_page_new.dart';
import 'update_payment_response.dart';

class PaymentGatwayPage extends StatefulWidget {
  final String? redirectUrl;
  final String? paymentId;
  Function(String)? closePage;
  bool isFromSubscribe;
  bool? isFromRazor;
  bool isPaymentFromNotification;
  final String? cartId;

  PaymentGatwayPage(
      {Key? key,
      required this.redirectUrl,
      required this.paymentId,
      required this.isFromSubscribe,
      required this.isFromRazor,
      this.isPaymentFromNotification = false,
      this.cartId,
      this.closePage})
      : super(key: key);

  @override
  _WebViewExampleState createState() => _WebViewExampleState();
}

class _WebViewExampleState extends State<PaymentGatwayPage> {
  String? PAYMENT_URL;
  UpdatePaymentViewModel? updatePaymentViewModel;
  bool isFromSubscribe = false;
  bool? isFromRazor = false;

  final Completer<WebViewController> _controller =
      Completer<WebViewController>();

  SubscribeViewModel subscribeViewModel = SubscribeViewModel();

  String paymentOrderIdSub = '';

  @override
  void initState() {
    super.initState();
    updatePaymentViewModel = UpdatePaymentViewModel();
    PAYMENT_URL = widget.redirectUrl;
    isFromSubscribe = widget.isFromSubscribe;
    isFromRazor = widget.isFromRazor;

    if (Platform.isAndroid) {
      WebView.platform = SurfaceAndroidWebView();
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
          appBar: AppBar(
            flexibleSpace: GradientAppBar(),
            leading: IconButton(
              icon: Icon(
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
                  : iosWebview()),
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
                updatePaymentSubscribe(widget.paymentId, paymentOrderId,
                        paymentRequestId, isFromRazor!, signature)
                    .then((value) {
                  if ((value.isSuccess == true &&
                          value.result?.paymentStatus == PAYCREDIT) ||
                      (value.isSuccess == true &&
                          value.result?.paymentStatus == PAYCAPTURED)) {
                    paymentOrderIdSub = value.result?.paymentOrderId ?? '';
                    gotoPaymentResultPage(true, paymentOrderIdSub);
                  } else {
                    gotoPaymentResultPage(
                      false,
                      value.result?.paymentOrderId ?? '',
                      cartUserId: value.result?.cartUserId,
                      isPaymentFails: true,
                    );
                  }
                });
              } else {
                updatePaymentSubscribe(widget.paymentId, paymentOrderId,
                        paymentRequestId, isFromRazor!, signature)
                    .then((value) {
                  gotoPaymentResultPage(
                    false,
                    value.result?.paymentOrderId ?? '',
                    cartUserId: value.result?.cartUserId,
                    isPaymentFails: true,
                  );
                });
              }
            } else if (finalUrl.contains(STATUS_FAILED)) {
              gotoPaymentResultPage(
                false,
                '',
                cartUserId: '',
                isPaymentFails: true,
              );
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
              updatePaymentSubscribe(widget.paymentId, paymentOrderId,
                      paymentRequestId, isFromRazor!, signature)
                  .then((value) {
                if ((value.isSuccess == true &&
                        value.result?.paymentStatus == PAYCREDIT) ||
                    (value.isSuccess == true &&
                        value.result?.paymentStatus == PAYCAPTURED)) {
                  paymentOrderIdSub = value.result?.paymentOrderId ?? '';
                  gotoPaymentResultPage(true, paymentOrderIdSub);
                } else {
                  gotoPaymentResultPage(
                    false,
                    value.result?.paymentOrderId ?? '',
                    cartUserId: value.result?.cartUserId,
                    isPaymentFails: true,
                  );
                }
              });
            } else {
              updatePaymentSubscribe(widget.paymentId, paymentOrderId,
                      paymentRequestId, isFromRazor!, signature)
                  .then((value) {
                gotoPaymentResultPage(
                  false,
                  value.result?.paymentOrderId ?? '',
                  cartUserId: value.result?.cartUserId,
                  isPaymentFails: true,
                );
              });
            }
          } else if (finalUrl.contains(STATUS_FAILED)) {
            gotoPaymentResultPage(
              false,
              '',
              cartUserId: '',
              isPaymentFails: true,
            );
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
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('No'),
          ),
          TextButton(
            onPressed: () {
              Provider.of<CheckoutPageProvider>(context, listen: false)
                  .loader(false, isNeedRelod: true);
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
    ).then((value) => value ?? Future.value(false));
  }

  void gotoPaymentResultPage(bool status, String refNo,
      {bool? isPaymentFails, final String? cartUserId}) {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PaymentResultPage(
            status: status,
            refNo: refNo,
            isFromSubscribe: isFromSubscribe,
            closePage: (value) {
              widget.closePage!(value);
              Navigator.pop(context);
            },
            cartId: widget.cartId,
            cartUserId: cartUserId,
            isPaymentFails: isPaymentFails,
            paymentRetryUrl: PAYMENT_URL,
            paymentId: widget.paymentId,
            isFromRazor: isFromRazor,
            isPaymentFromNotification: widget.isPaymentFromNotification,
          ),
        ));
  }

  JavascriptChannel _toasterJavascriptChannel(BuildContext context) {
    return JavascriptChannel(
        name: 'Toaster',
        onMessageReceived: (JavascriptMessage message) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(message.message)),
          );
        });
  }

  Future<UpdatePaymentResponse> updatePaymentSubscribe(
      String? paymentId,
      String? paymentOrderId,
      String? paymentRequestId,
      bool isFromRazor,
      String? signature) async {
    var body;
    if (isFromRazor) {
      body = {
        "paymentId": "${paymentId}",
        "paymentOrderId": "${paymentOrderId}",
        "paymentRequestId": "${paymentRequestId}",
        "signature": "${signature}"
      };
    } else {
      body = {
        "paymentId": "${paymentId}",
        "paymentOrderId": "${paymentOrderId}",
        "paymentRequestId": "${paymentRequestId}"
      };
    }

    final updatePaymentResponse =
        await ApiBaseHelper().updatePaymentStatus(body);

    return updatePaymentResponse!;
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
