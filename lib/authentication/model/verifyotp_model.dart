class VerifyOTPModel {
  String verificationCode;
  String phoneNumber;

  VerifyOTPModel({this.verificationCode, this.phoneNumber});

  VerifyOTPModel.fromJson(Map<String, dynamic> json) {
    verificationCode = json['verificationCode'];
    phoneNumber = json['phoneNumber'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['verificationCode'] = this.verificationCode;
    data['phoneNumber'] = this.phoneNumber;
    return data;
  }
}
