class BookmarkRequest {
  List<String> mediaMetaIds;
  bool isBookmarked;

  BookmarkRequest({this.mediaMetaIds, this.isBookmarked});

  BookmarkRequest.fromJson(Map<String, dynamic> json) {
    mediaMetaIds = json['mediaMetaIds'].cast<String>();
    isBookmarked = json['isBookmarked'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['mediaMetaIds'] = this.mediaMetaIds;
    data['isBookmarked'] = this.isBookmarked;
    return data;
  }
}
