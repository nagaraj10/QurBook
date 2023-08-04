
import 'package:myfhb/common/CommonUtil.dart';

import '../../../constants/fhb_parameters.dart' as parameters;

class SavedMetaDataResponse {
  int? status;
  bool? success;
  String? message;
  Response? response;

  SavedMetaDataResponse(
      {this.status, this.success, this.message, this.response});

  SavedMetaDataResponse.fromJson(Map<String, dynamic> json) {
    try {
      status = json[parameters.strStatus];
      success = json[parameters.strSuccess];
      message = json[parameters.strMessage];
      response = json[parameters.strResponse] != null
              ? Response.fromJson(json[parameters.strResponse])
              : null;
    } catch (e,stackTrace) {
      CommonUtil().appLogs(message: e,stackTrace:stackTrace);
    }
  }

  Map<String, dynamic> toJson() {
    final data = Map<String, dynamic>();
   data[parameters.strStatus] = status;
    data[parameters.strSuccess] = success;
    data[parameters.strMessage] = message;
    if (response != null) {
      data[parameters.strResponse] = response!.toJson();
    }
    return data;
  }
}

class Response {
  int? count;
  SavedMediaData? data;

  Response({this.count, this.data});

  Response.fromJson(Map<String, dynamic> json) {
    try {
      count = json[parameters.strCount];
      data =
              json[parameters.strData] != null ? SavedMediaData.fromJson(json[parameters.strData]) : null;
    } catch (e,stackTrace) {
      CommonUtil().appLogs(message: e,stackTrace:stackTrace);
    }
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data[parameters.strCount] = count;
    if (this.data != null) {
      data[parameters.strData] = this.data!.toJson();
    }
    return data;
  }
}

class SavedMediaData {
  String? mediaMetaID;

  SavedMediaData({this.mediaMetaID});

  SavedMediaData.fromJson(Map<String, dynamic> json) {
    try {
      mediaMetaID = json[parameters.strmediaMetaID];
    } catch (e,stackTrace) {
      CommonUtil().appLogs(message: e,stackTrace:stackTrace);
    }
  }

  Map<String, dynamic> toJson() {
    final data = Map<String, dynamic>();
    data[parameters.strmediaMetaID] = mediaMetaID;
    return data;
  }
}
