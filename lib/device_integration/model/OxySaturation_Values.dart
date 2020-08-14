class OxySaturationValues {
  bool isSuccess;
  List<OxyResult> result;

  OxySaturationValues({this.isSuccess, this.result});

  OxySaturationValues.fromJson(Map<String, dynamic> json) {
    isSuccess = json['isSuccess'];
    if (json['result'] != null) {
      result = new List<OxyResult>();
      json['result'].forEach((v) {
        result.add(new OxyResult.fromJson(v));
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

class OxyResult {
  String sourceType;
  String startDateTime;
  String endDateTime;
  int oxygenSaturation;

  OxyResult(
      {this.sourceType,
      this.startDateTime,
      this.endDateTime,
      this.oxygenSaturation});

  OxyResult.fromJson(Map<String, dynamic> json) {
    sourceType = json['sourceType'];
    startDateTime = json['startDateTime'];
    endDateTime = json['endDateTime'];
    oxygenSaturation = json['oxygenSaturation'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['sourceType'] = this.sourceType;
    data['startDateTime'] = this.startDateTime;
    data['endDateTime'] = this.endDateTime;
    data['oxygenSaturation'] = this.oxygenSaturation;
    return data;
  }
}
