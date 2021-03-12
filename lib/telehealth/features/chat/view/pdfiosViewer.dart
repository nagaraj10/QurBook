import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:myfhb/src/utils/screenutils/size_extensions.dart';

import 'package:flutter/material.dart';
import 'package:myfhb/widgets/GradientAppBar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'package:simple_pdf_viewer/simple_pdf_viewer.dart';

class PDFiOSViewer extends StatefulWidget {
  String url;
  String path;
  String title;

  PDFiOSViewer({
    Key key,
    this.path,
    this.title,
    @required this.url,
  }) : super(key: key);

  @override
  _PDFiOSViewerState createState() => _PDFiOSViewerState();
}

class _PDFiOSViewerState extends State<PDFiOSViewer> {
  @override
  initState() {
    if (widget.path == null) {
      loadPdf();
    }
    super.initState();
  }

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/test.pdf');
  }

  Future<File> writeCounter(Uint8List stream) async {
    final file = await _localFile;
    return file.writeAsBytes(stream);
  }

  Future<Uint8List> fetchPost() async {
    final response = await http.get(widget.url);
    final responseJson = response.bodyBytes;
    return responseJson;
  }

  loadPdf() async {
    writeCounter(await fetchPost());
    widget.path = (await _localFile).path;
    print(widget.path);
    if (!mounted) return;
    widget.path = "file://" + widget.path;
    print(widget.path);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
            title: Text(widget.title ?? "PDF Viewer"),
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
        body: Center(
          child: (widget.path != null)
              ? SimplePdfViewerWidget(
                  completeCallback: (bool result) {},
                  initialUrl: widget.path,
                )
              : CircularProgressIndicator(),
        ),
      ),
    );
  }
}
