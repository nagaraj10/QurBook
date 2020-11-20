import 'package:myfhb/src/model/Health/DeviceMeasurement.dart';
import 'package:myfhb/constants/fhb_parameters.dart' as parameters;

class Data {
  String mediaMetaId;
  String mediaMasterId;
  DeviceMeasurements deviceMeasurements;

  Data({this.mediaMetaId, this.mediaMasterId, this.deviceMeasurements});

  Data.fromJson(Map<String, dynamic> json) {
    mediaMetaId = json[parameters.strmediaMetaId];
    mediaMasterId = json[parameters.strmediaMasterId];
    deviceMeasurements = json[parameters.strDeviceMeasurements] != null
        ? new DeviceMeasurements.fromJson(json[parameters.strDeviceMeasurements])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data[parameters.strmediaMetaId] = this.mediaMetaId;
    data[parameters.strmediaMasterId] = this.mediaMasterId;
    return data;
  }
}
