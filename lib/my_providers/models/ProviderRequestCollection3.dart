
import 'package:myfhb/common/CommonUtil.dart';
import 'package:myfhb/my_providers/models/Doctors.dart';

class ProviderRequestCollection3 {
  String? id;
  String? userPhoneNumber;
  bool? isActive;
  String? createdOn;
  String? lastModifiedOn;
  String? patientInfo;
  Doctors? doctor;

  ProviderRequestCollection3(
      {this.id,
      this.userPhoneNumber,
      this.isActive,
      this.createdOn,
      this.lastModifiedOn,
      this.patientInfo,
      this.doctor});

  ProviderRequestCollection3.fromJson(Map<String, dynamic> json) {
    try {
      id = json['id'];
      userPhoneNumber = json['userPhoneNumber'];
      isActive = json['isActive'];
      createdOn = json['createdOn'];
      lastModifiedOn = json['lastModifiedOn'];
      patientInfo = json['patientInfo'];
      doctor =
              json['doctor'] != null ? new Doctors.fromJson(json['doctor']) : null;
    } catch (e) {
      CommonUtil().appLogs(message: e.toString());
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['userPhoneNumber'] = this.userPhoneNumber;
    data['isActive'] = this.isActive;
    data['createdOn'] = this.createdOn;
    data['lastModifiedOn'] = this.lastModifiedOn;
    data['patientInfo'] = this.patientInfo;
    if (this.doctor != null) {
      data['doctor'] = this.doctor!.toJson();
    }
    return data;
  }
}
