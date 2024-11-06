
import 'package:myfhb/common/CommonUtil.dart';

class AddNetworkModel {
  String? result;
  String? hubId;
  bool? isSuccess;
  String? message;
  Diagnostics? diagnostics;

  AddNetworkModel(
      {this.result,
      this.hubId,
      this.isSuccess,
      this.message,
      this.diagnostics});

  AddNetworkModel.fromJson(Map<String, dynamic> json) {
    try {
      result = json['result'];
      hubId = json['hubId'];
      isSuccess = json['isSuccess'];
      message = json['message'];
      diagnostics = json['diagnostics'] != null
          ? Diagnostics.fromJson(json['diagnostics'])
          : null;
    } catch (e,stackTrace) {
            CommonUtil().appLogs(message: e,stackTrace:stackTrace);

    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    try {
      data['result'] = this.result;
      data['hubId'] = this.hubId;
      data['isSuccess'] = this.isSuccess;
      data['message'] = this.message;
      if (this.diagnostics != null) {
        data['diagnostics'] = this.diagnostics!.toJson();
      }
    } catch (e,stackTrace) {
            CommonUtil().appLogs(message: e,stackTrace:stackTrace);

    }
    return data;
  }
}

class Diagnostics {
  Diagnostics.fromJson(Map<String, dynamic>? json) {}

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    return data;
  }
}
