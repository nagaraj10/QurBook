// Copyright 2018 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// ignore_for_file: public_member_api_docs

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:myfhb/constants/fhb_constants.dart';
import 'package:myfhb/constants/fhb_parameters.dart';
import 'package:myfhb/telehealth/features/MyProvider/model/updatePayment/UpdatePaymentModel.dart';
import 'package:myfhb/telehealth/features/MyProvider/viewModel/UpdatePaymentViewModel.dart';
import 'package:myfhb/telehealth/features/Payment/ResultPage.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PaymentPage extends StatefulWidget {
  final String redirectUrl;
  final String paymentId;
  Function(String) closePage;

  PaymentPage(
      {Key key,
      @required this.redirectUrl,
      @required this.paymentId,
      this.closePage})
      : super(key: key);

  @override
  _WebViewExampleState createState() => _WebViewExampleState();
}

class _WebViewExampleState extends State<PaymentPage> {
  String PAYMENT_URL;
  String paymentId;
  UpdatePaymentViewModel updatePaymentViewModel;

  final Completer<WebViewController> _controller =
      Completer<WebViewController>();

  @override
  void initState() {
    updatePaymentViewModel = new UpdatePaymentViewModel();
    PAYMENT_URL = widget.redirectUrl;
    paymentId = widget.paymentId;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: AppBar(
          leading: new IconButton(
            icon: new Icon(Icons.arrow_back_ios),
            onPressed: () {
              _onWillPop();
            },
          ),
          title: const Text(TITLE_BAR),
          actions: <Widget>[
            NavigationControls(_controller.future),
          ],
        ),

        body: Builder(builder: (BuildContext context) {
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
                String paymentOrderId='';
                String paymentRequestId='';
                Uri uri = Uri.parse(finalUrl);
                String paymentStatus = uri.queryParameters[PAYMENT_STATUS];
                paymentOrderId = uri.queryParameters[PAYMENT_ID];
                paymentRequestId = uri.queryParameters[PAYMENT_REQ_ID];
                if (paymentStatus != null && paymentStatus == CREDIT) {
                  updatePayment(paymentId, paymentOrderId, paymentRequestId);
                } else {
                  updatePayment(paymentId, paymentOrderId, paymentRequestId);
                }
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
        }),
      ),
    );
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
              widget.closePage(STR_FAILED);
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: Text('Yes'),
          ),
        ],
      ),
    ) ??
        false;
  }

  void callResultPage(bool status, String refNo) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ResultPage(
                  status: status,
                  refNo: refNo,
                  closePage: (value) {
                    widget.closePage(value);
                    Navigator.pop(context);
                  },
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

  updatePayment(
      String paymentId, String paymentOrderId, String paymentRequestId) {
    updatePaymentStatus(paymentId, paymentOrderId, paymentRequestId)
        .then((value) {
      if (value.isSuccess == true &&
          value.result.paymentStatus.code == PAYSUC) {
        callResultPage(true, value.result.paymentOrderId);
      } else {
        callResultPage(false, '');
      }
    });
  }

  Future<UpdatePaymentModel> updatePaymentStatus(
      String paymentId, String paymentOrderId, String paymentRequestId) async {
    UpdatePaymentModel updatePaymentModel = await updatePaymentViewModel
        .updatePaymentStatus(paymentId, paymentOrderId, paymentRequestId);

    return updatePaymentModel;
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
        final WebViewController controller = snapshot.data;
        return Row(
          children: <Widget>[],
        );
      },
    );
  }
}
