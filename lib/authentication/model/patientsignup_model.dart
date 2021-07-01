import '../constants/constants.dart';

class PatientSignUp {
  String firstName;
  String lastName;
  String source;
  String password;
  String message;
  bool isSuccess;
  List<UserContactCollection3> userContactCollection3;
  Result result;

  PatientSignUp(
      {this.firstName,
      this.lastName,
      this.source,
      this.password,
      this.message,
      this.isSuccess,
      this.userContactCollection3,
      this.result});

  PatientSignUp.fromJson(Map<String, dynamic> json) {
    firstName = json[strfirstName];
    lastName = json[strlastName];
    source = json[strsource];
    password = json[strpassword];
    message = json[strmessage];
    isSuccess = json[strIsSuccess];
    if (json[struserContactCollection3] != null) {
      userContactCollection3 = <UserContactCollection3>[];
      json[struserContactCollection3].forEach((v) {
        userContactCollection3.add(UserContactCollection3.fromJson(v));
      });
    }
    result =
        json[strResult] != null ? Result.fromJson(json[strResult]) : null;
  }

  Map<String, dynamic> toJson() {
    final data = Map<String, dynamic>();
    data[strfirstName] = firstName;
    data[strlastName] = lastName;
    data[strsource] = source;
    data[strpassword] = password;
    data[strmessage] = message;
    data[strIsSuccess] = isSuccess;
    if (userContactCollection3 != null) {
      data[struserContactCollection3] =
          userContactCollection3.map((v) => v.toJson()).toList();
    }
    if (result != null) {
      data[strResult] = result.toJson();
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
    final data = Map<String, dynamic>();
    data[strphoneNumber] = phoneNumber;
    data[stremail] = email;
    data[strisPrimary] = isPrimary;
    return data;
  }
}

class Result {
  String userId;
  String userName;

  Result({this.userId, this.userName});

  Result.fromJson(Map<String, dynamic> json) {
    userId = json[strUserId];
    userName = json[struserName];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data[strUserId] = userId;
    data[struserName] = userName;
    return data;
  }
}
