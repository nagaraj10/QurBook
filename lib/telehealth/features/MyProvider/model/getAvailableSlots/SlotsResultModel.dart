import 'package:myfhb/telehealth/features/MyProvider/model/getAvailableSlots/SlotSessionsModel.dart';

class SlotsResultModel {
  String doctorId;
  String date;
  String day;
  int sessionCounts;
  List<SlotSessionsModel> sessions;

  SlotsResultModel(
      {this.doctorId, this.date, this.day, this.sessionCounts, this.sessions});

  SlotsResultModel.fromJson(Map<String, dynamic> json) {
    doctorId = json['doctorId'];
    date = json['date'];
    day = json['day'];
    sessionCounts = json['sessionCounts'];
    if (json['sessions'] != null) {
      sessions = new List<SlotSessionsModel>();
      json['sessions'].forEach((v) {
        sessions.add(new SlotSessionsModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['doctorId'] = this.doctorId;
    data['date'] = this.date;
    data['day'] = this.day;
    data['sessionCounts'] = this.sessionCounts;
    if (this.sessions != null) {
      data['sessions'] = this.sessions.map((v) => v.toJson()).toList();
    }
    return data;
  }
}