import 'package:myfhb/common/PreferenceUtil.dart';
import 'package:myfhb/constants/fhb_constants.dart' as Constants;
import 'package:myfhb/constants/fhb_query.dart';
import 'package:myfhb/my_providers/models/my_providers_response_list.dart';
import 'package:myfhb/src/resources/network/ApiBaseHelper.dart';
import 'package:myfhb/telehealth/features/MyProvider/model/AssociateRecordResponse.dart';
import 'package:myfhb/telehealth/features/MyProvider/model/BookAppointmentModel.dart';
import 'package:myfhb/telehealth/features/MyProvider/model/DoctorBookMarkedSucessModel.dart';
import 'package:myfhb/telehealth/features/MyProvider/model/DoctorTimeSlots.dart';
import 'dart:convert' as convert;

import 'package:myfhb/constants/router_variable.dart' as router;
import 'package:myfhb/constants/fhb_parameters.dart' as parameters;
import 'package:myfhb/constants/fhb_query.dart' as query;
import 'package:myfhb/telehealth/features/MyProvider/model/UpdatePaymentModel.dart';
import 'package:myfhb/telehealth/features/MyProvider/model/provider_model/DoctorIds.dart';
import 'package:myfhb/telehealth/features/MyProvider/model/provider_model/TelehealthProviderModel.dart';
import 'package:myfhb/telehealth/features/appointments/model/historyModel.dart';

class ProvidersListRepository {
  ApiBaseHelper _helper = ApiBaseHelper();

  String userID = PreferenceUtil.getStringValue(Constants.KEY_USERID);

  Future<MyProvidersResponseList> getMedicalPreferencesList() async {
    final response = await _helper.getMedicalPreferencesList(
        query.qr_Userprofile + userID + query.qr_slash);
    return MyProvidersResponseList.fromJson(response);
  }

  Future<TelehealthProviderModel> getTelehealthDoctorsList() async {
    String userID = PreferenceUtil.getStringValue(Constants.KEY_USERID);

    final response = await _helper.getTelehealthDoctorsList(
        query.qr_Userprofile +
            userID +
            query.qr_slash +
            query.qr_sections +
            query.qr_medicalPreferences);
    return TelehealthProviderModel.fromJson(response);
  }

  Future<DoctorBookMarkedSucessModel> bookMarkDoctor(
      bool condition, DoctorIds doctorIds) async {
    var bookMark = {};
    bookMark[parameters.strdoctorPatientMappingId] =
        doctorIds.doctorPatientMappingId;
    if (doctorIds.isDefault) {
      bookMark[parameters.strisDefault] = false;
    } else {
      bookMark[parameters.strisDefault] = true;
    }

    var jsonString = convert.jsonEncode(bookMark);
    final response = await _helper.bookMarkDoctor(
        query.qr_doctorpatientmapping + query.qr_updateDefaultProvider,
        jsonString);
    return DoctorBookMarkedSucessModel.fromJson(response);
  }

  Future<DoctorTimeSlotsModel> getTelehealthSlotsList(
      String date, String doctorId) async {
    var slotInput = {};
    slotInput[qr_slotDate] = date;
    slotInput[qr_doctorid] = doctorId;

    var jsonString = convert.jsonEncode(slotInput);
    final response = await _helper.getTimeSlotsList(qr_getSlots, jsonString);
    return DoctorTimeSlotsModel.fromJson(response);
  }

  Future<BookAppointmentModel> bookAppointment(
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
    //var parentAppoint = {};
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
    return BookAppointmentModel.fromJson(response);
  }

  Future<UpdatePaymentModel> updatePayment(
      String paymentId,
      String appointmentId,
      String paymentOrderId,
      String paymentRequestId) async {
    var paymentInput = {};
    paymentInput[qr_payment_id] = paymentId;
    paymentInput[qr_appoint_id] = appointmentId;
    paymentInput[qr_payment_order_id] = paymentOrderId;
    paymentInput[qr_payment_req_id] = paymentRequestId;

    var jsonString = convert.jsonEncode(paymentInput);
    final response = await _helper.updatePayment(qr_update_payment, jsonString);
    return UpdatePaymentModel.fromJson(response);
  }

  Future<AssociateRecordsResponse> associateRecords(
      String doctorId, String userId, List<String> healthRecords) async {
    String userID = PreferenceUtil.getStringValue(Constants.KEY_USERID);

    var associateRecord = {};
    //var parentAppoint = {};
    associateRecord[qr_doctorid] = doctorId;
    associateRecord[qr_userid] = userID;
    associateRecord[qr_mediaMetaId] = healthRecords;
    var jsonString = convert.jsonEncode(associateRecord);
    print(jsonString + '******************');
    final response = await _helper.associateRecords(qr_sharerecord, jsonString);
    return AssociateRecordsResponse.fromJson(response);
  }
}
