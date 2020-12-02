import 'package:myfhb/telehealth/features/appointments/constants/appointments_parameters.dart'
    as parameters;
import 'package:myfhb/telehealth/features/appointments/model/fetchAppointments/booked.dart';
import 'package:myfhb/telehealth/features/appointments/model/fetchAppointments/city.dart';
import 'package:myfhb/telehealth/features/appointments/model/fetchAppointments/doctor.dart';
import 'package:myfhb/telehealth/features/appointments/model/fetchAppointments/healthRecord.dart';
import 'package:myfhb/telehealth/features/appointments/model/fetchAppointments/status.dart';

class Past {
  Past({
    this.id,
    this.bookingId,
    this.doctorSessionId,
    this.plannedStartDateTime,
    this.plannedEndDateTime,
    this.actualStartDateTime,
    this.actualEndDateTime,
    this.slotNumber,
    this.isHealthRecordShared,
    this.plannedFollowupDate,
    this.isRefunded,
    this.isFollowupFee,
    this.isFollowup,
    this.isActive,
    this.createdOn,
    this.lastModifiedOn,
    this.bookedFor,
    this.bookedBy,
    this.status,
    this.prescriptionCollection,
    this.healthRecord,
    this.doctorFollowUpFee,
    this.healthOrganization,
    this.doctor,
  });

  String id;
  String bookingId;
  String doctorSessionId;
  String plannedStartDateTime;
  String plannedEndDateTime;
  String actualStartDateTime;
  String actualEndDateTime;
  int slotNumber;
  bool isHealthRecordShared;
  String plannedFollowupDate;
  bool isRefunded;
  bool isFollowupFee;
  dynamic isFollowup;
  bool isActive;
  String createdOn;
  String lastModifiedOn;
  Booked bookedFor;
  Booked bookedBy;
  Status status;
  List<dynamic> prescriptionCollection;
  HealthRecord healthRecord;
  String doctorFollowUpFee;
  Doctor doctor;
  City healthOrganization;
  bool isFollowUpTaken;

  Past.fromJson(Map<String, dynamic> json) {
    id = json[parameters.strId];
    bookingId = json[parameters.strBookingId];
    doctorSessionId = json[parameters.strDoctorSessionId];
    plannedStartDateTime = json[parameters.strPlannedStartDateTime];
    plannedEndDateTime = json[parameters.strPlannedEndDateTime];
    actualStartDateTime = json[parameters.strActualStartDateTime];
    actualEndDateTime = json[parameters.strActualEndDateTime];
    slotNumber = json[parameters.strSlotNumber];
    isHealthRecordShared = json[parameters.strIsHealthRecordShared];
    plannedFollowupDate = json[parameters.strPlannedFollowupDate];
    isRefunded = json[parameters.strIsRefunded];
    isFollowupFee = json[parameters.strIsFollowUpFee];
    isFollowup = json[parameters.strIsFollowup];
    isActive = json[parameters.strIsActive];
    createdOn = json[parameters.strCreatedOn];
    lastModifiedOn = json[parameters.strLastModifiedOn];
    bookedFor = json[parameters.strBookedFor] == null
        ? null
        : Booked.fromJson(json[parameters.strBookedFor]);
    bookedBy = json[parameters.strBookedBy] == null
        ? null
        : Booked.fromJson(json[parameters.strBookedBy]);
    status = json[parameters.strStatus] == null
        ? null
        : Status.fromJson(json[parameters.strStatus]);
    prescriptionCollection = json[parameters.strPrescriptionCollection] == null
        ? null
        : List<dynamic>.from(
            json[parameters.strPrescriptionCollection].map((x) => x));
    healthRecord = json[parameters.strHealthRecord] == null
        ? null
        : HealthRecord.fromJson(json[parameters.strHealthRecord]);
    doctorFollowUpFee = json[parameters.strDoctorFollowUpFee] == null
        ? null
        : json[parameters.strDoctorFollowUpFee];
    doctor = json[parameters.strdoctor] == null
        ? null
        : Doctor.fromJson(json[parameters.strdoctor]);
    healthOrganization = json[parameters.strHealthOrganization] != null
        ? new City.fromJson(json[parameters.strHealthOrganization])
        : null;
    isFollowUpTaken = json[parameters.strIsFollowUpTaken] != null
        ? json[parameters.strIsFollowUpTaken]
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data[parameters.strId] = id;
    data[parameters.strBookingId] = bookingId;
    data[parameters.strDoctorSessionId] = doctorSessionId;
    data[parameters.strPlannedStartDateTime] = plannedStartDateTime;
    data[parameters.strPlannedEndDateTime] = plannedEndDateTime;
    data[parameters.strActualStartDateTime] = actualStartDateTime;
    data[parameters.strActualEndDateTime] = actualEndDateTime;
    data[parameters.strSlotNumber] = slotNumber;
    data[parameters.strIsHealthRecordShared] = isHealthRecordShared;
    data[parameters.strPlannedFollowupDate] = plannedFollowupDate;
    data[parameters.strIsRefunded] = isRefunded;
    data[parameters.strIsFollowUpFee] = isFollowupFee;
    data[parameters.strIsFollowup] = isFollowup;
    data[parameters.strIsActive] = isActive;
    data[parameters.strCreatedOn] = createdOn;
    data[parameters.strLastModifiedOn] = lastModifiedOn;
    data[parameters.strBookedFor] = bookedFor.toJson();
    data[parameters.strBookedBy] = bookedBy.toJson();
    data[parameters.strStatus] = status.toJson();
    data[parameters.strIsFollowUpTaken] = isFollowUpTaken;
    data[parameters.strPrescriptionCollection] =
        List<dynamic>.from(prescriptionCollection.map((x) => x));
    data[parameters.strHealthRecord] = healthRecord.toJson();
    data[parameters.strDoctorFollowUpFee] =
        doctorFollowUpFee == null ? null : doctorFollowUpFee;
    data[parameters.strdoctor] = doctor.toJson();
    data[parameters.strHealthOrganization] = this.healthOrganization.toJson();
    return data;
  }
}
