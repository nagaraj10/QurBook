import 'package:myfhb/common/CommonUtil.dart';
import 'package:myfhb/constants/variable_constant.dart';

class HubListResponse {
  bool? isSuccess;
  List<UserDeviceCollection>? result;

  HubListResponse({this.isSuccess, this.result});

  HubListResponse.fromJson(Map<String, dynamic> json) {
    try {
      isSuccess = json['isSuccess'];
      if (json['result'] != null) {
        result = <UserDeviceCollection>[];
        json['result'].forEach((v) {
          result!.add(UserDeviceCollection.fromJson(v));
        });
      }
    } catch (e,stackTrace) {
      CommonUtil().appLogs(message: e,stackTrace:stackTrace);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['isSuccess'] = this.isSuccess;
    if (this.result != null) {
      data['result'] =
          this.result!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Result {
  String? id;
  String? nickName;
  String? additionalDetails;
  bool? isActive;
  String? createdOn;
  String? lastModifiedOn;
  String? hubId;
  String? userId;
  //Hub? hub;
  List<UserDeviceCollection>? userDeviceCollection;

  Result(
      {this.id,
      this.nickName,
      this.additionalDetails,
      this.isActive,
      this.createdOn,
      this.lastModifiedOn,
      this.hubId,
      this.userId,
      //this.hub,
      this.userDeviceCollection});

  Result.fromJson(Map<String, dynamic> json) {
    try {
      id = json['id'];
      nickName = json['nickName'];
      createdOn = json['createdOn'];
      hubId = json['hubId'];
      userId = json['userId'];
      //hub = json['hub'] != null ? Hub.fromJson(json['hub']) : null;

      if (json['userDeviceCollection'] != null) {
            userDeviceCollection = <UserDeviceCollection>[];
            json['userDeviceCollection'].forEach((v) {
              userDeviceCollection!.add(UserDeviceCollection.fromJson(v));
            });
          }
    } catch (e,stackTrace) {
      CommonUtil().appLogs(message: e,stackTrace:stackTrace);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = this.id;
    data['nickName'] = this.nickName;
    data['additionalDetails'] = this.additionalDetails;
    data['isActive'] = this.isActive;
    data['createdOn'] = this.createdOn;
    data['lastModifiedOn'] = this.lastModifiedOn;
    data['hubId'] = this.hubId;
    data['userId'] = this.userId;
    if (this.userDeviceCollection != null) {
      data['userDeviceCollection'] =
          this.userDeviceCollection!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class AdditionalDetails {
  bool? isVirtualHub;

  AdditionalDetails({this.isVirtualHub});

  AdditionalDetails.fromJson(Map<String, dynamic> json) {
    try {
      isVirtualHub = json['isVirtualHub'];
    } catch (e,stackTrace) {
            CommonUtil().appLogs(message: e,stackTrace:stackTrace);

    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    try {
      data['isVirtualHub'] = this.isVirtualHub;
    } catch (e,stackTrace) {
      print(e);
            CommonUtil().appLogs(message: e,stackTrace:stackTrace);

    }
    return data;
  }
}

class Hub {
  String? id;
  String? name;
  String? serialNumber;
  AdditionalDetails? additionalDetails;
  bool? isActive;
  String? createdOn;
  String? lastModifiedOn;
  Hub(
      {this.id,
      this.name,
      this.serialNumber,
      this.additionalDetails,
      this.isActive,
      this.createdOn,
      this.lastModifiedOn});
  Hub.fromJson(Map<String, dynamic> json) {
    try {
      id = json['id'];
      name = json['name'];
      serialNumber = json['serialNumber'];
      additionalDetails = json['additionalDetails'] != null
              ? AdditionalDetails.fromJson(json['additionalDetails'])
              : null;
      isActive = json['isActive'];
      createdOn = json['createdOn'];
      lastModifiedOn = json['lastModifiedOn'];
    } catch (e,stackTrace) {
      CommonUtil().appLogs(message: e,stackTrace:stackTrace);
    }
  }
}

class UserDeviceCollection {
  String? id;
  String? userHubId;
  String? pairHash;
  String? additionalDetails;
  bool? isActive;
  String? createdOn;
  String? lastModifiedOn;
  String? hubId;
  String? deviceId;
  String? userId;
  User? user;
  Device? device;
  String? manufacturer;
  UserDeviceCollection({
    this.id,
    this.userHubId,
    this.pairHash,
    this.additionalDetails,
    this.isActive,
    this.createdOn,
    this.lastModifiedOn,
    this.hubId,
    this.deviceId,
    this.userId,
    this.user,
    this.device,
    this.manufacturer,
  });

  UserDeviceCollection.fromJson(Map<String, dynamic> json) {
    try {
      id = json['id'];
      userHubId = json['userHubId'];
      pairHash = json['pairHash'];
      // additionalDetails = json['additionalDetails'];
      var addDetails = json['additionalDetails'];
      manufacturer = addDetails != null ? addDetails['manufacturer'] : null;
      isActive = json['isActive'];
      createdOn = json['createdOn'];
      lastModifiedOn = json['lastModifiedOn'];
      hubId = json['hubId'];
      deviceId = json['deviceId'];
      userId = json['userId'];
      user = json['user'] != null ? User.fromJson(json['user']) : null;
      device = json['device'] != null ? Device.fromJson(json['device']) : null;
    } catch (e,stackTrace) {
      CommonUtil().appLogs(message: e,stackTrace:stackTrace);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = this.id;
    data['userHubId'] = this.userHubId;
    data['pairHash'] = this.pairHash;
    data['additionalDetails'] = this.additionalDetails;
    data['isActive'] = this.isActive;
    data['createdOn'] = this.createdOn;
    data['lastModifiedOn'] = this.lastModifiedOn;
    data['hubId'] = this.hubId;
    data['deviceId'] = this.deviceId;
    data['userId'] = this.userId;
    if (this.user != null) {
      data['user'] = this.user!.toJson();
    }
    return data;
  }
}

// need to add a key additionalDetails with manufactures data
class Device {
  String? id;
  String? serialNumber;
  DeviceType? deviceType;
  String? name;
  bool? isActive;
  String? createdOn;
  String? lastModifiedOn;
  String? deviceTypeId;
  Device(
      {this.id,
      this.serialNumber,
      this.deviceType,
      this.name,
      this.isActive,
      this.createdOn,
      this.lastModifiedOn,
      this.deviceTypeId});

  Device.fromJson(Map<String, dynamic> json) {
    try {
      id = json['id'];
      serialNumber = json['serialNumber'];
      deviceType = json['deviceType'] != null
          ? DeviceType.fromJson(json['deviceType'])
          : null;
      name = json['name'];
      isActive = json['isActive'];
      createdOn = json['createdOn'];
      lastModifiedOn = json['lastModifiedOn'];
      deviceTypeId = json['deviceTypeId'];
    } catch (e,stackTrace) {
      CommonUtil().appLogs(message: e,stackTrace:stackTrace);
    }
  }
}

class DeviceType {
  String? id;
  String? code;
  String? name;
  String? description;
  int? sortOrder;
  bool? isActive;
  String? createdBy;
  String? createdOn;
  String? lastModifiedOn;
  AdditionalInfo? additionalInfo;

  DeviceType({
    this.id,
    this.code,
    this.name,
    this.description,
    this.sortOrder,
    this.isActive,
    this.createdBy,
    this.createdOn,
    this.lastModifiedOn,
    this.additionalInfo
  });

  DeviceType.fromJson(Map<String, dynamic> json) {
    try {
      id = json['id'];
      code = json['code'];
      name = json['name'];
      description = json['description'];
      sortOrder = json['sortOrder'];
      isActive = json['isActive'];
      createdBy = json['createdBy'];
      createdOn = json['createdOn'];
      lastModifiedOn = json['lastModifiedOn'];
      additionalInfo = json['additionalInfo'] != null
          ? AdditionalInfo.fromJson(json['additionalInfo'])
          : null;
      if (additionalInfo == null) {
        AdditionalInfo additionalInfoTemp = AdditionalInfo();
        additionalInfoTemp.connectivityType = strBluetooth;
        additionalInfo = additionalInfoTemp;
      }
    } catch (e,stackTrace) {
      CommonUtil().appLogs(message: e,stackTrace:stackTrace);
    }
  }
}

class User {
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
  String? isTempUser;
  String? isVirtualUser;
  String? isMigrated;
  String? isClaimed;
  bool? isIeUser;
  String? isEmailVerified;
  bool? isCpUser;
  String? communicationPreferences;
  String? medicalPreferences;
  bool? isSignedIn;
  bool? isActive;
  String? createdBy;
  String? createdOn;
  String? lastModifiedBy;
  String? lastModifiedOn;
  String? providerId;
  AdditionalInfo? additionalInfo;
  String? firstLoggedIn;

  User(
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
      this.providerId,
      this.additionalInfo,
      this.firstLoggedIn});

  User.fromJson(Map<String, dynamic> json) {
    try {
      id = json['id'];
      // name = json['name'];
      // userName = json['userName'];
      firstName = json['firstName'];
      middleName = json['middleName'];
      lastName = json['lastName'];
      gender = json['gender'];
      dateOfBirth = json['dateOfBirth'];
      bloodGroup = json['bloodGroup'];
      // countryCode = json['countryCode'];
      profilePicUrl = json['profilePicUrl'];
      profilePicThumbnailUrl = json['profilePicThumbnailUrl'];
    } catch (e,stackTrace) {
      CommonUtil().appLogs(message: e,stackTrace:stackTrace);
    }
    // isTempUser = json['isTempUser'];
    // isVirtualUser = json['isVirtualUser'];
    // isMigrated = json['isMigrated'];
    // isClaimed = json['isClaimed'];
    // isIeUser = json['isIeUser'];
    // isEmailVerified = json['isEmailVerified'];
    // isCpUser = json['isCpUser'];
    // communicationPreferences = json['communicationPreferences'];
    // medicalPreferences = json['medicalPreferences'];
    // isSignedIn = json['isSignedIn'];
    // isActive = json['isActive'];
    // createdBy = json['createdBy'];
    // createdOn = json['createdOn'];
    // lastModifiedBy = json['lastModifiedBy'];
    // lastModifiedOn = json['lastModifiedOn'];
    // providerId = json['providerId'];
    // additionalInfo = json['additionalInfo'] != null
    //     ? AdditionalInfo.fromJson(json['additionalInfo'])
    //     : null;
    // firstLoggedIn = json['firstLoggedIn'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
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
    data['providerId'] = this.providerId;
    if (this.additionalInfo != null) {
      data['additionalInfo'] = this.additionalInfo!.toJson();
    }
    data['firstLoggedIn'] = this.firstLoggedIn;
    return data;
  }
}

class AdditionalInfo {
  int? age;
  String? height;
  String? offset;
  String? weight;
  // List<Null> language;
  String? mrdNumber;
  String? uhidNumber;
  String? visitReason;
  String? patientHistory;
  String? connectivityType;

  AdditionalInfo(
      {this.age,
      this.height,
      this.offset,
      this.weight,
      // this.language,
      this.mrdNumber,
      this.uhidNumber,
      this.visitReason,
      this.patientHistory,this.connectivityType});

  AdditionalInfo.fromJson(Map<String, dynamic> json) {
    try {
      age = json['age'];
      height = json['height'];
      offset = json['offset'];
      weight = json['weight'];
      // if (json['language'] != null) {
      //   language = List<Null>();
      //   json['language'].forEach((v) {
      //     language.add(new Null.fromJson(v));
      //   });
      // }
      mrdNumber = json['mrdNumber'];
      uhidNumber = json['uhidNumber'];
      visitReason = json['visitReason'];
      patientHistory = json['patientHistory'];
      initConnectivityType(json);
    } catch (e,stackTrace) {
      initConnectivityType(json);
      CommonUtil().appLogs(message: e,stackTrace:stackTrace);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['age'] = this.age;
    data['height'] = this.height;
    data['offset'] = this.offset;
    data['weight'] = this.weight;
    // if (this.language != null) {
    //   data['language'] = this.language.map((v) => v.toJson()).toList();
    // }
    data['mrdNumber'] = this.mrdNumber;
    data['uhidNumber'] = this.uhidNumber;
    data['visitReason'] = this.visitReason;
    data['patientHistory'] = this.patientHistory;
    data['connectivityType'] = this.connectivityType;
    return data;
  }

  initConnectivityType(Map<String, dynamic> json) {
    try {
      connectivityType = (json['connectivityType'] ?? '');
      if ((connectivityType ?? '').trim().isEmpty) {
        connectivityType = strBluetooth;
      }
    } catch (e, stackTrace) {
      CommonUtil().appLogs(message: e, stackTrace: stackTrace);
    }
  }
}
