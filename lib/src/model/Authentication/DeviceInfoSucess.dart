class DeviceInfoSucess {
  bool isSuccess;
  String message;
  String result;

  DeviceInfoSucess({this.isSuccess, this.message, this.result});

  DeviceInfoSucess.fromJson(Map<String, dynamic> json) {
    isSuccess = json['isSuccess'];
    message = json['message'];
    result = json['result'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['isSuccess'] = this.isSuccess;
    data['message'] = this.message;
    data['result'] = this.result;
    return data;
  }
}
