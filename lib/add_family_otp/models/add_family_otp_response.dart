import 'package:myfhb/constants/fhb_parameters.dart' as parameters;
// class AddFamilyOTPResponse {
//   int status;
//   bool success;
//   String message;
//   Response response;

//   AddFamilyOTPResponse(
//       {this.status, this.success, this.message, this.response});

//   AddFamilyOTPResponse.fromJson(Map<String, dynamic> json) {
//     status = json[parameters.strStatus];
//     success = json[parameters.strSuccess];
//     message = json[parameters.strMessage];
//     response = json[parameters.strResponse] != null
//         ? new Response.fromJson(json[parameters.strResponse])
//         : null;
//   }


// }

// class Response {
//   AddFamilyUserInfo data;

//   Response({this.data});

//   Response.fromJson(Map<String, dynamic> json) {
//     data = json[parameters.strData] != null
//         ? new AddFamilyUserInfo.fromJson(json[parameters.strData])
//         : null;
//   }
// }

// class AddFamilyUserInfo {
//   String id;
//   String email;
//   String countryCode;
//   String phoneNumber;
//   String gender;
//   String name;
//   bool isTempUser;
//   bool isEmailVerified;
//   String transactionId;

//   AddFamilyUserInfo(
//       {this.id,
//       this.email,
//       this.countryCode,
//       this.phoneNumber,
//       this.gender,
//       this.name,
//       this.isTempUser,
//       this.isEmailVerified,
//       this.transactionId});

//   AddFamilyUserInfo.fromJson(Map<String, dynamic> json) {
//     Map<String, dynamic> userInfo = json[parameters.strUserInfo];

//     id = userInfo[parameters.strId];
//     email = userInfo[parameters.strEmail];
//     countryCode = userInfo[parameters.strCountryCode];
//     phoneNumber = userInfo[parameters.strPhoneNumber];
//     gender = userInfo[parameters.strGender];
//     name = userInfo[parameters.strName];
//     isTempUser = userInfo[parameters.strIstemper];
//     isEmailVerified = userInfo[parameters.strIsEmailVerified];
//     transactionId = json[parameters.strTransactionId];
//   }
// }

class AddFamilyOTPResponse {
  bool isSuccess;
  Result result;
  String message;

  AddFamilyOTPResponse({this.isSuccess, this.result,this.message});

