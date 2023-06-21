import 'package:myfhb/Qurhome/QurhomeDashboard/model/patientalertlist/additional_info.dart';

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
      this.lastModifiedOn});

  PatientAlertData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    additionalInfo = json['additionalInfo'] != null
        ? new AdditionalInfo.fromJson(json['additionalInfo'])
        : null;
    statusId = json['statusId'];
    statusName = json['statusName'];
    typeId = json['typeId'];
    typeName = json['typeName'];
    typeCode = json['typeCode'];

    createdOn = DateTime.tryParse(json['createdOn'] ?? '');
    isEscalated = json['isEscalated'];
    lastModifiedOn = json['lastModifiedOn'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
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
    return data;
  }
}
