import 'package:myfhb/common/CommonUtil.dart';

class GetUserActivitiesHistoryModel {
  GetUserActivitiesHistoryModel({
    this.isSuccess,
    this.result,
  });

  GetUserActivitiesHistoryModel.fromJson(Map<String, dynamic> json) {
    try {
      isSuccess = json['isSuccess'];
      result = json['result'] == null
          ? []
          : List<Result>.from(json['result']!.map((x) => Result.fromJson(x)));
    } catch (e, stackTrace) {
      CommonUtil().appLogs(
        message: e,
        stackTrace: stackTrace,
      );
    }
  }
  bool? isSuccess;
  List<Result>? result;

  Map<String, dynamic> toJson() => {
        'isSuccess': isSuccess,
        'result': result == null
            ? []
            : List<dynamic>.from(
                result!.map(
                  (x) => x.toJson(),
                ),
              ),
      };
}

class Result {
  Result({
    this.id,
    this.patientId,
    this.healthOrganizationId,
    this.screen,
    this.activity,
    this.status,
    this.seconds,
    this.createdOn,
    this.isActive,
    this.additionalInfo,
    this.patient,
    this.user,
  });

  Result.fromJson(Map<String, dynamic> json) {
    try {
      id = json['id'];
      patientId = json['patientId'];
      healthOrganizationId = json['healthOrganizationId'];
      screen = json['screen'];
      activity = json['activity'];
      status = json['status'];
      seconds = json['seconds'];
      createdOn = json['createdOn'];
      isActive = json['isActive'];
      additionalInfo = json['additionalInfo'] == null
          ? null
          : ResultAdditionalInfo.fromJson(
              json['additionalInfo'],
            );
      patient = json['patient'] == null
          ? null
          : Patient.fromJson(
              json['patient'],
            );
      user = json['user'] == null
          ? null
          : Patient.fromJson(
              json['user'],
            );
    } catch (e, stackTrace) {
      CommonUtil().appLogs(
        message: e,
        stackTrace: stackTrace,
      );
    }
  }

  String? id;
  String? patientId;
  String? healthOrganizationId;
  String? screen;
  String? activity;
  String? status;
  int? seconds;
  String? createdOn;
  bool? isActive;
  ResultAdditionalInfo? additionalInfo;
  Patient? patient;
  Patient? user;

  Map<String, dynamic> toJson() => {
        'id': id,
        'patientId': patientId,
        'healthOrganizationId': healthOrganizationId,
        'screen': screen,
        'activity': activity,
        'status': status,
        'seconds': seconds,
        'createdOn': createdOn,
        'isActive': isActive,
        'additionalInfo': additionalInfo?.toJson(),
        'patient': patient?.toJson(),
        'user': user?.toJson(),
      };
}

class ResultAdditionalInfo {
  ResultAdditionalInfo({
    this.ack,
    this.eid,
    this.title,
    this.uform,
    this.action,
    this.status,
    this.cptCode,
    this.dosemeal,
    this.ackLocal,
    this.issymptom,
    this.uformdata,
    this.activityTime,
    this.cptCodeDetails,
  });

  ResultAdditionalInfo.fromJson(Map<String, dynamic> json) {
    try {
      ack = json['ack'];
      eid = json['eid'];
      title = json['title'];
      uform = json['uform'] == null
          ? null
          : json['uform'].runtimeType == Map()
              ? Uform.fromJson(
                  json['uform'],
                )
              : null;
      action = json['action'] == null
          ? null
          : Action.fromJson(
              json['action'],
            );
      status = json['status'];
      cptCode = json['cpt_code'];
      dosemeal = json['dosemeal'];
      ackLocal = json['ack_local'];
      issymptom = json['issymptom'];
      uformdata = json['uformdata'] == null || json['uformdata'].runtimeType == String
              ? null
              : Uformdata.fromJson(
                  json['uformdata'],
                );
      activityTime = json['activityTime'];
      cptCodeDetails = json['cpt_code_details'];
    } catch (e, stackTrace) {
      CommonUtil().appLogs(
        message: e,
        stackTrace: stackTrace,
      );
    }
  }

  String? ack;
  int? eid;
  String? title;
  Uform? uform;
  Action? action;
  String? status;
  String? cptCode;
  int? dosemeal;
  String? ackLocal;
  bool? issymptom;
  Uformdata? uformdata;
  String? activityTime;
  String? cptCodeDetails;

