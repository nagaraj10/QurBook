
import 'package:myfhb/common/CommonUtil.dart';

class Status {
  dynamic id;
  dynamic code;
  dynamic name;
  dynamic description;
  int? sortOrder;
  bool? isActive;
  dynamic createdBy;
  dynamic createdOn;
  String? lastModifiedOn;

  Status(
      {this.id,
        this.code,
        this.name,
        this.description,
        this.sortOrder,
        this.isActive,
        this.createdBy,
        this.createdOn,
        this.lastModifiedOn});

  Status.fromJson(Map<String, dynamic> json) {
    try {
      id = json['id']!=null?json['id']:"";
      code = json['code']!=null?json['code']:"";
      name = json['name']!=null?json['name']:"";
      description = json['description']!=null?json['description']:"";
      sortOrder = json['sortOrder']!=null?json['sortOrder']:"" as int?;
      isActive = json['isActive']!=null?json['isActive']:"" as bool?;
      createdBy = json['createdBy']!=null?json['createdBy']:"";
      createdOn = json['createdOn']!=null?json['createdOn']:"";
      lastModifiedOn = json['lastModifiedOn']!=null?json['lastModifiedOn']:"";
    } catch (e) {
      CommonUtil().appLogs(message: e.toString());
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['code'] = this.code;
    data['name'] = this.name;
    data['description'] = this.description;
    data['sortOrder'] = this.sortOrder;
    data['isActive'] = this.isActive;
    data['createdBy'] = this.createdBy;
    data['createdOn'] = this.createdOn;
    data['lastModifiedOn'] = this.lastModifiedOn;
    return data;
  }
}
