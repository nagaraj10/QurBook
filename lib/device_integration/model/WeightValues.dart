class WeightValues {
  bool isSuccess;
  List<WVResult> result;

  WeightValues({this.isSuccess, this.result});

  WeightValues.fromJson(Map<String, dynamic> json) {
    isSuccess = json['isSuccess'];
    if (json['result'] != null) {
      result = new List<WVResult>();
      json['result'].forEach((v) {
        result.add(new WVResult.fromJson(v));
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

class WVResult {
  String sourceType;
  String startDateTime;
  String endDateTime;
  String weight;
  String weightUnit;

  WVResult(
      {this.sourceType,
      this.startDateTime,
      this.endDateTime,
      this.weight,
      this.weightUnit});

  WVResult.fromJson(Map<String, dynamic> json) {
    sourceType = json['sourceType'];
    startDateTime = json['startDateTime'];
    endDateTime = json['endDateTime'];
    weight = json['weight'];
    weightUnit = json['weightUnit'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['sourceType'] = this.sourceType;
    data['startDateTime'] = this.startDateTime;
    data['endDateTime'] = this.endDateTime;
    data['weight'] = this.weight;
    data['weightUnit'] = this.weightUnit;
    return data;
  }
}
