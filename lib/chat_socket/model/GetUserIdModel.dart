class GetUserIdModel {
  bool isSuccess;
  String message;
  UserIdResult result;

  GetUserIdModel({this.isSuccess, this.message, this.result});

  GetUserIdModel.fromJson(Map<String, dynamic> json) {
    isSuccess = json['isSuccess'];
    message = json['message'];
    result =
        json['result'] != null ? new UserIdResult.fromJson(json['result']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['isSuccess'] = this.isSuccess;
    data['message'] = this.message;
    if (this.result != null) {
      data['result'] = this.result.toJson();
    }
    return data;
  }
}

class UserIdResult {
  String id;
  String specialization;
  bool isTelehealthEnabled;
  bool isMciVerified;
  bool isActive;
  bool isWelcomeMailSent;
  String createdOn;
  String lastModifiedBy;
  String lastModifiedOn;
  bool isResident;
  User user;

  UserIdResult(
      {this.id,
      this.specialization,
      this.isTelehealthEnabled,
      this.isMciVerified,
      this.isActive,
      this.isWelcomeMailSent,
      this.createdOn,
      this.lastModifiedBy,
      this.lastModifiedOn,
      this.isResident,
      this.user});

  UserIdResult.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    specialization = json['specialization'];
    isTelehealthEnabled = json['isTelehealthEnabled'];
    isMciVerified = json['isMciVerified'];
    isActive = json['isActive'];
    isWelcomeMailSent = json['isWelcomeMailSent'];
    createdOn = json['createdOn'];
    lastModifiedBy = json['lastModifiedBy'];
    lastModifiedOn = json['lastModifiedOn'];
    isResident = json['isResident'];
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['specialization'] = this.specialization;
    data['isTelehealthEnabled'] = this.isTelehealthEnabled;
    data['isMciVerified'] = this.isMciVerified;
    data['isActive'] = this.isActive;
    data['isWelcomeMailSent'] = this.isWelcomeMailSent;
    data['createdOn'] = this.createdOn;
    data['lastModifiedBy'] = this.lastModifiedBy;
    data['lastModifiedOn'] = this.lastModifiedOn;
    data['isResident'] = this.isResident;
    if (this.user != null) {
      data['user'] = this.user.toJson();
    }
    return data;
  }
}

class Documents {
  String code;
  String documentId;
  String documentName;
  String documentTypeId;

  Documents(
      {this.code, this.documentId, this.documentName, this.documentTypeId});

  Documents.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    documentId = json['documentId'];
    documentName = json['documentName'];
    documentTypeId = json['documentTypeId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    data['documentId'] = this.documentId;
    data['documentName'] = this.documentName;
    data['documentTypeId'] = this.documentTypeId;
    return data;
  }
}

class Specialty {
  String id;
  String name;

  Specialty({this.id, this.name});

  Specialty.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    return data;
  }
}

class User {
  String id;

  User(
      {this.id});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    return data;
  }
}
