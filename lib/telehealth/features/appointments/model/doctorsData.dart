import 'historyModel.dart';
import 'package:myfhb/constants/fhb_parameters.dart' as parameters;

class DoctorsData {
  DoctorsData({
    this.history,
    this.upcoming,
  });

  List<History> history;
  List<History> upcoming;

  DoctorsData.fromJson(Map<String, dynamic> json) {
    history = json[parameters.strHistory] != null
        ? List<History>.from(
            json[parameters.strHistory].map((x) => History.fromJson(x)))
        : null;
    upcoming = json[parameters.strUpcoming] != null
        ? List<History>.from(
            json[parameters.strUpcoming].map((x) => History.fromJson(x)))
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.history != null) {
      data[parameters.strHistory] =
          List<dynamic>.from(history.map((x) => x.toJson()));
    }
    if (this.upcoming != null) {
      data[parameters.strUpcoming] =
          List<dynamic>.from(upcoming.map((x) => x.toJson()));
    }
    return data;
  }
}
