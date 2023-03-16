
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:myfhb/common/CommonUtil.dart';
import 'package:myfhb/telehealth/features/appointments/constants/appointments_constants.dart'
    as Constants;
import 'package:myfhb/telehealth/features/appointments/model/fetchAppointments/appointmentsData.dart';
import 'package:myfhb/telehealth/features/appointments/model/fetchAppointments/appointmentsModel.dart';
import 'package:myfhb/telehealth/features/appointments/model/fetchAppointments/past.dart';
import 'package:myfhb/telehealth/features/appointments/model/timeModel.dart';
import 'package:myfhb/telehealth/features/appointments/services/fetch_appointments_service.dart';

enum LoadingStatus {
  completed,
  searching,
  empty,
}

class AppointmentsListViewModel extends ChangeNotifier {
  LoadingStatus loadingStatus = LoadingStatus.searching;
  AppointmentsModel? _appointmentsModel;
  FetchAppointmentsService _fetchAppointmentsService =
      FetchAppointmentsService();

  AppointmentsModel? appointmentsModel;

  AppointmentsListViewModel({AppointmentsModel? appointmentsModel})
      : _appointmentsModel = appointmentsModel;

  AppointmentsModel? get appointments => _appointmentsModel;

  Future<AppointmentsModel?> fetchAppointments() async {
    try {
      this.loadingStatus = LoadingStatus.searching;
      AppointmentsModel appointments =
          await _fetchAppointmentsService.fetchAppointments();
      _appointmentsModel = appointments;
      this.loadingStatus = LoadingStatus.completed;
      notifyListeners();
      return _appointmentsModel;
    } catch (e) {
      this.loadingStatus = LoadingStatus.empty;
      notifyListeners();
    }
  }

  void clearAppointments() {
    _appointmentsModel = null;
    notifyListeners();
  }

  AppointmentsData filterSearchResults(String query) {
    List<Past> dummySearchListUpcoming = <Past>[];
    List<Past> dummySearchListHistory = <Past>[];
    AppointmentsData data = AppointmentsData();
    AppointmentsModel appointments = _appointmentsModel;
    if (appointments.result?.upcoming != null &&
        appointments.result?.upcoming.length > 0) {
      for (Past element in appointments.result?.upcoming) {
        try {
          String name = '';
          name = methodToGetTitle(element);
          if (name?.toLowerCase().trim().contains(query.toLowerCase().trim())) {
            dummySearchListUpcoming.add(element);
          }
        } catch (e) {}
      }
    }

    if (appointments.result?.past != null &&
        appointments.result?.past.length > 0) {
      for (Past element in appointments.result?.past) {
        try {
          String name = '';
          name = methodToGetTitle(element);
          if (name?.toLowerCase().trim().contains(query.toLowerCase().trim())) {
            dummySearchListHistory.add(element);
          }
        } catch (e) {}
      }
    }

    data = AppointmentsData(
        upcoming: dummySearchListUpcoming, past: dummySearchListHistory);
    return AppointmentsData(
        upcoming: dummySearchListUpcoming, past: dummySearchListHistory);
  }

  Time getTimeSlot(String plannedStartDateTime) {
    String hours, min;
    int dys;
    DateTime dob1 = DateFormat(CommonUtil.REGION_CODE == 'IN'
            ? Constants.Appointments_iso_format
            : Constants.Appointments_iso_formatUS)
        .parse(plannedStartDateTime);
    DateTime dob2 = DateFormat(CommonUtil.REGION_CODE == 'IN'
            ? Constants.Appointments_slot_format
            : Constants.Appointments_slot_formatUS)
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
    Time time = Time();
    time.hours = hours;
    time.minutes =
        dur.inHours >= 24 || int.parse(min) <= 0 ? Constants.STATIC_HOUR : min;
    time.daysCount = dys >= 0 ? dys.toString() : Constants.ZERO;
    return time;
  }

  String methodToGetTitle(Past element) {
    String name = "";
    if (element.doctorSessionId == null &&
        element?.healthOrganization != null) {
      name = element?.healthOrganization?.name?.capitalizeFirstofEach != null
          ? element?.healthOrganization?.name?.capitalizeFirstofEach
          : '';
    } else if (element?.additionalinfo?.provider_name != null) {
      name = element?.additionalinfo?.provider_name ?? '';
    } else if (element.doctorSessionId == null &&
        element?.healthOrganization == null) {
      name = element?.additionalinfo?.title ?? '';
    } else if (element.doctorSessionId != null &&
        element?.doctor != null &&
        element?.doctor?.user != null) {
      name = element?.doctor?.user?.firstName != null
          ? element?.doctor?.user?.firstName?.capitalizeFirstofEach +
              ' ' +
              element?.doctor?.user?.lastName?.capitalizeFirstofEach
          : '';
    }

    if (name == '') {
      if (element?.serviceCategory?.code == 'LAB') {
        name = element?.additionalinfo?.lab_name ?? '';
      }
    }

    return name;
  }
}
