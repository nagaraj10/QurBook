import 'package:myfhb/Qurhome/QurhomeDashboard/model/patientalertlist/patient_alert_data.dart';
import 'package:myfhb/common/CommonUtil.dart';

class PatientAlertListResult {
  int? totalRecord;
  String? currentPage;
  int? totalPage;
  String? healthOrganizationId;
  List<PatientAlertData>? data;

  PatientAlertListResult(
      {this.totalRecord, this.currentPage, this.totalPage,this.healthOrganizationId, this.data});

  PatientAlertListResult.fromJson(Map<String, dynamic> json) {
    try {
      totalRecord = json['totalRecord'];
      currentPage = json['currentPage'];
      totalPage = json['totalPage'];
      healthOrganizationId = json['healthOrganizationId'];
      if (json['data'] != null) {
            data = <PatientAlertData>[];
            json['data'].forEach((v) {
              data!.add(new PatientAlertData.fromJson(v));
            });
          }
    } catch (e,stackTrace) {
      CommonUtil().appLogs(message: e,stackTrace:stackTrace);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['totalRecord'] = this.totalRecord;
    data['currentPage'] = this.currentPage;
    data['totalPage'] = this.totalPage;
    data['healthOrganizationId'] = this.healthOrganizationId;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
