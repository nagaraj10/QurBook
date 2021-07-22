class DeviceInfoSucess {
  bool isSuccess;
  String message;
  String result;

  DeviceInfoSucess({this.isSuccess, this.message, this.result});

  DeviceInfoSucess.fromJson(Map<String, dynamic> json) {
    if (json != null) {
      isSuccess = json['isSuccess'] ?? false;
      if (json.containsKey('message')) message = json['message'];
      if (json.containsKey('result')) {
        result = json['result'] ?? null;
      }
    } else {
      isSuccess = false;
      message = '';
      result = null;
    }
  }

  Map<String, dynamic> toJson() {
    final data = Map<String, dynamic>();
    data['isSuccess'] = isSuccess;
    data['message'] = message;
    data['result'] = result;
    return data;
  }
}
