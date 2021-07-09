import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:myfhb/myPlan/model/myPlanListModel.dart';

class PlanWizardViewModel extends ChangeNotifier {
  final PageController pageController = PageController();
  int currentPage = 0;
  List<MyPlanListResult> carePlanList = [];
  List<MyPlanListResult> dietPlanList = [];
  List<MyPlanListResult> cartItemsList = [];

  void changeCurrentPage(int newPage) {
    currentPage = newPage;
    notifyListeners();
  }

  void addCarePlan(MyPlanListResult newPlan) {
    carePlanList.clear();
    carePlanList.add(newPlan);
    updateCart();
  }

  void addDietPlan(MyPlanListResult newPlan) {
    dietPlanList.clear();
    dietPlanList.add(newPlan);
    updateCart();
  }

  void updateCart() {
    cartItemsList.clear();
    cartItemsList.addAll(carePlanList);
    cartItemsList.addAll(dietPlanList);
    notifyListeners();
  }
}
