import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/get.dart';
import 'package:myfhb/common/CommonUtil.dart';
import 'package:myfhb/my_providers/bloc/providers_block.dart';
import 'package:myfhb/my_providers/models/Doctors.dart';
import 'package:myfhb/my_providers/models/Hospitals.dart';
import 'package:myfhb/my_providers/models/User.dart';
import 'package:myfhb/ticket_support/model/ticket_types_model.dart';

class CreateTicketController extends GetxController {
  List<Hospitals> labsList = [];
  List<Hospitals> hospitalList = [];
  List<Doctors> doctorsList = [];

  ProvidersBloc _providersBloc;
  var isCTLoading = false.obs;
  var isPreferredLabDisable = false.obs;
  var labBookAppointment = false.obs;
  var selPrefLab = "Select".obs;
  var selPrefLabId = "".obs;

  var isPreferredDoctorDisable = false.obs;
  var doctorBookAppointment = false.obs;
  var selPrefDoctor = "Select".obs;
  var selPrefDoctorId = "".obs;

  //List<FieldData> modeOfServiceList = [];
  var dynamicTextFiledObj  = {};

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

  getLabList({bool updateLab = false}) {
    try {
      if (!updateLab) {
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
      } else {}
    } catch (e) {
      labsList = [];
      labsList.insert(0, new Hospitals(name: 'Select'));
      isCTLoading.value = false;
      isPreferredLabDisable.value = true;
    }
  }

  getDoctorList({bool updateDoctor = false}) {
    try {
      if (!updateDoctor) {
        _providersBloc = ProvidersBloc();
        isCTLoading.value = true;

        _providersBloc.getMedicalPreferencesForDoctors().then((value) {
          isCTLoading.value = false;
          if (value != null &&
              value.result != null &&
              value.result.doctors != null &&
              value.result.doctors.isNotEmpty) {
            doctorsList = value.result.doctors;
            doctorsList.sort((a, b) => CommonUtil()
                .validString(a.user.name.toString())
                .toLowerCase()
                .compareTo(CommonUtil()
                    .validString(b.user.name.toString())
                    .toLowerCase()));
            // ignore: unnecessary_new
            doctorsList.insert(0, new Doctors(user: User(name: 'Select')));
            isPreferredDoctorDisable.value = false;
          } else {
            doctorsList = [];
            doctorsList.insert(0, new Doctors(user: User(name: 'Select')));
            isPreferredDoctorDisable.value = true;
          }
        });
      } else {}
    } catch (e) {
      doctorsList = [];
      doctorsList.insert(0, new Doctors(user: User(name: 'Select')));
      isCTLoading.value = false;
      isPreferredDoctorDisable.value = true;
    }
  }
}
