import 'package:myfhb/constants/fhb_parameters.dart' as parameters;
import 'package:myfhb/src/model/Health/MediaMasterIds.dart';
import 'package:myfhb/src/model/Health/MetaInfo.dart';

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
      this.mediaMasterIds});

  MediaMetaInfo.fromJson(Map<String, dynamic> json) {
    id = json[parameters.strId];
    metaTypeId = json[parameters.strmetaTypeId];
    userId = json[parameters.struserId];
    metaInfo = json[parameters.strmetaInfo] != null
        ? new MetaInfo.fromJson(json[parameters.strmetaInfo])
        : null;
    isActive = json[parameters.strIsActive];
    createdBy = json[parameters.strCreatedBy];
    createdOn = json[parameters.strCreatedOn];
    lastModifiedOn = json[parameters.strLastModifiedOn];
    isBookmarked = json[parameters.strIsBookmarked];
    isDraft = json[parameters.strisDraft];
    createdByUser = json[parameters.strcreatedByUser];
    if (json[parameters.strmediaMasterIds] != null) {
      mediaMasterIds = new List<MediaMasterIds>();
      json[parameters.strmediaMasterIds].forEach((v) {
        mediaMasterIds.add(new MediaMasterIds.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data[parameters.strId] = this.id;
    data[parameters.strmetaTypeId] = this.metaTypeId;
    data[parameters.struserId] = this.userId;
    if (this.metaInfo != null) {
      data[parameters.strmetaInfo] = this.metaInfo.toJson();
    }
    data[parameters.strIsActive] = this.isActive;
    data[parameters.strCreatedBy] = this.createdBy;
    data[parameters.strCreatedOn] = this.createdOn;
    data[parameters.strLastModifiedOn] = this.lastModifiedOn;
    data[parameters.strIsBookmarked] = this.isBookmarked;
    data[parameters.strisDraft] = this.isDraft;
    data[parameters.strcreatedByUser] = this.createdByUser;
    if (this.mediaMasterIds != null) {
      data[parameters.strmediaMasterIds] =
          this.mediaMasterIds.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

