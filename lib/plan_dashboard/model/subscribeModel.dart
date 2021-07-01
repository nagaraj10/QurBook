class SubscribeModel {
  bool isSuccess;
  SubscibeResult result;

  SubscribeModel({this.isSuccess, this.result});

  SubscribeModel.fromJson(Map<String, dynamic> json) {
    isSuccess = json['isSuccess'];
    result =
    json['result'] != null ? SubscibeResult.fromJson(json['result']) : null;
  }

  Map<String, dynamic> toJson() {
    final data = Map<String, dynamic>();
    data['isSuccess'] = isSuccess;
    if (result != null) {
      data['result'] = result.toJson();
    }
    return data;
  }
}

class SubscibeResult {
  String result;
  String message;

  SubscibeResult({this.result, this.message});

  SubscibeResult.fromJson(Map<String, dynamic> json) {
    result = json['Result'];
    message = json['Message'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['Result'] = result;
    data['Message'] = message;
    return data;
  }
}