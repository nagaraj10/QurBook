class HeartRateValues {
  bool isSuccess;
  List<HRResult> result;

  HeartRateValues({this.isSuccess, this.result});

  HeartRateValues.fromJson(Map<String, dynamic> json) {
    isSuccess = json['isSuccess'];
    if (json['result'] != null) {
      result = new List<HRResult>();
      json['result'].forEach((v) {
        result.add(new HRResult.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['isSuccess'] = this.isSuccess;
    if (this.result != null) {
      data['result'] = this.result.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class HRResult {
  String sourceType;
  String startDateTime;
  String endDateTime;
  int bpm;

  HRResult({this.sourceType, this.startDateTime, this.endDateTime, this.bpm});

  HRResult.fromJson(Map<String, dynamic> json) {
    sourceType = json['sourceType'];
    startDateTime = json['startDateTime'];
    endDateTime = json['endDateTime'];
    bpm = json['bpm'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['sourceType'] = this.sourceType;
    data['startDateTime'] = this.startDateTime;
    data['endDateTime'] = this.endDateTime;
    data['bpm'] = this.bpm;
    return data;
  }
}
