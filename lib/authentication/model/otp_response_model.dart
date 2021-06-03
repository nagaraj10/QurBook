class OtpResponseModel {
  OtpResponseModel({
    this.isSuccess,
    this.message,
    this.otpData,
  });

  final bool isSuccess;
  final String message;
  final OtpModel otpData;

  factory OtpResponseModel.fromJson(Map<String, dynamic> json) =>
      OtpResponseModel(
        isSuccess: json['isSuccess'],
        message: json['message'],
        otpData:
            json['result'] != null ? OtpModel.fromJson(json['result']) : null,
      );

  Map<String, dynamic> toJson() => {
        'isSuccess': isSuccess,
        'message': message,
        'result': otpData.toJson(),
      };
}

class OtpModel {
  OtpModel({
    this.otpCode,
  });

  final String otpCode;

  factory OtpModel.fromJson(Map<String, dynamic> json) => OtpModel(
        otpCode: json['code'],
      );

  Map<String, dynamic> toJson() => {
        'code': otpCode,
      };
}
