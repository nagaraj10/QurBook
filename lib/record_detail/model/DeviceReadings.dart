
import 'package:myfhb/common/CommonUtil.dart';

import '../../constants/fhb_parameters.dart' as parameters;

class DeviceReadings {
  String? parameter;
  String? unit;
  String? value;

  DeviceReadings({this.parameter, this.unit, this.value});

  DeviceReadings.fromJson(Map<String, dynamic> json) {
    try {
      parameter = json[parameters.strParameters];
      if (json[parameters.strvalue] is int) {
            value = json[parameters.strvalue].toString();
          } else {
            value = json[parameters.strvalue];
          }
      unit = json[parameters.strUnit];
    } catch (e,stackTrace) {
      CommonUtil().appLogs(message: e,stackTrace:stackTrace);
    }
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data[parameters.strParameters] = parameter;
    data[parameters.strUnit] = unit;
    data[parameters.strvalue] = value;
    return data;
  }
}