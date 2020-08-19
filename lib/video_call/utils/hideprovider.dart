import 'package:flutter/material.dart';

class HideProvider extends ChangeNotifier {
  bool isControlStatus = true;

  void hideMe() {
    isControlStatus = false;
    notifyListeners();
  }

  void showMe() {
    isControlStatus = true;
    notifyListeners();
  }
}
