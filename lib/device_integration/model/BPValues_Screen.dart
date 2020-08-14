class BPValues {
  bool isSuccess;
  List<BPResult> result;

  BPValues({this.isSuccess, this.result});

  BPValues.fromJson(Map<String, dynamic> json) {
    isSuccess = json['isSuccess'];
    if (json['result'] != null) {
      result = new List<BPResult>();
      json['result'].forEach((v) {
        result.add(new BPResult.fromJson(v));
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

class BPResult {
  String sourceType;
  String startDateTime;
  String endDateTime;
  int systolic;
  int diastolic;

  BPResult(
      {this.sourceType,
      this.startDateTime,
      this.endDateTime,
      this.systolic,
      this.diastolic});

  BPResult.fromJson(Map<String, dynamic> json) {
    sourceType = json['sourceType'];
    startDateTime = json['startDateTime'];
    endDateTime = json['endDateTime'];
    systolic = json['systolic'];
    diastolic = json['diastolic'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['sourceType'] = this.sourceType;
    data['startDateTime'] = this.startDateTime;
    data['endDateTime'] = this.endDateTime;
    data['systolic'] = this.systolic;
    data['diastolic'] = this.diastolic;
    return data;
  }
}
