import 'DeviceMesurementsData.dart';
import '../../../constants/fhb_parameters.dart' as parameters;


class DeviceMeasurements {
  List<DeviceMeasurementsData> data;

  DeviceMeasurements({this.data});

  DeviceMeasurements.fromJson(Map<String, dynamic> json) {
    if (json != null) {
      data = List<DeviceMeasurementsData>();
      json[parameters.strData].forEach((v) {
        data.add(DeviceMeasurementsData.fromJson(v));
      });
    }
  }
}