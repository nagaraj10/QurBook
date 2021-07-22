import '../../constants/fhb_parameters.dart' as parameters;

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
    final data = <String, dynamic>{};
    data[parameters.strCountryCode] = countryCode;
    data[parameters.strPhoneNumber] = phoneNumber;
    data[parameters.strEmail] = email;
    return data;
  }
}
