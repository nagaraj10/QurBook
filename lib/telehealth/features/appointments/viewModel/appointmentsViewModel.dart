import 'package:flutter/cupertino.dart';
import 'package:myfhb/src/resources/network/ApiBaseHelper.dart';
import 'package:myfhb/telehealth/features/appointments/model/appointmentsModel.dart';
import 'package:myfhb/telehealth/features/appointments/model/cancelModel.dart';
import 'package:myfhb/telehealth/features/appointments/model/doctorsData.dart';
import 'package:myfhb/telehealth/features/appointments/model/historyModel.dart';
import 'package:myfhb/telehealth/features/appointments/model/resheduleModel.dart';
import 'package:myfhb/telehealth/features/appointments/model/timeModel.dart';

class AppointmentsViewModel extends ChangeNotifier {
  ApiBaseHelper _helper=ApiBaseHelper();
  AppointmentsModel appointmentsModel;
  CancelAppointmentModel cancelAppointmentModel = new CancelAppointmentModel();
  Reshedule resheduleAppointmentModel = new Reshedule();

  Future<AppointmentsModel> fetchAppointments() async {
    try {
      AppointmentsModel myAppointmentsModel =
      await _helper.fetchAppointments();

      appointmentsModel = myAppointmentsModel;
      return appointmentsModel;
    } catch (e) {}
  }

  DoctorsData filterSearchResults(String query) {
    List<History> dummySearchListUpcoming = List<History>();
    List<History> dummySearchListHistory = List<History>();
    DoctorsData data = DoctorsData();
    AppointmentsModel appointments = appointmentsModel;
    dummySearchListUpcoming = appointments.response.data.upcoming
        .where((element) => element.doctorName
        .toLowerCase()
        .trim()
        .contains(query.toLowerCase().trim())||element.location
        .toLowerCase()
        .trim()
        .contains(query.toLowerCase().trim()))
        .toList();

    dummySearchListHistory = appointments.response.data.history
        .where((element) => element.doctorName
        .toLowerCase()
        .trim()
        .contains(query.toLowerCase().trim())||element.location
        .toLowerCase()
        .trim()
        .contains(query.toLowerCase().trim()))
        .toList();
    data = DoctorsData(
        upcoming: dummySearchListUpcoming, history: dummySearchListHistory);
    return DoctorsData(
        upcoming: dummySearchListUpcoming, history: dummySearchListHistory);
  }

  Time getStaticValue(){
    List<String> hours;
    List<String> minutes;
    hours = List.filled(appointmentsModel
        .response.data.upcoming.length, '00');
    minutes = List.filled(appointmentsModel
        .response.data.upcoming.length, '00');
    Time time;
    time = Time(minutes: minutes, hours: hours);
    return time;
  }

  Time getTimeSlot(List<History> upcoming,bool isSearch) {
    if(appointmentsModel!=null) {
      List<History> upcomingInfo = isSearch ? upcoming : appointmentsModel
          .response.data.upcoming;
      List<String> dummySearchList = List<String>();
      List<String> dummyHour = List<String>();
      List<String> dummyMinutes = List<String>();
      List<String> hours;
      List<String> minutes;
      Time time;


      dummySearchList
          .addAll(upcomingInfo.map((e) => e.plannedStartDateTime).toList());
      for (int i = 0; i < dummySearchList.length; i++) {
        DateTime dob = DateTime.parse(dummySearchList[i]);
        Duration dur = dob.difference(DateTime.now());
        String differenceInHours = dur.inHours >= 0 && dur.inHours <= 24
            ? (dur.inHours.remainder(24)).round().toString().padLeft(2, '0')
            : '00';
        String differenceInMinutes = dur.inHours >= 0 && dur.inHours <= 24
            ? (dur.inMinutes.remainder(60)).toString().padLeft(2, '0')
            : '00';
        dummyMinutes.add(
            int.parse(differenceInMinutes) <= 0 ? '00' : differenceInMinutes);
        dummyHour.add(
            dur.inHours.remainder(24).toInt() <= 0 ? '00' : differenceInHours);
      }
      minutes = dummyMinutes;
      hours = dummyHour;
      time = Time(minutes: minutes, hours: hours);

      return time;
    }else{

    }
  }

  Future<CancelAppointmentModel> fetchCancelAppointment(
      List<String> bookingId) async {
    try {
      CancelAppointmentModel cancelAppointment =
      await _helper.getCancelAppointment(bookingId);
      cancelAppointmentModel = cancelAppointment;
      return cancelAppointmentModel;
    } catch (e) {}
  }

  Future<Reshedule> resheduleAppointment(
      List<String> bookingId,String slotNumber,String resheduleDate) async {
    try {
      Reshedule resheduleAp =
      await _helper.resheduleAppointment(bookingId,slotNumber,resheduleDate);
      resheduleAppointmentModel = resheduleAp;
      return resheduleAppointmentModel;
    } catch (e) {}
  }


}
