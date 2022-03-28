
import 'package:advance_pdf_viewer/advance_pdf_viewer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ShowPDFFromFile extends StatelessWidget {
  const ShowPDFFromFile({
    this.document,
  });

  final PDFDocument document;

  @override
  Widget build(BuildContext context) {
    return PDFViewer(document: document);
  }
}