  Map<String, dynamic> toJson() => {
        'ack': ack,
        'eid': eid,
        'title': title,
        'uform': uform?.toJson(),
        'action': action?.toJson(),
        'status': status,
        'cpt_code': cptCode,
        'dosemeal': dosemeal,
        'ack_local': ackLocal,
        'issymptom': issymptom,
        'uformdata': uformdata?.toJson(),
        'activityTime': activityTime,
        'cpt_code_details': cptCodeDetails,
      };
}

class Action {
  Action({
    this.id,
    this.code,
    this.name,
    this.comment,
  });

  Action.fromJson(Map<String, dynamic> json) {
    try {
      id = json['id'];
      code = json['code'];
      name = json['name'];
      comment = json['comment'];
    } catch (e, stackTrace) {
      CommonUtil().appLogs(
        message: e,
        stackTrace: stackTrace,
      );
    }
  }
  String? id;
  String? code;
  String? name;
  String? comment;

  Map<String, dynamic> toJson() => {
        'id': id,
        'code': code,
        'name': name,
        'comment': comment,
      };
}

class Uform {
  Uform({
    this.weight,
  });

  Uform.fromJson(Map<String, dynamic> json) {
    try {
      weight = json['Weight'] == null
          ? null
          : UformWeight.fromJson(
              json['Weight'],
            );
    } catch (e, stackTrace) {
      CommonUtil().appLogs(
        message: e,
        stackTrace: stackTrace,
      );
    }
  }
  UformWeight? weight;

  Map<String, dynamic> toJson() => {
        'Weight': weight?.toJson(),
      };
}

class UformWeight {
  UformWeight({
    this.ts,
    this.seq,
    this.amax,
    this.amin,
    this.info,
    this.vmax,
    this.vmin,
    this.depth,
    this.fdata,
    this.ftype,
    this.title,
    this.uomid,
    this.formid,
    this.deleted,
    this.fieldid,
    this.otherinfo,
    this.providerid,
    this.validation,
    this.description,
    this.lastModifiedBy,
  });

  UformWeight.fromJson(Map<String, dynamic> json) {
    try {
      ts = json['ts'];
      seq = json['seq'];
      amax = json['amax'];
      amin = json['amin'];
      info = json['info'];
      vmax = json['vmax'];
      vmin = json['vmin'];
      depth = json['depth'];
      fdata = json['fdata'];
      ftype = json['ftype'];
      title = json['title'];
      uomid = json['uomid'];
      formid = json['formid'];
      deleted = json['deleted'];
      fieldid = json['fieldid'];
      otherinfo = json['otherinfo'];
      providerid = json['providerid'];
      validation = json['validation'];
      description = json['description'];
      lastModifiedBy = json['last_modified_by'];
    } catch (e, stackTrace) {
      CommonUtil().appLogs(
        message: e,
        stackTrace: stackTrace,
      );
    }
  }

  String? ts;
  String? seq;
  String? amax;
  String? amin;
  String? info;
  String? vmax;
  String? vmin;
  String? depth;
  String? fdata;
  String? ftype;
  String? title;
  String? uomid;
  String? formid;
  String? deleted;
  String? fieldid;
  String? otherinfo;
  String? providerid;
  dynamic validation;
  String? description;
  dynamic lastModifiedBy;

  Map<String, dynamic> toJson() => {
        'ts': ts,
        'seq': seq,
        'amax': amax,
        'amin': amin,
        'info': info,
        'vmax': vmax,
        'vmin': vmin,
        'depth': depth,
        'fdata': fdata,
        'ftype': ftype,
        'title': title,
        'uomid': uomid,
        'formid': formid,
        'deleted': deleted,
        'fieldid': fieldid,
        'otherinfo': otherinfo,
        'providerid': providerid,
        'validation': validation,
        'description': description,
        'last_modified_by': lastModifiedBy,
      };
}

class Uformdata {
  Uformdata({
    this.weight,
  });

  Uformdata.fromJson(Map<String, dynamic> json) {
    try {
      weight = json['Weight'] == null
          ? null
          : UformdataWeight.fromJson(
              json['Weight'],
            );
    } catch (e, stackTrace) {
      CommonUtil().appLogs(
        message: e,
        stackTrace: stackTrace,
      );
    }
  }
  UformdataWeight? weight;

