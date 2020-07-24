import 'package:flutter/cupertino.dart';
import 'package:myfhb/my_providers/models/my_providers_response_list.dart';
import 'package:myfhb/my_providers/services/providers_repository.dart';
import 'package:myfhb/telehealth/features/MyProvider/model/BookAppointmentModel.dart';
import 'package:myfhb/telehealth/features/MyProvider/model/BookAppointmentOld.dart';
import 'package:myfhb/telehealth/features/MyProvider/model/DateSlots.dart';
import 'package:myfhb/telehealth/features/MyProvider/model/DoctorBookMarkedSucessModel.dart';
import 'package:myfhb/telehealth/features/MyProvider/model/DoctorTimeSlots.dart';
import 'package:myfhb/telehealth/features/MyProvider/model/GetAllPatientsModel.dart';
import 'package:myfhb/telehealth/features/MyProvider/model/Data.dart';
import 'package:myfhb/telehealth/features/MyProvider/model/provider_model/DoctorIds.dart';
import 'package:myfhb/telehealth/features/MyProvider/model/provider_model/TelehealthProviderModel.dart';

class MyProviderViewModel extends ChangeNotifier {
  List<GetAllPatientsModel> mockDoctors = List<GetAllPatientsModel>();
  List<DoctorIds> doctorIdsList = new List();
  SessionData sessionList = new SessionData();
  List<DateSlotTimings> dateSlotTimings = new List();
  List<TelehealthProviderModel> teleHealthProviderModel = new List();
  BookAppointmentOld bookAppointment = BookAppointmentOld();

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

  Future<BookAppointmentOld> putBookAppointment(String createdBy,String createdFor,String doctorSessionId,String scheduleDate,String startTime,String endTime,String slotNumber,String isMedicalShared,String isFollowUp) async {
    try {
      BookAppointmentOld bookAppointmentModel =
      await _providersListRepository.bookAppointment(createdBy,createdFor,doctorSessionId,scheduleDate,startTime,endTime,slotNumber,isMedicalShared,isFollowUp);
      bookAppointment = bookAppointmentModel;
      return bookAppointment;
    } catch (e) {}
  }
}
