import '../../../constants/fhb_parameters.dart' as parameters;
import 'MediaMasterIds.dart';
import 'MetaInfo.dart';

class MediaMetaInfo {
  String id;
  String metaTypeId;
  String userId;
  MetaInfo metaInfo;
  bool isActive;
  String createdBy;
  String createdOn;
  String lastModifiedOn;
  bool isBookmarked;
  bool isDraft;
  String createdByUser;
  List<MediaMasterIds> mediaMasterIds;
  bool isSelected = false;

  MediaMetaInfo(
      {this.id,
      this.metaTypeId,
      this.userId,
      this.metaInfo,
      this.isActive,
      this.createdBy,
      this.createdOn,
      this.lastModifiedOn,
      this.isBookmarked,
      this.isDraft,
      this.createdByUser,
      this.mediaMasterIds,
      this.isSelected});

  MediaMetaInfo.fromJson(Map<String, dynamic> json) {
    id = json[parameters.strId];
    metaTypeId = json[parameters.strmetaTypeId];
    userId = json[parameters.struserId];
    metaInfo = json[parameters.strmetaInfo] != null
        ? MetaInfo.fromJson(json[parameters.strmetaInfo])
        : null;
    isActive = json[parameters.strIsActive] ?? false;
    createdBy = json[parameters.strCreatedBy];
    createdOn = json[parameters.strCreatedOn];
    lastModifiedOn = json[parameters.strLastModifiedOn];
    isBookmarked = json[parameters.strIsBookmarked] ?? false;
    isDraft = json[parameters.strisDraft] ?? false;
    createdByUser = json[parameters.strcreatedByUser];
    if (json[parameters.strmediaMasterIds] != null) {
      mediaMasterIds = <MediaMasterIds>[];
      json[parameters.strmediaMasterIds].forEach((v) {
        mediaMasterIds.add(MediaMasterIds.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data[parameters.strId] = id;
    data[parameters.strmetaTypeId] = metaTypeId;
    data[parameters.struserId] = userId;
    if (metaInfo != null) {
      data[parameters.strmetaInfo] = metaInfo.toJson();
    }
    data[parameters.strIsActive] = isActive;
    data[parameters.strCreatedBy] = createdBy;
    data[parameters.strCreatedOn] = createdOn;
    data[parameters.strLastModifiedOn] = lastModifiedOn;
    data[parameters.strIsBookmarked] = isBookmarked;
    data[parameters.strisDraft] = isDraft;
    data[parameters.strcreatedByUser] = createdByUser;
    if (mediaMasterIds != null) {
      data[parameters.strmediaMasterIds] =
          mediaMasterIds.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
