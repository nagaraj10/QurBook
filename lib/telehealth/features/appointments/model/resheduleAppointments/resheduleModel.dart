
import 'package:myfhb/common/CommonUtil.dart';
import 'package:myfhb/telehealth/features/appointments/constants/appointments_parameters.dart'as parameters;
import 'package:myfhb/telehealth/features/appointments/model/resheduleAppointments/resheduleResult.dart';

class ResheduleModel {
  bool? isSuccess;
  String? message;
  ResheduleResult? result;

  ResheduleModel({this.isSuccess, this.message, this.result});

  ResheduleModel.fromJson(Map<String, dynamic> json) {
    try {
      isSuccess = json['isSuccess'];
      message = json['message'];
      result = json['result'] != null ? ResheduleResult.fromJson(json['result']) : null;
    } catch (e,stackTrace) {
      CommonUtil().appLogs(message: e,stackTrace:stackTrace);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['isSuccess'] = this.isSuccess;
    data['message'] = this.message;
    if (this.result != null) {
      data['result'] = this.result!.toJson();
    }
    return data;
  }
}