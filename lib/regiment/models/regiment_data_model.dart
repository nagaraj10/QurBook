import 'dart:convert';

import 'package:get/get.dart';
import 'package:myfhb/common/CommonUtil.dart';
import 'package:myfhb/regiment/models/Status.dart';
import 'package:myfhb/telehealth/features/appointments/model/fetchAppointments/past.dart';

import '../../../constants/fhb_constants.dart' as Constants;

class RegimentDataModel {
  RegimentDataModel(
      {this.eid,
      this.id,
      this.providerid,
      this.uid,
      this.title,
      this.description,
      this.tplanid,
      this.teidUser,
      this.aid,
      this.activityname,
      this.uformid,
      this.uformname,
      this.uformname1,
      this.estart,
      this.estartNew,
      this.eend,
      this.html,
      this.otherinfo,
      this.remindin,
      this.remindinType,
      this.ack,
      this.ack_local,
      this.ackIST,
      this.alarm,
      this.uformdata,
      this.ts,
      this.deleted,
      this.evDuration,
      this.hashtml,
      this.hascustform,
      this.htmltemplate,
      this.dosesNeeded,
      this.dosesAvailable,
      this.dosesUsed,
      this.providername,
      this.hasform,
      this.saytext,
      this.doseMeal,
      this.doseRepeat,
      this.metadata,
      this.isActive,
      this.scheduled = false,
      this.asNeeded = false,
      this.isEventDisabled = false,
      this.sayTextDynamic,
      this.isSymptom = false,
      this.isMandatory = false,
      this.isModifiedToday = false,
      this.healthOrgName,
      this.activityOrgin,
      this.duration,
      this.seq,
      this.doctorSessionId,
      this.serviceCategory,
      this.modeOfService,
      this.isEndTimeOptional,
      this.code,
      this.dayrepeat,
      this.additionalInfo,
      this.doseMealString,
      this.activityThreshold});

  final dynamic eid;
  final dynamic id;
  final dynamic providerid;
  final dynamic uid;
  final dynamic title;
  final dynamic description;
  final dynamic tplanid;
  final dynamic teidUser;
  final dynamic aid;
  final Activityname? activityname;
  final dynamic uformid;
  final Uformname? uformname;
  final String? uformname1;
  final DateTime? estart;
  final String? estartNew;
  final DateTime? eend;
  final dynamic html;
  final Otherinfo? otherinfo;
  final dynamic remindin;
  final dynamic remindinType;
  final DateTime? ack;
  final DateTime? ack_local;
  final DateTime? ackIST;
  final dynamic alarm;
  final UformData? uformdata;
  final DateTime? ts;
  final dynamic deleted;
  final dynamic evDuration;
  final bool? hashtml;
  final bool? isActive;
  final dynamic hascustform;
  final dynamic htmltemplate;
  final dynamic dosesNeeded;
  final dynamic dosesAvailable;
  final dynamic dosesUsed;
  final dynamic providername;
  final bool? hasform;
  final dynamic saytext;
  final bool? doseMeal;
  final dynamic doseRepeat;
  final Metadata? metadata;
  Rx<bool> isPlaying = false.obs;
  final bool scheduled;
  final bool asNeeded;
  final bool isEventDisabled;
  final dynamic sayTextDynamic;
  final bool isSymptom;
  final bool? isEndTimeOptional;
  final String? code;
  final bool isMandatory;
  final bool isModifiedToday;
  final dynamic healthOrgName;
  final dynamic activityOrgin;
  final int? duration;
  String? seq;
  final dynamic doctorSessionId;
  final ServiceCategory? serviceCategory;
  final ServiceCategory? modeOfService;
  final dynamic dayrepeat;
  AdditionalInfo? additionalInfo;
  String? doseMealString;
  final dynamic? activityThreshold;

