import 'package:agora_rtc_engine/rtc_engine.dart';

class CallArguments {
  String channelName;
  String userName;
  ClientRole role;
  String doctorId;
  bool isAppExists;

  String doctorPicture;
  String meetingId;

  CallArguments(
      {this.channelName,
      this.userName,
      this.role,
      this.doctorId,
      this.isAppExists,
      this.doctorPicture,
      this.meetingId});
}
