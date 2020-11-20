import 'package:myfhb/constants/fhb_parameters.dart' as parameters;
import 'package:myfhb/src/model/Health/CategoryInfo.dart';
import 'package:myfhb/src/model/Health/DeviceReadings.dart';
import 'package:myfhb/src/model/Health/Doctor.dart';
import 'package:myfhb/src/model/Health/Hospital.dart';
import 'package:myfhb/src/model/Health/Laboratory.dart';
import 'package:myfhb/src/model/Health/MediaTypeInfo.dart';

class MetaInfo {
  CategoryInfo categoryInfo;
  String dateOfVisit;
  List<DeviceReadings> deviceReadings;
  Doctor doctor;
  String fileName;
  bool hasVoiceNotes;
  bool isDraft;
  MediaTypeInfo mediaTypeInfo;
  String memoText;
  String memoTextRaw;
  String sourceName;
  Laboratory laboratory;
  Hospital hospital;
  String dateOfExpiry;
  String idType;

  MetaInfo(
      {this.categoryInfo,
      this.dateOfVisit,
      this.deviceReadings,
      this.doctor,
      this.fileName,
      this.hasVoiceNotes,
      this.isDraft,
      this.mediaTypeInfo,
      this.memoText,
      this.memoTextRaw,
      this.sourceName,
      this.laboratory,
      this.hospital,
      this.dateOfExpiry,
      this.idType});

  MetaInfo.fromJson(Map<String, dynamic> json) {
    categoryInfo = json[parameters.strcategoryInfo] != null
        ? new CategoryInfo.fromJson(json[parameters.strcategoryInfo])
        : null;
    dateOfVisit = json[parameters.strdateOfVisit];
    try{
    if (json[parameters.strdeviceReadings] != null) {
      deviceReadings = new List<DeviceReadings>();
      json[parameters.strdeviceReadings].forEach((v) {
        deviceReadings.add(new DeviceReadings.fromJson(v));
      });
    }
     }catch(e){

    }
    doctor =
        json[parameters.strdoctor] != null ? new Doctor.fromJson(json[parameters.strdoctor]) : null;
    fileName = json[parameters.strfileName];
    hasVoiceNotes = json[parameters.strhasVoiceNotes]!=null?json[parameters.strhasVoiceNotes]:false;
    isDraft = json[parameters.strisDraft]!=null?json[parameters.strisDraft]:false;
    mediaTypeInfo = json[parameters.strmediaTypeInfo] != null
        ? new MediaTypeInfo.fromJson(json[parameters.strmediaTypeInfo])
        : null;
    memoText = json[parameters.strmemoText];
    memoTextRaw = json[parameters.strmemoTextRaw];
    sourceName = json[parameters.strsourceName];
    laboratory = json[parameters.strlaboratory] != null
        ? new Laboratory.fromJson(json[parameters.strlaboratory])
        : null;
    hospital = json[parameters.strhospital] != null
        ? new Hospital.fromJson(json[parameters.strhospital])
        : null;
    dateOfExpiry = json[parameters.strdateOfExpiry];
    idType = json[parameters.stridType] != null ? json[parameters.stridType] : "";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.categoryInfo != null) {
      data[parameters.strcategoryInfo] = this.categoryInfo.toJson();
    }
    data[parameters.strdateOfVisit] = this.dateOfVisit;
    if (this.deviceReadings != null) {
      data[parameters.strdeviceReadings] =
          this.deviceReadings.map((v) => v.toJson()).toList();
    }
    if (this.doctor != null) {
      data[parameters.strdoctor] = this.doctor.toJson();
    }
    data[parameters.strfileName] = this.fileName;
    data[parameters.strhasVoiceNotes] = this.hasVoiceNotes;
    data[parameters.strisDraft] = this.isDraft;
    if (this.mediaTypeInfo != null) {
      data[parameters.strmediaTypeInfo] = this.mediaTypeInfo.toJson();
    }
    data[parameters.strmemoText] = this.memoText;
    data[parameters.strmemoTextRaw] = this.memoTextRaw;
    data[parameters.strsourceName] = this.sourceName;
    if (this.laboratory != null) {
      data[parameters.strlaboratory] = this.laboratory.toJson();
    }
    if (this.hospital != null) {
      data[parameters.strhospital] = this.hospital.toJson();
    }
    data[parameters.strdateOfExpiry] = this.dateOfExpiry;
    if (this.idType != null) {
      data[parameters.stridType] = this.idType;
    }
    return data;
  }
}




