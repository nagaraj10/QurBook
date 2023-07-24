import 'package:myfhb/common/CommonUtil.dart';
import 'package:myfhb/constants/fhb_constants.dart';

import '../../constants/fhb_parameters.dart' as parameters;
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
  bool? isSuccess;
  Result? result;
  String? message;

  AddFamilyOTPResponse({this.isSuccess, this.result, this.message});

  AddFamilyOTPResponse.fromJson(Map<String, dynamic> json) {
    isSuccess = json['isSuccess'];
    message = json['message'];
    result = json['result'] != null ? Result.fromJson(json['result']) : null;
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['isSuccess'] = isSuccess;
    data['message'] = message;
    if (result != null) {
      data['result'] = result!.toJson();
    }
    return data;
  }
}

class Result {
  String? id;
  String? name;
  String? userName;
  String? firstName;
  String? middleName;
  String? lastName;
  String? gender;
  String? dateOfBirth;
  String? bloodGroup;
  String? countryCode;
  String? profilePicUrl;
  String? profilePicThumbnailUrl;
  bool? isTempUser;
  bool? isVirtualUser;
  bool? isMigrated;
  bool? isClaimed;
  bool? isIeUser;
  bool? isEmailVerified;
  bool? isCpUser;
  String? communicationPreferences;
  String? medicalPreferences;
  bool? isSignedIn;
  bool? isActive;
  String? createdBy;
  String? createdOn;
  String? lastModifiedBy;
  String? lastModifiedOn;
  List<ContactInfo>? contactInfo;
  ChildInfo? childInfo;

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
      contactInfo = <ContactInfo>[];
      json['contactInfo'].forEach((v) {
        contactInfo!.add(ContactInfo.fromJson(v));
      });
    }
    childInfo = json['childInfo'] != null
        ? ChildInfo.fromJson(json['childInfo'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final data = Map<String, dynamic>();
    data['id'] = id;
    data['name'] = name;
    data['userName'] = userName;
    data['firstName'] = firstName;
    data['middleName'] = middleName;
    data['lastName'] = lastName;
    data['gender'] = gender;
    data['dateOfBirth'] = dateOfBirth;
    data['bloodGroup'] = bloodGroup;
    data['countryCode'] = countryCode;
    data['profilePicUrl'] = profilePicUrl;
    data['profilePicThumbnailUrl'] = profilePicThumbnailUrl;
    data['isTempUser'] = isTempUser;
    data['isVirtualUser'] = isVirtualUser;
    data['isMigrated'] = isMigrated;
    data['isClaimed'] = isClaimed;
    data['isIeUser'] = isIeUser;
    data['isEmailVerified'] = isEmailVerified;
    data['isCpUser'] = isCpUser;
    data['communicationPreferences'] = communicationPreferences;
    data['medicalPreferences'] = medicalPreferences;
    data['isSignedIn'] = isSignedIn;
    data['isActive'] = isActive;
    data['createdBy'] = createdBy;
    data['createdOn'] = createdOn;
    data['lastModifiedBy'] = lastModifiedBy;
    data['lastModifiedOn'] = lastModifiedOn;
    if (contactInfo != null) {
      data['contactInfo'] = contactInfo!.map((v) => v.toJson()).toList();
    }
    if (childInfo != null) {
      data['childInfo'] = childInfo!.toJson();
    }
    return data;
  }
}

class ContactInfo {
  String? id;
  String? phoneNumber;
  bool? isPrimary;
  bool? isActive;
  String? createdOn;
  String? lastModifiedOn;
  String? email;

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
    final data = <String, dynamic>{};
    data['id'] = id;
    data['phoneNumber'] = phoneNumber;
    data['isPrimary'] = isPrimary;
    data['isActive'] = isActive;
    data['createdOn'] = createdOn;
    data['lastModifiedOn'] = lastModifiedOn;
    data['email'] = email;
    return data;
  }
}

