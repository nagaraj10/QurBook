
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/get.dart';

import '../../constants/fhb_constants.dart' as constants;

class LandingScreenController extends GetxController {

  var isSearchVisible = false.obs;
  var appBarTitle = constants.strMyDashboard.obs;
  var currentTabIndex = 0.obs;


  void changeSearchBar({bool isEnabled = false, bool needNotify = true}) {
    isSearchVisible.value = isEnabled;
    /*if (needNotify) {
      notifyListeners();
    }*/
  }

  void updateTabIndex(int newIndex) {
    currentTabIndex.value = newIndex;
    changeSearchBar(needNotify: false);
    switch (currentTabIndex.value) {
      case 1:
        appBarTitle.value = constants.CHAT;
        break;
      case 2:
        appBarTitle.value = constants.strSheelaG;
        break;
      case 3:
        appBarTitle.value = constants.strAppointment;
        break;
      case 4:
        appBarTitle.value = constants.RECORDS_TITLE;
        break;
      default:
        appBarTitle.value = constants.strMyDashboard;
        break;
    }
  }
}