import 'package:myfhb/constants/fhb_query.dart';
import 'package:myfhb/src/resources/network/ApiBaseHelper.dart';
import 'package:myfhb/telehealth/features/MyProvider/model/appointments/CreateAppointmentModel.dart';
import 'package:myfhb/telehealth/features/appointments/model/historyModel.dart';
import 'dart:convert' as convert;

class CreateAppointmentService {
  ApiBaseHelper _helper = ApiBaseHelper();

  Future<CreateAppointmentModel> bookAppointment(
      String createdBy,
      String createdFor,
      String doctorSessionId,
      String scheduleDate,
      String slotNumber,
      bool isMedicalShared,
      bool isFollowUp,
      List<String> healthRecords,
      {History doc}) async {
    var slotInput = {};
    slotInput[qr_created_by] = createdBy;
    slotInput[qr_created_for] = createdFor;
    slotInput[qr_doctor_session_id] = doctorSessionId;
    slotInput[qr_schedule_date] = scheduleDate;
    slotInput[qr_slot_number] = slotNumber;
    slotInput[qr_is_medical_shared] = isMedicalShared;
    slotInput[qr_is_followup] = isFollowUp;
    slotInput[qr_health_record_ref] = healthRecords;
    if (isFollowUp) {
      var parentAppoint = {};

      parentAppoint["id"] = doc.appointmentId;
      parentAppoint["bookingID"] = doc.bookingId;

      slotInput[qr_parent_appointment] = parentAppoint;
    } else {
      slotInput[qr_parent_appointment] = {};
    }

    var jsonString = convert.jsonEncode(slotInput);
    print(jsonString);
    final response = await _helper.bookAppointment(qr_bookAppmnt, jsonString);
    print(response);
    return CreateAppointmentModel.fromJson(response);
  }
}
