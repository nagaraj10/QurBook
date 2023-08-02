import 'package:myfhb/Qurhome/QurhomeDashboard/model/patientalertlist/patient_alert_list_result.dart';
import 'package:myfhb/common/CommonUtil.dart';

class PatientAlertListModel {
  bool? isSuccess;
  PatientAlertListResult? result;
  Diagnostics? diagnostics;

  PatientAlertListModel({this.isSuccess, this.result});

  PatientAlertListModel.fromJson(Map<String, dynamic> json) {
    try {
      isSuccess = json['isSuccess'];
      result = json.containsKey('result')
              ? json['result'] != null
                  ? new PatientAlertListResult.fromJson(json['result'])
                  : null
              : null;
      diagnostics = json.containsKey('diagnostics')
              ? json['diagnostics'] != null
                  ? new Diagnostics.fromJson(json['diagnostics'])
                  : null
              : null;
    } catch (e) {
      CommonUtil().appLogs(message: e.toString());
    }
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

class Diagnostics {


	Diagnostics();

	Diagnostics.fromJson(Map<String, dynamic> json) {
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		return data;
	}
}
