import '../../constants/fhb_parameters.dart';
import 'googleFitValues.dart';
import 'googleFitEnumvalues.dart';

class Point {
  Point({
    this.startTimeNanos,
    this.originDataSourceId,
    this.endTimeNanos,
    this.value,
    this.dataTypeName,
  });

  String startTimeNanos;
  String originDataSourceId;
  String endTimeNanos;
  List<Value> value;
  String dataTypeName;

  factory Point.fromJson(Map<String, dynamic> json) => Point(
        startTimeNanos: json[gfstartTimeNanos],
        originDataSourceId: json[gforiginDataSourceId],
        endTimeNanos: json[gfendTimeNanos],
        value: List<Value>.from(json[gfvalue].map((x) => Value.fromJson(x))),
        dataTypeName: json[gfdataTypeName],
      );

  Map<String, dynamic> toJson() => {
        gfstartTimeNanos: startTimeNanos,
        gforiginDataSourceId: originDataSourceId,
        gfendTimeNanos: endTimeNanos,
        gfvalue: List<dynamic>.from(value.map((x) => x.toJson())),
        gfdataTypeName: dataTypeName,
      };
}

enum DataTypeName { COM_GOOGLE_BLOOD_PRESSURE }

final dataTypeNameValues = EnumValues(
    {'com.google.blood_pressure': DataTypeName.COM_GOOGLE_BLOOD_PRESSURE});
