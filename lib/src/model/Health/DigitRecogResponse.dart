class DigitRecogResponse {
  bool isSuccess;
  String message;
  Result result;

  DigitRecogResponse({this.isSuccess, this.message, this.result});

  DigitRecogResponse.fromJson(Map<String, dynamic> json) {
    isSuccess = json['isSuccess'];
    message = json['message'];
    result =
    json['result'] != null ? Result.fromJson(json['result']) : null;
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['isSuccess'] = isSuccess;
    data['message'] = message;
    if (result != null) {
      data['result'] = result.toJson();
    }
    return data;
  }
}

class Result {
  DeviceMeasurementsHead deviceMeasurementsHead;
  String healthRecordDocumentId;
  String healthRecordMetaId;

  Result(
      {this.deviceMeasurementsHead,
        this.healthRecordDocumentId,
        this.healthRecordMetaId});

  Result.fromJson(Map<String, dynamic> json) {
    deviceMeasurementsHead = json['deviceMeasurements'] != null
        ? DeviceMeasurementsHead.fromJson(json['deviceMeasurements'])
        : null;
    healthRecordDocumentId = json['healthRecordDocumentId'];
    healthRecordMetaId = json['healthRecordMetaId'];
  }

  Map<String, dynamic> toJson() {
    final data = Map<String, dynamic>();
    if (deviceMeasurementsHead != null) {
      data['deviceMeasurements'] = deviceMeasurementsHead.toJson();
    }
    data['healthRecordDocumentId'] = healthRecordDocumentId;
    data['healthRecordMetaId'] = healthRecordMetaId;
    return data;
  }
}

class DeviceMeasurementsHead {
  String deviceClass;
  List<DeviceMeasurements> deviceMeasurements;

  DeviceMeasurementsHead({this.deviceClass, this.deviceMeasurements});

  DeviceMeasurementsHead.fromJson(Map<String, dynamic> json) {
    deviceClass = json['deviceClass'];
    if (json['deviceMeasurements'] != null) {
      deviceMeasurements = <DeviceMeasurements>[];
      json['deviceMeasurements'].forEach((v) {
        deviceMeasurements.add(DeviceMeasurements.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['deviceClass'] = deviceClass;
    if (deviceMeasurements != null) {
      data['deviceMeasurements'] =
          deviceMeasurements.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class DeviceMeasurements {
  Coordinates coordinates;
  String parameter;
  String unit;
  String values;

  DeviceMeasurements(
      {this.coordinates, this.parameter, this.unit, this.values});

  DeviceMeasurements.fromJson(Map<String, dynamic> json) {
    coordinates = json['coordinates'] != null
        ? Coordinates.fromJson(json['coordinates'])
        : null;
    parameter = json['parameter'];
    unit = json['unit'];
    values = json['values'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    if (coordinates != null) {
      data['coordinates'] = coordinates.toJson();
    }
    data['parameter'] = parameter;
    data['unit'] = unit;
    data['values'] = values;
    return data;
  }
}

class Coordinates {
  int height;
  int width;
  int x;
  int y;

  Coordinates({this.height, this.width, this.x, this.y});

  Coordinates.fromJson(Map<String, dynamic> json) {
    height = json['height'];
    width = json['width'];
    x = json['x'];
    y = json['y'];
  }

  Map<String, dynamic> toJson() {
    final data = Map<String, dynamic>();
    data['height'] = height;
    data['width'] = width;
    data['x'] = x;
    data['y'] = y;
    return data;
  }
}