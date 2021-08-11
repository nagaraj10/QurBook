import 'package:flutter/material.dart';

class VideoIconProvider extends ChangeNotifier {
  bool isVideoOn = false;

  void turnOnVideo() {
    isVideoOn = true;
    notifyListeners();
  }

  void turnOffVideo() {
    isVideoOn = false;
    notifyListeners();
  }

  void swapVideo() {
    isVideoOn = !isVideoOn;
    notifyListeners();
  }
}
