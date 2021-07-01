import 'UpdateMediaResponse.dart';
import '../../constants/router_variable.dart' as router;
import '../../constants/fhb_parameters.dart' as parameters;
import '../../constants/fhb_query.dart' as query;

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
    id = json[parameters.strId];
    metaTypeId = json[parameters.strmetaTypeId];
    userId = json[parameters.struserId];
    metaInfo = json[parameters.strmetaInfo] != null
        ? MetaInfo.fromJson(json[parameters.strmetaInfo])
        : null;
    isActive = json[parameters.strIsActive];
    isVisible = json[parameters.strisVisible];
    createdBy = json[parameters.strCreatedBy];
    createdOn = json[parameters.strCreatedOn];
    lastModifiedOn = json[parameters.strLastModifiedOn];
    isBookmarked = json[parameters.strIsBookmarked];
    isDraft = json[parameters.strisDraft];
    lastModifiedBy = json[parameters.strlastModifiedBy];
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
    data[parameters.strisVisible] = isVisible;
    data[parameters.strCreatedBy] = createdBy;
    data[parameters.strCreatedOn] = createdOn;
    data[parameters.strLastModifiedOn] = lastModifiedOn;
    data[parameters.strIsBookmarked] = isBookmarked;
    data[parameters.strisDraft] = isDraft;
    data[parameters.strlastModifiedBy] = lastModifiedBy;
    return data;
  }
}
