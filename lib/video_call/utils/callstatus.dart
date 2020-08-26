import 'package:flutter/material.dart';

class CallStatus extends ChangeNotifier {
  bool isCallAlive = false;

  void startCall() {
    isCallAlive = true;
    notifyListeners();
  }

  void enCall() {
    isCallAlive = false;
    notifyListeners();
  }
}
