
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:myfhb/constants/fhb_constants.dart';

class PickImageController {
  static PickImageController get instance => PickImageController();
  File croppedFile;

  Future<File> cropImageFromFile(String isFrom) async{
    // TakeImage from user's photo
    //File imageFileFromLibrary = await ImagePicker.pickImage(source:ImageSource.gallery);
    File file = await FilePicker.getFile(
      type: isFrom==strGallery?FileType.image:isFrom==strVideo?FileType.video:isFrom==strFiles?FileType.any:isFrom==strAudio?FileType.audio:FileType.any,
      /*allowedExtensions: [strJpg, strPdf, strPng],*/
    );
    // Start crop iamge then take the file.
    if ((file.path.toString().toLowerCase().contains(strJpgDot)) ||
        (file.path.toString().toLowerCase().contains(strJpegDot)) ||
        (file.path.toString().toLowerCase().contains(strPngDot))) {

       croppedFile = await ImageCropper.cropImage(
          sourcePath: file.path,
          aspectRatioPresets: [
            CropAspectRatioPreset.square,
            CropAspectRatioPreset.ratio3x2,
            CropAspectRatioPreset.original,
            CropAspectRatioPreset.ratio4x3,
            CropAspectRatioPreset.ratio16x9
          ],
          androidUiSettings: AndroidUiSettings(
              toolbarTitle: 'Cropper',
              toolbarColor: Colors.deepOrange,
              toolbarWidgetColor: Colors.white,
              initAspectRatio: CropAspectRatioPreset.original,
              lockAspectRatio: false),
          iosUiSettings: IOSUiSettings(
            minimumAspectRatio: 1.0,
          )
      );

    }
    else
      {
      croppedFile = file;
    }


    return croppedFile != null ? croppedFile : null;
  }
}