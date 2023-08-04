
import 'package:myfhb/common/CommonUtil.dart';

import 'DeviceMesurementsData.dart';
import '../../../constants/fhb_parameters.dart' as parameters;


class DeviceMeasurements {
  List<DeviceMeasurementsData>? data;

  DeviceMeasurements({this.data});

  DeviceMeasurements.fromJson(Map<String, dynamic>? json) {
    try {
      if (json != null) {
            data = <DeviceMeasurementsData>[];
            json[parameters.strData].forEach((v) {
              data!.add(DeviceMeasurementsData.fromJson(v));
            });
          }
    } catch (e,stackTrace) {
      CommonUtil().appLogs(message: e,stackTrace:stackTrace);
    }
  }
}