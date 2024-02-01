import 'dart:convert';

DoctorSpecializationModel doctorSpecializationModelFromJson(String str) => DoctorSpecializationModel.fromJson(json.decode(str));

String doctorSpecializationModelToJson(DoctorSpecializationModel data) => json.encode(data.toJson());

class DoctorSpecializationModel {
  bool? isSuccess;
  List<DoctorSpecialization>? result;

  DoctorSpecializationModel({
    this.isSuccess,
    this.result,
  });

  factory DoctorSpecializationModel.fromJson(Map<String, dynamic> json) => DoctorSpecializationModel(
        isSuccess: json["isSuccess"],
        result: json["result"] == null ? [] : List<DoctorSpecialization>.from(json["result"]!.map((x) => DoctorSpecialization.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "isSuccess": isSuccess,
        "result": result == null ? [] : List<dynamic>.from(result!.map((x) => x.toJson())),
      };
}

class DoctorSpecialization {
  String? specialization;
  String? doctorId;

  DoctorSpecialization({
    this.specialization,
    this.doctorId,
  });

  factory DoctorSpecialization.fromJson(Map<String, dynamic> json) => DoctorSpecialization(
        specialization: json["specialization"],
        doctorId: json["doctorId"],
      );

  Map<String, dynamic> toJson() => {
        "specialization": specialization,
        "doctorId": doctorId,
      };
}
