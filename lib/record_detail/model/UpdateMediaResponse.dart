import '../../constants/fhb_parameters.dart' as parameters;
import 'Doctor.dart';
import 'Hospital.dart';
import 'MediaTypeInfo.dart';
import 'UpdateMediaResponseData.dart';
import '../../src/model/Health/CategoryInfo.dart';

class UpdateMediaResponse {
  int status;
  bool success;
  String message;
  Response response;

  UpdateMediaResponse({this.status, this.success, this.message, this.response});

  UpdateMediaResponse.fromJson(Map<String, dynamic> json) {
    status = json[parameters.strStatus];
    success = json[parameters.strSuccess];
    message = json[parameters.strMessage];
    response = json[parameters.strResponse] != null
        ? Response.fromJson(json[parameters.strResponse])
        : null;
  }

  Map<String, dynamic> toJson() {
    final data = Map<String, dynamic>();
    data[parameters.strStatus] = status;
    data[parameters.strSuccess] = success;
    data[parameters.strMessage] = message;
    if (response != null) {
      data[parameters.strResponse] = response.toJson();
    }
    return data;
  }
}

class Response {
  int count;
  UpdateMediaResponseData data;

  Response({this.count, this.data});

  Response.fromJson(Map<String, dynamic> json) {
    count = json[parameters.strCount];
    data = json[parameters.strData] != null
        ? UpdateMediaResponseData.fromJson(json[parameters.strData])
        : null;
  }

  Map<String, dynamic> toJson() {
    final data = Map<String, dynamic>();
    data[parameters.strCount] = count;
    if (this.data != null) {
      data[parameters.strData] = this.data.toJson();
    }
    return data;
  }
}

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

    doctor = json[parameters.strdoctor] != null
        ? Doctor.fromJson(json[parameters.strdoctor])
        : null;
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
  }
}
