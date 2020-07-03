import 'package:myfhb/constants/fhb_parameters.dart' as parameters;

class BookmarkRequest {
  List<String> mediaMetaIds;
  bool isBookmarked;

  BookmarkRequest({this.mediaMetaIds, this.isBookmarked});

  BookmarkRequest.fromJson(Map<String, dynamic> json) {
    mediaMetaIds = json[parameters.strMediaMetaIds].cast<String>();
    isBookmarked = json[parameters.strIsBookmarked];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data[parameters.strMediaMetaIds] = this.mediaMetaIds;
    data[parameters.strIsBookmarked]= this.isBookmarked;
    return data;
  }
}
