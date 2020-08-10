import 'dart:convert';

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
            List<Bucket>.from(json["bucket"].map((x) => Bucket.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "bucket": List<dynamic>.from(bucket.map((x) => x.toJson())),
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
        startTimeMillis: json["startTimeMillis"],
        endTimeMillis: json["endTimeMillis"],
        dataset:
            List<Dataset>.from(json["dataset"].map((x) => Dataset.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "startTimeMillis": startTimeMillis,
        "endTimeMillis": endTimeMillis,
        "dataset": List<dynamic>.from(dataset.map((x) => x.toJson())),
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
        dataSourceId: json["dataSourceId"],
        point: List<Point>.from(json["point"].map((x) => Point.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "dataSourceId": dataSourceId,
        "point": List<dynamic>.from(point.map((x) => x.toJson())),
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
        startTimeNanos: json["startTimeNanos"],
        originDataSourceId: json["originDataSourceId"],
        endTimeNanos: json["endTimeNanos"],
        value: List<Value>.from(json["value"].map((x) => Value.fromJson(x))),
        dataTypeName: json["dataTypeName"],
      );

  Map<String, dynamic> toJson() => {
        "startTimeNanos": startTimeNanos,
        "originDataSourceId": originDataSourceId,
        "endTimeNanos": endTimeNanos,
        "value": List<dynamic>.from(value.map((x) => x.toJson())),
        "dataTypeName": dataTypeName,
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
        mapVal: List<dynamic>.from(json["mapVal"].map((x) => x)),
        fpVal: json["fpVal"],
      );

  Map<String, dynamic> toJson() => {
        "mapVal": List<dynamic>.from(mapVal.map((x) => x)),
        "fpVal": fpVal,
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
