import 'package:myfhb/record_detail/model/UpdateMediaResponse.dart';

class MediaMetaInfo {
  String id;
  String metaTypeId;
  String userId;
  MetaInfo metaInfo;
  bool isActive;
  bool isVisible;
  String createdBy;
  String createdOn;
  String lastModifiedOn;
  bool isBookmarked;
  bool isDraft;
  String lastModifiedBy;

  MediaMetaInfo(
      {this.id,
      this.metaTypeId,
      this.userId,
      this.metaInfo,
      this.isActive,
      this.isVisible,
      this.createdBy,
      this.createdOn,
      this.lastModifiedOn,
      this.isBookmarked,
      this.isDraft,
      this.lastModifiedBy});

  MediaMetaInfo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    metaTypeId = json['metaTypeId'];
    userId = json['userId'];
    metaInfo = json['metaInfo'] != null
        ? new MetaInfo.fromJson(json['metaInfo'])
        : null;
    isActive = json['isActive'];
    isVisible = json['isVisible'];
    createdBy = json['createdBy'];
    createdOn = json['createdOn'];
    lastModifiedOn = json['lastModifiedOn'];
    isBookmarked = json['isBookmarked'];
    isDraft = json['isDraft'];
    lastModifiedBy = json['lastModifiedBy'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['metaTypeId'] = this.metaTypeId;
    data['userId'] = this.userId;
    if (this.metaInfo != null) {
      data['metaInfo'] = this.metaInfo.toJson();
    }
    data['isActive'] = this.isActive;
    data['isVisible'] = this.isVisible;
    data['createdBy'] = this.createdBy;
    data['createdOn'] = this.createdOn;
    data['lastModifiedOn'] = this.lastModifiedOn;
    data['isBookmarked'] = this.isBookmarked;
    data['isDraft'] = this.isDraft;
    data['lastModifiedBy'] = this.lastModifiedBy;
    return data;
  }
}
