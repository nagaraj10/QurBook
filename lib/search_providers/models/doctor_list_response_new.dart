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
        result = new List<DoctorsListResult>();
        json['result'].forEach((v) {
          result.add(new DoctorsListResult.fromJson(v));
        });
      }
    }
    if (json.containsKey('diagnostics')) {
      diagnostics = json['diagnostics'] != null
          ? new Diagnostics.fromJson(json['diagnostics'])
          : null;
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['isSuccess'] = this.isSuccess;
    data['message'] = this.message;
    if (this.result != null) {
      data['result'] = this.result.map((v) => v.toJson()).toList();
    }
    if (this.diagnostics != null) {
      data['diagnostics'] = this.diagnostics.toJson();
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
      this.isMciVerified});

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
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['doctorId'] = this.doctorId;
    data['userId'] = this.userId;
    data['name'] = this.name;
    data['firstName'] = this.firstName;
    data['lastName'] = this.lastName;
    data['specialization'] = this.specialization;
    data['city'] = this.city;
    data['state'] = this.state;
    data['doctorReferenceId'] = this.doctorReferenceId;
    data['addressLine1'] = this.addressLine1;
    data['specialty'] = this.specialty;
    data['addressLine2'] = this.addressLine2;
    data['profilePicThumbnailUrl'] = this.profilePicThumbnailUrl;
    data['isTelehealthEnabled'] = this.isTelehealthEnabled;
    data['isMciVerified'] = this.isMciVerified;
    return data;
  }
}

class Diagnostics {
  DoctorsListResult errorData;
  bool includeErrorDataInResponse;

  Diagnostics({this.errorData, this.includeErrorDataInResponse});

  Diagnostics.fromJson(Map<String, dynamic> json) {
    errorData = json['errorData'] != null
        ? new DoctorsListResult.fromJson(json['errorData'])
        : null;
    includeErrorDataInResponse = json['includeErrorDataInResponse'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.errorData != null) {
      data['errorData'] = this.errorData.toJson();
    }
    data['includeErrorDataInResponse'] = this.includeErrorDataInResponse;
    return data;
  }
}
