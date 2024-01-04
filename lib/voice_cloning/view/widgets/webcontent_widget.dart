import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:myfhb/common/CommonUtil.dart';
import 'package:myfhb/common/common_circular_indicator.dart';
import 'package:myfhb/constants/variable_constant.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebContentWidget extends StatefulWidget {
  final String? selectedUrl;

  const WebContentWidget(
      {
        required this.selectedUrl});

  @override
  _MyWebContentWidget createState() => _MyWebContentWidget();
}

class _MyWebContentWidget extends State<WebContentWidget> {
  late WebViewController _controller;
  bool isLoading = true;
  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Stack(
      children: <Widget>[
        WebView(
          initialUrl: widget.selectedUrl,
          javascriptMode: JavascriptMode.unrestricted,
          onWebViewCreated: (webViewController) {
            _controller = webViewController;
            _controller.loadUrl(widget.selectedUrl!);
          },
          onPageFinished: (_) {
            setState(() {
              isLoading = false;
            });
          },
        ),
        if (isLoading) CommonCircularIndicator() else Container(),
      ],
    );
}
