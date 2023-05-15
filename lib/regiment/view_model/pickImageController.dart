import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import '../../constants/fhb_constants.dart';

class PickImageController {
  static PickImageController get instance => PickImageController();
  File? croppedFile;

  Future<File?> cropImageFromFile(String isFrom) async {
    final FilePickerResult? filePickerResult =
        await FilePicker.platform.pickFiles(
      type: isFrom == strGallery
          ? FileType.image
          : isFrom == strVideo
              ? FileType.video
              : isFrom == strFiles
                  ? FileType.any
                  : isFrom == strAudio
                      ? FileType.audio
                      : FileType.any,
      /*allowedExtensions: [strJpg, strPdf, strPng],*/
    );
    File? file = (filePickerResult!.files.length) > 0
        ? File(filePickerResult.files[0].path!)
        : null;
    // Start crop iamge then take the file.
    if (file != null &&
        ((file.path.toString().toLowerCase().contains(strJpgDot)) ||
            (file.path.toString().toLowerCase().contains(strJpegDot)) ||
            (file.path.toString().toLowerCase().contains(strPngDot)))) {
    } else {
      croppedFile = file;
    }

    return croppedFile ?? null;
  }
}
