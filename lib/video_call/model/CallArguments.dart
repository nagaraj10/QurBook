import 'package:agora_rtc_engine/agora_rtc_engine.dart';

class CallArguments {
  String channelName;
  String userName;
  ClientRole role;
  String doctorId;
  bool isAppExists;

  CallArguments(
      {this.channelName,
      this.userName,
      this.role,
      this.doctorId,
      this.isAppExists});
}
