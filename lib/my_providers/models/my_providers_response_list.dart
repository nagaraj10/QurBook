import '../../constants/fhb_parameters.dart' as parameters;
import 'DoctorModel.dart';
import 'HospitalModel.dart';
import 'LaborartoryModel.dart';
import 'ProfilePic.dart';

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
        ? Response.fromJson(json[parameters.strResponse])
        : null;
  }

  Map<String, dynamic> toJson() {
    final data = Map<String, dynamic>();
    data[parameters.strStatus] = status;
    data[parameters.strSuccess] = success;
    data[parameters.strMessage] = message;
    if (response != null) {
      data[parameters.strResponse] = response.toJson();
    }
    return data;
  }
}

class Response {
  MyProvidersData data;

  Response({this.data});

  Response.fromJson(Map<String, dynamic> json) {
    data = json[parameters.strData] != null
        ? MyProvidersData.fromJson(json[parameters.strData])
        : null;
  }

  Map<String, dynamic> toJson() {
    final data = Map<String, dynamic>();
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
    final Map<String, dynamic> medicalJson = json[parameters.strmedicalPreferences];

    if (medicalJson != null) {
      final Map<String, dynamic> preferencesJson = medicalJson[parameters.strpreferences];

      if (preferencesJson != null) {
        if (preferencesJson[parameters.strdoctorIds] != null) {
          doctorsModel = List<DoctorsModel>();
          preferencesJson[parameters.strdoctorIds].forEach((v) {
            doctorsModel.add(DoctorsModel.fromJson(v));
          });
        }
        if (preferencesJson[parameters.strlaboratoryIds] != null) {
          laboratoryModel = <LaboratoryModel>[];
          preferencesJson[parameters.strlaboratoryIds].forEach((v) {
            laboratoryModel.add(LaboratoryModel.fromJson(v));
          });
        }
        if (preferencesJson[parameters.strhospitalIds] != null) {
          hospitalsModel = <HospitalsModel>[];
          preferencesJson[parameters.strhospitalIds].forEach((v) {
            hospitalsModel.add(HospitalsModel.fromJson(v));
          });
        }
      }
    }
  }

  Map<String, dynamic> toJson() {
    final data = Map<String, dynamic>();
    if (doctorsModel != null) {
      data[parameters.strdoctorIds] = doctorsModel.map((v) => v.toJson()).toList();
    }
    if (laboratoryModel != null) {
      data[parameters.strlaboratoryIds] =
          laboratoryModel.map((v) => v.toJson()).toList();
    }
    if (hospitalsModel != null) {
      data[parameters.strhospitalIds] = hospitalsModel.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
