import '../../../constants/fhb_parameters.dart' as parameters;
import 'CategoryInfo.dart';
import 'DeviceReadings.dart';
import 'Doctor.dart';
import 'Hospital.dart';
import 'Laboratory.dart';
import 'MediaTypeInfo.dart';

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
        ? CategoryInfo.fromJson(json[parameters.strcategoryInfo])
        : null;
    dateOfVisit = json[parameters.strdateOfVisit];
    try{
    if (json[parameters.strdeviceReadings] != null) {
      deviceReadings = <DeviceReadings>[];
      json[parameters.strdeviceReadings].forEach((v) {
        deviceReadings.add(DeviceReadings.fromJson(v));
      });
    }
     }catch(e){

    }
    doctor =
        json[parameters.strdoctor] != null ? Doctor.fromJson(json[parameters.strdoctor]) : null;
    fileName = json[parameters.strfileName];
    hasVoiceNotes = json[parameters.strhasVoiceNotes] ?? false;
    isDraft = json[parameters.strisDraft] ?? false;
    mediaTypeInfo = json[parameters.strmediaTypeInfo] != null
        ? MediaTypeInfo.fromJson(json[parameters.strmediaTypeInfo])
        : null;
    memoText = json[parameters.strmemoText];
    memoTextRaw = json[parameters.strmemoTextRaw];
    sourceName = json[parameters.strsourceName];
    laboratory = json[parameters.strlaboratory] != null
        ? Laboratory.fromJson(json[parameters.strlaboratory])
        : null;
    hospital = json[parameters.strhospital] != null
        ? Hospital.fromJson(json[parameters.strhospital])
        : null;
    dateOfExpiry = json[parameters.strdateOfExpiry];
    idType = json[parameters.stridType] != null ? json[parameters.stridType] : '';
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
    data[parameters.strhasVoiceNotes] = hasVoiceNotes;
    data[parameters.strisDraft] = isDraft;
    if (mediaTypeInfo != null) {
      data[parameters.strmediaTypeInfo] = mediaTypeInfo.toJson();
    }
    data[parameters.strmemoText] = memoText;
    data[parameters.strmemoTextRaw] = memoTextRaw;
    data[parameters.strsourceName] = sourceName;
    if (laboratory != null) {
      data[parameters.strlaboratory] = laboratory.toJson();
    }
    if (hospital != null) {
      data[parameters.strhospital] = hospital.toJson();
    }
    data[parameters.strdateOfExpiry] = dateOfExpiry;
    if (idType != null) {
      data[parameters.stridType] = idType;
    }
    return data;
  }
}




