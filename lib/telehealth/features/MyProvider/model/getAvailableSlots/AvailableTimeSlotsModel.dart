
import 'package:myfhb/common/CommonUtil.dart';
import 'package:myfhb/constants/fhb_parameters.dart';
import 'package:myfhb/telehealth/features/MyProvider/model/getAvailableSlots/SlotsResultModel.dart';

class AvailableTimeSlotsModel {
  bool? isSuccess;
  SlotsResultModel? result;
  String? message;

  AvailableTimeSlotsModel({this.isSuccess, this.result,this.message});

  AvailableTimeSlotsModel.fromJson(Map<String, dynamic> json) {
    try {
      isSuccess = json[strIsSuccess];
      message = json [strMessage];
      result = json[strResult] != null
              ? SlotsResultModel.fromJson(json[strResult])
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
