import 'package:flutter/material.dart';

class HideProvider extends ChangeNotifier {
  bool isControlStatus = true;
  int isAudioSwitchToVideo = -1;

  void hideMe() {
    isControlStatus = false;
    notifyListeners();
  }

  void showMe() {
    isControlStatus = true;
    notifyListeners();
  }

  void swithToVideo() {
    isAudioSwitchToVideo = 1;
    notifyListeners();
  }

  void swithToAudio() {
    isAudioSwitchToVideo = 0;
    notifyListeners();
  }
}
