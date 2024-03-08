class GetUserActivitiesHistoryModel {
  GetUserActivitiesHistoryModel({
    this.isSuccess,
    this.result,
  });

  factory GetUserActivitiesHistoryModel.fromJson(Map<String, dynamic> json) =>
      GetUserActivitiesHistoryModel(
        isSuccess: json['isSuccess'],
        result: json['result'] == null
            ? []
            : List<Result>.from(json['result']!.map((x) => Result.fromJson(x))),
      );
  final bool? isSuccess;
  final List<Result>? result;

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

  factory Result.fromJson(Map<String, dynamic> json) => Result(
        id: json['id'],
        patientId: json['patientId'],
        healthOrganizationId: json['healthOrganizationId'],
        screen: json['screen'],
        activity: json['activity'],
        status: json['status'],
        seconds: json['seconds'],
        createdOn: json['createdOn'] == null
            ? null
            : DateTime.parse(json['createdOn']),
        isActive: json['isActive'],
        additionalInfo: json['additionalInfo'] == null
            ? null
            : ResultAdditionalInfo.fromJson(json['additionalInfo']),
        patient:
            json['patient'] == null ? null : Patient.fromJson(json['patient']),
        user: json['user'] == null ? null : Patient.fromJson(json['user']),
      );
  final String? id;
  final String? patientId;
  final String? healthOrganizationId;
  final String? screen;
  final String? activity;
  final String? status;
  final int? seconds;
  final DateTime? createdOn;
  final bool? isActive;
  final ResultAdditionalInfo? additionalInfo;
  final Patient? patient;
  final Patient? user;

  Map<String, dynamic> toJson() => {
        'id': id,
        'patientId': patientId,
        'healthOrganizationId': healthOrganizationId,
        'screen': screen,
        'activity': activity,
        'status': status,
        'seconds': seconds,
        'createdOn': createdOn?.toIso8601String(),
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

  factory ResultAdditionalInfo.fromJson(Map<String, dynamic> json) =>
      ResultAdditionalInfo(
        ack: json['ack'] == null ? null : DateTime.parse(json['ack']),
        eid: json['eid'],
        title: json['title'],
        uform: json['uform'] == null
            ? null
            : json['uform'].runtimeType == Map()
                ? Uform.fromJson(json['uform']) : null,
        action: json['action'] == null ? null : Action.fromJson(json['action']),
        status: json['status'],
        cptCode: json['cpt_code'],
        dosemeal: json['dosemeal'],
        ackLocal: json['ack_local'] == null
            ? null
            : DateTime.parse(json['ack_local']),
        issymptom: json['issymptom'],
        uformdata: json['uformdata'] == null ||
                json['uformdata'].runtimeType == String
            ? null
            : Uformdata.fromJson(json['uformdata']),
        activityTime: json['activityTime'],
        cptCodeDetails: json['cpt_code_details'],
      );
  final DateTime? ack;
  final int? eid;
  final String? title;
  final Uform? uform;
  final Action? action;
  final String? status;
  final String? cptCode;
  final int? dosemeal;
  final DateTime? ackLocal;
  final bool? issymptom;
  final Uformdata? uformdata;
  final String? activityTime;
  final String? cptCodeDetails;

  Map<String, dynamic> toJson() => {
        'ack': ack?.toIso8601String(),
        'eid': eid,
        'title': title,
        'uform': uform?.toJson(),
        'action': action?.toJson(),
        'status': status,
        'cpt_code': cptCode,
        'dosemeal': dosemeal,
        'ack_local': ackLocal?.toIso8601String(),
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

  factory Action.fromJson(Map<String, dynamic> json) => Action(
        id: json['id'],
        code: json['code'],
        name: json['name'],
        comment: json['comment'],
      );
  final String? id;
  final String? code;
  final String? name;
  final String? comment;

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

  factory Uform.fromJson(Map<String, dynamic> json) => Uform(
        weight: json['Weight'] == null
            ? null
            : UformWeight.fromJson(json['Weight']),
      );
  final UformWeight? weight;

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

  factory UformWeight.fromJson(Map<String, dynamic> json) => UformWeight(
        ts: json['ts'] == null ? null : DateTime.parse(json['ts']),
        seq: json['seq'],
        amax: json['amax'],
        amin: json['amin'],
        info: json['info'],
        vmax: json['vmax'],
        vmin: json['vmin'],
        depth: json['depth'],
        fdata: json['fdata'],
        ftype: json['ftype'],
        title: json['title'],
        uomid: json['uomid'],
        formid: json['formid'],
        deleted: json['deleted'],
        fieldid: json['fieldid'],
        otherinfo: json['otherinfo'],
        providerid: json['providerid'],
        validation: json['validation'],
        description: json['description'],
        lastModifiedBy: json['last_modified_by'],
      );
  final DateTime? ts;
  final String? seq;
  final String? amax;
  final String? amin;
  final String? info;
  final String? vmax;
  final String? vmin;
  final String? depth;
  final String? fdata;
  final String? ftype;
  final String? title;
  final String? uomid;
  final String? formid;
  final String? deleted;
  final String? fieldid;
  final String? otherinfo;
  final String? providerid;
  final dynamic validation;
  final String? description;
  final dynamic lastModifiedBy;

  Map<String, dynamic> toJson() => {
        'ts': ts?.toIso8601String(),
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

  factory Uformdata.fromJson(Map<String, dynamic> json) => Uformdata(
        weight: json['Weight'] == null
            ? null
            : UformdataWeight.fromJson(json['Weight']),
      );
  final UformdataWeight? weight;

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
  factory UformdataWeight.fromJson(Map<String, dynamic> json) =>
      UformdataWeight(
        seq: json['seq'],
        amax: json['amax'],
        amin: json['amin'],
        type: json['type'],
        vmax: json['vmax'],
        vmin: json['vmin'],
        alarm: json['alarm'],
        value: json['value'],
        display: json['display'],
        description: json['description'],
        requestFileUrl: json['requestFileUrl'],
        requestFileType: json['requestFileType'],
      );
  final String? seq;
  final String? amax;
  final String? amin;
  final String? type;
  final String? vmax;
  final String? vmin;
  final int? alarm;
  final String? value;
  final String? display;
  final String? description;
  final dynamic requestFileUrl;
  final dynamic requestFileType;

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

  factory Patient.fromJson(Map<String, dynamic> json) => Patient(
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
            : PatientAdditionalInfo.fromJson(json['additionalInfo']),
        timezone: json['timezone'],
      );
  final String? id;
  final dynamic name;
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
  final dynamic isTempUser;
  final dynamic isVirtualUser;
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
  final PatientAdditionalInfo? additionalInfo;
  final String? timezone;

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

class PatientAdditionalInfo {
  PatientAdditionalInfo({
    this.height,
    this.offset,
    this.weight,
    this.heightUnitCode,
    this.weightUnitCode,
  });
  factory PatientAdditionalInfo.fromJson(Map<String, dynamic> json) =>
      PatientAdditionalInfo(
        height: json['height'],
        offset: json['offset'],
        weight: json['weight'],
        heightUnitCode: json['heightUnitCode'],
        weightUnitCode: json['weightUnitCode'],
      );
  final String? height;
  final String? offset;
  final String? weight;
  final String? heightUnitCode;
  final String? weightUnitCode;

  Map<String, dynamic> toJson() => {
        'height': height,
        'offset': offset,
        'weight': weight,
        'heightUnitCode': heightUnitCode,
        'weightUnitCode': weightUnitCode,
      };
}
