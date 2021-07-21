import '../../src/model/Health/MediaMasterIds.dart';
import '../../src/model/Health/MetaInfo.dart';
import '../../constants/fhb_parameters.dart' as parameters;

class Data {
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

  Data(
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
      this.mediaMasterIds});

  Data.fromJson(Map<String, dynamic> json) {
    id = json[parameters.strId];
    metaTypeId = json[parameters.strmetaTypeId];
    userId = json[parameters.struserId];
    metaInfo = json[parameters.strmetaInfo] != null
        ? MetaInfo.fromJson(json[parameters.strmetaInfo])
        : null;
    isActive = json[parameters.strIsActive];
    createdBy = json[parameters.strCreatedBy];
    createdOn = json[parameters.strCreatedOn];
    lastModifiedOn = json[parameters.strLastModifiedOn];
    isBookmarked = json[parameters.strIsBookmarked];
    isDraft = json[parameters.strisDraft];
    createdByUser = json[parameters.strcreatedByUser];
    if (json[parameters.strmediaMasterId] != null) {
      mediaMasterIds = <MediaMasterIds>[];
      json[parameters.strmediaMasterId].forEach((v) {
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
      data[parameters.strmediaMasterId] =
          mediaMasterIds.map((v) => v.toJson()).toList();
    }
    return data;
  }
}