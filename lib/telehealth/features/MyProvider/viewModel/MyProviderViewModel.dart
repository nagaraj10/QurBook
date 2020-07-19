import 'package:flutter/cupertino.dart';
import 'package:myfhb/my_providers/models/my_providers_response_list.dart';
import 'package:myfhb/my_providers/services/providers_repository.dart';
import 'package:myfhb/telehealth/features/MyProvider/model/DateSlots.dart';
import 'package:myfhb/telehealth/features/MyProvider/model/DoctorBookMarkedSucessModel.dart';
import 'package:myfhb/telehealth/features/MyProvider/model/DoctorTimeSlots.dart';
import 'package:myfhb/telehealth/features/MyProvider/model/GetAllPatientsModel.dart';
import 'package:myfhb/telehealth/features/MyProvider/model/TelehealthProviderModel.dart';
import 'package:myfhb/telehealth/features/MyProvider/model/mockDoctorsData.dart';
import 'package:myfhb/telehealth/features/MyProvider/model/Data.dart';

class MyProviderViewModel extends ChangeNotifier {
  List<GetAllPatientsModel> mockDoctors = List<GetAllPatientsModel>();
  List<DoctorIds> doctorIdsList = new List();
 SessionData sessionList = new SessionData();
  List<DateSlotTimings> dateSlotTimings = new List();
  List<TelehealthProviderModel> teleHealthProviderModel = new List();

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

  Future<void> getDateSlots() async {
    List<DateTiming> dateTimings = new List();
    dateTimings.add(new DateTiming(timeslots: '10:30'));
    dateTimings.add(new DateTiming(timeslots: '10:45'));
    dateTimings.add(new DateTiming(timeslots: '11:00'));

    List<DateTiming> dateTimings1 = new List();
    dateTimings1.add(new DateTiming(timeslots: '2:30'));
    dateTimings1.add(new DateTiming(timeslots: '3:00'));
    dateTimings1.add(new DateTiming(timeslots: '3:30'));

    List<DateTiming> dateTimings2 = new List();
    dateTimings2.add(new DateTiming(timeslots: '5:00'));
    dateTimings2.add(new DateTiming(timeslots: '5:30'));
    dateTimings2.add(new DateTiming(timeslots: '6:00'));
    dateTimings2.add(new DateTiming(timeslots: '6:00'));
    dateTimings2.add(new DateTiming(timeslots: '6:30'));

    List<DateTiming> dateTimings3 = new List();
    dateTimings3.add(new DateTiming(timeslots: '6:00'));
    dateTimings3.add(new DateTiming(timeslots: '6:30'));
    dateTimings3.add(new DateTiming(timeslots: '7:00'));
    dateTimings3.add(new DateTiming(timeslots: '7:30'));
    dateTimings3.add(new DateTiming(timeslots: '8:00'));

    List<DateTiming> dateTimings4 = new List();
    dateTimings4.add(new DateTiming(timeslots: '6:00'));
    dateTimings4.add(new DateTiming(timeslots: '6:30'));
    dateTimings4.add(new DateTiming(timeslots: '7:00'));
    dateTimings4.add(new DateTiming(timeslots: '7:30'));
    dateTimings4.add(new DateTiming(timeslots: '8:00'));

    dateSlotTimings.add(new DateSlotTimings(
        dateTimings: '10.00am - 11.30am', dateTimingsSlots: dateTimings));
    dateSlotTimings.add(new DateSlotTimings(
        dateTimings: '10.00am - 11.30am', dateTimingsSlots: dateTimings1));
    dateSlotTimings.add(new DateSlotTimings(
        dateTimings: '05.00pm - 11.00pm', dateTimingsSlots: dateTimings2));

    dateSlotTimings.add(
        new DateSlotTimings(dateTimings: '', dateTimingsSlots: dateTimings3));
    dateSlotTimings.add(
        new DateSlotTimings(dateTimings: '', dateTimingsSlots: dateTimings4));
  }

  List<DoctorIds> getFilterDoctorList(String doctorName) {
    List<DoctorIds> filterDoctorData = new List();
    for (DoctorIds doctorData in doctorIdsList) {
      print('$doctorName ************ ${doctorData.name}');

      if (doctorData.name
          .toLowerCase()
          .trim()
          .contains(doctorName.toLowerCase().trim())||doctorData.specialization
          .toLowerCase()
          .trim()
          .contains(doctorName.toLowerCase().trim())||doctorData.city
          .toLowerCase()
          .trim()
          .contains(doctorName.toLowerCase().trim())) {
        print('$doctorName ************ $doctorData.name');
        filterDoctorData.add(doctorData);
      }
    }
    return filterDoctorData;
  }

  Future<SessionData> fetchTimeSlots(String date,String doctorId) async {
    try {
      DoctorTimeSlotsModel doctorTimeSlotsModel =
      await _providersListRepository.getTelehealthSlotsList(date,doctorId);
      sessionList = doctorTimeSlotsModel.response.data;
      return sessionList;
    } catch (e) {}
  }
}
