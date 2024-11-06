
import 'package:myfhb/common/CommonUtil.dart';

import '../../../constants/fhb_parameters.dart' as parameters;

class MediaMasterIds {
  String? id;
  String? fileType;

  MediaMasterIds({this.id, this.fileType});

  MediaMasterIds.fromJson(Map<String, dynamic> json) {
    try {
      id = json[parameters.strId];
      fileType = json[parameters.strfileType];
    } catch (e,stackTrace) {
      CommonUtil().appLogs(message: e,stackTrace:stackTrace);
    }
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data[parameters.strId] = id;
    data[parameters.strfileType] = fileType;
    return data;
  }
}