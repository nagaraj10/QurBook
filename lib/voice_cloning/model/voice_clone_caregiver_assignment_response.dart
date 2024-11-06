class VoiceCloneCaregiverAssignmentResponse {
  final bool? isSuccess;
  final List<VoiceCloneCaregiverAssignmentResult>? result;

  VoiceCloneCaregiverAssignmentResponse({
    this.isSuccess,
    this.result,
  });

  factory VoiceCloneCaregiverAssignmentResponse.fromJson(
          Map<String, dynamic> json) =>
      VoiceCloneCaregiverAssignmentResponse(
        isSuccess: json['isSuccess'],
        result: json['result'] == null
            ? []
            : List<VoiceCloneCaregiverAssignmentResult>.from(json['result']!
                .map((x) => VoiceCloneCaregiverAssignmentResult.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        'isSuccess': isSuccess,
        'result': result == null
            ? []
            : List<dynamic>.from(result!.map((x) => x.toJson())),
      };
}

class VoiceCloneCaregiverAssignmentResult {
  final String? id;
  final bool? isActive;
  final String? createdBy;
  final DateTime? createdOn;
  final dynamic lastModifiedBy;
  final dynamic lastModifiedOn;
  final VoiceClone? voiceClone;
  final VoiceCloneCaregiverUser? user;
  final Status? status;

  VoiceCloneCaregiverAssignmentResult({
    this.id,
    this.isActive,
    this.createdBy,
    this.createdOn,
    this.lastModifiedBy,
    this.lastModifiedOn,
    this.voiceClone,
    this.user,
    this.status,
  });

  factory VoiceCloneCaregiverAssignmentResult.fromJson(
          Map<String, dynamic> json) =>
      VoiceCloneCaregiverAssignmentResult(
        id: json['id'],
        isActive: json['isActive'],
        createdBy: json['createdBy'],
        createdOn: json['createdOn'] == null
            ? null
            : DateTime.parse(json['createdOn']),
        lastModifiedBy: json['lastModifiedBy'],
        lastModifiedOn: json['lastModifiedOn'],
        voiceClone: json['voiceClone'] == null
            ? null
            : VoiceClone.fromJson(json['voiceClone']),
        user: json['user'] == null ? null : VoiceCloneCaregiverUser.fromJson(json['user']),
        status: json['status'] == null ? null : Status.fromJson(json['status']),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'isActive': isActive,
        'createdBy': createdBy,
        'createdOn': createdOn?.toIso8601String(),
        'lastModifiedBy': lastModifiedBy,
        'lastModifiedOn': lastModifiedOn,
        'voiceClone': voiceClone?.toJson(),
        'user': user?.toJson(),
        'status': status?.toJson(),
      };
}

class Status {
  final String? id;
  final String? code;
  final String? name;
  final String? description;
  final int? sortOrder;
  final bool? isActive;
  final dynamic additionalInfo;
  final String? createdBy;
  final dynamic parentId;
  final DateTime? createdOn;
  final dynamic lastModifiedOn;

  Status({
    this.id,
    this.code,
    this.name,
    this.description,
    this.sortOrder,
    this.isActive,
    this.additionalInfo,
    this.createdBy,
    this.parentId,
    this.createdOn,
    this.lastModifiedOn,
  });

  factory Status.fromJson(Map<String, dynamic> json) => Status(
        id: json['id'],
        code: json['code'],
        name: json['name'],
        description: json['description'],
        sortOrder: json['sortOrder'],
        isActive: json['isActive'],
        additionalInfo: json['additionalInfo'],
        createdBy: json['createdBy'],
        parentId: json['parentId'],
        createdOn: json['createdOn'] == null
            ? null
            : DateTime.parse(json['createdOn']),
        lastModifiedOn: json['lastModifiedOn'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'code': code,
        'name': name,
        'description': description,
        'sortOrder': sortOrder,
        'isActive': isActive,
        'additionalInfo': additionalInfo,
        'createdBy': createdBy,
        'parentId': parentId,
        'createdOn': createdOn?.toIso8601String(),
        'lastModifiedOn': lastModifiedOn,
      };
}

class VoiceCloneCaregiverUser {
  final String? id;
  final String? name;
  final String? userName;
  final String? firstName;
  final String? middleName;
  final String? lastName;
  final String? gender;
  final DateTime? dateOfBirth;
  final String? bloodGroup;
  final dynamic countryCode;
  final String? profilePicUrl;
  final String? profilePicThumbnailUrl;
  final bool? isTempUser;
  final bool? isVirtualUser;
  final dynamic isMigrated;
  final dynamic isClaimed;
  final bool? isIeUser;
  final dynamic isEmailVerified;
  final bool? isCpUser;
  final dynamic communicationPreferences;
  final dynamic medicalPreferences;
  final bool? isSignedIn;
  final bool? isActive;
  final String? createdBy;
  final DateTime? createdOn;
  final String? lastModifiedBy;
  final DateTime? lastModifiedOn;
  final String? providerId;
  final UserAdditionalInfo? additionalInfo;
  final String? timezone;

  VoiceCloneCaregiverUser({
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
    this.timezone,
  });

  factory VoiceCloneCaregiverUser.fromJson(Map<String, dynamic> json) => VoiceCloneCaregiverUser(
        id: json['id'],
        name: json['name'],
        userName: json['userName'],
        firstName: json['firstName'],
        middleName: json['middleName'],
        lastName: json['lastName'],
        gender: json['gender'],
        dateOfBirth: json['dateOfBirth'] == null
            ? null
            : DateTime.parse(json['dateOfBirth']),
        bloodGroup: json['bloodGroup'],
        countryCode: json['countryCode'],
        profilePicUrl: json['profilePicUrl'],
        profilePicThumbnailUrl: json['profilePicThumbnailUrl'],
        isTempUser: json['isTempUser'],
        isVirtualUser: json['isVirtualUser'],
        isMigrated: json['isMigrated'],
        isClaimed: json['isClaimed'],
        isIeUser: json['isIeUser'],
        isEmailVerified: json['isEmailVerified'],
        isCpUser: json['isCpUser'],
        communicationPreferences: json['communicationPreferences'],
        medicalPreferences: json['medicalPreferences'],
        isSignedIn: json['isSignedIn'],
        isActive: json['isActive'],
        createdBy: json['createdBy'],
        createdOn: json['createdOn'] == null
            ? null
            : DateTime.parse(json['createdOn']),
        lastModifiedBy: json['lastModifiedBy'],
        lastModifiedOn: json['lastModifiedOn'] == null
            ? null
            : DateTime.parse(json['lastModifiedOn']),
        providerId: json['providerId'],
        additionalInfo: json['additionalInfo'] == null
            ? null
            : UserAdditionalInfo.fromJson(json['additionalInfo']),
        timezone: json['timezone'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'userName': userName,
        'firstName': firstName,
        'middleName': middleName,
        'lastName': lastName,
        'gender': gender,
        'dateOfBirth':
            "${dateOfBirth!.year.toString().padLeft(4, '0')}-${dateOfBirth!.month.toString().padLeft(2, '0')}-${dateOfBirth!.day.toString().padLeft(2, '0')}",
        'bloodGroup': bloodGroup,
        'countryCode': countryCode,
        'profilePicUrl': profilePicUrl,
        'profilePicThumbnailUrl': profilePicThumbnailUrl,
        'isTempUser': isTempUser,
        'isVirtualUser': isVirtualUser,
        'isMigrated': isMigrated,
        'isClaimed': isClaimed,
        'isIeUser': isIeUser,
        'isEmailVerified': isEmailVerified,
        'isCpUser': isCpUser,
        'communicationPreferences': communicationPreferences,
        'medicalPreferences': medicalPreferences,
        'isSignedIn': isSignedIn,
        'isActive': isActive,
        'createdBy': createdBy,
        'createdOn': createdOn?.toIso8601String(),
        'lastModifiedBy': lastModifiedBy,
        'lastModifiedOn': lastModifiedOn?.toIso8601String(),
        'providerId': providerId,
        'additionalInfo': additionalInfo?.toJson(),
        'timezone': timezone,
      };
}

class UserAdditionalInfo {
  final int? age;
  final dynamic height;
  final String? offset;
  final String? weight;
  final dynamic language;
  final String? mrdNumber;
  final String? uhidNumber;
  final String? visitReason;
  final String? heightUnitCode;
  final String? patientHistory;
  final String? weightUnitCode;
  final dynamic gender;
  final String? phoneNumber;
  final bool? isVirtualNumber;
  final dynamic alternatePhoneNumber;

  UserAdditionalInfo({
    this.age,
    this.height,
    this.offset,
    this.weight,
    this.language,
    this.mrdNumber,
    this.uhidNumber,
    this.visitReason,
    this.heightUnitCode,
    this.patientHistory,
    this.weightUnitCode,
    this.gender,
    this.phoneNumber,
    this.isVirtualNumber,
    this.alternatePhoneNumber,
  });

  Map<String, dynamic> toJson() => {
        'age': age,
        'height': height,
        'offset': offset,
        'weight': weight,
        'language': language,
        'mrdNumber': mrdNumber,
        'uhidNumber': uhidNumber,
        'visitReason': visitReason,
        'heightUnitCode': heightUnitCode,
        'patientHistory': patientHistory,
        'weightUnitCode': weightUnitCode,
        'gender': gender,
        'phoneNumber': phoneNumber,
        'isVirtualNumber': isVirtualNumber,
        'alternatePhoneNumber': alternatePhoneNumber,
      };

  factory UserAdditionalInfo.fromJson(Map<String, dynamic> json) =>
      UserAdditionalInfo(
        age: json['age'],
        height: json['height'],
        offset: json['offset'],
        weight: json['weight'],
        language: json['language'],
        mrdNumber: json['mrdNumber'],
        uhidNumber: json['uhidNumber'],
        visitReason: json['visitReason'],
        heightUnitCode: json['heightUnitCode'],
        patientHistory: json['patientHistory'],
        weightUnitCode: json['weightUnitCode'],
        gender: json['gender'],
        phoneNumber: json['phoneNumber'],
        isVirtualNumber: json['isVirtualNumber'],
        alternatePhoneNumber: json['alternatePhoneNumber'],
      );
}

class HeightClass {
  final String? valueFeet;
  final String? valueInches;

  HeightClass({
    this.valueFeet,
    this.valueInches,
  });

  Map<String, dynamic> toJson() => {
        'valueFeet': valueFeet,
        'valueInches': valueInches,
      };

  factory HeightClass.fromJson(Map<String, dynamic> json) => HeightClass(
        valueFeet: json['valueFeet'],
        valueInches: json['valueInches'],
      );
}

class VoiceClone {
  final String? id;
  final dynamic voiceId;
  final VoiceCloneAdditionalInfo? additionalInfo;
  final String? url;
  final bool? isActive;
  final String? createdBy;
  final DateTime? createdOn;
  final dynamic lastModifiedBy;
  final dynamic lastModifiedOn;

  VoiceClone({
    this.id,
    this.voiceId,
    this.additionalInfo,
    this.url,
    this.isActive,
    this.createdBy,
    this.createdOn,
    this.lastModifiedBy,
    this.lastModifiedOn,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'voiceId': voiceId,
        'additionalInfo': additionalInfo?.toJson(),
        'url': url,
        'isActive': isActive,
        'createdBy': createdBy,
        'createdOn': createdOn?.toIso8601String(),
        'lastModifiedBy': lastModifiedBy,
        'lastModifiedOn': lastModifiedOn,
      };

  factory VoiceClone.fromJson(Map<String, dynamic> json) => VoiceClone(
        id: json['id'],
        voiceId: json['voiceId'],
        additionalInfo: json['additionalInfo'] == null
            ? null
            : VoiceCloneAdditionalInfo.fromJson(json['additionalInfo']),
        url: json['url'],
        isActive: json['isActive'],
        createdBy: json['createdBy'],
        createdOn: json['createdOn'] == null
            ? null
            : DateTime.parse(json['createdOn']),
        lastModifiedBy: json['lastModifiedBy'],
        lastModifiedOn: json['lastModifiedOn'],
      );
}

class VoiceCloneAdditionalInfo {
  final int? fileSize;
  final String? fileType;

  VoiceCloneAdditionalInfo({
    this.fileSize,
    this.fileType,
  });

  Map<String, dynamic> toJson() => {
        'fileSize': fileSize,
        'fileType': fileType,
      };

  factory VoiceCloneAdditionalInfo.fromJson(Map<String, dynamic> json) =>
      VoiceCloneAdditionalInfo(
        fileSize: json['fileSize'],
        fileType: json['fileType'],
      );
}
