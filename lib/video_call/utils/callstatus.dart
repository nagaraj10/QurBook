import 'package:flutter/material.dart';

class CallStatus extends ChangeNotifier {
  bool isCallAlive = false;

  void startCall() {
    isCallAlive = true;
    print('is My Call alive $isCallAlive');
    notifyListeners();
  }

  void enCall() {
    isCallAlive = false;
    print('is My Call alive $isCallAlive');
    notifyListeners();
  }
}
