
import 'package:myfhb/common/CommonUtil.dart';

class GoogleTTSResponseModel {
  bool? isSuccess;
  Payload? payload;

  GoogleTTSResponseModel({this.isSuccess, this.payload});

  GoogleTTSResponseModel.fromJson(Map<String, dynamic> json) {
    try {
      isSuccess = json['isSuccess'];
      payload =
              json['payload'] != null ? new Payload.fromJson(json['payload']) : null;
    } catch (e) {
      CommonUtil().appLogs(message: e.toString());
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['isSuccess'] = this.isSuccess;
    if (this.payload != null) {
      data['payload'] = this.payload!.toJson();
    }
    return data;
  }
}

class Payload {
  String? audioContent;

  Payload({this.audioContent});

  Payload.fromJson(Map<String, dynamic> json) {
    try {
      audioContent = json['audioContent'];
    } catch (e) {
      CommonUtil().appLogs(message: e.toString());
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['audioContent'] = this.audioContent;
    return data;
  }
}
