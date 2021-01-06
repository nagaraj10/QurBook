import 'package:flutter/material.dart';
import 'package:myfhb/widgets/GradientAppBar.dart';
import 'package:pdf_render/pdf_render_widgets.dart';
import 'package:myfhb/constants/variable_constant.dart' as variable;

class PDFViewer extends StatelessWidget {
  /// render at 100 dpi
  static const scale = 100.0 / 72.0;
  static const margin = 4.0;
  static const padding = 1.0;
  static const wmargin = (margin + padding) * 2;
  static final controller = ScrollController();
  final pdfData;
  String title;

  PDFViewer(this.pdfData, this.title);

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      debugShowCheckedModeBanner: false,
      home: new Scaffold(
          appBar: AppBar(
              title: Text(title != null ? title : ''),
              elevation: 0,
              automaticallyImplyLeading: false,
              flexibleSpace: GradientAppBar(),
              leading: IconButton(
                  icon: Icon(Icons.arrow_back_ios),
                  onPressed: () {
                    Navigator.of(context).pop();
                  })),
          backgroundColor: Colors.grey,
          body: Center(
              child: PdfDocumentLoader(
            filePath: pdfData,
            documentBuilder: (context, pdfDocument, pageCount) => LayoutBuilder(
              builder: (context, constraints) => ListView.builder(
                controller: controller,
                itemCount: pageCount,
                itemBuilder: (context, index) => Container(
                  margin: EdgeInsets.all(margin),
                  padding: EdgeInsets.all(padding),
                  color: Colors.black12,
                  child: PdfPageView(
                    pageNumber: index + 1,
                    calculateSize: (pageWidth, pageHeight, aspectRatio) => Size(
                        constraints.maxWidth - wmargin,
                        (constraints.maxWidth - wmargin) / aspectRatio),
                    customizer: (context, page, size) => Stack(
                      alignment: Alignment.bottomCenter,
                      children: <Widget>[
                        page != null ? page : 0,
                        Text(
                          '',
                          style: TextStyle(fontSize: 2),
                        ) // adding page number on the bottom of rendered page
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ))),
    );
  }
}
