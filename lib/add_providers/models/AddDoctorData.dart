import '../../common/CommonUtil.dart';
import '../../constants/fhb_parameters.dart' as parameters;

class AddDoctorData {
  String id;
  String name;
  String addressLine1;
  String addressLine2;
  String website;
  String googleMapUrl;
  String phoneNumber1;
  String phoneNumber2;
  String phoneNumber3;
  String phoneNumber4;
  String email;
  String state;
  String city;
  bool isActive;
  String specialization;
  bool isUserDefined;
  String description;
  String createdBy;
  String lastModifiedOn;

  AddDoctorData(
      {this.id,
      this.name,
      this.addressLine1,
      this.addressLine2,
      this.website,
      this.googleMapUrl,
      this.phoneNumber1,
      this.phoneNumber2,
      this.phoneNumber3,
      this.phoneNumber4,
      this.email,
      this.state,
      this.city,
      this.isActive,
      this.specialization,
      this.isUserDefined,
      this.description,
      this.createdBy,
      this.lastModifiedOn});

  AddDoctorData.fromJson(Map<String, dynamic> json) {
    final commonUtil = CommonUtil();
    id = json[parameters.strId];
    name = json[parameters.strName];
    addressLine1 =
        commonUtil.checkIfStringIsEmpty(json[parameters.strAddressLine1]);
    addressLine2 =
        commonUtil.checkIfStringIsEmpty(json[parameters.strAddressLine2]);
    website = commonUtil.checkIfStringIsEmpty(json[parameters.strWebsite]);
    googleMapUrl =
        commonUtil.checkIfStringIsEmpty(json[parameters.strGoogleMapUrl]);
    phoneNumber1 =
        commonUtil.checkIfStringIsEmpty(json[parameters.strPhoneNumber1]);
    phoneNumber2 =
        commonUtil.checkIfStringIsEmpty(json[parameters.strPhoneNumber2]);
    phoneNumber3 =
        commonUtil.checkIfStringIsEmpty(json[parameters.strPhoneNumber3]);
    phoneNumber4 =
        commonUtil.checkIfStringIsEmpty(json[parameters.strPhoneNumber4]);
    email = json[parameters.strEmail];
    state = json[parameters.strState];
    city = json[parameters.strCity];
    isActive = json[parameters.strIsActive];
    specialization = json[parameters.strSpecilization];
    isUserDefined = json[parameters.strIsUserDefined];
    description = json[parameters.strDescription];
    createdBy = json[parameters.strCreatedBy];
    lastModifiedOn = json[parameters.strLastModifiedOn];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data[parameters.strId] = id;
    data[parameters.strName] = name;
    data[parameters.strAddressLine1] = addressLine1;
    data[parameters.strAddressLine2] = addressLine2;
    data[parameters.strWebsite] = website;
    data[parameters.strGoogleMapUrl] = googleMapUrl;
    data[parameters.strPhoneNumber1] = phoneNumber1;
    data[parameters.strPhoneNumber2] = phoneNumber2;
    data[parameters.strPhoneNumber3] = phoneNumber3;
    data[parameters.strPhoneNumber4] = phoneNumber4;
    data[parameters.strEmail] = email;
    data[parameters.strState] = state;
    data[parameters.strCity] = city;
    data[parameters.strIsActive] = isActive;
    data[parameters.strSpecilization] = specialization;
    data[parameters.strIsUserDefined] = isUserDefined;
    data[parameters.strDescription] = description;
    data[parameters.strCreatedBy] = createdBy;
    data[parameters.strLastModifiedOn] = lastModifiedOn;
    return data;
  }
}
