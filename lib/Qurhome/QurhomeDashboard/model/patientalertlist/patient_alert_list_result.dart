import 'package:myfhb/Qurhome/QurhomeDashboard/model/patientalertlist/patient_alert_data.dart';

class PatientAlertListResult {
  int? totalRecord;
  String? currentPage;
  int? totalPage;
  List<PatientAlertData>? data;

  PatientAlertListResult(
      {this.totalRecord, this.currentPage, this.totalPage, this.data});

  PatientAlertListResult.fromJson(Map<String, dynamic> json) {
    totalRecord = json['totalRecord'];
    currentPage = json['currentPage'];
    totalPage = json['totalPage'];
    if (json['data'] != null) {
      data = <PatientAlertData>[];
      json['data'].forEach((v) {
        data!.add(new PatientAlertData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['totalRecord'] = this.totalRecord;
    data['currentPage'] = this.currentPage;
    data['totalPage'] = this.totalPage;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}