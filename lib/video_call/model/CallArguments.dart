import 'package:agora_rtc_engine/agora_rtc_engine.dart';

class CallArguments {
  String channelName;
  ClientRole role;
  bool isAppExists;

  CallArguments({this.channelName, this.role, this.isAppExists});
}
