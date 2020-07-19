import 'package:myfhb/constants/fhb_parameters.dart' as parameters;
class VirtualUserParent {
  String countryCode;
  String phoneNumber;
  String email;

  VirtualUserParent({this.countryCode, this.phoneNumber, this.email});

  VirtualUserParent.fromJson(Map<String, dynamic> json) {
    countryCode = json[parameters.strCountryCode];
    phoneNumber = json[parameters.strPhoneNumber];
    email = json[parameters.strEmail];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data[parameters.strCountryCode] = this.countryCode;
    data[parameters.strPhoneNumber] = this.phoneNumber;
    data[parameters.strEmail] = this.email;
    return data;
  }
}