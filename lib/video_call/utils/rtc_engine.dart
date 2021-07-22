import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:flutter/material.dart';
import 'package:myfhb/video_call/utils/settings.dart';

class RTCEngineProvider extends ChangeNotifier {
  RtcEngine _rtcEngine = null;
  bool isVideoPaused = false;

  RtcEngine get rtcEngine {
    if (_rtcEngine == null) {
      startEngine();
      Future.delayed(Duration(seconds: 1), () {
        return _rtcEngine;
      });
    } else {
      return _rtcEngine;
    }
  }

  Future<RtcEngine> startEngine() async {
    _rtcEngine = await RtcEngine.create(APP_ID);
    //notifyListeners();
  }

  void stopEngine() {
    _rtcEngine.leaveChannel();
    _rtcEngine.destroy();
    //notifyListeners();
  }

  void changeLocalVideoStatus(bool value) {
    isVideoPaused = value;
    notifyListeners();
  }
}