  Map<String, dynamic> toJson() => {
        'Weight': weight?.toJson(),
      };
}

class UformdataWeight {
  UformdataWeight({
    this.seq,
    this.amax,
    this.amin,
    this.type,
    this.vmax,
    this.vmin,
    this.alarm,
    this.value,
    this.display,
    this.description,
    this.requestFileUrl,
    this.requestFileType,
  });
  UformdataWeight.fromJson(Map<String, dynamic> json) {
    try {
      seq = json['seq'];
      amax = json['amax'];
      amin = json['amin'];
      type = json['type'];
      vmax = json['vmax'];
      vmin = json['vmin'];
      alarm = json['alarm'];
      value = json['value'];
      display = json['display'];
      description = json['description'];
      requestFileUrl = json['requestFileUrl'];
      requestFileType = json['requestFileType'];
    } catch (e, stackTrace) {
      CommonUtil().appLogs(
        message: e,
        stackTrace: stackTrace,
      );
    }
  }
  String? seq;
  String? amax;
  String? amin;
  String? type;
  String? vmax;
  String? vmin;
  int? alarm;
  String? value;
  String? display;
  String? description;
  dynamic requestFileUrl;
  dynamic requestFileType;

  Map<String, dynamic> toJson() => {
        'seq': seq,
        'amax': amax,
        'amin': amin,
        'type': type,
        'vmax': vmax,
        'vmin': vmin,
        'alarm': alarm,
        'value': value,
        'display': display,
        'description': description,
        'requestFileUrl': requestFileUrl,
        'requestFileType': requestFileType,
      };
}

class Patient {
  Patient({
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

  Patient.fromJson(Map<String, dynamic> json) {
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
      providerId = json['providerId'];
      additionalInfo = json['additionalInfo'] == null
          ? null
          : PatientAdditionalInfo.fromJson(
              json['additionalInfo'],
            );
      timezone = json['timezone'];
    } catch (e, stackTrace) {
      CommonUtil().appLogs(
        message: e,
        stackTrace: stackTrace,
      );
    }
  }
  String? id;
  dynamic name;
  String? userName;
  String? firstName;
  String? middleName;
  String? lastName;
  String? gender;
  String? dateOfBirth;
  String? bloodGroup;
  dynamic countryCode;
  String? profilePicUrl;
  String? profilePicThumbnailUrl;
  dynamic isTempUser;
  dynamic isVirtualUser;
  dynamic isMigrated;
  dynamic isClaimed;
  bool? isIeUser;
  dynamic isEmailVerified;
  bool? isCpUser;
  dynamic communicationPreferences;
  dynamic medicalPreferences;
  bool? isSignedIn;
  bool? isActive;
  String? createdBy;
  String? createdOn;
  String? lastModifiedBy;
  String? lastModifiedOn;
  String? providerId;
  PatientAdditionalInfo? additionalInfo;
  String? timezone;

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'userName': userName,
        'firstName': firstName,
        'middleName': middleName,
        'lastName': lastName,
        'gender': gender,
        'dateOfBirth': dateOfBirth,
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
        'createdOn': createdOn,
        'lastModifiedBy': lastModifiedBy,
        'lastModifiedOn': lastModifiedOn,
        'providerId': providerId,
        'additionalInfo': additionalInfo?.toJson(),
        'timezone': timezone,
      };
}

class PatientAdditionalInfo {
  PatientAdditionalInfo({
    this.height,
    this.offset,
    this.weight,
    this.heightUnitCode,
    this.weightUnitCode,
  });
  PatientAdditionalInfo.fromJson(Map<String, dynamic> json) {
    try {
      height = json['height'];
      offset = json['offset'];
      weight = json['weight'];
      heightUnitCode = json['heightUnitCode'];
      weightUnitCode = json['weightUnitCode'];
    } catch (e, stackTrace) {
      CommonUtil().appLogs(
        message: e,
        stackTrace: stackTrace,
      );
    }
  }
  String? height;
  String? offset;
  String? weight;
  String? heightUnitCode;
  String? weightUnitCode;

  Map<String, dynamic> toJson() => {
        'height': height,
        'offset': offset,
        'weight': weight,
        'heightUnitCode': heightUnitCode,
        'weightUnitCode': weightUnitCode,
      };
}