  factory RegimentDataModel.fromJson(Map<String, dynamic> json,
          {String? date}) =>
      RegimentDataModel(
        eid: json['eid'],
        id: json['id'],
        providerid: json['providerid'],
        uid: json['uid'],
        title: json['title'],
        description: json['description'],
        isEndTimeOptional: json['additionalInfo'] != null
            ? json['additionalInfo']['isEndTimeOptional']
            : null,
        code: json['serviceCategory'] != null
            ? json['serviceCategory']['code']
            : null,
        tplanid: json['tplanid'],
        teidUser: json['teid_user'],
        aid: json['aid'],
        activityname: activitynameValues.map[json['activityname']],
        uformid: json['uformid'],
        uformname: uformnameValues.map[json['uformname']],
        uformname1: (json['uformname'] ?? ''),
        estart: DateTime.tryParse(json['estart'] ?? ''),
        estartNew: json['estart'] ?? '',
        eend: DateTime.tryParse(json['eend'] ?? ''),
        html: json['html'] != null ? json['html'] : '',
        otherinfo: json['otherinfo'] != null
            ? Otherinfo.fromJson(json['otherinfo'] is List
                ? {}
                : (json['otherinfo'] ?? '{}' as Map<String, dynamic>))
            : null,
        remindin: json['remindin'],
        remindinType: json['remindin_type'],
        ack: json['ack_utc'] == null
            ? null
            : DateTime.tryParse(json['ack_utc'] ?? '')?.toLocal(),
        ackIST: DateTime.tryParse(json['ack'] ?? ''),
        ack_local: (json['ack_local'] ?? '').isEmpty
            ? null
            : DateTime.tryParse(json['ack_local']!),
        alarm: json['alarm'],
        uformdata:
            json['uformdata'] != null && json['uformdata'].toString().isNotEmpty
                ? UformData().fromJson(jsonDecode(json['uformdata'] ?? '{}'))
                : null,
        ts: DateTime.tryParse(json['ts'] ?? ''),
        deleted: json['deleted'],
        evDuration: json['ev_duration'],
        hashtml: (json['hashtml'] ?? 0) == 1,
        hascustform: json['hascustform'],
        htmltemplate: json['htmltemplate'],
        dosesNeeded: json['doses_needed'],
        dosesAvailable: json['doses_available'],
        dosesUsed: json['doses_used'],
        providername: json['providername'],
        hasform: (json['hasform'] ?? 0) == 1,
        saytext: json['saytext'],
        doseMealString: json['dosemeal'] ?? "",
        doseMeal: (((json['dosemeal'] ?? 0).toString() == '64') ||
                ((json['dosemeal'] ?? 0).toString() == '128')) &&
            (activitynameValues.map[json['activityname']] ==
                Activityname.SYMPTOM),
        asNeeded: json['hour_repeat'] != null
            ? (json['hour_repeat']?.trim().toLowerCase() ==
                    Constants.strText.trim().toLowerCase())
                ? false
                : (((json['dosemeal'] ?? 0).toString() == '64') ||
                    ((json['dosemeal'] ?? 0).toString() == '128'))
            : false,
        scheduled: ((json['dosemeal'] ?? 0).toString() != '64') &&
            ((json['dosemeal'] ?? 0).toString() != '128'),
        doseRepeat: json['doserepeat'],
        metadata: json['metadata'] is List
            ? Metadata()
            : Metadata.fromJson(json['metadata'] ?? {}),
        isEventDisabled: (json['ev_disabled'] ?? '0') == '1',
        sayTextDynamic: json['saytext_dyn'] ?? '',
        isSymptom: (json['issymptom'] ?? '0') == '1',
        isMandatory: (json['importance'] ?? '0') == '2',
        isModifiedToday: ((json['customized'] ?? '0') == '1') &&
            (CommonUtil.getDateStringFromDateTime(json['dtu_ts']) ==
                CommonUtil.getDateStringFromDateTime(json['estart'])),
        healthOrgName: json['healthorganizationname'],
        activityOrgin: json['activityname_orig'],
        duration: json['duration'],
        seq: json['seq'],
        doctorSessionId:
            json.containsKey('doctorSessionId') ? json['doctorSessionId'] : '',
        serviceCategory: json['serviceCategory'] != null
            ? ServiceCategory.fromJson(json['serviceCategory'])
            : null,
        modeOfService: json['modeOfService'] != null
            ? ServiceCategory.fromJson(json['modeOfService'])
            : null,
        dayrepeat: json['hour_repeat'],
        activityThreshold: json.containsKey('activityThreshold')
            ? json['activityThreshold' ?? 15]
            : 15,
        additionalInfo: json['additionalInfo'] != null
            ? AdditionalInfo.fromJson(json['additionalInfo'])
            : null,
      );

