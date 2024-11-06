import 'package:myfhb/Qurhome/QurhomeDashboard/model/patientalertlist/additional_info.dart';
import 'package:myfhb/common/CommonUtil.dart';

class PatientAlertData {
  String? id;
  AdditionalInfo? additionalInfo;
  String? statusId;
  String? statusName;
  String? typeId;
  String? typeName;
  String? typeCode;
  DateTime? createdOn;
  bool? isEscalated;
  String? lastModifiedOn;
  List<String>? interaction;

  PatientAlertData(
      {this.id,
      this.additionalInfo,
      this.statusId,
      this.statusName,
      this.typeId,
      this.typeName,
      this.typeCode,
      this.createdOn,
      this.isEscalated,
      this.lastModifiedOn,
      this.interaction});

  PatientAlertData.fromJson(Map<String, dynamic> json) {
    try {
      id = json['id'];
      additionalInfo = json['additionalInfo'] != null
          ? AdditionalInfo.fromJson(json['additionalInfo'])
          : null;
      statusId = json['statusId'];
      statusName = json['statusName'];
      typeId = json['typeId'];
      typeName = json['typeName'];
      typeCode = json['typeCode'];

      createdOn = DateTime.tryParse(json['createdOn'] ?? '');
      isEscalated = json['isEscalated'];
      lastModifiedOn = json['lastModifiedOn'];
      interaction = json['interaction']!=null?List<String>.from(json['interaction']):[];
    } catch (e, stackTrace) {
      CommonUtil().appLogs(message: e, stackTrace: stackTrace);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = this.id;
    if (this.additionalInfo != null) {
      data['additionalInfo'] = this.additionalInfo!.toJson();
    }
    data['statusId'] = this.statusId;
    data['statusName'] = this.statusName;
    data['typeId'] = this.typeId;
    data['typeName'] = this.typeName;
    data['typeCode'] = this.typeCode;
    data['createdOn'] = this.createdOn?.toIso8601String();
    data['isEscalated'] = this.isEscalated;
    data['lastModifiedOn'] = this.lastModifiedOn;
    data['interaction'] = this.interaction;
    return data;
  }
}
