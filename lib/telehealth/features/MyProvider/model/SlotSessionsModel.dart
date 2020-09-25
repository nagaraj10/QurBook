class SlotSessionsModel {
  String doctorSessionId;
  String sessionStartTime;
  String sessionEndTime;
  int duration;
  List<WeekdayPreference> weekdayPreference;
  bool isEnabled;
  bool isActive;
  int slotCounts;
  List<Slots> slots;

  SlotSessionsModel(
      {this.doctorSessionId,
        this.sessionStartTime,
        this.sessionEndTime,
        this.duration,
        this.weekdayPreference,
        this.isEnabled,
        this.isActive,
        this.slotCounts,
        this.slots});

  SlotSessionsModel.fromJson(Map<String, dynamic> json) {
    doctorSessionId = json['doctorSessionId'];
    sessionStartTime = json['sessionStartTime'];
    sessionEndTime = json['sessionEndTime'];
    duration = json['duration'];
    if (json['weekdayPreference'] != null) {
      weekdayPreference = new List<WeekdayPreference>();
      json['weekdayPreference'].forEach((v) {
        weekdayPreference.add(new WeekdayPreference.fromJson(v));
      });
    }
    isEnabled = json['isEnabled'];
    isActive = json['isActive'];
    slotCounts = json['slotCounts'];
    if (json['slots'] != null) {
      slots = new List<Slots>();
      json['slots'].forEach((v) {
        slots.add(new Slots.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['doctorSessionId'] = this.doctorSessionId;
    data['sessionStartTime'] = this.sessionStartTime;
    data['sessionEndTime'] = this.sessionEndTime;
    data['duration'] = this.duration;
    if (this.weekdayPreference != null) {
      data['weekdayPreference'] =
          this.weekdayPreference.map((v) => v.toJson()).toList();
    }
    data['isEnabled'] = this.isEnabled;
    data['isActive'] = this.isActive;
    data['slotCounts'] = this.slotCounts;
    if (this.slots != null) {
      data['slots'] = this.slots.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class WeekdayPreference {
  String day;
  bool isAvailable;

  WeekdayPreference({this.day, this.isAvailable});

  WeekdayPreference.fromJson(Map<String, dynamic> json) {
    day = json['Day'];
    isAvailable = json['isAvailable'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Day'] = this.day;
    data['isAvailable'] = this.isAvailable;
    return data;
  }
}

class Slots {
  String startTime;
  String endTime;
  String isAvailable;
  int slotNumber;

  Slots({this.startTime, this.endTime, this.isAvailable, this.slotNumber});

  Slots.fromJson(Map<String, dynamic> json) {
    startTime = json['startTime'];
    endTime = json['endTime'];
    isAvailable = json['isAvailable'];
    slotNumber = json['slotNumber'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['startTime'] = this.startTime;
    data['endTime'] = this.endTime;
    data['isAvailable'] = this.isAvailable;
    data['slotNumber'] = this.slotNumber;
    return data;
  }
}