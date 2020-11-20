class AppointmentStatus {
  String code;
  String name;
  String description;

  AppointmentStatus({this.code, this.name, this.description});

  AppointmentStatus.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    name = json['name'];
    description = json['description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    data['name'] = this.name;
    data['description'] = this.description;
    return data;
  }
}