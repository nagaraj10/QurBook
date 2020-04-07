class DigitRecogResponse {
  int status;
  bool success;
  String message;
  Response response;

  DigitRecogResponse({this.status, this.success, this.message, this.response});

  DigitRecogResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    success = json['success'];
    message = json['message'];
    response = json['response'] != null
        ? new Response.fromJson(json['response'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['success'] = this.success;
    data['message'] = this.message;
    if (this.response != null) {
      data['response'] = this.response.toJson();
    }
    return data;
  }
}

class Response {
  int count;
  Data data;

  Response({this.count, this.data});

  Response.fromJson(Map<String, dynamic> json) {
    count = json['count'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['count'] = this.count;
    if (this.data != null) {
      data['data'] = this.data.toJson();
    }
    return data;
  }
}

class Data {
  String mediaMetaId;
  String mediaMasterId;
  DeviceMeasurements deviceMeasurements;

  Data({this.mediaMetaId, this.mediaMasterId, this.deviceMeasurements});

  Data.fromJson(Map<String, dynamic> json) {
    mediaMetaId = json['mediaMetaId'];
    mediaMasterId = json['mediaMasterId'];
    deviceMeasurements = json['deviceMeasurements'] != null
        ? new DeviceMeasurements.fromJson(json['deviceMeasurements'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['mediaMetaId'] = this.mediaMetaId;
    data['mediaMasterId'] = this.mediaMasterId;
    return data;
  }
}

class DeviceMeasurements {
  List<DeviceMeasurementsData> data;

  DeviceMeasurements({this.data});

  DeviceMeasurements.fromJson(Map<String, dynamic> json) {
    if (json != null) {
      data = new List<DeviceMeasurementsData>();
      json['data'].forEach((v) {
        data.add(new DeviceMeasurementsData.fromJson(v));
      });
    }
  }
}

class DeviceMeasurementsData {
  String parameter;
  String unit;
  String values;

  DeviceMeasurementsData({this.parameter, this.unit, this.values});

  DeviceMeasurementsData.fromJson(Map<String, dynamic> json) {
    parameter = json['parameter'];
    unit = json['unit'];
    values = json['values'];
  }
}
