import 'package:flutter/material.dart';
import 'package:myfhb/widgets/GradientAppBar.dart';
import 'package:simple_pdf_viewer/simple_pdf_viewer.dart';
import 'package:myfhb/src/utils/screenutils/size_extensions.dart';

class PDFViewURL extends StatefulWidget {
  String url;

  PDFViewURL({
    Key key,
    @required this.url,
  }) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<PDFViewURL> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(
            'PDF Viewer',
            style: TextStyle(
              fontSize: 14.0.sp,
            ),
          ),
          elevation: 0,
          automaticallyImplyLeading: false,
          flexibleSpace: GradientAppBar(),
          leading: IconButton(
              icon: Icon(
                Icons.arrow_back_ios,
                size: 24.0.sp,
              ),
              onPressed: () {
                Navigator.of(context).pop();
              })),
      body: SimplePdfViewerWidget(
        completeCallback: (bool result) {},
        initialUrl: widget.url,
      ),
    );
  }
}
