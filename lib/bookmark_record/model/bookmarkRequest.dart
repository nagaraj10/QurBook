import '../../constants/fhb_parameters.dart' as parameters;

class BookmarkRequest {
  List<String> mediaMetaIds;
  bool isBookmarked;

  BookmarkRequest({this.mediaMetaIds, this.isBookmarked});

  BookmarkRequest.fromJson(Map<String, dynamic> json) {
    mediaMetaIds = json[parameters.strMediaMetaIds].cast<String>();
    isBookmarked = json[parameters.strIsBookmarked];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data[parameters.strMediaMetaIds] = mediaMetaIds;
    data[parameters.strIsBookmarked]= isBookmarked;
    return data;
  }
}