  AddFamilyOTPResponse.fromJson(Map<String, dynamic> json) {
    isSuccess = json['isSuccess'];
    message = json['message'];
    result =
        json['result'] != null ? new Result.fromJson(json['result']) : null;
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

class Result {
  String id;
  String name;
  String userName;
  String firstName;
  String middleName;
  String lastName;
  String gender;
  String dateOfBirth;
  String bloodGroup;
  String countryCode;
  String profilePicUrl;
  String profilePicThumbnailUrl;
  bool isTempUser;
  bool isVirtualUser;
  bool isMigrated;
  bool isClaimed;
  bool isIeUser;
  bool isEmailVerified;
  bool isCpUser;
  String communicationPreferences;
  String medicalPreferences;
  bool isSignedIn;
  bool isActive;
  String createdBy;
  String createdOn;
  String lastModifiedBy;
  String lastModifiedOn;
  List<ContactInfo> contactInfo;
  ChildInfo childInfo;

  Result(
      {this.id,
      this.name,
      this.userName,
      this.firstName,
      this.middleName,
      this.lastName,
      this.gender,
      this.dateOfBirth,
      this.bloodGroup,
      this.countryCode,
      this.profilePicUrl,
      this.profilePicThumbnailUrl,
      this.isTempUser,
      this.isVirtualUser,
      this.isMigrated,
      this.isClaimed,
      this.isIeUser,
      this.isEmailVerified,
      this.isCpUser,
      this.communicationPreferences,
      this.medicalPreferences,
      this.isSignedIn,
      this.isActive,
      this.createdBy,
      this.createdOn,
      this.lastModifiedBy,
      this.lastModifiedOn,
      this.contactInfo,
      this.childInfo});

  Result.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    userName = json['userName'];
    firstName = json['firstName'];
    middleName = json['middleName'];
    lastName = json['lastName'];
    gender = json['gender'];
    dateOfBirth = json['dateOfBirth'];
    bloodGroup = json['bloodGroup'];
    countryCode = json['countryCode'];
    profilePicUrl = json['profilePicUrl'];
    profilePicThumbnailUrl = json['profilePicThumbnailUrl'];
    isTempUser = json['isTempUser'];
    isVirtualUser = json['isVirtualUser'];
    isMigrated = json['isMigrated'];
    isClaimed = json['isClaimed'];
    isIeUser = json['isIeUser'];
    isEmailVerified = json['isEmailVerified'];
    isCpUser = json['isCpUser'];
    communicationPreferences = json['communicationPreferences'];
    medicalPreferences = json['medicalPreferences'];
    isSignedIn = json['isSignedIn'];
    isActive = json['isActive'];
    createdBy = json['createdBy'];
    createdOn = json['createdOn'];
    lastModifiedBy = json['lastModifiedBy'];
    lastModifiedOn = json['lastModifiedOn'];
    if (json['contactInfo'] != null) {
      contactInfo = new List<ContactInfo>();
      json['contactInfo'].forEach((v) {
        contactInfo.add(new ContactInfo.fromJson(v));
      });
    }
    childInfo = json['childInfo'] != null
        ? new ChildInfo.fromJson(json['childInfo'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['userName'] = this.userName;
    data['firstName'] = this.firstName;
    data['middleName'] = this.middleName;
    data['lastName'] = this.lastName;
    data['gender'] = this.gender;
    data['dateOfBirth'] = this.dateOfBirth;
    data['bloodGroup'] = this.bloodGroup;
    data['countryCode'] = this.countryCode;
    data['profilePicUrl'] = this.profilePicUrl;
    data['profilePicThumbnailUrl'] = this.profilePicThumbnailUrl;
    data['isTempUser'] = this.isTempUser;
    data['isVirtualUser'] = this.isVirtualUser;
    data['isMigrated'] = this.isMigrated;
    data['isClaimed'] = this.isClaimed;
    data['isIeUser'] = this.isIeUser;
    data['isEmailVerified'] = this.isEmailVerified;
    data['isCpUser'] = this.isCpUser;
    data['communicationPreferences'] = this.communicationPreferences;
    data['medicalPreferences'] = this.medicalPreferences;
    data['isSignedIn'] = this.isSignedIn;
    data['isActive'] = this.isActive;
    data['createdBy'] = this.createdBy;
    data['createdOn'] = this.createdOn;
    data['lastModifiedBy'] = this.lastModifiedBy;
    data['lastModifiedOn'] = this.lastModifiedOn;
    if (this.contactInfo != null) {
      data['contactInfo'] = this.contactInfo.map((v) => v.toJson()).toList();
    }
    if (this.childInfo != null) {
      data['childInfo'] = this.childInfo.toJson();
    }
    return data;
  }
}

class ContactInfo {
  String id;
  String phoneNumber;
  bool isPrimary;
  bool isActive;
  String createdOn;
  String lastModifiedOn;
  String email;

  ContactInfo(
      {this.id,
      this.phoneNumber,
      this.isPrimary,
      this.isActive,
      this.createdOn,
      this.lastModifiedOn,
      this.email});

  ContactInfo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    phoneNumber = json['phoneNumber'];
    isPrimary = json['isPrimary'];
    isActive = json['isActive'];
    createdOn = json['createdOn'];
    lastModifiedOn = json['lastModifiedOn'];
    email = json['email'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['phoneNumber'] = this.phoneNumber;
    data['isPrimary'] = this.isPrimary;
    data['isActive'] = this.isActive;
    data['createdOn'] = this.createdOn;
    data['lastModifiedOn'] = this.lastModifiedOn;
    data['email'] = this.email;
    return data;
  }
}

class ChildInfo {
  String id;
  String name;
  String userName;
  String firstName;
  String middleName;
  String lastName;
  String gender;
  String dateOfBirth;
  String bloodGroup;
  String countryCode;
  String profilePicUrl;
  String profilePicThumbnailUrl;
  bool isTempUser;
  bool isVirtualUser;
  bool isMigrated;
  bool isClaimed;
  bool isIeUser;
  bool isEmailVerified;
  bool isCpUser;
  String communicationPreferences;
  String medicalPreferences;
  bool isSignedIn;
  bool isActive;
  String createdBy;
  String createdOn;
  String lastModifiedBy;
  String lastModifiedOn;
  List<ContactInfo> contactInfo;

  ChildInfo(
      {this.id,
      this.name,
      this.userName,
      this.firstName,
      this.middleName,
      this.lastName,
      this.gender,
      this.dateOfBirth,
      this.bloodGroup,
      this.countryCode,
      this.profilePicUrl,
      this.profilePicThumbnailUrl,
      this.isTempUser,
      this.isVirtualUser,
      this.isMigrated,
      this.isClaimed,
      this.isIeUser,
      this.isEmailVerified,
      this.isCpUser,
      this.communicationPreferences,
      this.medicalPreferences,
      this.isSignedIn,
      this.isActive,
      this.createdBy,
      this.createdOn,
      this.lastModifiedBy,
      this.lastModifiedOn,
      this.contactInfo});

  ChildInfo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    userName = json['userName'];
    firstName = json['firstName'];
    middleName = json['middleName'];
    lastName = json['lastName'];
    gender = json['gender'];
    dateOfBirth = json['dateOfBirth'];
    bloodGroup = json['bloodGroup'];
    countryCode = json['countryCode'];
    profilePicUrl = json['profilePicUrl'];
    profilePicThumbnailUrl = json['profilePicThumbnailUrl'];
    isTempUser = json['isTempUser'];
    isVirtualUser = json['isVirtualUser'];
    isMigrated = json['isMigrated'];
    isClaimed = json['isClaimed'];
    isIeUser = json['isIeUser'];
    isEmailVerified = json['isEmailVerified'];
    isCpUser = json['isCpUser'];
    communicationPreferences = json['communicationPreferences'];
    medicalPreferences = json['medicalPreferences'];
    isSignedIn = json['isSignedIn'];
    isActive = json['isActive'];
    createdBy = json['createdBy'];
    createdOn = json['createdOn'];
    lastModifiedBy = json['lastModifiedBy'];
    lastModifiedOn = json['lastModifiedOn'];
    if (json['contactInfo'] != null) {
      contactInfo = new List<ContactInfo>();
      json['contactInfo'].forEach((v) {
        contactInfo.add(new ContactInfo.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['userName'] = this.userName;
    data['firstName'] = this.firstName;
    data['middleName'] = this.middleName;
    data['lastName'] = this.lastName;
    data['gender'] = this.gender;
    data['dateOfBirth'] = this.dateOfBirth;
    data['bloodGroup'] = this.bloodGroup;
    data['countryCode'] = this.countryCode;
    data['profilePicUrl'] = this.profilePicUrl;
    data['profilePicThumbnailUrl'] = this.profilePicThumbnailUrl;
    data['isTempUser'] = this.isTempUser;
    data['isVirtualUser'] = this.isVirtualUser;
    data['isMigrated'] = this.isMigrated;
    data['isClaimed'] = this.isClaimed;
    data['isIeUser'] = this.isIeUser;
    data['isEmailVerified'] = this.isEmailVerified;
    data['isCpUser'] = this.isCpUser;
    data['communicationPreferences'] = this.communicationPreferences;
    data['medicalPreferences'] = this.medicalPreferences;
    data['isSignedIn'] = this.isSignedIn;
    data['isActive'] = this.isActive;
    data['createdBy'] = this.createdBy;
    data['createdOn'] = this.createdOn;
    data['lastModifiedBy'] = this.lastModifiedBy;
    data['lastModifiedOn'] = this.lastModifiedOn;
    if (this.contactInfo != null) {
      data['contactInfo'] = this.contactInfo.map((v) => v.toJson()).toList();
    }
    return data;
  }
}




