
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:myfhb/common/PreferenceUtil.dart';
import 'package:myfhb/src/resources/network/api_services.dart';
import 'package:myfhb/src/utils/FHBUtils.dart';
import 'package:myfhb/widgets/ShowImage.dart';
import '../../common/CommonUtil.dart';
import '../../constants/variable_constant.dart' as variable;
import '../../src/model/Health/asgard/health_record_collection.dart';
import '../../constants/fhb_constants.dart' as Constants;
import '../../src/utils/screenutils/size_extensions.dart';

class DownloadMultipleImages {
  final List<HealthRecordCollection> image_list;

  DownloadMultipleImages(this.image_list);

  void downloadFilesFromServer(BuildContext contxt) async {
    String? authToken =
        await PreferenceUtil.getStringValue(Constants.KEY_AUTHTOKEN);

    List<String?> filePathist = [];
    for (final _currentImage in image_list) {
      try {
        var url = _currentImage.healthRecordUrl ?? '';
        var extension = _currentImage.fileType ?? '';
        final req = await ApiServices.get(url);
        final bytes = req!.bodyBytes;
        final dir = Platform.isIOS
            ? await FHBUtils.createFolderInAppDocDirForIOS('images')
            : await FHBUtils.createFolderInAppDocDir();

        String? imageName;
        if (url.contains('/')) {
          imageName = url.split('/').last;
        }
        var file = File('$dir/${imageName}$extension');
        await file.writeAsBytes(bytes);

        print("file.path" + file.path ?? '');
        filePathist.add(file.path ?? '');
      } catch (e, stackTrace) {
        CommonUtil().appLogs(message: e, stackTrace: stackTrace);
      }
    }
    if (filePathist.length == image_list.length) {
      ScaffoldMessenger.of(contxt).showSnackBar(SnackBar(
          content: Text(
            variable.strFileDownloaded,
            style: TextStyle(
              fontSize: 16.0.sp,
            ),
          ),
          backgroundColor: Color(CommonUtil().getMyPrimaryColor()),
          action: SnackBarAction(
            label: 'Open',
            onPressed: () async {
              await Navigator.push(
                  contxt,
                  MaterialPageRoute(
                      builder: (context) => ShowImage(
                            filePathList: filePathist,
                          )));
            },
          )));
    }else{
      ScaffoldMessenger.of(contxt).showSnackBar(SnackBar(
          content: Text(
            variable.strFileDownloadeding,
            style: TextStyle(
              fontSize: 16.0.sp,
            ),
          ),
          backgroundColor: Color(CommonUtil().getMyPrimaryColor()),
          ));

    }
  }
}
