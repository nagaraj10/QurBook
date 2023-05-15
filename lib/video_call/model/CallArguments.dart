import 'package:agora_rtc_engine/rtc_engine.dart';

class CallArguments {
  String? channelName;
  String? userName;
  ClientRole? role;
  String? doctorId;
  bool? isAppExists;
  String? doctorName;
  String? doctorPicture;
  String? patientId;
  String? patientName;
  String? patientPicture;

  String? meetingId;
  bool? isWeb;
  CallArguments({
    this.channelName,
    this.userName,
    this.role,
    this.doctorId,
    this.isAppExists,
    this.doctorPicture,
    this.patientId,
    this.patientName,
    this.patientPicture,
    this.meetingId,
    this.doctorName,
    this.isWeb,
  });
}
