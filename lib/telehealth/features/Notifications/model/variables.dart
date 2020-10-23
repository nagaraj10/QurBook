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
    lastName = json['lastName'];
    bookingId = json['bookingId'];
    firstName = json['firstName'];
    doctorName = json['doctorName'];
    slotNumber = json['slotNumber'];
    doctorLastname = json['doctorLastname'];
    appointmentDate = json['appointmentDate'];
    appointmentTime = json['appointmentTime'];
    doctorFirstname = json['doctorFirstname'];
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