class Variables {
  Variables({
    this.bookingId,
    this.paidOn,
    this.endTime,
    this.lastName,
    this.firstName,
    this.startTime,
    this.doctorName,
    this.paidAmount,
    this.slotNumber,
    this.patientName,
    this.modeOfPayment,
    this.appointmentDate,
    this.transactionReference,
    this.appointmentTime,
    this.previousSlotNumber,
    this.doctorLastname,
    this.doctorFirstname,
    this.prescriptionNumber,
    this.newBookingId,
    this.oldBookingId,
    this.newAppointmentDate,
    this.newAppointmentTime,
    this.oldAppointmentDate,
    this.oldAppointmentTime,
  });

  String bookingId;
  DateTime paidOn;
  String endTime;
  String lastName;
  String firstName;
  String startTime;
  String doctorName;
  String paidAmount;
  dynamic slotNumber;
  String patientName;
  String modeOfPayment;
  DateTime appointmentDate;
  String transactionReference;
  String appointmentTime;
  String previousSlotNumber;
  String doctorLastname;
  String doctorFirstname;
  String prescriptionNumber;
  String newBookingId;
  String oldBookingId;
  DateTime newAppointmentDate;
  String newAppointmentTime;
  DateTime oldAppointmentDate;
  String oldAppointmentTime;

  Variables.fromJson(Map<String, dynamic> json) {
    bookingId= json["bookingId"] == null ? null : json["bookingId"];
    paidOn= json["paidOn"] == null ? null : DateTime.parse(json["paidOn"]);
    endTime= json["endTime"] == null ? null : json["endTime"];
    lastName= json["lastName"] == null ? null : json["lastName"];
    firstName= json["firstName"] == null ? null : json["firstName"];
    startTime= json["startTime"] == null ? null : json["startTime"];
    doctorName= json["doctorName"] == null ? null : json["doctorName"];
    paidAmount= json["paidAmount"] == null ? null : json["paidAmount"];
    slotNumber= json["slotNumber"];
    patientName= json["patientName"] == null ? null : json["patientName"];
    modeOfPayment= json["modeOfPayment"] == null ? null : json["modeOfPayment"];
    appointmentDate= json["appointmentDate"] == null ? null : DateTime.parse(json["appointmentDate"]);
    transactionReference= json["transactionReference"] == null ? null : json["transactionReference"];
    appointmentTime= json["appointmentTime"] == null ? null : json["appointmentTime"];
    previousSlotNumber= json["previousSlotNumber"] == null ? null : json["previousSlotNumber"];
    doctorLastname= json["doctorLastname"] == null ? null : json["doctorLastname"];
    doctorFirstname= json["doctorFirstname"] == null ? null : json["doctorFirstname"];
    prescriptionNumber= json["prescriptionNumber"] == null ? null : json["prescriptionNumber"];
    newBookingId= json["newBookingId"] == null ? null : json["newBookingId"];
    oldBookingId= json["oldBookingId"] == null ? null : json["oldBookingId"];
    newAppointmentDate= json["newAppointmentDate"] == null ? null : DateTime.parse(json["newAppointmentDate"]);
    newAppointmentTime= json["newAppointmentTime"] == null ? null : json["newAppointmentTime"];
    oldAppointmentDate= json["oldAppointmentDate"] == null ? null : DateTime.parse(json["oldAppointmentDate"]);
    oldAppointmentTime= json["oldAppointmentTime"] == null ? null : json["oldAppointmentTime"];
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
