
import 'package:flutter/foundation.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:myfhb/common/CommonUtil.dart';
import 'package:myfhb/constants/fhb_constants.dart';
import 'package:myfhb/constants/fhb_parameters.dart';
import 'package:myfhb/landing/model/membership_detail_response.dart';
import 'package:myfhb/my_providers/bloc/providers_block.dart';
import 'package:myfhb/my_providers/models/Doctors.dart';
import 'package:myfhb/my_providers/models/Hospitals.dart';
import 'package:myfhb/my_providers/models/User.dart';
import 'package:myfhb/ticket_support/model/ticket_types_model.dart';
import 'package:myfhb/ticket_support/services/ticket_service.dart';

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
