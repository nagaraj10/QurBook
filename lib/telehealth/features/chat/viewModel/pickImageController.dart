
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class PickImageController {
  static PickImageController get instance => PickImageController();
  File croppedFile;

  Future<File> cropImageFromFile() async{
    // TakeImage from user's photo
    //File imageFileFromLibrary = await ImagePicker.pickImage(source:ImageSource.gallery);
    File file = await FilePicker.getFile(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'pdf', 'png'],
    );
    // Start crop iamge then take the file.
    if ((file.path.toString().toLowerCase().contains('.jpg')) ||
        (file.path.toString().toLowerCase().contains('.jpeg')) ||
        (file.path.toString().toLowerCase().contains('.png'))) {

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