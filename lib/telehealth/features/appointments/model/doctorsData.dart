import 'historyModel.dart';

class DoctorsData {
  DoctorsData({
    this.history,
    this.upcoming,
  });

  List<History> history;
  List<History> upcoming;

  DoctorsData.fromJson(Map<String, dynamic> json) {
    history = json["history"] != null
        ? List<History>.from(json["history"].map((x) => History.fromJson(x)))
        : null;
    upcoming = json["upcoming"]!=null
        ? List<History>.from(json["upcoming"].map((x) => History.fromJson(x)))
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.history != null) {
      data["history"] = List<dynamic>.from(history.map((x) => x.toJson()));
    }
    if (this.upcoming != null) {
      data["upcoming"] = List<dynamic>.from(upcoming.map((x) => x.toJson()));
    }
    return data;
  }
}