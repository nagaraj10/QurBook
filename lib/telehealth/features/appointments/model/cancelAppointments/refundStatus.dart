import 'package:myfhb/telehealth/features/appointments/model/cancelAppointments/referenceData.dart';
import 'package:myfhb/telehealth/features/appointments/constants/appointments_parameters.dart'as parameters;

class RefundStatus {
  String id;
  String code;
  String name;
  String description;
  int sortOrder;
  bool isActive;
  String createdBy;
  String createdOn;
  dynamic lastModifiedOn;
  ReferenceData referenceData;

  RefundStatus(
      {this.id,
      this.code,
      this.name,
      this.description,
      this.sortOrder,
      this.isActive,
      this.createdBy,
      this.createdOn,
      this.lastModifiedOn,
      this.referenceData});

  RefundStatus.fromJson(Map<String, dynamic> json) {
    id = json[parameters.strId];
    code = json[parameters.strCode];
    name = json[parameters.strName];
    description = json[parameters.strDescription];
    sortOrder = json[parameters.strSortOrder];
    isActive = json[parameters.strIsActive];
    createdBy = json[parameters.strCreatedBy];
    createdOn = json[parameters.strCreatedOn];
    lastModifiedOn = json[parameters.strLastModifiedOn];
    referenceData = json[parameters.strReferenceData] != null
        ? new ReferenceData.fromJson(json[parameters.strReferenceData])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data[parameters.strId] = this.id;
    data[parameters.strCode] = this.code;
    data[parameters.strName] = this.name;
    data[parameters.strDescription] = this.description;
    data[parameters.strSortOrder] = this.sortOrder;
    data[parameters.strIsActive] = this.isActive;
    data[parameters.strCreatedBy] = this.createdBy;
    data[parameters.strCreatedOn] = this.createdOn;
    data[parameters.strLastModifiedOn] = this.lastModifiedOn;
    if (this.referenceData != null) {
      data[parameters.strReferenceData] = this.referenceData.toJson();
    }
    return data;
  }
}
