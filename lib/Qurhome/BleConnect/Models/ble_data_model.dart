import 'package:myfhb/common/CommonUtil.dart';

class BleDataModel {
  String? status;
  String? hubId;
  String? deviceId;
  String? deviceType;
  Data? data;
  String? eid;
  String? uid;
  String? ackLocal;
  EidInfo? eidInfo;


  BleDataModel(
      {this.status, this.hubId, this.deviceId, this.deviceType, this.data, this.eidInfo});

  BleDataModel.fromJson(Map<String, dynamic> json) {
    try {
      status = json['Status'];
      hubId = json['hubId'];
      deviceId = json['deviceId'];
      deviceType = json['deviceType'];
      eid = json['eid'];
      uid = json['uid'];
      ackLocal = json['ackLocal'];
      data = json['Data'] != null ? Data.fromJson(json['Data']) : null;
      eidInfo= json["eidInfo"] == null ? null : EidInfo.fromJson(json["eidInfo"]);
    } catch (e,stackTrace) {
      CommonUtil().appLogs(message: e,stackTrace:stackTrace);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    try {
      data['Status'] = this.status;
      data['hubId'] = this.hubId;
      data['deviceId'] = this.deviceId;
      data['deviceType'] = this.deviceType;
      data['eid'] = this.eid;
      data['uid'] = this.uid;
      data['ackLocal'] = this.ackLocal;
      data['eidInfo'] = this.eidInfo;
      if (this.data != null) {
        data['Data'] = this.data!.toJson();
      }
    } catch (e,stackTrace) {
      CommonUtil().appLogs(message: e,stackTrace:stackTrace);

      print(e);
    }
    return data;
  }
}
class EidInfo {
  int? eid;
  DateTime? estart;
  String? uformname;
  String? activity;
  int? uid;
  String? estartTime;

  EidInfo({
    this.eid,
    this.estart,
    this.uformname,
    this.activity,
    this.uid,
    this.estartTime,
  });

  factory EidInfo.fromJson(Map<String, dynamic> json) => EidInfo(
    eid: json["eid"]??0,
    estart: json["estart"] == null ? null : DateTime.parse(json["estart"]),
    uformname: json["uformname"]??"",
    activity: json["activity"]??"",
    uid: json["uid"]??0,
    estartTime: json["estartTime"]??"",
  );

  Map<String, dynamic> toJson() => {
    "eid": eid,
    "estart": estart?.toIso8601String(),
    "uformname": uformname,
    "activity": activity,
    "uid": uid,
    "estartTime": estartTime,
  };
}


class Data {
  String? sPO2;
  String? pulse;
  String? systolic;
  String? diastolic;
  String? weight;
  String? bgl;

  Data({
    this.sPO2,
    this.pulse,
    this.systolic,
    this.diastolic,
    this.weight,
    this.bgl,
  });

  Data.fromJson(Map<String, dynamic> json) {
    try {
      sPO2 = json['SPO2'].toString();
      pulse = json['Pulse'].toString();
      systolic = json['Systolic'].toString();
      diastolic = json['Diastolic'].toString();
      weight = json['Weight'].toString();
      bgl = json['BGL'].toString();
    } catch (e,stackTrace) {
      CommonUtil().appLogs(message: e,stackTrace:stackTrace);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    try {
      data['SPO2'] = this.sPO2;
      data['Pulse'] = this.pulse;
      data['Systolic'] = this.systolic;
      data['Diastolic'] = this.diastolic;
      data['Weight'] = this.weight;
      data['BGL'] = this.bgl;
    } catch (e,stackTrace) {
      CommonUtil().appLogs(message: e,stackTrace:stackTrace);
    }
    return data;
  }
}

class BleDataResponseModel {
  bool? isSuccess;
  BleDataResult? result;

  BleDataResponseModel({this.isSuccess, this.result});

  BleDataResponseModel.fromJson(Map<String, dynamic> json) {
    try {
      isSuccess = json['isSuccess'];
      result = json['result'] != null
          ? BleDataResult.fromJson(json['result'])
          : null;
    } catch (e,stackTrace) {
      CommonUtil().appLogs(message: e,stackTrace:stackTrace);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    try {
      data['isSuccess'] = this.isSuccess;
      if (this.result != null) {
        data['result'] = this.result!.toJson();
      }
    } catch (e,stackTrace) {
      CommonUtil().appLogs(message: e,stackTrace:stackTrace);
    }

    return data;
  }
}

class BleDataResult {
  BleDataResponseData? data;
  String? hubId;
  String? deviceId;
  String? deviceType;
  String? status;
  String? deviceName;

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
          ? BleDataResponseData.fromJson(json['Data'])
          : null;
      hubId = json['hubId'];
      deviceId = json['deviceId'];
      deviceType = json['deviceType'];
      status = json['Status'];
      deviceName = json['deviceName'];
    } catch (e,stackTrace) {
      CommonUtil().appLogs(message: e,stackTrace:stackTrace);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    try {
      if (this.data != null) {
        data['Data'] = this.data!.toJson();
      }
      data['hubId'] = this.hubId;
      data['deviceId'] = this.deviceId;
      data['deviceType'] = this.deviceType;
      data['Status'] = this.status;
      data['deviceName'] = this.deviceName;
    } catch (e,stackTrace) {
      CommonUtil().appLogs(message: e,stackTrace:stackTrace);
    }

    return data;
  }
}

class BleDataResponseData {
  String? pulse;
  String? sPO2;

  BleDataResponseData({this.pulse, this.sPO2});

  BleDataResponseData.fromJson(Map<String, dynamic> json) {
    try {
      pulse = json['Pulse'];
      sPO2 = json['SPO2'];
    } catch (e,stackTrace) {
      CommonUtil().appLogs(message: e,stackTrace:stackTrace);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    try {
      data['Pulse'] = this.pulse;
      data['SPO2'] = this.sPO2;
    } catch (e,stackTrace) {
      CommonUtil().appLogs(message: e,stackTrace:stackTrace);
    }
    return data;
  }
}
