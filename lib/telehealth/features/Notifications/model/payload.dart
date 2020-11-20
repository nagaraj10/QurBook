class Payload {
  Payload({
    this.type,
    this.meetingId,
    this.priority,
    this.appointmentDate,
    this.userName,
    this.doctorId,
    this.payloadMeetingId,
    this.templateName,
    this.providerRequestId,
  });

  String type;
  String meetingId;
  String priority;
  String appointmentDate;
  String userName;
  String doctorId;
  dynamic payloadMeetingId;
  String templateName;
  String providerRequestId;

  Payload.fromJson(Map<String, dynamic> json) {
    type= json["type"];
    meetingId= json["meetingId"] == null ? null : json["meetingId"];
    priority= json["priority"] == null ? null : json["priority"];
    appointmentDate= json["appointmentDate"] == null ? null : json["appointmentDate"];
    userName= json["userName"] == null ? null : json["userName"];
    doctorId= json["doctorId"] == null ? null : json["doctorId"];
    payloadMeetingId= json["meeting_id"];
    templateName= json["templateName"] == null ? null : json["templateName"];
    providerRequestId= json["providerRequestId"] == null ? null : json["providerRequestId"];
    }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['type'] = this.type;
    data['priority'] = this.priority;
    data['appointmentDate'] = this.appointmentDate;
    return data;
  }
}