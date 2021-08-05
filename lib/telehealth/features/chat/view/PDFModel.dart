import 'package:flutter/foundation.dart';

enum PDFLocation { URL, Asset, Path }

class OpenPDF {
  final PDFLocation type;
  final String path;
  final String title;
  OpenPDF({@required this.path, @required this.type, this.title});
}
