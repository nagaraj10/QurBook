class Contacts {
  String name;
  String phoneNumber;

  Contacts({this.name, this.phoneNumber});

  Contacts.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    phoneNumber = json['phoneNumber'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['phoneNumber'] = this.phoneNumber;
    return data;
  }
}
