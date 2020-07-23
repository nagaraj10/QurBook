import 'package:myfhb/telehealth/features/MyProvider/model/provider_model/Degree.dart';
import 'package:myfhb/telehealth/features/MyProvider/model/provider_model/UniversityModel.dart';

import 'package:myfhb/constants/fhb_parameters.dart' as parameters;

class QualificationInfo {
  List<Degree> degree;
  List<University> university;

  QualificationInfo({this.degree, this.university});

  QualificationInfo.fromJson(Map<String, dynamic> json) {
    if (json[parameters.strdegree] != null) {
      degree = new List<Degree>();
      json[parameters.strdegree].forEach((v) {
        degree.add(new Degree.fromJson(v));
      });
    }
    if (json[parameters.struniversity] != null) {
      university = new List<University>();
      json[parameters.struniversity].forEach((v) {
        university.add(new University.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.degree != null) {
      data[parameters.strdegree] = this.degree.map((v) => v.toJson()).toList();
    }
    if (this.university != null) {
      data[parameters.struniversity] = this.university.map((v) => v.toJson()).toList();
    }
    return data;
  }
}