
import 'package:myfhb/common/CommonUtil.dart';

class HealthRecordCollection {
  String? id;
  String? fileType;
  String? healthRecordUrl;
  bool? isActive;
  String? createdOn;
  String? createdBy;

  HealthRecordCollection({this.id,
    this.fileType,
    this.healthRecordUrl,
    this.isActive,
    this.createdOn,
    this.createdBy});

  HealthRecordCollection.fromJson(Map<String, dynamic> json) {
    try {
      id = json['id'];
      fileType = json['fileType'];
      healthRecordUrl = json['healthRecordUrl'];
      isActive = json['isActive'];
      createdOn = json['createdOn'];
      createdBy = json['createdBy'];
    } catch (e,stackTrace) {
      CommonUtil().appLogs(message: e,stackTrace:stackTrace);
    }
  }

  Map<String, dynamic> toJson() {
    final data = Map<String, dynamic>();
    data['id'] = id;
    data['fileType'] = fileType;
    data['healthRecordUrl'] = healthRecordUrl;
    data['isActive'] = isActive;
    data['createdOn'] = createdOn;
    data['createdBy'] = createdBy;
    return data;
  }
}