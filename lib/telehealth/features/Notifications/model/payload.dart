class Payload {
  String type;
  String priority;
  String appointmentDate;

  Payload({this.type, this.priority, this.appointmentDate});

  Payload.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    priority = json['priority'];
    appointmentDate = json['appointmentDate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['type'] = this.type;
    data['priority'] = this.priority;
    data['appointmentDate'] = this.appointmentDate;
    return data;
  }
}