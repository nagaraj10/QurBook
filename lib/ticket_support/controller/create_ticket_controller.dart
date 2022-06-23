import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/get.dart';
import 'package:myfhb/common/CommonUtil.dart';
import 'package:myfhb/my_providers/bloc/providers_block.dart';
import 'package:myfhb/my_providers/models/Hospitals.dart';

class CreateTicketController extends GetxController {
  List<Hospitals> labsList = [];
  ProvidersBloc _providersBloc;
  var isCTLoading = false.obs;
  var isPreferredLabDisable = false.obs;
  var labBookAppointment = false.obs;
  var selPrefLab = "Select".obs;
  var selPrefLabId = "".obs;

  @override
  void onClose() {
    try {
      super.onClose();
    } catch (e) {
      print(e);
    }
  }

  @override
  void onInit() {
    try {
      super.onInit();
    } catch (e) {
      print(e);
    }
  }

  getLabList({bool updateLab=false}) {
    try {
      if(!updateLab){
      _providersBloc = ProvidersBloc();
      isCTLoading.value = true;

      _providersBloc.getMedicalPreferencesForHospital().then((value) {
        isCTLoading.value = false;
        if (value != null &&
            value.result != null &&
            value.result.labs != null &&
            value.result.labs.isNotEmpty) {
          labsList = value.result.labs;
          labsList.sort((a, b) => CommonUtil()
              .validString(a.name.toString())
              .toLowerCase()
              .compareTo(
                  CommonUtil().validString(b.name.toString()).toLowerCase()));
          labsList.insert(0, new Hospitals(name: 'Select'));
          isPreferredLabDisable.value = false;
        } else {
          labsList = [];
          labsList.insert(0, new Hospitals(name: 'Select'));
          isPreferredLabDisable.value = true;
        }
      });
      }else{

      }
    } catch (e) {
      labsList = [];
      labsList.insert(0, new Hospitals(name: 'Select'));
      isCTLoading.value = false;
      isPreferredLabDisable.value = true;
    }
  }
}
