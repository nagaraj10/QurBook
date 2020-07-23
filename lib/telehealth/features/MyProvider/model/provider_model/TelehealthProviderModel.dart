import 'package:myfhb/src/model/user/HospitalIds.dart';
import 'package:myfhb/telehealth/features/MyProvider/model/provider_model/DoctorIds.dart';
import 'package:myfhb/telehealth/features/MyProvider/model/provider_model/LaboratoryIds.dart';

import 'package:myfhb/constants/fhb_parameters.dart' as parameters;


class TelehealthProviderModel {
  int status;
  bool success;
  String message;
  Response response;

  TelehealthProviderModel(
      {this.status, this.success, this.message, this.response});

  TelehealthProviderModel.fromJson(Map<String, dynamic> json) {
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
  int count;
  Data data;

  Response({this.count, this.data});

  Response.fromJson(Map<String, dynamic> json) {
    count = json[parameters.strCount];
    data = json[parameters.strData] != null ? new Data.fromJson(json[parameters.strData]) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data[parameters.strCount] = this.count;
    if (this.data != null) {
      data[parameters.strData] = this.data.toJson();
    }
    return data;
  }
}

class Data {
  MedicalPreferences medicalPreferences;

  Data({this.medicalPreferences});

  Data.fromJson(Map<String, dynamic> json) {
    medicalPreferences = json[parameters.strmedicalPreferences] != null
        ? new MedicalPreferences.fromJson(json[parameters.strmedicalPreferences])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.medicalPreferences != null) {
      data[parameters.strmedicalPreferences] = this.medicalPreferences.toJson();
    }
    return data;
  }
}

class MedicalPreferences {
  Preferences preferences;

  MedicalPreferences({this.preferences});

  MedicalPreferences.fromJson(Map<String, dynamic> json) {
    preferences = json[parameters.strpreferences] != null
        ? new Preferences.fromJson(json[parameters.strpreferences])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.preferences != null) {
      data[parameters.strpreferences] = this.preferences.toJson();
    }
    return data;
  }
}

class Preferences {
  List<DoctorIds> doctorIds;
  List<HospitalIds> hospitalIds;
  List<LaboratoryIds> laboratoryIds;

  Preferences({this.doctorIds, this.hospitalIds, this.laboratoryIds});

  Preferences.fromJson(Map<String, dynamic> json) {
    if (json[parameters.strdoctorIds] != null) {
      doctorIds = new List<DoctorIds>();
      json[parameters.strdoctorIds].forEach((v) {
        doctorIds.add(new DoctorIds.fromJson(v));
      });
    }
    if (json[parameters.strhospitalIds] != null) {
      hospitalIds = new List<HospitalIds>();
      json[parameters.strhospitalIds].forEach((v) {
        hospitalIds.add(new HospitalIds.fromJson(v));
      });
    }
    if (json[parameters.strlaboratoryIds] != null) {
      laboratoryIds = new List<LaboratoryIds>();
      json[parameters.strlaboratoryIds].forEach((v) {
        laboratoryIds.add(new LaboratoryIds.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.doctorIds != null) {
      data[parameters.strdoctorIds] = this.doctorIds.map((v) => v.toJson()).toList();
    }
    if (this.hospitalIds != null) {
      data[parameters.strhospitalIds] = this.hospitalIds.map((v) => v.toJson()).toList();
    }
    if (this.laboratoryIds != null) {
      data[parameters.strlaboratoryIds] =
          this.laboratoryIds.map((v) => v.toJson()).toList();
    }
    return data;
  }
}




















