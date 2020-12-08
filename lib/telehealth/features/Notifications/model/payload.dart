class Payload {
  Payload(
      {this.type,
      this.meetingId,
      this.priority,
      this.appointmentDate,
      this.userName,
      this.doctorId,
      this.payloadMeetingId,
      this.templateName,
      this.providerRequestId,
      this.doctorSessionId,
      this.bookingId,
      this.healthOrganizationId,
      this.plannedStartDateTime});

  String type;
  String meetingId;
  String priority;
  String appointmentDate;
  String userName;
  String doctorId;
  dynamic payloadMeetingId;
  String templateName;
  String providerRequestId;
  String bookingId;
  String doctorSessionId;
  String healthOrganizationId;
  String plannedStartDateTime;

  Payload.fromJson(Map<String, dynamic> json) {
    type = json["type"];
    meetingId = json["meetingId"] == null ? null : json["meetingId"];
    priority = json["priority"] == null ? null : json["priority"];
    appointmentDate =
        json["appointmentDate"] == null ? null : json["appointmentDate"];
    userName = json["userName"] == null ? null : json["userName"];
    doctorId = json["doctorId"] == null ? null : json["doctorId"];
    payloadMeetingId = json["meetingId"] == null ? null : json["meetingId"];
    templateName = json["templateName"] == null ? null : json["templateName"];
    providerRequestId =
        json["providerRequestId"] == null ? null : json["providerRequestId"];
    bookingId = json['bookingId'] != null ? json['bookingId'] : null;
    doctorSessionId =
        json['doctorSessionId'] != null ? json['doctorSessionId'] : null;
    providerRequestId =
        json['providerRequestId'] != null ? json['providerRequestId'] : null;
    healthOrganizationId = json['healthOrganizationId'] != null
        ? json['healthOrganizationId']
        : null;
    plannedStartDateTime = json['plannedStartDateTime'] != null
        ? json['plannedStartDateTime']
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['type'] = this.type;
    data['priority'] = this.priority;
    data['appointmentDate'] = this.appointmentDate;
    return data;
  }
}
