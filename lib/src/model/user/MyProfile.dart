class MyProfile {
  int status;
  bool success;
  String message;
  Response response;

  MyProfile({this.status, this.success, this.message, this.response});

  MyProfile.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    success = json['success'];
    message = json['message'];
    response = json['response'] != null
        ? new Response.fromJson(json['response'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['success'] = this.success;
    data['message'] = this.message;
    if (this.response != null) {
      data['response'] = this.response.toJson();
    }
    return data;
  }
}

class Response {
  int count;
  MyProfileData data;

  Response({this.count, this.data});

  Response.fromJson(Map<String, dynamic> json) {
    count = json['count'];
    data =
        json['data'] != null ? new MyProfileData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['count'] = this.count;
    if (this.data != null) {
      data['data'] = this.data.toJson();
    }
    return data;
  }
}

class MyProfileData {
  GeneralInfo generalInfo;

  MyProfileData({this.generalInfo});

  MyProfileData.fromJson(Map<String, dynamic> json) {
    generalInfo = json['generalInfo'] != null
        ? new GeneralInfo.fromJson(json['generalInfo'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.generalInfo != null) {
      data['generalInfo'] = this.generalInfo.toJson();
    }
    return data;
  }
}

class GeneralInfo {
  String name;
  String countryCode;
  String phoneNumber;
  String email;
  String gender;
  String bloodGroup;
  String createdBy;
  bool isEmailVerified;
  bool isVirtualUser;
  bool isTempUser;
  String createdOn;
  String lastModifiedOn;
  String dateOfBirth;
  ProfilePicThumbnailMain profilePicThumbnail;

  GeneralInfo(
      {this.name,
      this.countryCode,
      this.phoneNumber,
      this.email,
      this.gender,
      this.bloodGroup,
      this.createdBy,
      this.isEmailVerified,
      this.isVirtualUser,
      this.isTempUser,
      this.createdOn,
      this.lastModifiedOn,
      this.dateOfBirth,
      this.profilePicThumbnail});

  GeneralInfo.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    countryCode = json['countryCode'];
    phoneNumber = json['phoneNumber'];
    email = json['email'];
    gender = json['gender'];
    bloodGroup = json['bloodGroup'];
    createdBy = json['createdBy'];
    isEmailVerified = json['isEmailVerified'];
    isVirtualUser = json['isVirtualUser'];
    isTempUser = json['isTempUser'];
    createdOn = json['createdOn'];
    lastModifiedOn = json['lastModifiedOn'];
    dateOfBirth = json['dateOfBirth'];
    profilePicThumbnail = json['profilePicThumbnail'] != null
        ? new ProfilePicThumbnailMain.fromJson(json['profilePicThumbnail'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['countryCode'] = this.countryCode;
    data['phoneNumber'] = this.phoneNumber;
    data['email'] = this.email;
    data['gender'] = this.gender;
    data['bloodGroup'] = this.bloodGroup;
    data['createdBy'] = this.createdBy;
    data['isEmailVerified'] = this.isEmailVerified;
    data['isVirtualUser'] = this.isVirtualUser;
    data['isTempUser'] = this.isTempUser;
    data['createdOn'] = this.createdOn;
    data['lastModifiedOn'] = this.lastModifiedOn;
    data['dateOfBirth'] = this.dateOfBirth;
    if (this.profilePicThumbnail != null) {
      data['profilePicThumbnail'] = this.profilePicThumbnail.toJson();
    }
    return data;
  }
}

class ProfilePicThumbnailMain {
  String type;
  List<int> data;

  ProfilePicThumbnailMain({this.type, this.data});

  ProfilePicThumbnailMain.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    data = json['data'].cast<int>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['type'] = this.type;
    data['data'] = this.data;
    return data;
  }
}
