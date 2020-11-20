import 'package:myfhb/constants/fhb_parameters.dart';
import 'package:myfhb/telehealth/features/MyProvider/model/getAvailableSlots/SlotsResultModel.dart';

class AvailableTimeSlotsModel {

  bool isSuccess;
  SlotsResultModel result;

  AvailableTimeSlotsModel({this.isSuccess, this.result});

  AvailableTimeSlotsModel.fromJson(Map<String, dynamic> json) {
    isSuccess = json[strIsSuccess];
    result =
    json[strResult] != null ? new SlotsResultModel.fromJson(json[strResult]) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data[strIsSuccess] = this.isSuccess;
    if (this.result != null) {
      data[strResult] = this.result.toJson();
    }
    return data;
  }
}