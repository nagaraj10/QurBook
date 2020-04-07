import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:myfhb/widgets/GradientAppBar.dart';

import 'package:webview_flutter/webview_flutter.dart';

class MyFhbWebView extends StatefulWidget {
  final String title;
  final String selectedUrl;
  final bool isLocalAsset;

  MyFhbWebView(
      {@required this.title,
      @required this.selectedUrl,
      @required this.isLocalAsset});

  @override
  _MyFhbWebViewState createState() => _MyFhbWebViewState();
}

class _MyFhbWebViewState extends State<MyFhbWebView> {
  WebViewController _controller;

  @override
  Widget build(BuildContext context) {
    print('selected url :' + widget.selectedUrl);

    return Scaffold(
        appBar: AppBar(
          flexibleSpace: GradientAppBar(),
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          title: Text(widget.title),
        ),
        body: WebView(
          initialUrl: widget.selectedUrl,
          javascriptMode: JavascriptMode.unrestricted,
          onWebViewCreated: (WebViewController webViewController) {
            _controller = webViewController;
            widget.isLocalAsset
                ? _loadHtmlFromAssets(widget.selectedUrl)
                : _controller.loadUrl(widget.selectedUrl);
          },
        ));
  }

  _loadHtmlFromAssets(String selectedUrl) async {
    String fileText = await rootBundle.loadString(selectedUrl);
    _controller.loadUrl(Uri.dataFromString(fileText,
            mimeType: 'text/html', encoding: Encoding.getByName('utf-8'))
        .toString());
  }
}
