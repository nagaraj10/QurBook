class VerifyOTPModel {
  String verificationCode;
  String phoneNumber;

  VerifyOTPModel({this.verificationCode, this.phoneNumber});

  VerifyOTPModel.fromJson(Map<String, dynamic> json) {
    verificationCode = json['verificationCode'];
    phoneNumber = json['phoneNumber'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['verificationCode'] = verificationCode;
    data['phoneNumber'] = phoneNumber;
    return data;
  }
}
