class UpdateDeviceModel {
  bool isSuccess;
  String message;
  String result;

  UpdateDeviceModel({this.isSuccess, this.message, this.result});

  UpdateDeviceModel.fromJson(Map<String, dynamic> json) {
    isSuccess = json['isSuccess'];
    message = json['message'];
    result = json['result'];
  }

  Map<String, dynamic> toJson() {
    final data = Map<String, dynamic>();
    data['isSuccess'] = isSuccess;
    data['message'] = message;
    data['result'] = result;
    return data;
  }
}