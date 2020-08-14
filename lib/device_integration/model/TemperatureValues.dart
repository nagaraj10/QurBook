class TemperatureValues {
  bool isSuccess;
  List<TMPResult> result;

  TemperatureValues({this.isSuccess, this.result});

  TemperatureValues.fromJson(Map<String, dynamic> json) {
    isSuccess = json['isSuccess'];
    if (json['result'] != null) {
      result = new List<TMPResult>();
      json['result'].forEach((v) {
        result.add(new TMPResult.fromJson(v));
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

class TMPResult {
  String sourceType;
  String startDateTime;
  String endDateTime;
  String temperature;
  String temperatureUnit;

  TMPResult(
      {this.sourceType,
      this.startDateTime,
      this.endDateTime,
      this.temperature,
      this.temperatureUnit});

  TMPResult.fromJson(Map<String, dynamic> json) {
    sourceType = json['sourceType'];
    startDateTime = json['startDateTime'];
    endDateTime = json['endDateTime'];
    temperature = json['temperature'];
    temperatureUnit = json['temperatureUnit'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['sourceType'] = this.sourceType;
    data['startDateTime'] = this.startDateTime;
    data['endDateTime'] = this.endDateTime;
    data['temperature'] = this.temperature;
    data['temperatureUnit'] = this.temperatureUnit;
    return data;
  }
}
