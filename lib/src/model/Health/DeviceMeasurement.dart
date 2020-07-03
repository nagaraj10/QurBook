import 'package:myfhb/src/model/Health/DeviceMesurementsData.dart';
import 'package:myfhb/constants/fhb_parameters.dart' as parameters;


class DeviceMeasurements {
  List<DeviceMeasurementsData> data;

  DeviceMeasurements({this.data});

  DeviceMeasurements.fromJson(Map<String, dynamic> json) {
    if (json != null) {
      data = new List<DeviceMeasurementsData>();
      json[parameters.strData].forEach((v) {
        data.add(new DeviceMeasurementsData.fromJson(v));
      });
    }
  }
}