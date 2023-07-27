
import 'package:myfhb/common/CommonUtil.dart';

import '../../constants/fhb_parameters.dart' as parameters;

class BookmarkRequest {
  List<String>? mediaMetaIds;
  bool? isBookmarked;

  BookmarkRequest({this.mediaMetaIds, this.isBookmarked});

  BookmarkRequest.fromJson(Map<String, dynamic> json) {
    try {
      mediaMetaIds = json[parameters.strMediaMetaIds].cast<String>();
      isBookmarked = json[parameters.strIsBookmarked];
    } catch (e) {
      CommonUtil().appLogs(message: e.toString());
    }
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data[parameters.strMediaMetaIds] = mediaMetaIds;
    data[parameters.strIsBookmarked]= isBookmarked;
    return data;
  }
}
