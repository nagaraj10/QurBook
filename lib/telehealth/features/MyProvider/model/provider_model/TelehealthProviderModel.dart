
import 'package:myfhb/common/CommonUtil.dart';
import 'package:myfhb/src/model/user/HospitalIds.dart';
import 'package:myfhb/telehealth/features/MyProvider/model/provider_model/DoctorIds.dart';
import 'package:myfhb/telehealth/features/MyProvider/model/provider_model/LaboratoryIds.dart';

import 'package:myfhb/constants/fhb_parameters.dart' as parameters;


class TelehealthProviderModel {
  int? status;
  bool? success;
  String? message;
  Response? response;

  TelehealthProviderModel(
      {this.status, this.success, this.message, this.response});

  TelehealthProviderModel.fromJson(Map<String, dynamic> json) {
    try {
      status = json[parameters.strStatus];
      success = json[parameters.strSuccess];
      message = json[parameters.strMessage];
      response = json[parameters.strResponse] != null
              ? Response.fromJson(json[parameters.strResponse])
              : null;
    } catch (e,stackTrace) {
      CommonUtil().appLogs(message: e,stackTrace:stackTrace);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data[parameters.strStatus] = this.status;
    data[parameters.strSuccess] = this.success;
    data[parameters.strMessage] = this.message;
    if (this.response != null) {
      data[parameters.strResponse] = this.response!.toJson();
    }
    return data;
  }
}

class Response {
  int? count;
  Data? data;

  Response({this.count, this.data});

  Response.fromJson(Map<String, dynamic> json) {
    try {
      count = json[parameters.strCount];
      data = json[parameters.strData] != null ? Data.fromJson(json[parameters.strData]) : null;
    } catch (e,stackTrace) {
      CommonUtil().appLogs(message: e,stackTrace:stackTrace);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data[parameters.strCount] = this.count;
    if (this.data != null) {
      data[parameters.strData] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  MedicalPreferences? medicalPreferences;

  Data({this.medicalPreferences});

  Data.fromJson(Map<String, dynamic> json) {
    try {
      medicalPreferences = json[parameters.strmedicalPreferences] != null
              ? MedicalPreferences.fromJson(json[parameters.strmedicalPreferences])
              : null;
    } catch (e,stackTrace) {
      CommonUtil().appLogs(message: e,stackTrace:stackTrace);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    if (this.medicalPreferences != null) {
      data[parameters.strmedicalPreferences] = this.medicalPreferences!.toJson();
    }
    return data;
  }
}

class MedicalPreferences {
  Preferences? preferences;

  MedicalPreferences({this.preferences});

  MedicalPreferences.fromJson(Map<String, dynamic> json) {
    try {
      preferences = json[parameters.strpreferences] != null
              ? Preferences.fromJson(json[parameters.strpreferences])
              : null;
    } catch (e,stackTrace) {
      CommonUtil().appLogs(message: e,stackTrace:stackTrace);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    if (this.preferences != null) {
      data[parameters.strpreferences] = this.preferences!.toJson();
    }
    return data;
  }
}

class Preferences {
  List<DoctorIds>? doctorIds;
  List<HospitalIds>? hospitalIds;
  List<LaboratoryIds>? laboratoryIds;

  Preferences({this.doctorIds, this.hospitalIds, this.laboratoryIds});

  Preferences.fromJson(Map<String, dynamic> json) {
    try {
      if (json[parameters.strdoctorIds] != null) {
            doctorIds = <DoctorIds>[];
            json[parameters.strdoctorIds].forEach((v) {
              doctorIds!.add(DoctorIds.fromJson(v));
            });
          }
      if (json[parameters.strhospitalIds] != null) {
            hospitalIds = <HospitalIds>[];
            json[parameters.strhospitalIds].forEach((v) {
              hospitalIds!.add(HospitalIds.fromJson(v));
            });
          }
      if (json[parameters.strlaboratoryIds] != null) {
            laboratoryIds = <LaboratoryIds>[];
            json[parameters.strlaboratoryIds].forEach((v) {
              laboratoryIds!.add(LaboratoryIds.fromJson(v));
            });
          }
    } catch (e,stackTrace) {
      CommonUtil().appLogs(message: e,stackTrace:stackTrace);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    if (this.doctorIds != null) {
      data[parameters.strdoctorIds] = this.doctorIds!.map((v) => v.toJson()).toList();
    }
    if (this.hospitalIds != null) {
      data[parameters.strhospitalIds] = this.hospitalIds!.map((v) => v.toJson()).toList();
    }
    if (this.laboratoryIds != null) {
      data[parameters.strlaboratoryIds] =
          this.laboratoryIds!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}




















