class GlucoseValues {
  bool isSuccess;
  List<GVResult> result;

  GlucoseValues({this.isSuccess, this.result});

  GlucoseValues.fromJson(Map<String, dynamic> json) {
    isSuccess = json['isSuccess'];
    if (json['result'] != null) {
      result = new List<GVResult>();
      json['result'].forEach((v) {
        result.add(new GVResult.fromJson(v));
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

class GVResult {
  String sourceType;
  String startDateTime;
  String endDateTime;
  int bloodGlucoseLevel;
  String bgUnit;
  String mealContext;
  String mealType;
  GVResult(
      {this.sourceType,
      this.startDateTime,
      this.endDateTime,
      this.bloodGlucoseLevel,
      this.bgUnit,
      this.mealContext,
      this.mealType});

  GVResult.fromJson(Map<String, dynamic> json) {
    sourceType = json['sourceType'];
    startDateTime = json['startDateTime'];
    endDateTime = json['endDateTime'];
    bloodGlucoseLevel = json['bloodGlucoseLevel'];
    bgUnit = json['bgUnit'];
    mealContext = json['mealContext'];
    mealType = json['mealType'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['sourceType'] = this.sourceType;
    data['startDateTime'] = this.startDateTime;
    data['endDateTime'] = this.endDateTime;
    data['bloodGlucoseLevel'] = this.bloodGlucoseLevel;
    data['bgUnit'] = this.bgUnit;
    data['mealContext'] = this.mealContext;
    data['mealType'] = this.mealType;
    return data;
  }
}
