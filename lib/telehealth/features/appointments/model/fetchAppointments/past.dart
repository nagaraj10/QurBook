import 'package:myfhb/telehealth/features/appointments/constants/appointments_parameters.dart'
    as parameters;
import 'package:myfhb/telehealth/features/appointments/model/fetchAppointments/booked.dart';
import 'package:myfhb/telehealth/features/appointments/model/fetchAppointments/city.dart';
import 'package:myfhb/telehealth/features/appointments/model/fetchAppointments/doctor.dart';
import 'package:myfhb/telehealth/features/appointments/model/fetchAppointments/feeDetails.dart';
import 'package:myfhb/telehealth/features/appointments/model/fetchAppointments/healthRecord.dart';
import 'package:myfhb/telehealth/features/appointments/model/fetchAppointments/status.dart';
import 'package:myfhb/regiment/models/Status.dart';

class Past {
  Past(
      {this.id,
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
      this.feeDetails,
      this.doctor,
      this.chatListId,
      this.chatMessage,
      this.serviceCategory,
      this.modeOfService,
      this.additionalinfo});

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
  FeeDetails feeDetails;
  City healthOrganization;
  bool isFollowUpTaken;
  String chatListId;
  ChatMessage chatMessage;
  ServiceCategory serviceCategory;
  ServiceCategory modeOfService;
  AdditionalInfo additionalinfo;

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
    feeDetails = json[parameters.strFeeDetails] != null
        ? new FeeDetails.fromJson(json[parameters.strFeeDetails])
        : null;
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
    chatListId = json[parameters.strChatListId] == null
        ? null
        : json[parameters.strChatListId];
    chatMessage = json["chatMessage"] == null
        ? null
        : ChatMessage.fromJson(json["chatMessage"]);
    serviceCategory = json["serviceCategory"] == null
        ? null
        : ServiceCategory.fromJson(json["serviceCategory"]);
    modeOfService = json["modeOfService"] == null
        ? null
        : ServiceCategory.fromJson(json["modeOfService"]);
    additionalinfo = json["additionalInfo"] == null
        ? null
        : AdditionalInfo.fromJson(json["additionalInfo"]);
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
    if (this.feeDetails != null) {
      data[parameters.strFeeDetails] = this.feeDetails.toJson();
    }
    data[parameters.strdoctor] = doctor.toJson();
    data[parameters.strHealthOrganization] = this.healthOrganization.toJson();
    data[parameters.strChatListId] = chatListId;
    data['additionalInfo'] = this.additionalinfo.toJson();
    data['modeOfService'] = this.modeOfService.toJson();
    data['serviceCategory'] = this.serviceCategory.toJson();

    return data;
  }
}

class ChatMessage {
  ChatMessage({
    this.deliveredOn,
    this.documentId,
    this.chatMessageId,
  });

  String deliveredOn;
  String documentId;
  String chatMessageId;

  ChatMessage.fromJson(Map<String, dynamic> json) {
    deliveredOn = json["deliveredOn"];
    documentId = json["documentId"];
    chatMessageId = json["chatMessageId"];
  }
}

class AdditionalInfo {
  AdditionalInfo({
    this.title,
    this.Address,
    this.description,
    this.serviceType,
    this.fee,
  });

  String title;
  String Address;
  String description;
  String serviceType;

  int fee;

  AdditionalInfo.fromJson(Map<String, dynamic> json) {
    title = json.containsKey('title') ? json["title"] : '';
    Address = json.containsKey('Address') ? json["Address"] : '';
    description = json.containsKey('description') ? json["description"] : '';
    serviceType = json.containsKey('serviceType') ? json["serviceType"] : '';
    fee = json.containsKey('fee') ? json["fee"] : 0;
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = title;
    data['Address'] = Address;
    data['description'] = description;
    data['serviceType'] = serviceType;
    data['fee'] = fee;
  }
}
