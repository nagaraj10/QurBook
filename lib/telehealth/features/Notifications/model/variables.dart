class Variables {
  String lastName;
  String bookingId;
  String firstName;
  String doctorName;
  int slotNumber;
  String doctorLastname;
  String appointmentDate;
  String appointmentTime;
  String doctorFirstname;

  Variables(
      {this.lastName,
      this.bookingId,
      this.firstName,
      this.doctorName,
      this.slotNumber,
      this.doctorLastname,
      this.appointmentDate,
      this.appointmentTime,
      this.doctorFirstname});

  Variables.fromJson(Map<String, dynamic> json) {
//    lastName = json['lastName'] == null ? null : json['lastName'];
    bookingId = json['bookingId'] == null ? null : json['bookingId'];
//    firstName = json['firstName'] == null ? null : json['firstName'];
//    doctorName = json['doctorName'] == null ? null : json['doctorName'];
//    slotNumber = json['slotNumber'] == null ? null : json['slotNumber'];
//    doctorLastname =
//        json['doctorLastname'] == null ? null : json['doctorLastname'];
//    appointmentDate =
//        json['appointmentDate'] == null ? null : json['appointmentDate'];
//    appointmentTime =
//        json['appointmentTime'] == null ? null : json['appointmentTime'];
//    doctorFirstname =
//        json['doctorFirstname'] == null ? null : json['doctorFirstname'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['lastName'] = this.lastName;
    data['bookingId'] = this.bookingId;
    data['firstName'] = this.firstName;
    data['doctorName'] = this.doctorName;
    data['slotNumber'] = this.slotNumber;
    data['doctorLastname'] = this.doctorLastname;
    data['appointmentDate'] = this.appointmentDate;
    data['appointmentTime'] = this.appointmentTime;
    data['doctorFirstname'] = this.doctorFirstname;
    return data;
  }
}
