import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class PlanWizardViewModel extends ChangeNotifier {
  final PageController pageController = PageController();
  int currentPage = 0;

  void changeCurrentPage(int newPage) {
    currentPage = newPage;
    notifyListeners();
  }
}