class ChildInfo {
  String? id;
  String? name;
  String? userName;
  String? firstName;
  String? middleName;
  String? lastName;
  String? gender;
  String? dateOfBirth;
  String? bloodGroup;
  String? countryCode;
  String? profilePicUrl;
  String? profilePicThumbnailUrl;
  bool? isTempUser;
  bool? isVirtualUser;
  bool? isMigrated;
  bool? isClaimed;
  bool? isIeUser;
  bool? isEmailVerified;
  bool? isCpUser;
  String? communicationPreferences;
  String? medicalPreferences;
  bool? isSignedIn;
  bool? isActive;
  String? createdBy;
  String? createdOn;
  String? lastModifiedBy;
  String? lastModifiedOn;
  String? membershipOfferedBy;
  String? providerId;
  AdditionalInfos? additionalInfo;
  List<ContactInfo>? contactInfo;

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
      this.contactInfo,
      this.additionalInfo,
      this.providerId,
      this.membershipOfferedBy});

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
    if (json.containsKey('membershipOfferedBy')) {
      membershipOfferedBy = json['membershipOfferedBy'];
    }
    if (json['contactInfo'] != null) {
      contactInfo = <ContactInfo>[];
      json['contactInfo'].forEach((v) {
        contactInfo!.add(ContactInfo.fromJson(v));
      });
    }
    additionalInfo = json['additionalInfo'] != null
        ? AdditionalInfos.fromJson(json['additionalInfo'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['userName'] = userName;
    data['firstName'] = firstName;
    data['middleName'] = middleName;
    data['lastName'] = lastName;
    data['gender'] = gender;
    data['dateOfBirth'] = dateOfBirth;
    data['bloodGroup'] = bloodGroup;
    data['countryCode'] = countryCode;
    data['profilePicUrl'] = profilePicUrl;
    data['profilePicThumbnailUrl'] = profilePicThumbnailUrl;
    data['isTempUser'] = isTempUser;
    data['isVirtualUser'] = isVirtualUser;
    data['isMigrated'] = isMigrated;
    data['isClaimed'] = isClaimed;
    data['isIeUser'] = isIeUser;
    data['isEmailVerified'] = isEmailVerified;
    data['isCpUser'] = isCpUser;
    data['communicationPreferences'] = communicationPreferences;
    data['medicalPreferences'] = medicalPreferences;
    data['isSignedIn'] = isSignedIn;
    data['isActive'] = isActive;
    data['createdBy'] = createdBy;
    data['createdOn'] = createdOn;
    data['lastModifiedBy'] = lastModifiedBy;
    data['lastModifiedOn'] = lastModifiedOn;
    data['membershipOfferedBy'] = membershipOfferedBy;
    if (contactInfo != null) {
      data['contactInfo'] = contactInfo!.map((v) => v.toJson()).toList();
    }
    if (additionalInfo != null) {
      data['additionalInfo'] = additionalInfo!.toJson();
    }
    return data;
  }
}

class HeightObjNew {
  String? valueFeet;
  String? valueInches;

  HeightObjNew({this.valueFeet, this.valueInches});

  HeightObjNew.fromJson(Map<String, dynamic> json) {
    valueFeet = json['valueFeet'];
    valueInches = json['valueInches'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['valueFeet'] = this.valueFeet;
    data['valueInches'] = this.valueInches;
    return data;
  }
}

class AdditionalInfos {
  String? height;
  String? weight;
  HeightObjNew? heightObj;
  String offSet = CommonUtil().setTimeZone();

  AdditionalInfos({this.height, this.weight});

  AdditionalInfos.fromJson(Map<String, dynamic> json) {
    try {
      if (json['height'].runtimeType == String) {
        height = json['height'];
      } else {
        heightObj = json['height'] != null
            ? HeightObjNew.fromJson(json['height'])
            : null;
      }
    } catch (e) {
      CommonUtil().appLogs(message: e.toString());
    }
    weight = json['weight'];
    try {
      height = json['height'];
      weight = json['weight'];
    } catch (e) {
      CommonUtil().appLogs(message: e.toString());
    }
  }

  Map<String, dynamic> toJson() {
    final data = Map<String, dynamic>();
    data['height'] = height;
    data['weight'] = weight;
    if (this.heightObj != null) {
      data['height'] = this.heightObj!.toJson();
    }
    data[KEY_OffSet] = CommonUtil().setTimeZone();

    return data;
  }
}
