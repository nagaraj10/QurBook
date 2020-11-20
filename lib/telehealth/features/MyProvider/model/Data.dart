class Data {
  String userid;
  String username;
  String fullname;
  String age;
  String history;
  String profileimage;
  String address;
  String countryCode;
  String phoneNumber;
  String status;
  String conditions;

  bool isBookmarked;
  String isAvailable;
  String consultationFee;
  String specialist;
  String city;

  Data(
      {this.userid,
      this.username,
      this.fullname,
      this.age,
      this.history,
      this.profileimage,
      this.address,
      this.countryCode,
      this.phoneNumber,
      this.status,
      this.conditions,
      this.isBookmarked,
      this.isAvailable,
      this.consultationFee,
      this.city,
      this.specialist});

  Data.fromJson(Map<String, dynamic> json) {
    userid = json['userid'];
    username = json['username'];
    fullname = json['fullname'];
    age = json['age'];
    history = json['history'];
    profileimage = json['profileimage'];
    address = json['address'];
    countryCode = json['countryCode'];
    phoneNumber = json['phoneNumber'];
    status = json['status'];
    conditions = json['conditions'];
    isBookmarked = json['isBookMarked'];
    isAvailable = json['isAvailable'];
    consultationFee = json['consultation_fee'];

    specialist = json['specialist'];
    city = json['city'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['userid'] = this.userid;
    data['username'] = this.username;
    data['fullname'] = this.fullname;
    data['age'] = this.age;
    data['history'] = this.history;
    data['profileimage'] = this.profileimage;
    data['address'] = this.address;
    data['countryCode'] = this.countryCode;
    data['phoneNumber'] = this.phoneNumber;
    data['status'] = this.status;
    data['conditions'] = this.conditions;
    data['isBookMarked'] = this.isBookmarked;
    data['isAvailable'] = this.isAvailable;
    data['consultation_fee'] = this.consultationFee;
    data['specialist'] = this.specialist;
    data['city'] = this.city;

    return data;
  }
}
