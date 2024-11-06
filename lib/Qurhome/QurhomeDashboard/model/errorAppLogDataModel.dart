import 'dart:core';


class ErrorAppLogDataModel {
  String? itemId;
  String? message;
  String? appVersion;
  String? osVersion;

  ErrorAppLogDataModel(
  {required this.itemId, required this.message, required this.appVersion, required this.osVersion});
}
