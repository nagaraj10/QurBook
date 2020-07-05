import 'package:flutter/cupertino.dart';
import 'package:myfhb/telehealth/features/MyProvider/model/DateSlots.dart';
import 'package:myfhb/telehealth/features/MyProvider/model/GetAllPatientsModel.dart';
import 'package:myfhb/telehealth/features/MyProvider/model/mockDoctorsData.dart';
import 'package:myfhb/telehealth/features/MyProvider/model/Data.dart';

class MyProviderViewModel extends ChangeNotifier {
  List<GetAllPatientsModel> mockDoctors = List<GetAllPatientsModel>();
  List<Data> docsList = new List<Data>();
  List<DateSlotTimings> dateSlotTimings = new List();

  Future<void> fetchDoctors() async {
    mockDoctorsData mockData = mockDoctorsData();

    mockDoctors.add(GetAllPatientsModel.fromJson(mockData.doctorList));

    for (int i = 0; i < mockDoctors.length; i++) {
      for (int j = 0; j < mockDoctors[i].data.length; j++) {
        docsList.add(mockDoctors[i].data[j]);
      }
    }
    notifyListeners();
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

    List<DateTiming> dateTimings3 = new List();
    dateTimings3.add(new DateTiming(timeslots: '6:00'));
    dateTimings3.add(new DateTiming(timeslots: '6:30'));
    dateTimings3.add(new DateTiming(timeslots: '7:00'));

    dateSlotTimings.add(new DateSlotTimings(
        dateTimings: '10.00am - 11.30am', dateTimingsSlots: dateTimings));
    dateSlotTimings.add(new DateSlotTimings(
        dateTimings: '02.00pm - 04.00pm', dateTimingsSlots: dateTimings1));
    dateSlotTimings.add(new DateSlotTimings(
        dateTimings: '05.00pm - 11.00pm', dateTimingsSlots: dateTimings2));
    dateSlotTimings.add(
        new DateSlotTimings(dateTimings: '', dateTimingsSlots: dateTimings3));
  }

  List<Data> getFilterDoctorList(String doctorName) {
    List<Data> filterDoctorData = new List();
    for (Data doctorData in docsList) {
      print('$doctorName ************ ${doctorData.fullname}');

      if (doctorData.fullname.toLowerCase().trim()
          .contains(doctorName.toLowerCase().trim())) {
        print('$doctorName ************ $doctorData.fullname');
        filterDoctorData.add(doctorData);
      }
    }
    return filterDoctorData;
  }
}
