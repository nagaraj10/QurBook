
import 'package:myfhb/common/CommonUtil.dart';
import 'package:myfhb/telehealth/features/MyProvider/model/Data.dart';
class GetAllPatientsModel {
  String? status;
  List<Data>? data;

  GetAllPatientsModel({this.status, this.data});

  GetAllPatientsModel.fromJson(Map<String, dynamic> json) {
    try {
      status = json['status'];
      if (json['data'] != null) {
            data = <Data>[];
            json['data'].forEach((v) {
              data!.add(Data.fromJson(v));
            });
          }
    } catch (e,stackTrace) {
      CommonUtil().appLogs(message: e,stackTrace:stackTrace);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['status'] = this.status;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

