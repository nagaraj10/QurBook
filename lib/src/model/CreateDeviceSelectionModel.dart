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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['isSuccess'] = this.isSuccess;
    data['message'] = this.message;
    data['result'] = this.result;
    return data;
  }
}