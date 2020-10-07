import 'package:myfhb/telehealth/features/appointments/constants/appointments_parameters.dart'as parameters;
import 'package:myfhb/telehealth/features/appointments/model/fetchAppointments/past.dart';

class AppointmentsData {
  AppointmentsData({
    this.upcoming,
    this.past,
  });

  List<Past> upcoming;
  List<Past> past;

  AppointmentsData.fromJson(Map<String, dynamic> json) {
    upcoming = json[parameters.strUpcoming] == null
        ? null
        : List<Past>.from(
            json[parameters.strUpcoming].map((x) => Past.fromJson(x)));
    past = json[parameters.strPast] == null
        ? null
        : List<Past>.from(
            json[parameters.strPast].map((x) => Past.fromJson(x)));
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data[parameters.strUpcoming] =
        List<dynamic>.from(upcoming.map((x) => x.toJson()));
    data[parameters.strPast] = List<dynamic>.from(past.map((x) => x));

    return data;
  }
}
