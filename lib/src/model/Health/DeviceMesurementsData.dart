import 'package:myfhb/constants/fhb_parameters.dart' as parameters;

class DeviceMeasurementsData {
  String parameter;
  String unit;
  String values;

  DeviceMeasurementsData({this.parameter, this.unit, this.values});

  DeviceMeasurementsData.fromJson(Map<String, dynamic> json) {
    parameter = json[parameters.strParameters];
    unit = json[parameters.strUnits];
    values = json[parameters.strValues];
  }
}
