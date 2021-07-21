import 'dart:io';

import 'package:advance_pdf_viewer/advance_pdf_viewer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myfhb/telehealth/features/chat/view/PDFModel.dart';

class PDFViewController extends GetxController {
  OpenPDF data;
  var isLoading = true.obs;
  PDFDocument document;

  loadingPDF() async {
    isLoading.value = true;
    update();
    switch (data.type) {
      case PDFLocation.URL:
        document = await PDFDocument.fromURL(data.path);
        break;
      case PDFLocation.Asset:
        document = await PDFDocument.fromAsset(data.path);
        break;
      case PDFLocation.Path:
        File file = File(data.path);
        document = await PDFDocument.fromFile(file);
        break;
      default:
        document = await PDFDocument.fromURL(data.path);
        break;
    }
    isLoading.value = false;
    update();
  }
}
