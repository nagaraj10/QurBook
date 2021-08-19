import 'package:flutter/material.dart';

class AudioCallProvider extends ChangeNotifier {
  bool isAudioCall = false;

  void enableAudioCall() {
    isAudioCall = true;
    notifyListeners();
  }

  void disableAudioCall() {
    isAudioCall = false;
    notifyListeners();
  }
}
