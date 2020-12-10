class DigitRecogResponse {
  bool isSuccess;
  String message;
  Result result;

  DigitRecogResponse({this.isSuccess, this.message, this.result});

  DigitRecogResponse.fromJson(Map<String, dynamic> json) {
    isSuccess = json['isSuccess'];
    message = json['message'];
    result =
    json['result'] != null ? new Result.fromJson(json['result']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['isSuccess'] = this.isSuccess;
    data['message'] = this.message;
    if (this.result != null) {
      data['result'] = this.result.toJson();
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
        ? new DeviceMeasurementsHead.fromJson(json['deviceMeasurements'])
        : null;
    healthRecordDocumentId = json['healthRecordDocumentId'];
    healthRecordMetaId = json['healthRecordMetaId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.deviceMeasurementsHead != null) {
      data['deviceMeasurements'] = this.deviceMeasurementsHead.toJson();
    }
    data['healthRecordDocumentId'] = this.healthRecordDocumentId;
    data['healthRecordMetaId'] = this.healthRecordMetaId;
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
      deviceMeasurements = new List<DeviceMeasurements>();
      json['deviceMeasurements'].forEach((v) {
        deviceMeasurements.add(new DeviceMeasurements.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['deviceClass'] = this.deviceClass;
    if (this.deviceMeasurements != null) {
      data['deviceMeasurements'] =
          this.deviceMeasurements.map((v) => v.toJson()).toList();
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
        ? new Coordinates.fromJson(json['coordinates'])
        : null;
    parameter = json['parameter'];
    unit = json['unit'];
    values = json['values'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.coordinates != null) {
      data['coordinates'] = this.coordinates.toJson();
    }
    data['parameter'] = this.parameter;
    data['unit'] = this.unit;
    data['values'] = this.values;
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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['height'] = this.height;
    data['width'] = this.width;
    data['x'] = this.x;
    data['y'] = this.y;
    return data;
  }
}