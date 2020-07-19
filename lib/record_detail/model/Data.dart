import 'package:myfhb/constants/fhb_parameters.dart' as parameters;
import 'package:myfhb/record_detail/model/MetaInfo.dart';

class Data {
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

  Data(
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

  Data.fromJson(Map<String, dynamic> json) {
    id = json[parameters.strId];
    metaTypeId = json[parameters.strmetaTypeId];
    userId = json[parameters.struserId];
    metaInfo = json[parameters.strmetaInfo] != null
        ? new MetaInfo.fromJson(json[parameters.strmetaInfo])
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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data[parameters.strId] = this.id;
    data[parameters.strmetaTypeId] = this.metaTypeId;
    data[parameters.struserId] = this.userId;
    if (this.metaInfo != null) {
      data[parameters.strmetaInfo] = this.metaInfo.toJson();
    }
    data[parameters.strIsActive] = this.isActive;
    data[parameters.strisVisible] = this.isVisible;
    data[parameters.strCreatedBy] = this.createdBy;
    data[parameters.strCreatedOn] = this.createdOn;
    data[parameters.strLastModifiedOn] = this.lastModifiedOn;
    data[parameters.strIsBookmarked] = this.isBookmarked;
    data[parameters.strisDraft] = this.isDraft;
    data[parameters.strlastModifiedBy] = this.lastModifiedBy;
    return data;
  }
}

