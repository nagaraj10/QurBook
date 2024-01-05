
import 'package:myfhb/common/CommonUtil.dart';

class CaregiverCommunicationSetting {
  bool? vitals;
  bool? symptoms;
  bool? appointments;

  CaregiverCommunicationSetting(
      {this.vitals, this.symptoms, this.appointments});

  CaregiverCommunicationSetting.fromJson(Map<String, dynamic> json) {
    try {
      vitals = json['vitals'];
      symptoms = json['symptoms'];
      appointments = json['appointments'];
    } catch (e,stackTrace) {
      CommonUtil().appLogs(message: e,stackTrace:stackTrace);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['vitals'] = this.vitals;
    data['symptoms'] = this.symptoms;
    data['appointments'] = this.appointments;
    return data;
  }
}