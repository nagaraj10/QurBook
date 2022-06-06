import 'dart:core';

import 'package:myfhb/telehealth/features/appointments/model/fetchAppointments/healthRecord.dart';

class CallMetaData {
  String bookId;
  String appointmentId;
  String patName;
  String patId;
  String patientDOB;
  String patientPicUrl;
  String gender;
  String docName;
  dynamic slotDuration;
  HealthRecord healthRecord;
  String patientPrescriptionId;

  CallMetaData(
      this.bookId,
      this.appointmentId,
      this.patName,
      this.patId,
      this.patientDOB,
      this.patientPicUrl,
      this.gender,
      this.docName,
      this.healthRecord,
      this.patientPrescriptionId,
      {this.slotDuration});

  String get mbookId {
    return bookId;
  }

  String get mappointmentId {
    return appointmentId;
  }

  String get mpatName {
    return patName;
  }

  String get mpatId {
    return patId;
  }

  String get mpatientDOB {
    return patientDOB;
  }

  String get mpatientPicUrl {
    return patientPicUrl;
  }

  String get mgender {
    return gender;
  }

  String get mDocName {
    return docName;
  }

  HealthRecord get mhealthRecord {
    return healthRecord;
  }
}
