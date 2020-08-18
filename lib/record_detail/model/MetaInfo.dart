import 'package:myfhb/constants/fhb_parameters.dart' as parameters;
import 'package:myfhb/record_detail/model/DeviceReadings.dart';
import 'package:myfhb/record_detail/model/Hospital.dart';
import 'package:myfhb/record_detail/model/MediaTypeInfo.dart';
import 'package:myfhb/src/model/Health/CategoryInfo.dart';
import 'package:myfhb/src/model/Health/Doctor.dart';

class MetaInfo {
  CategoryInfo categoryInfo;
  MediaTypeInfo mediaTypeInfo;
  String dateOfVisit;
  String memoText;
  bool hasVoiceNote;
  bool isDraft;
  String sourceName;
  String memoTextRaw;
  Doctor doctor;
  Hospital hospital;
  String fileName;
  List<DeviceReadings> deviceReadings;
  // Laboratory laboratory;

  MetaInfo(
      {this.categoryInfo,
      this.mediaTypeInfo,
      this.dateOfVisit,
      this.memoText,
      this.hasVoiceNote,
      this.isDraft,
      this.sourceName,
      this.memoTextRaw,
      this.doctor,
      this.hospital,
      this.fileName});

  MetaInfo.fromJson(Map<String, dynamic> json) {
    categoryInfo = json[parameters.strcategoryInfo] != null
        ? new CategoryInfo.fromJson(json[parameters.strcategoryInfo])
        : null;
    dateOfVisit = json[parameters.strdateOfVisit];
    if (json[parameters.strdeviceReadings] != null) {
      deviceReadings = new List<DeviceReadings>();
      json[parameters.strdeviceReadings].forEach((v) {
        deviceReadings.add(new DeviceReadings.fromJson(v));
      });
    }
    doctor =
        json[parameters.strdoctor] != null ? new Doctor.fromJson(json[parameters.strdoctor]) : null;
    fileName = json[parameters.strfileName];
    isDraft = json[parameters.strisDraft]!=null?json[parameters.strisDraft]:false;
    mediaTypeInfo = json[parameters.strmediaTypeInfo] != null
        ? new MediaTypeInfo.fromJson(json[parameters.strmediaTypeInfo])
        : null;
    memoText = json[parameters.strmemoText];
    memoTextRaw = json[parameters.strmemoTextRaw];
    sourceName = json[parameters.strsourceName];
    
    hospital = json[parameters.strhospital] != null
        ? new Hospital.fromJson(json[parameters.strhospital])
        : null;
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
    data[parameters.strisDraft] = this.isDraft;
    if (this.mediaTypeInfo != null) {
      data[parameters.strmediaTypeInfo] = this.mediaTypeInfo.toJson();
    }
    data[parameters.strmemoText] = this.memoText;
    data[parameters.strmemoTextRaw] = this.memoTextRaw;
    data[parameters.strsourceName] = this.sourceName;
   
    if (this.hospital != null) {
      data[parameters.strhospital] = this.hospital.toJson();
    }
    
    return data;
  }}
