import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:myfhb/telehealth/features/appointments/constants/appointments_constants.dart' as Constants;
import 'package:myfhb/telehealth/features/appointments/model/fetchAppointments/appointmentsData.dart';
import 'package:myfhb/telehealth/features/appointments/model/fetchAppointments/appointmentsModel.dart';
import 'package:myfhb/telehealth/features/appointments/model/fetchAppointments/past.dart';
import 'package:myfhb/telehealth/features/appointments/model/timeModel.dart';
import 'package:myfhb/telehealth/features/appointments/services/fetch_appointments_service.dart';

class AppointmentsListViewModel extends ChangeNotifier {
  AppointmentsModel _appointmentsModel;
  FetchAppointmentsService _fetchAppointmentsService=FetchAppointmentsService();

  AppointmentsModel appointmentsModel;

  AppointmentsListViewModel({AppointmentsModel appointmentsModel})
      : _appointmentsModel = appointmentsModel;

  AppointmentsModel get appointments => _appointmentsModel;

  Future<AppointmentsModel> fetchAppointments() async {
    try {
      _appointmentsModel = await _fetchAppointmentsService.fetchAppointments();
      notifyListeners();
      return _appointmentsModel;
    } catch (e) {}
  }

  void clearAppointments() {
    _appointmentsModel = null;
    notifyListeners();
  }

  AppointmentsData filterSearchResults(String query) {
    List<Past> dummySearchListUpcoming = List<Past>();
    List<Past> dummySearchListHistory = List<Past>();
    AppointmentsData data = AppointmentsData();
    AppointmentsModel appointments = _appointmentsModel;
    dummySearchListUpcoming = appointments.result.upcoming
        .where((element) =>
            element.doctor.user.firstName
                .toLowerCase()
                .trim()
                .contains(query.toLowerCase().trim()) ||
            element.doctor.user.lastName
                .toLowerCase()
                .trim()
                .contains(query.toLowerCase().trim()))
        .toList();

    dummySearchListHistory = appointments.result.past
        .where((element) =>
            element.doctor.user.firstName
                .toLowerCase()
                .trim()
                .contains(query.toLowerCase().trim()) ||
            element.doctor.user.lastName
                .toLowerCase()
                .trim()
                .contains(query.toLowerCase().trim()))
        .toList();
    data = AppointmentsData(
        upcoming: dummySearchListUpcoming, past: dummySearchListHistory);
    return AppointmentsData(
        upcoming: dummySearchListUpcoming, past: dummySearchListHistory);
  }

  Time getTimeSlot(String plannedStartDateTime) {
    String hours, min;
    int dys;
    DateTime dob1 = DateFormat(Constants.Appointments_iso_format)
        .parse(plannedStartDateTime);
    DateTime dob2 = DateFormat(Constants.Appointments_slot_format)
        .parse('${DateTime.now()}');
    Duration dur = dob1.difference(dob2);
    dys = dur.inDays;
    hours = dur.inHours >= 0 && dur.inHours <= 24
        ? (dur.inHours.remainder(24))
            .round()
            .toString()
            .padLeft(2, Constants.ZERO)
        : Constants.STATIC_HOUR;
    min = dur.inHours >= 0 && dur.inHours <= 24
        ? (dur.inMinutes.remainder(60)).toString().padLeft(2, Constants.ZERO)
        : Constants.STATIC_HOUR;
    Time time=Time();
    time.hours = hours;
    time.minutes =
        dur.inHours >= 24 || int.parse(min) <= 0 ? Constants.STATIC_HOUR : min;
    time.daysCount = dys >= 0 ? dys.toString() : Constants.ZERO;
    return time;
  }
}
