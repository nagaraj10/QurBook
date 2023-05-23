import 'package:myfhb/Qurhome/QurhomeDashboard/model/patientalertlist/patient_alert_list_result.dart';

class PatientAlertListModel {
  bool? isSuccess;
  PatientAlertListResult? result;

  PatientAlertListModel({this.isSuccess, this.result});

  PatientAlertListModel.fromJson(Map<String, dynamic> json) {
    isSuccess = json['isSuccess'];
    result = json['result'] != null
        ? new PatientAlertListResult.fromJson(json['result'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['isSuccess'] = this.isSuccess;
    if (this.result != null) {
      data['result'] = this.result!.toJson();
    }
    return data;
  }
}
