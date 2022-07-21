class DoctorsSearchListResponse {
  bool isSuccess;
  String message;
  List<DoctorsListResult> result;
  Diagnostics diagnostics;

  DoctorsSearchListResponse(
      {this.isSuccess, this.message, this.result, this.diagnostics});

  DoctorsSearchListResponse.fromJson(Map<String, dynamic> json) {
    isSuccess = json['isSuccess'];
    message = json['message'];
    if (json.containsKey('result')) {
      if (json['result'] != null) {
        result = List<DoctorsListResult>();
        json['result'].forEach((v) {
          result.add(DoctorsListResult.fromJson(v));
        });
      }
    }
    if (json.containsKey('diagnostics')) {
      diagnostics = json['diagnostics'] != null
          ? Diagnostics.fromJson(json['diagnostics'])
          : null;
    }
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['isSuccess'] = isSuccess;
    data['message'] = message;
    if (result != null) {
      data['result'] = result.map((v) => v.toJson()).toList();
    }
    if (diagnostics != null) {
      data['diagnostics'] = diagnostics.toJson();
    }

    return data;
  }
}

class DoctorsListResult {
  String doctorId;
  String userId;
  String name;
  String firstName;
  String lastName;
  String specialization;
  String city;
  String state;
  String doctorReferenceId;
  String addressLine1;
  String specialty;
  String addressLine2;
  String profilePicThumbnailUrl;
  bool isTelehealthEnabled;
  bool isMciVerified;
  bool patientAssociationRequest;

  DoctorsListResult(
      {this.doctorId,
      this.userId,
      this.name,
      this.firstName,
      this.lastName,
      this.specialization,
      this.city,
      this.state,
      this.doctorReferenceId,
      this.addressLine1,
      this.specialty,
      this.addressLine2,
      this.profilePicThumbnailUrl,
      this.isTelehealthEnabled,
      this.isMciVerified,
      this.patientAssociationRequest});

  DoctorsListResult.fromJson(Map<String, dynamic> json) {
    doctorId = json['doctorId'];
    userId = json['userId'];
    name = json['name'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    specialization = json['specialization'];
    city = json['city'];
    state = json['state'];
    doctorReferenceId = json['doctorReferenceId'];
    addressLine1 = json['addressLine1'];
    specialty = json['specialty'];
    addressLine2 = json['addressLine2'];
    profilePicThumbnailUrl = json['profilePicThumbnailUrl'];
    isTelehealthEnabled = json['isTelehealthEnabled'];
    isMciVerified = json['isMciVerified'];
    patientAssociationRequest = json['patientAssociationRequest'];
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
    data['doctorReferenceId'] = doctorReferenceId;
    data['addressLine1'] = addressLine1;
    data['specialty'] = specialty;
    data['addressLine2'] = addressLine2;
    data['profilePicThumbnailUrl'] = profilePicThumbnailUrl;
    data['isTelehealthEnabled'] = isTelehealthEnabled;
    data['isMciVerified'] = isMciVerified;
    data['patientAssociationRequest'] = patientAssociationRequest;
    return data;
  }
}

class Diagnostics {
  DoctorsListResult errorData;
  bool includeErrorDataInResponse;

  Diagnostics({this.errorData, this.includeErrorDataInResponse});

  Diagnostics.fromJson(Map<String, dynamic> json) {
    errorData = json['errorData'] != null
        ? DoctorsListResult.fromJson(json['errorData'])
        : null;
    includeErrorDataInResponse = json['includeErrorDataInResponse'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    if (errorData != null) {
      data['errorData'] = errorData.toJson();
    }
    data['includeErrorDataInResponse'] = includeErrorDataInResponse;
    return data;
  }
}
