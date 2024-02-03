import 'package:myfhb/common/CommonUtil.dart';

class DoctorsSearchListResponse {
  bool? isSuccess;
  String? message;
  List<DoctorsListResult>? result;
  Diagnostics? diagnostics;

  DoctorsSearchListResponse({this.isSuccess, this.message, this.result, this.diagnostics});

  DoctorsSearchListResponse.fromJson(Map<String, dynamic> json) {
    try {
      isSuccess = json['isSuccess'];
      message = json['message'];
      if (json.containsKey('result')) {
        if (json['result'] != null) {
          result = <DoctorsListResult>[];
          json['result'].forEach((v) {
            result!.add(DoctorsListResult.fromJson(v));
          });
        }
      }
      if (json.containsKey('diagnostics')) {
        diagnostics = json['diagnostics'] != null ? Diagnostics.fromJson(json['diagnostics']) : null;
      }
    } catch (e, stackTrace) {
      CommonUtil().appLogs(message: e, stackTrace: stackTrace);
    }
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['isSuccess'] = isSuccess;
    data['message'] = message;
    if (result != null) {
      data['result'] = result!.map((v) => v.toJson()).toList();
    }
    if (diagnostics != null) {
      data['diagnostics'] = diagnostics!.toJson();
    }

    return data;
  }
}

class DoctorsListResult {
  String? doctorId;
  String? userId;
  String? name;
  String? firstName;
  String? lastName;
  String? specialization;
  String? city;
  String? state;
  String? doctorReferenceId;
  String? addressLine1;
  String? specialty;
  String? addressLine2;
  String? profilePicThumbnailUrl;
  bool? isTelehealthEnabled;
  bool? isMciVerified;
  String? healthOrganizationName;
  bool? patientAssociationRequest;
  List<String>? doctorLanguage;
  String? gender;
  dynamic experience;

  DoctorsListResult(
      {this.doctorId,
      this.userId,
      this.name,
      this.firstName,
      this.lastName,
      this.specialization,
      this.doctorReferenceId,
      this.city,
      this.state,
      this.healthOrganizationName,
      this.doctorLanguage,
      this.gender,
      this.experience,
      this.addressLine1,
      this.specialty,
      this.addressLine2,
      this.profilePicThumbnailUrl,
      this.isTelehealthEnabled,
      this.isMciVerified,
      this.patientAssociationRequest});

  DoctorsListResult.fromJson(Map<String, dynamic> json) {
    try {
      doctorId = json['doctorId']??'';
      userId = json['userId']??'';
      name = json['name']??'';
      gender = json['gender']??'';
      firstName = json['firstName']??'';
      lastName = json['lastName']??'';
      specialization = json['specialization']??'';
      doctorReferenceId = json['doctorReferenceId']??'';
      city = json['city']??'';
      state = json['state']??'';
      experience = json['experience']??'0';
      addressLine1 = json['addressLine1']??'';
      specialty = json['specialty']??'';
      addressLine2 = json['addressLine2']??'';
      healthOrganizationName = json['healthOrganizationName']??'';
      profilePicThumbnailUrl = json['profilePicThumbnailUrl']??'';
      isTelehealthEnabled = json['isTelehealthEnabled']??false;
      isMciVerified = json['isMciVerified']??false;
      patientAssociationRequest = json['patientAssociationRequest']??false;
      doctorLanguage = List<String>.from(json['doctorLanguage'] ?? []);
      // Check if doctorLanguage is not null and has elements
      if (doctorLanguage != null && (doctorLanguage?.length ?? 0) > 0) {
        // Convert the doctorLanguage list to a Set to remove duplicates, then back to a List
        doctorLanguage = doctorLanguage?.toSet().toList();
      }

    } catch (e, stackTrace) {
      CommonUtil().appLogs(message: e, stackTrace: stackTrace);
    }
  }

  Map<String, dynamic> toJson() {
    final data = Map<String, dynamic>();
    data['doctorId'] = doctorId;
    data['userId'] = userId;
    data['name'] = name;
    data['firstName'] = firstName;
    data['lastName'] = lastName;
    data['specialization'] = specialization;
    data['city'] = city;
    data['state'] = state;
    // data['doctorReferenceId'] = doctorReferenceId;
    data['addressLine1'] = addressLine1;
    data['specialty'] = specialty;
    data['addressLine2'] = addressLine2;
    data['profilePicThumbnailUrl'] = profilePicThumbnailUrl;
    data['isTelehealthEnabled'] = isTelehealthEnabled;
    data['isMciVerified'] = isMciVerified;
    data['patientAssociationRequest'] = patientAssociationRequest;
    data['experience'] = experience;
    return data;
  }
}

class Diagnostics {
  DoctorsListResult? errorData;
  bool? includeErrorDataInResponse;

  Diagnostics({this.errorData, this.includeErrorDataInResponse});

  Diagnostics.fromJson(Map<String, dynamic> json) {
    try {
      errorData = json['errorData'] != null ? DoctorsListResult.fromJson(json['errorData']) : null;
      includeErrorDataInResponse = json['includeErrorDataInResponse'];
    } catch (e, stackTrace) {
      CommonUtil().appLogs(message: e, stackTrace: stackTrace);
    }
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    if (errorData != null) {
      data['errorData'] = errorData!.toJson();
    }
    data['includeErrorDataInResponse'] = includeErrorDataInResponse;
    return data;
  }
}
