import 'dart:convert';
import 'package:myfhb/constants/fhb_parameters.dart';

GoogleFitResponseModel ResponseFromJson(String str) =>
    GoogleFitResponseModel.fromJson(json.decode(str));

String RequestToJson(GoogleFitResponseModel data) => json.encode(data.toJson());

class GoogleFitResponseModel {
  GoogleFitResponseModel({
    this.bucket,
  });

  List<Bucket> bucket;

  factory GoogleFitResponseModel.fromJson(Map<String, dynamic> json) =>
      GoogleFitResponseModel(
        bucket:
            List<Bucket>.from(json[gfbucket].map((x) => Bucket.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        gfbucket: List<dynamic>.from(bucket.map((x) => x.toJson())),
      };
}

class Bucket {
  Bucket({
    this.startTimeMillis,
    this.endTimeMillis,
    this.dataset,
  });

  String startTimeMillis;
  String endTimeMillis;
  List<Dataset> dataset;

  factory Bucket.fromJson(Map<String, dynamic> json) => Bucket(
        startTimeMillis: json[gfstartTimeMillis],
        endTimeMillis: json[gfendTimeMillis],
        dataset:
            List<Dataset>.from(json[gfdataset].map((x) => Dataset.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        gfstartTimeMillis: startTimeMillis,
        gfendTimeMillis: endTimeMillis,
        gfdataset: List<dynamic>.from(dataset.map((x) => x.toJson())),
      };
}

class Dataset {
  Dataset({
    this.dataSourceId,
    this.point,
  });

  String dataSourceId;
  List<Point> point;

  factory Dataset.fromJson(Map<String, dynamic> json) => Dataset(
        dataSourceId: json[gfdataSourceId],
        point: List<Point>.from(json[gfpoint].map((x) => Point.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        gfdataSourceId: dataSourceId,
        gfpoint: List<dynamic>.from(point.map((x) => x.toJson())),
      };
}

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
    {"com.google.blood_pressure": DataTypeName.COM_GOOGLE_BLOOD_PRESSURE});

class Value {
  Value({
    this.mapVal,
    this.fpVal,
  });

  List<dynamic> mapVal;
  var fpVal;

  factory Value.fromJson(Map<String, dynamic> json) => Value(
        mapVal: List<dynamic>.from(json[gfmapVal].map((x) => x)),
        fpVal: json[gffpVal],
      );

  Map<String, dynamic> toJson() => {
        gfmapVal: List<dynamic>.from(mapVal.map((x) => x)),
        gffpVal: fpVal,
      };
}

class EnumValues<T> {
  Map<String, T> map;
  Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    if (reverseMap == null) {
      reverseMap = map.map((k, v) => new MapEntry(v, k));
    }
    return reverseMap;
  }
}
