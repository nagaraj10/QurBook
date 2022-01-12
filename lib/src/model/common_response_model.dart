class CommonResponseModel {
  bool isSuccess;
  String message;

  CommonResponseModel({this.isSuccess, this.message});

  CommonResponseModel.fromJson(Map<String, dynamic> json) {
    isSuccess = json['isSuccess'];
    message = json['message'];


  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['isSuccess'] = isSuccess;
    data['message'] = message;
    return data;
  }
}
