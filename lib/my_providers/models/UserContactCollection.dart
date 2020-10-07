import 'PhoneNumberType.dart';

class UserContactCollection3 {
  String id;
  String phoneNumber;
  bool isPrimary;
  bool isActive;
  String createdOn;
  String lastModifiedOn;
  String email;
  PhoneNumberType phoneNumberType;

  UserContactCollection3(
      {this.id,
        this.phoneNumber,
        this.isPrimary,
        this.isActive,
        this.createdOn,
        this.lastModifiedOn,
        this.email,
        this.phoneNumberType});

  UserContactCollection3.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    phoneNumber = json['phoneNumber'];
    isPrimary = json['isPrimary'];
    isActive = json['isActive'];
    createdOn = json['createdOn'];
    lastModifiedOn = json['lastModifiedOn'];
    email = json['email'];
    phoneNumberType = json['phoneNumberType'] != null
        ? new PhoneNumberType.fromJson(json['phoneNumberType'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['phoneNumber'] = this.phoneNumber;
    data['isPrimary'] = this.isPrimary;
    data['isActive'] = this.isActive;
    data['createdOn'] = this.createdOn;
    data['lastModifiedOn'] = this.lastModifiedOn;
    data['email'] = this.email;
    if (this.phoneNumberType != null) {
      data['phoneNumberType'] = this.phoneNumberType.toJson();
    }
    return data;
  }
}