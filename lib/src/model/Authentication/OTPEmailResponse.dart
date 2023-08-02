
import '../../../common/CommonUtil.dart';
import '../../../constants/fhb_parameters.dart' as parameters;

class OTPEmailResponse {
  int? status;
  bool? success;
  String? message;
  String? response;

  OTPEmailResponse({this.status, this.success, this.message, this.response});

  OTPEmailResponse.fromJson(Map<String, dynamic> json) {
    try {
      final commonUtil = CommonUtil();
      status = json[parameters.strStatus];
      success = json[parameters.strSuccess];
      message = json[parameters.strMessage];
      response = commonUtil.checkIfStringIsEmpty(json[parameters.strResponse]);
    } catch (e) {
      CommonUtil().appLogs(message: e.toString());
    }
  }

  Map<String, dynamic> toJson() {
    final data = Map<String, dynamic>();
    data[parameters.strStatus] = status;
    data[parameters.strSuccess] = success;
    data[parameters.strMessage] = message;
    data[parameters.strResponse] = response;
    return data;
  }
}
