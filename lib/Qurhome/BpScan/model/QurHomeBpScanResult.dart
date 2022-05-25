class QurHomeBpScanResult {
  String option;
  String deviceCategory;
  String modelName;
  String deviceAddress;
  String currentTime;
  int batteryLevel;
  List<MeasurementRecords> measurementRecords;
  String completionReason;

  QurHomeBpScanResult(
      {this.option,
        this.deviceCategory,
        this.modelName,
        this.deviceAddress,
        this.currentTime,
        this.batteryLevel,
        this.measurementRecords,
        this.completionReason});

  QurHomeBpScanResult.fromJson(Map<String, dynamic> json) {
    option = json['option'];
    deviceCategory = json['deviceCategory'];
    modelName = json['modelName'];
    deviceAddress = json['deviceAddress'];
    currentTime = json['currentTime'];
    batteryLevel = json['batteryLevel'];
    if (json['measurementRecords'] != null) {
      measurementRecords = <MeasurementRecords>[];
      json['measurementRecords'].forEach((v) {
        measurementRecords.add(new MeasurementRecords.fromJson(v));
      });
    }
    completionReason = json['completionReason'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['option'] = this.option;
    data['deviceCategory'] = this.deviceCategory;
    data['modelName'] = this.modelName;
    data['currentTime'] = this.currentTime;
    data['batteryLevel'] = this.batteryLevel;
    if (this.measurementRecords != null) {
      data['measurementRecords'] =
          this.measurementRecords.map((v) => v.toJson()).toList();
    }
    data['completionReason'] = this.completionReason;
    return data;
  }
}

class MeasurementRecords {
  String timeStampKey;
  int pulseRateKey;
  int systolicKey;
  String bloodPressureMeasurementStatusKey;
  int userIndexKey;
  int diastolicKey;
  int meanArterialPressureKey;
  String bloodPressureUnitKey;

  MeasurementRecords(
      {this.timeStampKey,
        this.pulseRateKey,
        this.systolicKey,
        this.bloodPressureMeasurementStatusKey,
        this.userIndexKey,
        this.diastolicKey,
        this.meanArterialPressureKey,
        this.bloodPressureUnitKey});

  MeasurementRecords.fromJson(Map<String, dynamic> json) {
    timeStampKey = json['TimeStampKey'];
    pulseRateKey = json['PulseRateKey'];
    systolicKey = json['SystolicKey'];
    bloodPressureMeasurementStatusKey =
    json['BloodPressureMeasurementStatusKey'];
    userIndexKey = json['UserIndexKey'];
    diastolicKey = json['DiastolicKey'];
    meanArterialPressureKey = json['MeanArterialPressureKey'];
    bloodPressureUnitKey = json['BloodPressureUnitKey'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['TimeStampKey'] = this.timeStampKey;
    data['PulseRateKey'] = this.pulseRateKey;
    data['SystolicKey'] = this.systolicKey;
    data['BloodPressureMeasurementStatusKey'] =
        this.bloodPressureMeasurementStatusKey;
    data['UserIndexKey'] = this.userIndexKey;
    data['DiastolicKey'] = this.diastolicKey;
    data['MeanArterialPressureKey'] = this.meanArterialPressureKey;
    data['BloodPressureUnitKey'] = this.bloodPressureUnitKey;
    return data;
  }
}