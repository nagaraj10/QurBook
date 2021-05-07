class SubscribeModel {
  bool isSuccess;
  SubscibeResult result;

  SubscribeModel({this.isSuccess, this.result});

  SubscribeModel.fromJson(Map<String, dynamic> json) {
    isSuccess = json['isSuccess'];
    result =
    json['result'] != null ? new SubscibeResult.fromJson(json['result']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['isSuccess'] = this.isSuccess;
    if (this.result != null) {
      data['result'] = this.result.toJson();
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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Result'] = this.result;
    data['Message'] = this.message;
    return data;
  }
}