  Map<String, dynamic> toJson() => {
        'eid': eid,
        'id': id,
        'providerid': providerid,
        'uid': uid,
        'title': title,
        'description': description,
        'tplanid': tplanid,
        'teid_user': teidUser,
        'aid': aid,
        'activityname': activitynameValues.reverse![activityname!],
        'uformid': uformid,
        'uformname': uformnameValues.reverse![uformname!],
        'uformname': uformname1,
        'estart': estart?.toIso8601String(),
        'eend': eend?.toIso8601String(),
        'html': html,
        'otherinfo': otherinfo?.toJson(),
        'remindin': remindin,
        'remindin_type': remindinType,
        'ack_utc': ack?.toIso8601String(),
        'ack': ackIST?.toIso8601String(),
        'ack_local': ack_local?.toIso8601String(),
        'alarm': alarm,
        'uformdata': uformdata,
        'ts': ts?.toIso8601String(),
        'deleted': deleted,
        'ev_duration': evDuration,
        'hashtml': hashtml,
        'hascustform': hascustform,
        'htmltemplate': htmltemplate,
        'doses_needed': dosesNeeded,
        'doses_available': dosesAvailable,
        'doses_used': dosesUsed,
        'providername': providername,
        'hasform': hasform,
        'saytext': saytext,
        'dosemeal': doseMeal,
        'doserepeat': doseRepeat,
        'metadata': metadata!.toJson(),
        'ev_disabled': isEventDisabled ? '1' : '0',
        'saytext_dyn': sayTextDynamic,
        'healthorganizationname': healthOrgName,
        'activityname_orig': activityOrgin,
        'duration': duration,
        'seq': seq,
        'doctorSessionId': doctorSessionId,
        'serviceCategory': serviceCategory!.toJson(),
        'modeOfService': modeOfService!.toJson(),
        'hour_repeat': dayrepeat,
        'activityThreshold': activityThreshold,
        'additionalInfo':
            additionalInfo?.toJson() ?? Map<String, dynamic>(),
      };
}

class Otherinfo {
  Otherinfo(
      {this.needPhoto,
      this.needAudio,
      this.needVideo,
      this.needFile,
      this.snoozeText,
      this.introText,
      this.isAllDayActivity,
      this.isSkipAcknowledgement});

  final String? needPhoto;
  final String? needAudio;
  final String? needVideo;
  final String? needFile;
  final String? snoozeText;
  final String? introText;
  final bool? isAllDayActivity;
  final String? isSkipAcknowledgement;

  factory Otherinfo.fromJson(Map<String, dynamic> json) => Otherinfo(
        needPhoto: (json['NeedPhoto'] ?? 0).toString(),
        needAudio: (json['NeedAudio'] ?? 0).toString(),
        needVideo: (json['NeedVideo'] ?? 0).toString(),
        needFile: (json['NeedFile'] ?? 0).toString(),
        snoozeText: json.containsKey('snoozeText') ? (json['snoozeText']) : '',
        isAllDayActivity: json.containsKey('isAllDayActivity')
            ? (json['isAllDayActivity'] ?? false)
            : false,
        isSkipAcknowledgement: json.containsKey('isSkipAcknowledgement')
            ? (json['isSkipAcknowledgement'] ?? 0).toString()
            : "0",
        introText: json.containsKey('introtext') ? (json['introtext']) : '',
      );

  Map<String, dynamic> toJson() => {
        'NeedPhoto': needPhoto,
        'NeedAudio': needAudio,
        'NeedVideo': needVideo,
        'NeedFile': needFile,
        'snoozeText': snoozeText,
        'introtext': introText,
        'isAllDayActivity': isAllDayActivity
      };
}

class UformData {
  UformData({
    this.vitalsData,
  });

  List<VitalsData>? vitalsData;

  UformData fromJson(Map<String, dynamic> json) {
    final vitalsDataList = <VitalsData>[];
    json.forEach((key, value) {
      final vitalsMap = <String, dynamic>{};
      vitalsMap.addAll(value);
      vitalsMap.putIfAbsent('vitalName', () => key);
      vitalsDataList.add(VitalsData.fromJson(vitalsMap));
    });
    return UformData(
      vitalsData: vitalsDataList,
    );
  }

  Map<String?, dynamic> toJson() {
    final jsonMap = <String?, dynamic>{};
    vitalsData!.forEach((vitalData) {
      jsonMap.putIfAbsent(vitalData.vitalName, () => vitalData.toJson());
    });
    return jsonMap;
  }
}

