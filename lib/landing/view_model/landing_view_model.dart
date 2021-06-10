import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:myfhb/common/CommonUtil.dart';
import 'package:myfhb/constants/fhb_constants.dart' as constants;

class LandingViewModel extends ChangeNotifier {
  Color primaryColor = Color(CommonUtil().getMyPrimaryColor());
  int currentTabIndex = 0;
  var appBarTitle = constants.strMyDashboard;
  bool isSearchVisible = false;

  void changeSearchBar({bool isEnabled = false, bool needNotify = true}) {
    isSearchVisible = isEnabled;
    if (needNotify) {
      notifyListeners();
    }
  }

  void updateTabIndex(int newIndex) {
    currentTabIndex = newIndex;
    changeSearchBar(needNotify: false);
    switch (currentTabIndex) {
      case 1:
        appBarTitle = constants.CHAT;
        break;
      case 2:
        appBarTitle = constants.strSheelaG;
        break;
      case 3:
        appBarTitle = constants.strAppointment;
        break;
      case 4:
        appBarTitle = constants.RECORDS_TITLE;
        break;
      default:
        appBarTitle = constants.strMyDashboard;
        break;
    }
    notifyListeners();
  }

  void updatePrimaryColor() {
    primaryColor = Color(CommonUtil().getMyPrimaryColor());
    notifyListeners();
  }
}
