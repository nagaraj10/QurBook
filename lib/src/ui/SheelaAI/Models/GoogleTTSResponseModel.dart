
import 'package:myfhb/common/CommonUtil.dart';

class GoogleTTSResponseModel {
  bool? isSuccess;
  Payload? payload;
  Result? result;

  GoogleTTSResponseModel({this.isSuccess, this.payload});

  GoogleTTSResponseModel.fromJson(Map<String, dynamic> json) {
    try {
      isSuccess = json['isSuccess'];
      payload =
              json['payload'] != null ? Payload.fromJson(json['payload']) : null;
      getResultFromAPI(json);
    } catch (e,stackTrace) {
      getResultFromAPI(json);
      CommonUtil().appLogs(message: e,stackTrace:stackTrace);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['isSuccess'] = this.isSuccess;
    if (this.payload != null) {
      data['payload'] = this.payload!.toJson();
    }
    if (this.result != null) {
      data['result'] = this.result!.toJson();
    }
    return data;
  }

  getResultFromAPI(Map<String, dynamic> json) {
    try {
      result =
          json['result'] != null ? Result.fromJson(json['result']) : null;
    } catch (e, stackTrace) {
      CommonUtil().appLogs(message: e, stackTrace: stackTrace);
    }
  }
}

class Payload {
  String? audioContent;

  Payload({this.audioContent});

  Payload.fromJson(Map<String, dynamic> json) {
    try {
      audioContent = json['audioContent'];
    } catch (e,stackTrace) {
      CommonUtil().appLogs(message: e,stackTrace:stackTrace);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['audioContent'] = this.audioContent;
    return data;
  }
}

class Result {
  String? translatedText;
  String? sourceLanguageCode;
  String? targetLanguageCode;

  Result(
      {this.translatedText, this.sourceLanguageCode, this.targetLanguageCode});

  Result.fromJson(Map<String, dynamic> json) {
    try {
      translatedText = (json['TranslatedText']??'');
      sourceLanguageCode = (json['SourceLanguageCode']??'');
      targetLanguageCode = (json['TargetLanguageCode']??'');
    } catch (e,stackTrace) {
      CommonUtil().appLogs(message: e,stackTrace:stackTrace);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['TranslatedText'] = this.translatedText;
    data['SourceLanguageCode'] = this.sourceLanguageCode;
    data['TargetLanguageCode'] = this.targetLanguageCode;
    return data;
  }
}
