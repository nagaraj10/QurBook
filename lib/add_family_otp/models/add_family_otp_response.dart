class AddFamilyOTPResponse {
  int status;
  bool success;
  String message;
  Response response;

  AddFamilyOTPResponse(
      {this.status, this.success, this.message, this.response});

  AddFamilyOTPResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    success = json['success'];
    message = json['message'];
    response = json['response'] != null
        ? new Response.fromJson(json['response'])
        : null;
  }

//  Map<String, dynamic> toJson() {
//    final Map<String, dynamic> data = new Map<String, dynamic>();
//    data['status'] = this.status;
//    data['success'] = this.success;
//    data['message'] = this.message;
//    if (this.response != null) {
//      data['response'] = this.response.toJson();
//    }
//    return data;
//  }
}

class Response {
  AddFamilyUserInfo data;

  Response({this.data});

  Response.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null
        ? new AddFamilyUserInfo.fromJson(json['data'])
        : null;
  }
}

class AddFamilyUserInfo {
  String id;
  String email;
  String countryCode;
  String phoneNumber;
  String gender;
  String name;
  bool isTempUser;
  bool isEmailVerified;
  String transactionId;

  AddFamilyUserInfo(
      {this.id,
      this.email,
      this.countryCode,
      this.phoneNumber,
      this.gender,
      this.name,
      this.isTempUser,
      this.isEmailVerified,
      this.transactionId});

  AddFamilyUserInfo.fromJson(Map<String, dynamic> json) {
    Map<String, dynamic> userInfo = json['userInfo'];

    id = userInfo['id'];
    email = userInfo['email'];
    countryCode = userInfo['countryCode'];
    phoneNumber = userInfo['phoneNumber'];
    gender = userInfo['gender'];
    name = userInfo['name'];
    isTempUser = userInfo['isTempUser'];
    isEmailVerified = userInfo['isEmailVerified'];
    transactionId = json['transactionId'];
  }
}
