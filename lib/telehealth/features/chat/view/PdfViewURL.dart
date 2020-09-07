import 'package:flutter/material.dart';
import 'package:myfhb/widgets/GradientAppBar.dart';
import 'package:simple_pdf_viewer/simple_pdf_viewer.dart';

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
          title: Text('PDF Viewer'),
          elevation: 0,
          automaticallyImplyLeading: false,
          flexibleSpace: GradientAppBar(),
          leading: IconButton(
              icon: Icon(Icons.arrow_back_ios),
              onPressed: () {
                Navigator.of(context).pop();
              })),
        body: SimplePdfViewerWidget(
          completeCallback: (bool result){
          },
          initialUrl: widget.url,
        ),
    );
  }
}