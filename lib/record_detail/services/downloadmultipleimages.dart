import 'package:flutter/material.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:myfhb/common/CommonUtil.dart';
import 'package:myfhb/constants/variable_constant.dart' as variable;

class DownloadMultipleImages {
  final List image_list;

  DownloadMultipleImages(this.image_list);

  void downloadFilesFromServer(BuildContext contxt) async {
    for (var _currentImage in image_list) {
      try {
        var filePath = await CommonUtil.downloadFile(_currentImage.response.data.fileContent,
                _currentImage.response.data.fileType);
        var status =  GallerySaver.saveImage(filePath.path, albumName: 'myfhb');
      } catch (e) {
        print('$e exception thrown');
      }
    }
    Scaffold.of(contxt).showSnackBar(SnackBar(
      content: const Text(variable.strFilesView),
      backgroundColor: Color(CommonUtil().getMyPrimaryColor()),
    ));
  }
}
