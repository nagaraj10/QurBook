// TODO: multi_image_picker deprecated so need to FIX
// import 'package:multi_image_picker/src/asset.dart';

class ImagesModel {
  ImagesModel(
      {this.file,
      this.isFromFile = true,
      this.isdownloaded = false,
      // TODO: multi_image_picker deprecated so need to FIX
      // this.asset,
      this.fileType});
  String? file;
  bool isFromFile;
  bool isdownloaded;
  // TODO: multi_image_picker deprecated so need to FIX
  // Asset? asset;
  String? fileType;
}
