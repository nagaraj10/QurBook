
import 'package:myfhb/common/CommonUtil.dart';

import 'DeviceMeasurement.dart';
import '../../../constants/fhb_parameters.dart' as parameters;

class Data {
  String? mediaMetaId;
  String? mediaMasterId;
  DeviceMeasurements? deviceMeasurements;

  Data({this.mediaMetaId, this.mediaMasterId, this.deviceMeasurements});

  Data.fromJson(Map<String, dynamic> json) {
    try {
      mediaMetaId = json[parameters.strmediaMetaId];
      mediaMasterId = json[parameters.strmediaMasterId];
      deviceMeasurements = json[parameters.strDeviceMeasurements] != null
              ? DeviceMeasurements.fromJson(json[parameters.strDeviceMeasurements])
              : null;
    } catch (e,stackTrace) {
      CommonUtil().appLogs(message: e,stackTrace:stackTrace);
    }
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data[parameters.strmediaMetaId] = mediaMetaId;
    data[parameters.strmediaMasterId] = mediaMasterId;
    return data;
  }
}
