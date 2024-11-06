import 'package:myfhb/common/CommonUtil.dart';

class CareGiverPatientList {
  bool? isSuccess;
  List<CareGiverPatientListResult?>? result;

  CareGiverPatientList({this.isSuccess, this.result});

  CareGiverPatientList.fromJson(Map<String, dynamic> json) {
    try {
      isSuccess = json['isSuccess'];
      if (json['result'] != null) {
            result = <CareGiverPatientListResult>[];
            json['result'].forEach((v) {
              result!.add(CareGiverPatientListResult.fromJson(v));
            });
          }
    } catch (e,stackTrace) {
      CommonUtil().appLogs(message: e,stackTrace:stackTrace);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['isSuccess'] = isSuccess;
    data['result'] =
        result != null ? result!.map((v) => v?.toJson()).toList() : null;
    return data;
  }
}

class CareGiverPatientListResult {
  String? childId;
  String? firstName;
  String? middleName;
  String? lastName;
  String? relationship;

  CareGiverPatientListResult(
      {this.childId,
      this.firstName,
      this.middleName,
      this.lastName,
      this.relationship});

  CareGiverPatientListResult.fromJson(Map<String, dynamic> json) {
    try {
      childId = json['childId'];
      firstName = json['firstName'];
      middleName = json['middleName'];
      lastName = json['lastName'];
      relationship = json['relationship'];
    } catch (e,stackTrace) {
      CommonUtil().appLogs(message: e,stackTrace:stackTrace);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['childId'] = childId;
    data['firstName'] = firstName;
    data['middleName'] = middleName;
    data['lastName'] = lastName;
    data['relationship'] = relationship;
    return data;
  }
}
