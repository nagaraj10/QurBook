import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:myfhb/src/resources/network/ApiBaseHelper.dart';
import 'package:myfhb/telehealth/features/appointments/model/appointmentsModel.dart';
import 'package:myfhb/telehealth/features/appointments/model/cancelModel.dart';
import 'package:myfhb/telehealth/features/appointments/model/doctorsData.dart';
import 'package:myfhb/telehealth/features/appointments/model/historyModel.dart';
import 'package:myfhb/telehealth/features/appointments/model/resheduleModel.dart';
import 'package:myfhb/telehealth/features/appointments/model/timeModel.dart';
import 'package:myfhb/telehealth/features/chat/model/GetMetaFileURLModel.dart';

class AppointmentsViewModel extends ChangeNotifier {
  ApiBaseHelper _helper = ApiBaseHelper();
  AppointmentsModel appointmentsModel;
  CancelAppointmentModel cancelAppointmentModel = new CancelAppointmentModel();
  Reshedule resheduleAppointmentModel = new Reshedule();
  GetMetaFileURLModel getMetaFileURLModel = new GetMetaFileURLModel();

  Future<AppointmentsModel> fetchAppointments() async {
    try {
      AppointmentsModel myAppointmentsModel = await _helper.fetchAppointments();

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
        .where((element) =>
            element.doctorName
                .toLowerCase()
                .trim()
                .contains(query.toLowerCase().trim()) ||
            element.location
                .toLowerCase()
                .trim()
                .contains(query.toLowerCase().trim()))
        .toList();

    dummySearchListHistory = appointments.response.data.history
        .where((element) =>
            element.doctorName
                .toLowerCase()
                .trim()
                .contains(query.toLowerCase().trim()) ||
            element.location
                .toLowerCase()
                .trim()
                .contains(query.toLowerCase().trim()))
        .toList();
    data = DoctorsData(
        upcoming: dummySearchListUpcoming, history: dummySearchListHistory);
    return DoctorsData(
        upcoming: dummySearchListUpcoming, history: dummySearchListHistory);
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
      List<String> bookingId, String slotNumber, String resheduleDate) async {
    try {
      Reshedule resheduleAp = await _helper.resheduleAppointment(
          bookingId, slotNumber, resheduleDate);
      resheduleAppointmentModel = resheduleAp;
      return resheduleAppointmentModel;
    } catch (e) {}
  }
}
