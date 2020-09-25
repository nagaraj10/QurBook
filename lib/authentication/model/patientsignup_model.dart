import 'package:myfhb/authentication/constants/constants.dart';

class PatientSignUp {
  String firstName;
  String lastName;
  String source;
  String password;
  String message;
  bool isSuccess;
  List<UserContactCollection3> userContactCollection3;

  PatientSignUp(
      {this.firstName,
      this.lastName,
      this.source,
      this.password,
      this.message,
      this.isSuccess,
      this.userContactCollection3});

  PatientSignUp.fromJson(Map<String, dynamic> json) {
    firstName = json[strfirstName];
    lastName = json[strlastName];
    source = json[strsource];
    password = json[strpassword];
    message = json[strmessage];
    isSuccess = json[strIsSuccess];
    if (json[struserContactCollection3] != null) {
      userContactCollection3 = new List<UserContactCollection3>();
      json[struserContactCollection3].forEach((v) {
        userContactCollection3.add(new UserContactCollection3.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data[strfirstName] = this.firstName;
    data[strlastName] = this.lastName;
    data[strsource] = this.source;
    data[strpassword] = this.password;
    data[strmessage] = this.message;
    data[strIsSuccess] = this.isSuccess;
    if (this.userContactCollection3 != null) {
      data[struserContactCollection3] =
          this.userContactCollection3.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class UserContactCollection3 {
  String phoneNumber;
  String email;
  bool isPrimary;

  UserContactCollection3({this.phoneNumber, this.email, this.isPrimary});

  UserContactCollection3.fromJson(Map<String, dynamic> json) {
    phoneNumber = json[strphoneNumber];
    email = json[stremail];
    isPrimary = json[strisPrimary];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data[strphoneNumber] = this.phoneNumber;
    data[stremail] = this.email;
    data[strisPrimary] = this.isPrimary;
    return data;
  }
}
