import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../common/CommonUtil.dart';
import '../../common/common_circular_indicator.dart';
import '../../constants/fhb_constants.dart';
import '../../constants/router_variable.dart';
import '../../constants/variable_constant.dart' as variable;
import '../../constants/variable_constant.dart';
import '../../src/utils/screenutils/size_extensions.dart';
import '../../widgets/GradientAppBar.dart';

class TermsAndConditonWebView extends StatefulWidget {
  final String? title;
  final String? selectedUrl;
  final bool isLocalAsset;

  const TermsAndConditonWebView(
      {required this.title,
      required this.selectedUrl,
      required this.isLocalAsset});

  @override
  _MyFhbWebViewState createState() => _MyFhbWebViewState();
}

class _MyFhbWebViewState extends State<TermsAndConditonWebView> {
  late WebViewController _controller;
  bool isLoading = true;
  double iconSize = CommonUtil().isTablet! ? tabFontTitle : mobileFontTitle;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: GradientAppBar(),
        centerTitle: false,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            size: 24.0.sp,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: AppBarForVoiceCloning().getVoiceCloningAppBar(),
      ),
      body: Stack(
        children: <Widget>[
          WebView(
            initialUrl: widget.selectedUrl,
            javascriptMode: JavascriptMode.unrestricted,
            onWebViewCreated: (webViewController) {
              _controller = webViewController;
              widget.isLocalAsset
                  ? _loadHtmlFromAssets(widget.selectedUrl!)
                  : _controller.loadUrl(widget.selectedUrl!);
            },
            onPageFinished: (_) {
              setState(() {
                isLoading = false;
              });
            },
          ),
          if (isLoading) CommonCircularIndicator() else Container(),
          Container(
              alignment: Alignment.bottomCenter,
              width: double.maxFinite,
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(
                      CommonUtil().getMyPrimaryColor(),
                    ),
                  ),
                  onPressed: () {
                    Navigator.pushNamed(
                      context,
                      rt_VoiceCloningIntro,
                    ).then((value) {
                      setState(() {});
                    });
                  },
                  child: Padding(
                      padding: EdgeInsets.all(20.sp),
                      child: Text(
                        strVoiceTerms,
                        style: TextStyle(fontSize: iconSize),
                      )),
                ),
              )),
        ],
      ),
    );
  }

  _loadHtmlFromAssets(String selectedUrl) async {
    try {
      final fileText = await rootBundle.loadString(selectedUrl);
      await _controller.loadUrl(Uri.dataFromString(fileText,
              mimeType: variable.strtexthtml,
              encoding: Encoding.getByName(variable.strUtf))
          .toString());
    } catch (e, stackTrace) {
      CommonUtil().appLogs(message: e, stackTrace: stackTrace);

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

class AppBarForVoiceCloning {
  double iconSize = CommonUtil().isTablet! ? imageCloseTab : imageCloseMobile;
  double fontTitle = CommonUtil().isTablet! ? tabFontTitle : mobileFontTitle;

  Widget getVoiceCloningAppBar() {
    return Transform(
        // you can forcefully translate values left side using Transform
        transform: Matrix4.translationValues(-30.0, 0.0, 0.0),
        child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
          SizedBox(
            width: 10.sp,
          ),
          Text(
            variable.strVoiceCloning,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: fontTitle),
          ),
        ]));
  }

//get Text Status color based on the status
  getTextStyle(String voiceCloningStatus) {
    double title3 = CommonUtil().isTablet! ? tabHeader3 : mobileHeader3;

    switch (voiceCloningStatus) {
      case 'Under Review':
        return TextStyle(
          fontSize: title3,
          color: Colors.blue,
        );

      case 'Being Processed':
        return TextStyle(
          fontSize: title3,
          color: Colors.blue,
        );

      case 'Approved':
        return TextStyle(
          fontSize: title3,
          color: Colors.green,
        );

      case 'Declined':
        return TextStyle(
          fontSize: title3,
          color: Colors.red,
        );

      default:
        return TextStyle(
          fontSize: title3,
          color: Colors.grey,
        );
    }
  }
}
