class CreateDeviceSelectionModel {
  bool isSuccess;
  String message;
  String result;

  CreateDeviceSelectionModel({this.isSuccess, this.message, this.result});

  CreateDeviceSelectionModel.fromJson(Map<String, dynamic> json) {
    isSuccess = json['isSuccess'];
    message = json['message'];
    result = json['result'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['isSuccess'] = isSuccess;
    data['message'] = message;
    data['result'] = result;
    return data;
  }
}