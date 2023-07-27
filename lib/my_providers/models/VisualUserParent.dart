
import 'package:myfhb/common/CommonUtil.dart';

import '../../constants/fhb_parameters.dart' as parameters;
class VirtualUserParent {
  String? countryCode;
  String? phoneNumber;
  String? email;

  VirtualUserParent({this.countryCode, this.phoneNumber, this.email});

  VirtualUserParent.fromJson(Map<String, dynamic> json) {
    try {
      countryCode = json[parameters.strCountryCode];
      phoneNumber = json[parameters.strPhoneNumber];
      email = json[parameters.strEmail];
    } catch (e) {
      CommonUtil().appLogs(message: e.toString());
    }
  }

  Map<String, dynamic> toJson() {
    final data = Map<String, dynamic>();
    data[parameters.strCountryCode] = countryCode;
    data[parameters.strPhoneNumber] = phoneNumber;
    data[parameters.strEmail] = email;
    return data;
  }
}