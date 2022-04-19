import 'package:get/get_state_manager/get_state_manager.dart';

class QurhomeDashboardController extends GetxController {
  var currentSelectedIndex = 0;

  void pageChanged(int index) {
      currentSelectedIndex = index;
  }

}
