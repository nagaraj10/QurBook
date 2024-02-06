import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../../common/CommonUtil.dart';
import '../../../src/utils/screenutils/size_extensions.dart';
import '../../../widgets/GradientAppBar.dart';

class RegimentWebView extends StatefulWidget {
  final String? title;
  final String? selectedUrl;

  const RegimentWebView({
    required this.title,
    required this.selectedUrl,
  });

  @override
  _RegimentWebViewState createState() => _RegimentWebViewState();
}

class _RegimentWebViewState extends State<RegimentWebView> {
  WebViewController? _controller;
  bool isLoading = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: GradientAppBar(),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            size: 24.0.sp,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Text(widget.title!),
      ),
      body: SingleChildScrollView(
        child: Html(
          data: Platform.isIOS
              ? widget.selectedUrl?.replaceAll(
                    'src="//',
                    'src="https://',
                  ) ??
                  ''
              : widget.selectedUrl?.replaceAll(
                    'src="//',
                    'src="',
                  ) ??
                  '',
          onLinkTap: (linkUrl, attributes, element) {
            CommonUtil().openWebViewNew(
              widget.title,
              linkUrl,
              false,
            );
          },
        ),
      ),
    );
  }
}
