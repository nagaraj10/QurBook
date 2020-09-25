
import 'package:myfhb/constants/fhb_parameters.dart';
import 'package:myfhb/telehealth/features/MyProvider/model/SlotsResultModel.dart';

class AvailableTimeSlotsModel {

  bool isSuccess;
  SlotsResultModel result;

  AvailableTimeSlotsModel({this.isSuccess, this.result});

  AvailableTimeSlotsModel.fromJson(Map<String, dynamic> json) {
    isSuccess = json[IS_SUCCESS];
    result =
    json[RESULT] != null ? new SlotsResultModel.fromJson(json[RESULT]) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data[IS_SUCCESS] = this.isSuccess;
    if (this.result != null) {
      data[RESULT] = this.result.toJson();
    }
    return data;
  }
}