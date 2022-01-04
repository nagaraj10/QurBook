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
    String authToken =
        await PreferenceUtil.getStringValue(Constants.KEY_AUTHTOKEN);

    List<String> filePathist = new List();
    for (final _currentImage in image_list) {
      try {
        await FHBUtils.createFolderInAppDocDirClone(variable.stAudioPath,
                _currentImage.healthRecordUrl.split('/').last)
            .then((filePath) async {
          var file;
          if (_currentImage.fileType == '.pdf') {
            file = File('$filePath');
          } else {
            file = File('$filePath');
          }
          final request = await ApiServices.get(
            _currentImage.healthRecordUrl,
            headers: {
              HttpHeaders.authorizationHeader: authToken,
              Constants.KEY_OffSet: CommonUtil().setTimeZone()
            },
          );
          final bytes = request.bodyBytes; //close();
          await file.writeAsBytes(bytes);

          print("file.path" + file.path);
          filePathist.add(file.path);
        });
      } catch (e) {
        //print('$e exception thrown');
      }
    }
    if (filePathist.length == image_list.length) {
      Scaffold.of(contxt).showSnackBar(SnackBar(
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
      Scaffold.of(contxt).showSnackBar(SnackBar(
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
