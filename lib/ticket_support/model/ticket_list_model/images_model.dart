import 'package:multi_image_picker/src/asset.dart';

class ImagesModel {
  ImagesModel(
      {this.file,
      this.isFromFile = true,
      this.isdownloaded = false,
      this.asset,
      this.fileType});
  String file;
  bool isFromFile;
  bool isdownloaded;
  Asset asset;
  String fileType;
}
