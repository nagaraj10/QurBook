class DoctorTimeSlotsModel {
  int status;
  bool success;
  String message;
  Response response;

  DoctorTimeSlotsModel(
      {this.status, this.success, this.message, this.response});

  DoctorTimeSlotsModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    success = json['success'];
    message = json['message'];
    response = json['response'] != null
        ? new Response.fromJson(json['response'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['success'] = this.success;
    data['message'] = this.message;
    if (this.response != null) {
      data['response'] = this.response.toJson();
    }
    return data;
  }
}

class Response {
  int count;
  SessionData data;

  Response({this.count, this.data});

  Response.fromJson(Map<String, dynamic> json) {
    count = json['count'];
    data = json['data'] != null ? new SessionData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['count'] = this.count;
    if (this.data != null) {
      data['data'] = this.data.toJson();
    }
    return data;
  }
}

class SessionData {
  String doctorId;
  String date;
  String day;
  int sessionCounts;
  List<SessionsTime> sessions;

  SessionData({this.doctorId, this.date, this.day, this.sessionCounts, this.sessions});

  SessionData.fromJson(Map<String, dynamic> json) {
    doctorId = json['doctorId'];
    date = json['date'];
    day = json['day'];
    sessionCounts = json['sessionCounts'];
    if (json['sessions'] != null) {
      sessions = new List<SessionsTime>();
      json['sessions'].forEach((v) {
        sessions.add(new SessionsTime.fromJson(v));
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

class SessionsTime {
  String doctorSessionId;
  String sessionStartTime;
  String sessionEndTime;
  int slotCounts;
  List<Slots> slots;

  SessionsTime(
      {this.doctorSessionId,
        this.sessionStartTime,
        this.sessionEndTime,
        this.slotCounts,
        this.slots});

  SessionsTime.fromJson(Map<String, dynamic> json) {
    doctorSessionId = json['doctorSessionId'];
    sessionStartTime = json['sessionStartTime'];
    sessionEndTime = json['sessionEndTime'];
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
    data['slotCounts'] = this.slotCounts;
    if (this.slots != null) {
      data['slots'] = this.slots.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Slots {
  String startTime;
  String endTime;
  bool isAvailable;
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