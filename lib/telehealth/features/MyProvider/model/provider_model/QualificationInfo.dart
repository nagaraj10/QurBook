
import 'package:myfhb/common/CommonUtil.dart';
import 'package:myfhb/telehealth/features/MyProvider/model/provider_model/Degree.dart';
import 'package:myfhb/telehealth/features/MyProvider/model/provider_model/UniversityModel.dart';

import 'package:myfhb/constants/fhb_parameters.dart' as parameters;

class QualificationInfo {
  List<Degree>? degree;
  List<University>? university;

  QualificationInfo({this.degree, this.university});

  QualificationInfo.fromJson(Map<String, dynamic> json) {
    try {
      if (json[parameters.strdegree] != null) {
            degree = <Degree>[];
            json[parameters.strdegree].forEach((v) {
              degree!.add(Degree.fromJson(v));
            });
          }
      if (json[parameters.struniversity] != null) {
            university = <University>[];
            json[parameters.struniversity].forEach((v) {
              university!.add(University.fromJson(v));
            });
          }
    } catch (e,stackTrace) {
      CommonUtil().appLogs(message: e,stackTrace:stackTrace);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    if (this.degree != null) {
      data[parameters.strdegree] = this.degree!.map((v) => v.toJson()).toList();
    }
    if (this.university != null) {
      data[parameters.struniversity] = this.university!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}