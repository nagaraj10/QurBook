class ReferAFriendResponse {
  bool isSuccess;
  List<Result> result;

  ReferAFriendResponse({this.isSuccess, this.result});

  ReferAFriendResponse.fromJson(Map<String, dynamic> json) {
    isSuccess = json['isSuccess'];
    if (json['result'] != null) {
      result = new List<Result>();
      json['result'].forEach((v) {
        result.add(new Result.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['isSuccess'] = this.isSuccess;
    if (this.result != null) {
      data['result'] = this.result.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Result {
  String phoneNumber;
  String name;
  bool isExistingUser;
  String message;

  Result({this.phoneNumber, this.name, this.isExistingUser, this.message});

  Result.fromJson(Map<String, dynamic> json) {
    phoneNumber = json['phoneNumber'];
    name = json['name'];
    isExistingUser = json['isExistingUser'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['phoneNumber'] = this.phoneNumber;
    data['name'] = this.name;
    data['isExistingUser'] = this.isExistingUser;
    data['message'] = this.message;
    return data;
  }
}