class VitalsData {
  VitalsData(
      {this.vitalName,
      this.value,
      this.type,
      this.display,
      this.description,
      this.alarm,
      this.amin,
      this.amax,
      this.fieldType,
      this.photo,
      this.audio,
      this.video,
      this.file});

  dynamic vitalName;
  dynamic value;
  dynamic type;
  dynamic display;
  dynamic description;
  dynamic alarm;
  dynamic amin;
  dynamic amax;
  FieldType? fieldType;
  OtherData? photo;
  OtherData? audio;
  OtherData? file;
  OtherData? video;

  factory VitalsData.fromJson(Map<String, dynamic> json) {
    return VitalsData(
      vitalName: json['vitalName'] ?? '',
      value: json['value'],
      type: json['type'],
      display: json['display'],
      description: json['description'] != null ? json['description'] : null,
      alarm: json['alarm'],
      amin: json['amin'],
      amax: json['amax'],
      fieldType: fieldTypeValues.map[json['type']],
      photo: json['PHOTO'] != null ? OtherData.fromMap(json['PHOTO']) : null,
      audio: json['AUDIO'] != null ? OtherData.fromMap(json['AUDIO']) : null,
      video: json['VIDEO'] != null ? OtherData.fromMap(json['VIDEO']) : null,
      file: json['FILE'] != null ? OtherData.fromMap(json['FILE']) : null,
    );
  }

  Map<String, dynamic> toJson() => {
        'value': value,
        'type': type,
        'display': display,
        'description': description,
        'alarm': alarm,
        'amin': amin,
        'amax': amax,
      };
}

enum Activityname {
  DIET,
  VITALS,
  MEDICATION,
  SCREENING,
  SYMPTOM,
  APPOINTMENT,
  ANNOUNCEMENT
}

final activitynameValues = EnumValues({
  'diet': Activityname.DIET,
  'medication': Activityname.MEDICATION,
  'screening': Activityname.SCREENING,
  'vitals': Activityname.VITALS,
  'symptom': Activityname.SYMPTOM,
  'appointment': Activityname.APPOINTMENT,
  'announcement': Activityname.ANNOUNCEMENT,
});

enum FieldType { NUMBER, CHECKBOX, TEXT, LOOKUP, RADIO }

final fieldTypeValues = EnumValues({
  'number': FieldType.NUMBER,
  'checkbox': FieldType.CHECKBOX,
  'mlist': FieldType.CHECKBOX,
  'text': FieldType.TEXT,
  'lookup': FieldType.LOOKUP,
  'check': FieldType.CHECKBOX,
  'radio': FieldType.RADIO,
});

enum Uformname { EMPTY, BLOODPRESSURE, BLOODSUGAR, PULSE }

final uformnameValues = EnumValues({
  'bloodpressure': Uformname.BLOODPRESSURE,
  'bloodsugar': Uformname.BLOODSUGAR,
  'pulse': Uformname.PULSE,
  '': Uformname.EMPTY
});

class EnumValues<T> {
  Map<String, T> map;
  Map<T, String>? reverseMap;

  EnumValues(this.map);

  Map<T, String>? get reverse {
    reverseMap ??= map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}

class Metadata {
  Metadata({
    this.icon,
    this.color,
    this.bgcolor,
    this.metadatafrom,
  });

  final String? icon;
  final String? color;
  final String? bgcolor;
  final String? metadatafrom;

  factory Metadata.fromJson(Map<String, dynamic> json) => Metadata(
        icon: json['icon'],
        color: json['color'],
        bgcolor: json['bgcolor'],
        metadatafrom: json['metadatafrom'],
      );

  Map<String, dynamic> toJson() => {
        'icon': icon,
        'color': color,
        'bgcolor': bgcolor,
        'metadatafrom': metadatafrom,
      };
}

class OtherData {
  String? name;
  String? url;

  OtherData({
    this.name,
    this.url,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'url': url,
    };
  }

  factory OtherData.fromMap(Map<String, dynamic> map) {
    return OtherData(
      name: map['name'],
      url: map['url'],
    );
  }

  String toJson() => json.encode(toMap());

  factory OtherData.fromJson(String source) =>
      OtherData.fromMap(json.decode(source));

  @override
  String toString() => 'OtherData(name: $name, url: $url)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is OtherData && other.name == name && other.url == url;
  }

  @override
  int get hashCode => name.hashCode ^ url.hashCode;
}
