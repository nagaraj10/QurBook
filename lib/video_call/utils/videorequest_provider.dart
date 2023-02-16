import 'package:flutter/material.dart';

class VideoRequestProvider extends ChangeNotifier {
  bool isRequestPromptShown = false;
  bool isVideoOn = false;

  void showRequestPrompt() {
    isRequestPromptShown = true;
    notifyListeners();
  }

  void hideRequestPrompt() {
    isRequestPromptShown = false;
    notifyListeners();
  }
}
