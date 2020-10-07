import 'package:myfhb/telehealth/features/appointments/model/fetchAppointments/healthRecord.dart';
import 'package:myfhb/telehealth/features/appointments/constants/appointments_parameters.dart'as parameters;

class History {
  History(
      {this.appointmentId,
      this.createdOn,
      this.createdBy,
      this.lastModifiedBy,
      this.healthRecord,
      this.plannedStartDateTime,
      this.plannedEndDateTime,
      this.slotNumber,
      this.isRefunded,
      this.bookingId,
      this.sharedMedicalRecordsId,
      this.isMedicalRecordsShared,
      this.specialization,
      this.location,
      this.doctorPic,
      this.doctorName,
      this.doctorId,
      this.doctorSessionId,
      this.patientId,
      this.actualStartDateTime,
      this.actualEndDateTime,
      this.followupDate,
      this.followupFee,
      this.status,
      this.paymentMediaMetaId,
      this.refundMediaMetaId});

  String appointmentId;
  String createdOn;
  String createdBy;
  String lastModifiedBy;
  HealthRecord healthRecord;
  String plannedStartDateTime;
  String plannedEndDateTime;
  int slotNumber;
  bool isRefunded;
  String bookingId;
  String sharedMedicalRecordsId;
  bool isMedicalRecordsShared;
  String specialization;
  String location;
  String doctorPic;
  String doctorName;
  String doctorId;
  String doctorSessionId;
  String patientId;
  String actualStartDateTime;
  String actualEndDateTime;
  String followupDate;
  String followupFee;
  String status;
  String paymentMediaMetaId;
  String refundMediaMetaId;

  History.fromJson(Map<String, dynamic> json) {
    appointmentId = json[parameters.strAppointmentId];
    createdOn = json[parameters.strCreatedOn];
    createdBy = json[parameters.strCreatedBy];
    lastModifiedBy = json[parameters.strlastModifiedBy];
    healthRecord = json[parameters.strHealthRecord] == null
        ? null
        : HealthRecord.fromJson(json[parameters.strHealthRecord]);
    plannedStartDateTime = json[parameters.strPlannedStartDateTime];
    plannedEndDateTime = json[parameters.strPlannedEndDateTime];
    slotNumber = json[parameters.strSlotNumber];
    isRefunded = json[parameters.strIsRefunded];
    bookingId = json[parameters.strBookingID];
    sharedMedicalRecordsId = json[parameters.strSharedMedicalRecordsId] == null
        ? null
        : json[parameters.strSharedMedicalRecordsId];
    isMedicalRecordsShared = json[parameters.strIsMedicalRecordsShared];
    specialization = json[parameters.strSpecilization];
    location = json[parameters.strlocation];
    doctorPic = json[parameters.strDoctorPic];
    doctorName = json[parameters.strDoctorName];
    doctorId = json[parameters.strDoctorId];
    doctorSessionId = json[parameters.strDoctorSessionId];
    patientId = json[parameters.strPatientId];
    actualStartDateTime = json[parameters.strActualStartDateTime];
    actualEndDateTime = json[parameters.strActualEndDateTime];
    followupDate = json[parameters.strFollowupDate];
    followupFee = json[parameters.strFollowupFee];
    status = json[parameters.strStatus];
    paymentMediaMetaId = json[parameters.strPaymentMediaMetaId];
    refundMediaMetaId = json[parameters.strRefundMediaMetaId];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data[parameters.strAppointmentId] = this.appointmentId;
    data[parameters.strCreatedOn] = this.createdOn;
    data[parameters.strCreatedBy] = this.createdBy;
    data[parameters.strlastModifiedBy] = this.lastModifiedBy;
//    if (this.healthRecord != null) {
//      data["healthRecord"] =
//      List<dynamic>.from(healthRecord.map((x) => x.toJson()));
//    }
    data[parameters.strPlannedStartDateTime] = this.plannedStartDateTime;
    data[parameters.strPlannedEndDateTime] = this.plannedEndDateTime;
    data[parameters.strSlotNumber] = this.slotNumber;
    data[parameters.strIsRefunded] = this.isRefunded;
    data[parameters.strBookingID] = this.bookingId;
    data[parameters.strSharedMedicalRecordsId] = this.sharedMedicalRecordsId;
    data[parameters.strIsMedicalRecordsShared] = this.isMedicalRecordsShared;
    data[parameters.strSpecilization] = this.specialization;
    data[parameters.strlocation] = this.location;
    data[parameters.strDoctorPic] = this.doctorPic;
    data[parameters.strDoctorName] = this.doctorName;
    data[parameters.strDoctorId] = this.doctorId;
    data[parameters.strDoctorSessionId] = this.doctorSessionId;
    data[parameters.strPatientId] = this.patientId;
    data[parameters.strActualStartDateTime] = this.actualStartDateTime;
    data[parameters.strActualEndDateTime] = this.actualEndDateTime;
    data[parameters.strFollowupDate] = this.followupDate;
    data[parameters.strFollowupFee] = this.followupFee;
    data[parameters.strStatus] = this.status;
    data[parameters.strPaymentMediaMetaId] = this.paymentMediaMetaId;
    data[parameters.strRefundMediaMetaId] = this.refundMediaMetaId;
    return data;
  }
}
