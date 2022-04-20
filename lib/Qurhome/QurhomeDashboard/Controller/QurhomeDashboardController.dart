import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/get.dart';

class QurhomeDashboardController extends GetxController {
  var currentSelectedIndex = 0.obs;
  var appBarTitle = 'Hello User'.obs;


  void updateTabIndex(int newIndex) {
    currentSelectedIndex.value = newIndex;
    switch (currentSelectedIndex.value) {
      case 0:
        appBarTitle = 'Hello User'.obs;
        break;
      case 1:
        appBarTitle = 'Hello User'.obs;
        break;
      case 2:
        appBarTitle = 'Vitals'.obs;
        break;
      case 3:
        appBarTitle = 'Symptoms'.obs;
        break;
    }
  }

}
