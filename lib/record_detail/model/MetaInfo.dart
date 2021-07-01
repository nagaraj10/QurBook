import '../../constants/fhb_parameters.dart' as parameters;
import 'DeviceReadings.dart';
import 'Hospital.dart';
import 'MediaTypeInfo.dart';
import '../../src/model/Health/CategoryInfo.dart';
import '../../src/model/Health/Doctor.dart';

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
        ? CategoryInfo.fromJson(json[parameters.strcategoryInfo])
        : null;
    dateOfVisit = json[parameters.strdateOfVisit];
    if (json[parameters.strdeviceReadings] != null) {
      deviceReadings = <DeviceReadings>[];
      json[parameters.strdeviceReadings].forEach((v) {
        deviceReadings.add(DeviceReadings.fromJson(v));
      });
    }
    doctor =
        json[parameters.strdoctor] != null ? Doctor.fromJson(json[parameters.strdoctor]) : null;
    fileName = json[parameters.strfileName];
    isDraft = json[parameters.strisDraft] ?? false;
    mediaTypeInfo = json[parameters.strmediaTypeInfo] != null
        ? MediaTypeInfo.fromJson(json[parameters.strmediaTypeInfo])
        : null;
    memoText = json[parameters.strmemoText];
    memoTextRaw = json[parameters.strmemoTextRaw];
    sourceName = json[parameters.strsourceName];
    
    hospital = json[parameters.strhospital] != null
        ? Hospital.fromJson(json[parameters.strhospital])
        : null;
  }

  Map<String, dynamic> toJson() {
    final data = Map<String, dynamic>();
    if (categoryInfo != null) {
      data[parameters.strcategoryInfo] = categoryInfo.toJson();
    }
    data[parameters.strdateOfVisit] = dateOfVisit;
    if (deviceReadings != null) {
      data[parameters.strdeviceReadings] =
          deviceReadings.map((v) => v.toJson()).toList();
    }
    if (doctor != null) {
      data[parameters.strdoctor] = doctor.toJson();
    }
    data[parameters.strfileName] = fileName;
    data[parameters.strisDraft] = isDraft;
    if (mediaTypeInfo != null) {
      data[parameters.strmediaTypeInfo] = mediaTypeInfo.toJson();
    }
    data[parameters.strmemoText] = memoText;
    data[parameters.strmemoTextRaw] = memoTextRaw;
    data[parameters.strsourceName] = sourceName;
   
    if (hospital != null) {
      data[parameters.strhospital] = hospital.toJson();
    }
    
    return data;
  }}
