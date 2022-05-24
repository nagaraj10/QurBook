class BleBPDataModel {
  String status;
  String hubId;
  String deviceId;
  String deviceType;
  String eid;
  String uid;
  String ackLocal;
  BPData data;

  BleBPDataModel(
      {this.status,
        this.hubId,
        this.deviceId,
        this.deviceType,
        this.eid,
        this.uid,
        this.ackLocal,
        this.data});

  BleBPDataModel.fromJson(Map<String, dynamic> json) {
    status = json['Status'];
    hubId = json['hubId'];
    deviceId = json['deviceId'];
    deviceType = json['deviceType'];
    eid = json['eid'];
    uid = json['uid'];
    ackLocal = json['ackLocal'];
    data = json['Data'] != null ? new BPData.fromJson(json['Data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Status'] = this.status;
    data['hubId'] = this.hubId;
    data['deviceId'] = this.deviceId;
    data['deviceType'] = this.deviceType;
    data['eid'] = this.eid;
    data['uid'] = this.uid;
    data['ackLocal'] = this.ackLocal;
    if (this.data != null) {
      data['Data'] = this.data.toJson();
    }
    return data;
  }
}

class BPData {
  String systolic;
  String diastolic;
  String pulse;

  BPData({this.systolic, this.diastolic, this.pulse});

  BPData.fromJson(Map<String, dynamic> json) {
    systolic = json['Systolic'];
    diastolic = json['Diastolic'];
    pulse = json['Pulse'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Systolic'] = this.systolic;
    data['Diastolic'] = this.diastolic;
    data['Pulse'] = this.pulse;
    return data;
  }
}