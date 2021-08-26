// Copyright 2018 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// ignore_for_file: public_member_api_docs

import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:gmiwidgetspackage/widgets/flutterToast.dart';
import 'package:myfhb/common/PreferenceUtil.dart';
import 'package:myfhb/constants/fhb_constants.dart';
import 'package:myfhb/constants/fhb_constants.dart' as Constants;
import 'package:myfhb/constants/fhb_parameters.dart';
import 'package:myfhb/plan_dashboard/model/UpdatePaymentStatusSubscribe.dart';
import 'package:myfhb/plan_dashboard/viewModel/subscribeViewModel.dart';
import 'package:myfhb/src/utils/screenutils/size_extensions.dart';
import 'package:myfhb/telehealth/features/MyProvider/model/updatePayment/UpdatePaymentModel.dart';
import 'package:myfhb/telehealth/features/MyProvider/viewModel/UpdatePaymentViewModel.dart';
import 'package:myfhb/telehealth/features/Payment/ResultPage.dart';
import 'package:myfhb/widgets/GradientAppBar.dart';
import 'package:webview_flutter/webview_flutter.dart';

class ReportWebView extends StatefulWidget {
  final String embededUrl;
  final String reportId;
  final String id;

  ReportWebView({Key key, @required this.embededUrl, @required this.reportId,@required this.id})
      : super(key: key);

  @override
  _ReportWebView createState() => _ReportWebView();
}

class _ReportWebView extends State<ReportWebView> {
  String embededUrl;
  String reportId;
  String authToken;
  String id;

  final Completer<WebViewController> _controller =
  Completer<WebViewController>();

  @override
  void initState() {
    mInitialTime = DateTime.now();
    embededUrl = widget.embededUrl;
    reportId = widget.reportId;
    id = widget.id;

    authToken = PreferenceUtil.getStringValue(Constants.KEY_AUTHTOKEN);
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
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: GradientAppBar(),
        title: const Text(REPORT_PAGE),
      ),
      body: Platform.isAndroid ? androidWebview() : iosWebview(),
    );
  }

  Widget androidWebview() {
    return SingleChildScrollView(
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height + 200,
        child: InAppWebView(
          initialUrlRequest: URLRequest(
              url: Uri.parse(
                  'https://portal.dev-efhb.vsolgmi.com/assets/powerbi-mobile.html'),
              /*method: 'GET',
              //body: Uint8List.fromList(utf8.encode("authToken=$authToken&reportId=$reportId&embedUrl=$embededUrl")),
              headers: {'Content-Type': 'application/x-www-form-urlencoded','authToken':authToken,'reportId':reportId,'embedUrl':embededUrl}*/),
          onWebViewCreated: (controller) {
            //controller.evaluateJavascript(source: 'onHTMLLoad($reportId,$embededUrl,$authToken)');
            //controller.evaluateJavascript(source: 'onHTMLLoad()');
          },
          onLoadStop: (InAppWebViewController controller, Uri url) {
            controller.evaluateJavascript(source: 'onHTMLLoad("$id",$reportId","$embededUrl","$authToken")');
          },
          shouldOverrideUrlLoading: (controller, shouldOverrideUrlLoadingRequest) async {
            if (Platform.isAndroid || shouldOverrideUrlLoadingRequest.iosWKNavigationType == IOSWKNavigationType.LINK_ACTIVATED) {
              controller.loadUrl(urlRequest: shouldOverrideUrlLoadingRequest.request);
              return NavigationActionPolicy.CANCEL;
            }
            return NavigationActionPolicy.ALLOW;
          },
        ),
      ),
    );
  }

  Widget iosWebview() {
    return Builder(builder: (BuildContext context) {
      return InAppWebView(
        initialUrlRequest: URLRequest(
          url: Uri.parse(
              'https://portal.dev-efhb.vsolgmi.com/assets/powerbi-mobile.html'),
          /*method: 'GET',
              //body: Uint8List.fromList(utf8.encode("authToken=$authToken&reportId=$reportId&embedUrl=$embededUrl")),
              headers: {'Content-Type': 'application/x-www-form-urlencoded','authToken':authToken,'reportId':reportId,'embedUrl':embededUrl}*/),
        onWebViewCreated: (controller) {
          //controller.evaluateJavascript(source: 'onHTMLLoad($reportId,$embededUrl,$authToken)');
          //controller.evaluateJavascript(source: 'onHTMLLoad()');
        },
        onLoadStop: (InAppWebViewController controller, Uri url) {
          controller.evaluateJavascript(source: 'onHTMLLoad("$id",$reportId","$embededUrl","$authToken")');
        },
        shouldOverrideUrlLoading: (controller, shouldOverrideUrlLoadingRequest) async {
          if (Platform.isAndroid || shouldOverrideUrlLoadingRequest.iosWKNavigationType == IOSWKNavigationType.LINK_ACTIVATED) {
            controller.loadUrl(urlRequest: shouldOverrideUrlLoadingRequest.request);
            return NavigationActionPolicy.CANCEL;
          }
          return NavigationActionPolicy.ALLOW;
        },
      );
    });
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
