class UserModel {
  String auth_token;
  String birthdate;
  String given_name;
  String phone_number;
  String family_name;
  String email;
  String userId;
  UserModel(
      {this.auth_token,
      this.birthdate,
      this.given_name,
      this.phone_number,
      this.family_name,
      this.email,
      this.userId});

  UserModel.fromJson(Map<String, dynamic> json) {
    auth_token = json['result'];
    birthdate = json['birthdate'];
    given_name = json['given_name'];
    phone_number = json['phone_number'];
    family_name = json['family_name'];
    email = json['email'];
    userId = json['userId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['result'] = this.auth_token;
    data['birthdate'] = this.birthdate;
    data['given_name'] = this.given_name;
    data['phone_number'] = this.phone_number;
    data['family_name'] = this.family_name;
    data['email'] = this.email;
    data['userId'] = this.userId;
    return data;
  }
}
