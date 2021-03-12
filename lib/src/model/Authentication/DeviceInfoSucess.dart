class DeviceInfoSucess {
  bool isSuccess;
  String message;
  String result;

  DeviceInfoSucess({this.isSuccess, this.message, this.result});

  DeviceInfoSucess.fromJson(Map<String, dynamic> json) {
    if (json != null) {
      isSuccess = json['isSuccess'] != null ? json['isSuccess'] : false;
      if (json.containsKey('message')) message = json['message'];
      if (json.containsKey('result'))
        result = json['result'] != null ? json['result'] : null;
    } else {
      isSuccess = false;
      message = '';
      result = null;
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['isSuccess'] = this.isSuccess;
    data['message'] = this.message;
    data['result'] = this.result;
    return data;
  }
}
