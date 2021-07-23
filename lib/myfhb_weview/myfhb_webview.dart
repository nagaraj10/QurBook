import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../common/CommonUtil.dart';
import '../constants/fhb_constants.dart';
import '../widgets/GradientAppBar.dart';
import '../src/utils/screenutils/size_extensions.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../constants/variable_constant.dart' as variable;
import 'package:myfhb/common/common_circular_indicator.dart';

class MyFhbWebView extends StatefulWidget {
  final String title;
  final String selectedUrl;
  final bool isLocalAsset;

  const MyFhbWebView(
      {@required this.title,
      @required this.selectedUrl,
      @required this.isLocalAsset});

  @override
  _MyFhbWebViewState createState() => _MyFhbWebViewState();
}

class _MyFhbWebViewState extends State<MyFhbWebView> {
  WebViewController _controller;
  bool isLoading = true;

  @override
  void initState() {
    mInitialTime = DateTime.now();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    fbaLog(eveName: 'qurbook_screen_event', eveParams: {
      'eventTime': '${DateTime.now()}',
      'pageName': 'Helps Docs Screen',
      'screenSessionTime':
          '${DateTime.now().difference(mInitialTime).inSeconds} secs'
    });
  }

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
          title: Text(widget.title),
        ),
        body: Stack(
          children: <Widget>[
            WebView(
              initialUrl: widget.selectedUrl,
              javascriptMode: JavascriptMode.unrestricted,
              onWebViewCreated: (webViewController) {
                _controller = webViewController;
                widget.isLocalAsset
                    ? _loadHtmlFromAssets(widget.selectedUrl)
                    : _controller.loadUrl(widget.selectedUrl);
              },
              onPageFinished: (_) {
                setState(() {
                  isLoading = false;
                });
              },
            ),
            if (isLoading) CommonCircularIndicator() else Container(),
          ],
        ));
  }

  _loadHtmlFromAssets(String selectedUrl) async {
    try {
      final fileText = await rootBundle.loadString(selectedUrl);
      await _controller.loadUrl(Uri.dataFromString(fileText,
              mimeType: variable.strtexthtml,
              encoding: Encoding.getByName(variable.strUtf))
          .toString());
    } catch (e) {
      print(e);
      if (selectedUrl.isNotEmpty) {
        await _controller.loadUrl(Uri.dataFromString(selectedUrl,
                mimeType: variable.strtexthtml,
                encoding: Encoding.getByName(variable.strUtf))
            .toString());
      }
    }
  }
}
