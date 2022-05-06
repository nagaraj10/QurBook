class BleDataModel {
  String status;
  String hubId;
  String deviceId;
  String deviceType;
  Data data;
  String eid;
  String uid;

  BleDataModel(
      {this.status, this.hubId, this.deviceId, this.deviceType, this.data});

  BleDataModel.fromJson(Map<String, dynamic> json) {
    try {
      status = json['Status'];
      hubId = json['hubId'];
      deviceId = json['deviceId'];
      deviceType = json['deviceType'];
      eid = json['eid'];
      uid = json['uid'];
      data = json['Data'] != null ? new Data.fromJson(json['Data']) : null;
    } catch (e) {
      print(e);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    try {
      data['Status'] = this.status;
      data['hubId'] = this.hubId;
      data['deviceId'] = this.deviceId;
      data['deviceType'] = this.deviceType;
      data['eid'] = this.eid;
      data['uid'] = this.uid;
      if (this.data != null) {
        data['Data'] = this.data.toJson();
      }
    } catch (e) {
      print(e);
    }
    return data;
  }
}

class Data {
  String sPO2;
  String pulse;

  Data({this.sPO2, this.pulse});

  Data.fromJson(Map<String, dynamic> json) {
    try {
      sPO2 = json['SPO2'];
      pulse = json['Pulse'];
    } catch (e) {
      print(e);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    try {
      data['SPO2'] = this.sPO2;
      data['Pulse'] = this.pulse;
    } catch (e) {
      print(e);
    }
    return data;
  }
}

class BleDataResponseModel {
  bool isSuccess;
  BleDataResult result;

  BleDataResponseModel({this.isSuccess, this.result});

  BleDataResponseModel.fromJson(Map<String, dynamic> json) {
    try {
      isSuccess = json['isSuccess'];
      result = json['result'] != null
          ? new BleDataResult.fromJson(json['result'])
          : null;
    } catch (e) {
      print(e);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    try {
      data['isSuccess'] = this.isSuccess;
      if (this.result != null) {
        data['result'] = this.result.toJson();
      }
    } catch (e) {
      print(e);
    }

    return data;
  }
}

class BleDataResult {
  BleDataResponseData data;
  String hubId;
  String deviceId;
  String deviceType;
  String status;
  String deviceName;

  BleDataResult(
      {this.data,
      this.hubId,
      this.deviceId,
      this.deviceType,
      this.status,
      this.deviceName});

  BleDataResult.fromJson(Map<String, dynamic> json) {
    try {
      data = json['Data'] != null
          ? new BleDataResponseData.fromJson(json['Data'])
          : null;
      hubId = json['hubId'];
      deviceId = json['deviceId'];
      deviceType = json['deviceType'];
      status = json['Status'];
      deviceName = json['deviceName'];
    } catch (e) {
      print(e);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    try {
      if (this.data != null) {
        data['Data'] = this.data.toJson();
      }
      data['hubId'] = this.hubId;
      data['deviceId'] = this.deviceId;
      data['deviceType'] = this.deviceType;
      data['Status'] = this.status;
      data['deviceName'] = this.deviceName;
    } catch (e) {
      print(e);
    }

    return data;
  }
}

class BleDataResponseData {
  String pulse;
  String sPO2;

  BleDataResponseData({this.pulse, this.sPO2});

  BleDataResponseData.fromJson(Map<String, dynamic> json) {
    try {
      pulse = json['Pulse'];
      sPO2 = json['SPO2'];
    } catch (e) {
      print(e);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    try {
      data['Pulse'] = this.pulse;
      data['SPO2'] = this.sPO2;
    } catch (e) {
      print(e);
    }
    return data;
  }
}
