import 'package:myfhb/common/CommonUtil.dart';
import 'package:myfhb/my_family/models/relationships.dart';
import 'package:myfhb/src/model/user/UserAddressCollection.dart';

class FamilyMembers {
  bool? isSuccess;
  String? message;
  FamilyMemberResult? result;

  FamilyMembers({this.isSuccess, this.message, this.result});

  FamilyMembers.fromJson(Map<String, dynamic> json) {
    try {
      isSuccess = json['isSuccess'];
      message = json['message'];
      result = json['result'] != null
          ? FamilyMemberResult.fromJson(json['result'])
          : null;
    } catch (e, stackTrace) {
      CommonUtil().appLogs(message: e, stackTrace: stackTrace);
    }
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

class FamilyMemberResult {
  List<SharedByUsers>? sharedByUsers;
  List<SharedToUsers>? sharedToUsers;

  VirtualUserParent? virtualUserParent;

  FamilyMemberResult(
      {this.sharedByUsers, this.sharedToUsers, this.virtualUserParent});

  FamilyMemberResult.fromJson(Map<String, dynamic> json) {
    try {
      if (json['sharedByUsers'] != null) {
        sharedByUsers = <SharedByUsers>[];
        json['sharedByUsers'].forEach((v) {
          sharedByUsers!.add(SharedByUsers.fromJson(v));
          // sharedByUsersOriginal!.add(SharedByUsers.fromJson(v));
        });
      }
      if (json['sharedToUsers'] != null) {
        sharedToUsers = <SharedToUsers>[];
        json['sharedToUsers'].forEach((v) {
          sharedToUsers!.add(SharedToUsers.fromJson(v));
        });
      }

      try {
        virtualUserParent = json['virtualUserParent'] != null
            ? VirtualUserParent.fromJson(json['virtualUserParent'])
            : null;
      } catch (e, stackTrace) {
        CommonUtil().appLogs(message: e, stackTrace: stackTrace);
      }
    } catch (e, stackTrace) {
      CommonUtil().appLogs(message: e, stackTrace: stackTrace);
    }
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    if (sharedByUsers != null) {
      data['sharedByUsers'] = sharedByUsers!.map((v) => v.toJson()).toList();
    }
    if (sharedToUsers != null) {
      data['sharedToUsers'] = sharedToUsers!.map((v) => v.toJson()).toList();
    }
    if (virtualUserParent != null) {
      data['virtualUserParent'] = virtualUserParent!.toJson();
    }
    return data;
  }
}

class SharedByUsers {
  String? id;
  String? status;
  String? nickName;
  bool? isActive;
  String? createdOn;
  String? lastModifiedOn;
  RelationsShipModel? relationship;
  Child? child;
  Child? parent;
  String? membershipOfferedBy;
  bool? isCaregiver;
  //for Non adherance
  bool? isNewUser = true;
  String? remainderForId;
  String? remainderFor;
  String? remainderMins;
  String? nonAdheranceId;
  ChatListItem? chatListItem;
  String? nickNameSelf;
  bool? showDelink = true;
  SharedByUsers(
      {this.id,
      this.status,
      this.nickName,
      this.isActive,
      this.createdOn,
      this.lastModifiedOn,
      this.relationship,
      this.child,
      this.membershipOfferedBy,
      this.isCaregiver,
      this.isNewUser,
      this.remainderFor,
      this.remainderMins,
      this.nonAdheranceId,
      this.remainderForId,
      this.chatListItem,
      this.nickNameSelf});

  SharedByUsers.fromJson(Map<String, dynamic> json) {
    try {
      id = json['id'];
      status = json['status'];
      nickName = json['nickName'];
      isActive = json['isActive'];
      createdOn = json['createdOn'];
      lastModifiedOn = json['lastModifiedOn'];
      isCaregiver = json['isCaregiver'] ?? false;
      if (json.containsKey('membershipOfferedBy'))
        membershipOfferedBy = json['membershipOfferedBy'];
      relationship = json['relationship'] != null
          ? RelationsShipModel.fromJson(json['relationship'])
          : null;
      child = json['child'] != null ? Child.fromJson(json['child']) : null;
      chatListItem = json['chatListItem'] != null
          ? new ChatListItem.fromJson(json['chatListItem'])
          : null;
      nickNameSelf = '';
      parent =
          json['parent'] != null ? new Child.fromJson(json['parent']) : null;
    } catch (e, stackTrace) {
      CommonUtil().appLogs(message: e, stackTrace: stackTrace);
    }
  }
  SharedByUsers.fromSharedToUsers(SharedToUsers sharedToUsers) {
    id = sharedToUsers.id;
    status = sharedToUsers.status;
    nickName = sharedToUsers.nickName;
    isActive = sharedToUsers.isActive;
    createdOn = sharedToUsers.createdOn;
    lastModifiedOn = sharedToUsers.lastModifiedOn;
    isCaregiver = sharedToUsers.isCaregiver;
    isNewUser = sharedToUsers.isNewUser;
    remainderForId = sharedToUsers.remainderForId;
    remainderFor = sharedToUsers.remainderFor;
    remainderMins = sharedToUsers.remainderMins;
    nonAdheranceId = sharedToUsers.nonAdheranceId;
    child = sharedToUsers.parent;
    relationship = sharedToUsers.relationship;
    nickName = sharedToUsers.nickName;
    showDelink =
        false; //for shared to users the delink button shouldnot be visible
  }

  Map<String, dynamic> toJson() {
    final data = Map<String, dynamic>();
    data['id'] = id;
    data['status'] = status;
    data['nickName'] = nickName;
    data['isActive'] = isActive;
    data['createdOn'] = createdOn;
    data['lastModifiedOn'] = lastModifiedOn;
    data['membershipOfferedBy'] = membershipOfferedBy;
    if (relationship != null) {
      data['relationship'] = relationship!.toJson();
    }
    if (child != null) {
      data['child'] = child!.toJson();
    }
    if (this.chatListItem != null) {
      data['chatListItem'] = this.chatListItem!.toJson();
    }
    data['nickNameSelf'] = nickNameSelf;
    return data;
  }
}

class Child {
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
  List<UserContactCollectionFamily>? userContactCollection3;
  List<UserRoleCollection3>? userRoleCollection3;
  List<UserAddressCollection3>? userAddressCollection3;
  AdditionalInfo? additionalInfo;

  Child({
    this.id,
    this.name,
    this.userName,
    this.firstName,
    this.middleName,
    this.lastName,
    this.gender,
    this.dateOfBirth,
    this.bloodGroup,
    this.countryCode,
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
    this.userContactCollection3,
    this.userRoleCollection3,
    this.userAddressCollection3,
    this.additionalInfo,
  });

  Child.fromJson(Map<String, dynamic> json) {
    try {
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
      if (json['userContactCollection3'] != null) {
        userContactCollection3 = <UserContactCollectionFamily>[];
        json['userContactCollection3'].forEach((v) {
          userContactCollection3!.add(UserContactCollectionFamily.fromJson(v));
        });
      }
      if (json['userRoleCollection3'] != null) {
        userRoleCollection3 = <UserRoleCollection3>[];
        json['userRoleCollection3'].forEach((v) {
          userRoleCollection3!.add(UserRoleCollection3.fromJson(v));
        });
      }
      if (json['userAddressCollection3'] != null) {
        userAddressCollection3 = <UserAddressCollection3>[];
        json['userAddressCollection3'].forEach((v) {
          userAddressCollection3!.add(UserAddressCollection3.fromJson(v));
        });
      }
      additionalInfo = json['additionalInfo'] != null
          ? AdditionalInfo.fromJson(json['additionalInfo'])
          : null;
    } catch (e, stackTrace) {
      CommonUtil().appLogs(message: e, stackTrace: stackTrace);
    }
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
    if (userContactCollection3 != null) {
      data['userContactCollection3'] =
          userContactCollection3!.map((v) => v.toJson()).toList();
    }
    if (userRoleCollection3 != null) {
      data['userRoleCollection3'] =
          userRoleCollection3!.map((v) => v.toJson()).toList();
    }
    if (userAddressCollection3 != null) {
      data['userAddressCollection3'] =
          userAddressCollection3!.map((v) => v.toJson()).toList();
    }
    if (additionalInfo != null) {
      data['additionalInfo'] = additionalInfo!.toJson();
    }
    return data;
  }
}

class ChatListItem {
  String? id;
  String? peerId;
  String? userId;
  String? createdOn;
  bool? isActive;
  bool? isDisable;
  bool? isMuted;
  int? unReadNotificationCount;
  String? lastModifiedOn;

  ChatListItem(
      {this.id,
      this.peerId,
      this.userId,
      this.createdOn,
      this.isActive,
      this.isDisable,
      this.isMuted,
      this.unReadNotificationCount,
      this.lastModifiedOn});

  ChatListItem.fromJson(Map<String, dynamic> json) {
    try {
      id = json['id'];
      peerId = json['peerId'];
      userId = json['userId'];
      createdOn = json['createdOn'];
      isActive = json['isActive'];
      isDisable = json['isDisable'];
      isMuted = json['isMuted'];
      unReadNotificationCount = json['unReadNotificationCount'];
      lastModifiedOn = json['lastModifiedOn'];
    } catch (e, stackTrace) {
      CommonUtil().appLogs(message: e, stackTrace: stackTrace);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = this.id;
    data['peerId'] = this.peerId;
    data['userId'] = this.userId;
    data['createdOn'] = this.createdOn;
    data['isActive'] = this.isActive;
    data['isDisable'] = this.isDisable;
    data['isMuted'] = this.isMuted;
    data['unReadNotificationCount'] = this.unReadNotificationCount;
    data['lastModifiedOn'] = this.lastModifiedOn;
    return data;
  }
}

class UserContactCollectionFamily {
  String? id;
  String? phoneNumber;
  bool? isPrimary;
  bool? isActive;
  String? createdOn;
  String? lastModifiedOn;
  String? email;

  UserContactCollectionFamily(
      {this.id,
      this.phoneNumber,
      this.isPrimary,
      this.isActive,
      this.createdOn,
      this.lastModifiedOn,
      this.email});

  UserContactCollectionFamily.fromJson(Map<String, dynamic> json) {
    try {
      id = json['id'] ?? "";
      phoneNumber = json['phoneNumber'] ?? "";
      isPrimary = json['isPrimary'] ?? false;
      isActive = json['isActive'] ?? false;
      createdOn = json['createdOn'] ?? "";
      lastModifiedOn = json['lastModifiedOn'] ?? "";
      email = json['email'] ?? "";
    } catch (e, stackTrace) {
      CommonUtil().appLogs(message: e, stackTrace: stackTrace);
    }
  }

  Map<String, dynamic> toJson() {
    final data = Map<String, dynamic>();
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

class UserRoleCollection3 {
  String? id;
  bool? isActive;
  String? createdOn;
  String? lastModifiedOn;

  UserRoleCollection3(
      {this.id, this.isActive, this.createdOn, this.lastModifiedOn});

  UserRoleCollection3.fromJson(Map<String, dynamic> json) {
    try {
      id = json['id'];
      isActive = json['isActive'];
      createdOn = json['createdOn'];
      lastModifiedOn = json['lastModifiedOn'];
    } catch (e, stackTrace) {
      CommonUtil().appLogs(message: e, stackTrace: stackTrace);
    }
  }

  Map<String, dynamic> toJson() {
    final data = Map<String, dynamic>();
    data['id'] = id;
    data['isActive'] = isActive;
    data['createdOn'] = createdOn;
    data['lastModifiedOn'] = lastModifiedOn;
    return data;
  }
}

class AdditionalInfo {
  dynamic? height;
  dynamic? weight;
  String? weightUnitCode;
  HeightObj? heightObj;

  AdditionalInfo({this.height, this.weight});

  AdditionalInfo.fromJson(Map<String, dynamic> json) {
    try {
      if (json['height'].runtimeType == String) {
        height = json['height'];
      } else {
        heightObj =
            json['height'] != null ? HeightObj.fromJson(json['height']) : null;
      }
    } catch (e, stackTrace) {
      CommonUtil().appLogs(message: e, stackTrace: stackTrace);
    }
    if (json.containsKey('weightUnitCode')) {
      weightUnitCode = json['weightUnitCode'];
    }
    try {
      weight = json['weight'];
    } catch (e, stackTrace) {
      CommonUtil().appLogs(message: e, stackTrace: stackTrace);
    }
  }

  Map<String, dynamic> toJson() {
    final data = Map<String, dynamic>();
    data['height'] = height;
    data['weight'] = weight;
    if (this.heightObj != null) {
      data['height'] = this.heightObj!.toJson();
    }
    return data;
  }
}

class HeightObj {
  String? valueFeet;
  String? valueInches;

  HeightObj({this.valueFeet, this.valueInches});

  HeightObj.fromJson(Map<String, dynamic> json) {
    try {
      valueFeet = json['valueFeet'];
      valueInches = json['valueInches'];
    } catch (e, stackTrace) {
      CommonUtil().appLogs(message: e, stackTrace: stackTrace);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['valueFeet'] = this.valueFeet;
    data['valueInches'] = this.valueInches;
    return data;
  }
}

class SharedToUsers {
  String? id;
  String? status;
  String? nickName;
  bool? isActive;
  String? createdOn;
  String? lastModifiedOn;
  RelationsShipModel? relationship;
  Child? parent;
  //non Adherance
  bool? isCaregiver;
  bool? isNewUser = true;
  String? remainderForId;
  String? remainderFor;
  String? remainderMins;
  String? nonAdheranceId;
  SharedToUsers(
      {this.id,
      this.status,
      this.nickName,
      this.isActive,
      this.createdOn,
      this.lastModifiedOn,
      this.relationship,
      this.parent,
      this.isCaregiver,
      this.isNewUser,
      this.remainderFor,
      this.remainderMins,
      this.nonAdheranceId,
      this.remainderForId});

  SharedToUsers.fromJson(Map<String, dynamic> json) {
    try {
      id = json['id'];
      status = json['status'];
      nickName = json['nickName'];
      isActive = json['isActive'];
      createdOn = json['createdOn'];
      lastModifiedOn = json['lastModifiedOn'];
      isCaregiver = json['isCaregiver'] ?? false;
      relationship = json['relationship'] != null
          ? RelationsShipModel.fromJson(json['relationship'])
          : null;
      parent = json['parent'] != null ? Child.fromJson(json['parent']) : null;
    } catch (e, stackTrace) {
      CommonUtil().appLogs(message: e, stackTrace: stackTrace);
    }
  }

  Map<String, dynamic> toJson() {
    final data = Map<String, dynamic>();
    data['id'] = id;
    data['status'] = status;
    data['nickName'] = nickName;
    data['isActive'] = isActive;
    data['createdOn'] = createdOn;
    data['lastModifiedOn'] = lastModifiedOn;
    if (relationship != null) {
      data['relationship'] = relationship!.toJson();
    }
    if (parent != null) {
      data['parent'] = parent!.toJson();
    }
    return data;
  }
}

class VirtualUserParent {
  String? countryCode;
  String? email;
  String? phoneNumber;

  VirtualUserParent({this.countryCode, this.email, this.phoneNumber});

  VirtualUserParent.fromJson(Map<String, dynamic> json) {
    try {
      countryCode = json['countryCode'];
      email = json['email'];
      phoneNumber = json['phoneNumber'];
    } catch (e, stackTrace) {
      CommonUtil().appLogs(message: e, stackTrace: stackTrace);
    }
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['countryCode'] = countryCode;
    data['email'] = email;
    data['phoneNumber'] = phoneNumber;
    return data;
  }
}
