import 'package:flutter/cupertino.dart';
import 'package:myfhb/my_providers/models/my_providers_response_list.dart';
import 'package:myfhb/my_providers/services/providers_repository.dart';
import 'package:myfhb/telehealth/features/MyProvider/model/AssociateRecordResponse.dart';
import 'package:myfhb/telehealth/features/MyProvider/model/BookAppointmentModel.dart';
import 'package:myfhb/telehealth/features/MyProvider/model/DateSlots.dart';
import 'package:myfhb/telehealth/features/MyProvider/model/DoctorBookMarkedSucessModel.dart';
import 'package:myfhb/telehealth/features/MyProvider/model/DoctorTimeSlots.dart';
import 'package:myfhb/telehealth/features/MyProvider/model/GetAllPatientsModel.dart';
import 'package:myfhb/telehealth/features/MyProvider/model/Data.dart';
import 'package:myfhb/telehealth/features/MyProvider/model/UpdatePaymentModel.dart';
import 'package:myfhb/telehealth/features/MyProvider/model/provider_model/DoctorIds.dart';
import 'package:myfhb/telehealth/features/MyProvider/model/provider_model/TelehealthProviderModel.dart';
import 'package:myfhb/telehealth/features/appointments/model/historyModel.dart';

class MyProviderViewModel extends ChangeNotifier {
  List<GetAllPatientsModel> mockDoctors = List<GetAllPatientsModel>();
  List<DoctorIds> doctorIdsList = new List();
  SessionData sessionList = new SessionData();
  List<DateSlotTimings> dateSlotTimings = new List();
  List<TelehealthProviderModel> teleHealthProviderModel = new List();
  BookAppointmentModel bookAppointment = BookAppointmentModel();
  UpdatePaymentModel updatePaymentModel = UpdatePaymentModel();
  AssociateRecordsResponse associateRecordResponse = AssociateRecordsResponse();

  ProvidersListRepository _providersListRepository = ProvidersListRepository();

  Future<List<DoctorIds>> fetchProviderDoctors() async {
    try {
      TelehealthProviderModel myProvidersResponseList =
          await _providersListRepository.getTelehealthDoctorsList();

      doctorIdsList = myProvidersResponseList
          .response.data.medicalPreferences.preferences.doctorIds;
      return doctorIdsList;
    } catch (e) {}
  }

  Future<bool> bookMarkDoctor(bool condition, DoctorIds doctorIds) async {
    bool condition;

    DoctorBookMarkedSucessModel doctorBookMarkedSucessModel =
        await _providersListRepository.bookMarkDoctor(condition, doctorIds);

    return doctorBookMarkedSucessModel.success;
  }

  List<DoctorIds> getFilterDoctorList(String doctorName) {
    List<DoctorIds> filterDoctorData = new List();
    for (DoctorIds doctorData in doctorIdsList) {
      if (doctorData.name
              .toLowerCase()
              .trim()
              .contains(doctorName.toLowerCase().trim()) ||
          doctorData.specialization
              .toLowerCase()
              .trim()
              .contains(doctorName.toLowerCase().trim()) ||
          doctorData.city
              .toLowerCase()
              .trim()
              .contains(doctorName.toLowerCase().trim())) {
        filterDoctorData.add(doctorData);
      }
    }
    return filterDoctorData;
  }

  Future<SessionData> fetchTimeSlots(String date, String doctorId) async {
    try {
      DoctorTimeSlotsModel doctorTimeSlotsModel =
          await _providersListRepository.getTelehealthSlotsList(date, doctorId);
      sessionList = doctorTimeSlotsModel.response.data;
      return sessionList;
    } catch (e) {}
  }

  Future<BookAppointmentModel> putBookAppointment(
      String createdBy,
      String createdFor,
      String doctorSessionId,
      String scheduleDate,
      String slotNumber,
      bool isMedicalShared,
      bool isFollowUp,
      List<String> healthRecords,
      {History doc}) async {
    try {
      BookAppointmentModel bookAppointmentModel =
          await _providersListRepository.bookAppointment(
              createdBy,
              createdFor,
              doctorSessionId,
              scheduleDate,
              slotNumber,
              isMedicalShared,
              isFollowUp,
              healthRecords,
              doc: doc);
      bookAppointment = bookAppointmentModel;
      return bookAppointment;
    } catch (e) {}
  }

  Future<UpdatePaymentModel> updatePaymentStatus(
      String paymentId,
      String appointmentId,
      String paymentOrderId,
      String paymentRequestId) async {
    try {
      UpdatePaymentModel updatePaymentModel =
          await _providersListRepository.updatePayment(
              paymentId, appointmentId, paymentOrderId, paymentRequestId);
      updatePaymentModel = updatePaymentModel;
      return updatePaymentModel;
    } catch (e) {}
  }

  Future<AssociateRecordsResponse> associateRecords(
      String doctorId, String userId, List<String> healthRecords) async {
    try {
      AssociateRecordsResponse bookAppointmentModel =
          await _providersListRepository.associateRecords(
              doctorId, userId, healthRecords);
      associateRecordResponse = bookAppointmentModel;
      return associateRecordResponse;
    } catch (e) {}
  }
}
