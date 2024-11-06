
import 'package:myfhb/common/CommonUtil.dart';
import 'package:myfhb/constants/fhb_parameters.dart';
import 'package:myfhb/telehealth/features/MyProvider/model/appointments/CreateAppointmentResult.dart';

class CreateAppointmentModel {
  bool? isSuccess;
  String? message;
  CreateAppointmentResult? result;

  CreateAppointmentModel({this.isSuccess, this.message, this.result});

  CreateAppointmentModel.fromJson(Map<String, dynamic> json) {
    try {
      isSuccess = json[strIsSuccess];
      message = json[strMessage];
      result =
          json[strResult] != null
              ? CreateAppointmentResult.fromJson(json[strResult])
              : null;
    } catch (e,stackTrace) {
      CommonUtil().appLogs(message: e,stackTrace:stackTrace);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data[strIsSuccess] = this.isSuccess;
    data[strMessage] = this.message;
    if (this.result != null) {
      data[strResult] = this.result!.toJson();
    }
    return data;
  }
}

