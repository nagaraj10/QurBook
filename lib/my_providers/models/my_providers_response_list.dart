import 'package:myfhb/constants/fhb_parameters.dart' as parameters;
import 'package:myfhb/my_providers/models/DoctorModel.dart';
import 'package:myfhb/my_providers/models/HospitalModel.dart';
import 'package:myfhb/my_providers/models/LaborartoryModel.dart';
import 'package:myfhb/my_providers/models/ProfilePic.dart';

class MyProvidersResponseList {
  int status;
  bool success;
  String message;
  Response response;

  MyProvidersResponseList(
      {this.status, this.success, this.message, this.response});

  MyProvidersResponseList.fromJson(Map<String, dynamic> json) {
    status = json[parameters.strStatus];
    success = json[parameters.strSuccess];
    message = json[parameters.strMessage];
    response = json[parameters.strResponse] != null
        ? new Response.fromJson(json[parameters.strResponse])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data[parameters.strStatus] = this.status;
    data[parameters.strSuccess] = this.success;
    data[parameters.strMessage] = this.message;
    if (this.response != null) {
      data[parameters.strResponse] = this.response.toJson();
    }
    return data;
  }
}

class Response {
  MyProvidersData data;

  Response({this.data});

  Response.fromJson(Map<String, dynamic> json) {
    data = json[parameters.strData] != null
        ? new MyProvidersData.fromJson(json[parameters.strData])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data[parameters.strData] = this.data.toJson();
    }
    return data;
  }
}

class MyProvidersData {
  List<DoctorsModel> doctorsModel;
  List<LaboratoryModel> laboratoryModel;
  List<HospitalsModel> hospitalsModel;

  MyProvidersData(
      {this.doctorsModel, this.laboratoryModel, this.hospitalsModel});

  MyProvidersData.fromJson(Map<String, dynamic> json) {
    Map<String, dynamic> medicalJson = json[parameters.strmedicalPreferences];

    if (medicalJson != null) {
      Map<String, dynamic> preferencesJson = medicalJson[parameters.strpreferences];

      if (preferencesJson != null) {
        if (preferencesJson[parameters.strdoctorIds] != null) {
          doctorsModel = new List<DoctorsModel>();
          preferencesJson[parameters.strdoctorIds].forEach((v) {
            doctorsModel.add(new DoctorsModel.fromJson(v));
          });
        }
        if (preferencesJson[parameters.strlaboratoryIds] != null) {
          laboratoryModel = new List<LaboratoryModel>();
          preferencesJson[parameters.strlaboratoryIds].forEach((v) {
            laboratoryModel.add(new LaboratoryModel.fromJson(v));
          });
        }
        if (preferencesJson[parameters.strhospitalIds] != null) {
          hospitalsModel = new List<HospitalsModel>();
          preferencesJson[parameters.strhospitalIds].forEach((v) {
            hospitalsModel.add(new HospitalsModel.fromJson(v));
          });
        }
      }
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.doctorsModel != null) {
      data[parameters.strdoctorIds] = this.doctorsModel.map((v) => v.toJson()).toList();
    }
    if (this.laboratoryModel != null) {
      data[parameters.strlaboratoryIds] =
          this.laboratoryModel.map((v) => v.toJson()).toList();
    }
    if (this.hospitalsModel != null) {
      data[parameters.strhospitalIds] = this.hospitalsModel.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
