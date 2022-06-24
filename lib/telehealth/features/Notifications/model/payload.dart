import '../../../../constants/fhb_parameters.dart' as parameters;

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
    this.doctorSessionId,
    this.bookingId,
    this.healthOrganizationId,
    this.plannedStartDateTime,
    this.redirectTo,
    this.healthRecordMetaIds,
    this.planId,
    this.userId,
    this.patientName,
    this.claimId,
    this.patientPhoneNumber,
    this.verificationCode,
    this.caregiverRequestor,
    this.caregiverReceiver,
    this.appointmentId,
    this.createdBy,
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
  String bookingId;
  String doctorSessionId;
  String healthOrganizationId;
  String plannedStartDateTime;
  String redirectTo;
  String healthRecordMetaIds;
  String planId;
  String userId;
  String patientName;
  String claimId;
  String patientPhoneNumber;
  String verificationCode;
  String caregiverRequestor;
  String caregiverReceiver;
  String appointmentId;
  String createdBy;

  Payload.fromJson(Map<String, dynamic> json) {
    type = json["type"];
    meetingId = json["meetingId"] == null ? null : json["meetingId"];
    appointmentId =
        json["appointmentId"] == null ? null : json["appointmentId"];
    createdBy = json["createdBy"] == null ? null : json["createdBy"];

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
    redirectTo = json["redirectTo"] == null ? null : json["redirectTo"];
    healthRecordMetaIds = json["healthRecordMetaIds"] == null
        ? null
        : json["healthRecordMetaIds"];
    patientName = json["patientName"] == null ? null : json["patientName"];
    userId = json["userId"] == null ? null : json["userId"];
    claimId = json["claimId"] == null ? null : json["claimId"];
    patientPhoneNumber = json[parameters.patientPhoneNumber] == null
        ? null
        : json[parameters.patientPhoneNumber];
    caregiverRequestor = json[parameters.caregiverRequestor] == null
        ? null
        : json[parameters.caregiverRequestor];
    caregiverReceiver = json[parameters.caregiverReceiver] == null
        ? null
        : json[parameters.caregiverReceiver];
    verificationCode = json[parameters.verificationCode] == null
        ? null
        : json[parameters.verificationCode];
    if (json["planId"] != null) {
      var plan = json["planId"];
      if (plan.runtimeType == String) {
        planId = plan;
      } else if (plan.runtimeType == int) {
        planId = '$plan';
      }
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['type'] = this.type;
    data['priority'] = this.priority;
    data['appointmentDate'] = this.appointmentDate;
    data['redirectTo'] = this.redirectTo;
    data['healthRecordMetaIds'] = this.healthRecordMetaIds;
    data['planId'] = this.planId;
    data['appointmentId'] = this.appointmentId;
    data['createdBy'] = this.createdBy;

    return data;
  }
}
