import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:myfhb/Qurhome/QurhomeDashboard/Api/QurHomeApiProvider.dart';
import 'package:myfhb/Qurhome/QurhomeDashboard/model/CareGiverPatientList.dart';
import 'package:myfhb/Qurhome/QurhomeDashboard/model/patientalertlist/patient_alert_data.dart';
import 'package:myfhb/Qurhome/QurhomeDashboard/model/patientalertlist/patient_alert_list_model.dart';
import 'package:myfhb/src/model/GetDeviceSelectionModel.dart';

import '../../../QurHub/Controller/HubListViewController.dart';
import '../../../common/CommonUtil.dart';
import '../../../common/PreferenceUtil.dart';
import '../../../constants/fhb_constants.dart';
import '../../../constants/fhb_constants.dart' as Constants;
import '../../../src/model/user/MyProfileModel.dart';
import '../../../src/ui/SheelaAI/Controller/SheelaAIController.dart';
import '../../../src/ui/SheelaAI/Services/SheelaAIBLEServices.dart';
import 'package:myfhb/src/resources/repository/health/HealthReportListForUserRepository.dart';


class QurhomeDashboardController extends GetxController {
  var currentSelectedIndex = 0.obs;
  var appBarTitle = ' '.obs;
  late HubListViewController hubController;
  late SheelaBLEController _sheelaBLEController;
  Timer? _bleTimer = null;
  bool isFirstTime = true;
  Timer? _idleTimer = null;

  Timer? get getBleTimer {
    return _bleTimer;
  }
//Adding this code to check if the screen is idle or not
//   Timer? get getIdleTimer {
//     return _idleTimer;
//   }

  SheelaAIController? sheelaAIController =
      CommonUtil().onInitSheelaAIController();
  var isLoading = false.obs;
  var eventId = ''.obs;
  var estart = ''.obs;

  var isVitalModuleDisable = true.obs;
  var isSymptomModuleDisable = true.obs;

  var loadingData = false.obs;
  var forPatientList = false.obs;
  CareGiverPatientListResult? careGiverPatientListResult;
  var currentSelectedTab = 0.obs;
  var isPatientClicked = false.obs;

  var careCoordinatorIdEmptyMsg = "".obs;

  final _apiProvider = QurHomeApiProvider();
  PatientAlertListModel? patientAlert;
  var loadingPatientData = false.obs;

  int nextAlertPosition = 0;
  int currentIndex = 0;
  var isOnceInAPlanActivity = false.obs;
  var isScreenNotIdle = false.obs;
  var isRegimenScreen = false.obs;
  var isShowScreenIdleDialog = false.obs;
  // Observable variable to track the current notification id
  var currentNotificationId = ' '.obs;

  //Define a variable to hold the current selected index for the patient dashboard
  var patientDashboardCurSelectedIndex = 0.obs;

  Rx<bool> isBtnLoading = false.obs;

  @override
  void onInit() {
    if (!Get.isRegistered<SheelaAIController>()) {
      Get.put(SheelaAIController());
    }
    if (!Get.isRegistered<SheelaBLEController>()) {
      Get.put(SheelaBLEController());
    }
    if (!Get.isRegistered<HubListViewController>()) {
      Get.put(HubListViewController());
    }
    _sheelaBLEController = Get.find<SheelaBLEController>();
    getHubDetails();
    // updateBLETimer();
    super.onInit();
  }

  setActiveQurhomeTo({required bool status}) {
    PreferenceUtil.saveIfQurhomeisAcive(
      qurhomeStatus: status,
    );
  }

  setActiveQurhomeDashboardToChat({required bool status}) {
    PreferenceUtil.saveIfQurhomeDashboardActiveChat(
      qurhomeStatus: status,
    );
  }

  @override
  void onClose() {
    // _disableTimer();
    //bleController.stopBleScan();
    updateBLETimer(Enable: false);
    super.onClose();
  }

  updateBLETimer({bool Enable = true}) {
    if (Enable) {
      if (_bleTimer != null) return;
      _bleTimer = Timer.periodic(
          const Duration(
            seconds: 20,
          ), (time) async {
        if (Get.find<SheelaAIController>().isSheelaScreenActive) {
          return;
        }
        _sheelaBLEController.stopScanning();
        await Future.delayed(const Duration(seconds: 2));
        _sheelaBLEController.setupListenerForReadings();
      });
    } else {
      _sheelaBLEController.stopTTS();
      _bleTimer?.cancel();
      _bleTimer = null;
    }
  }
  void resetScreenIdleTimer() {
    // isShowScreenIdleDialog.value=false;
    isScreenNotIdle.value = false; // Reset the screen idle flag
    _idleTimer?.cancel(); // Cancel existing idle timer
    if(isRegimenScreen.value) {
      checkScreenIdle(); // Restart the timer
    }
  }


//Function to check qur home is ideal for 5 minutes
  Future<void> checkScreenIdle() async {
    _idleTimer = Timer.periodic(const Duration(minutes: 5), (timer) {
      try {
        if (!isScreenNotIdle.value) {
          isScreenNotIdle.value = true;
          sheelaAIController?.getSheelaBadgeCountForIdeal(
            isFromQurHomeRegimen: true,
            makeApiRequest: true,
            isNeedSheelaDialog: true,
          );
        }
        timer.cancel(); // Cancel the timer after it triggers once
      } catch (e, stackTrace) {
        CommonUtil().appLogs(message: e, stackTrace: stackTrace);
        if (kDebugMode) {
          print(e);
        }
      }
    });
  }

  getHubDetails() async {
    hubController = Get.find<HubListViewController>();
    await hubController.getHubList();
  }

  void updateTabIndex(int newIndex) {
    currentSelectedIndex.value = newIndex;
    MyProfileModel myProfile;
    String firstName = '';
    try {
      myProfile = PreferenceUtil.getProfileData(Constants.KEY_PROFILE)!;
      firstName = myProfile.result != null
          ? myProfile.result!.firstName!.capitalizeFirstofEach
          : '';
    } catch (e, stackTrace) {
      CommonUtil().appLogs(message: e, stackTrace: stackTrace);
    }

    switch (currentSelectedIndex.value) {
      case 0:
        appBarTitle = '$firstName'.obs;
        updateBLETimer();
        break;
      case 1:
        appBarTitle = '$firstName'.obs;
        updateBLETimer();
        break;
      case 2:
        appBarTitle = 'Vitals'.obs;
        isRegimenScreen.value = false;
        updateBLETimer(Enable: false);
        break;
      case 3:
        appBarTitle = 'Symptoms'.obs;
        isRegimenScreen.value = false;
        updateBLETimer(Enable: false);
        break;
    }
  }

  updateModuleAccess(List<SelectionResult> selectionResult) {
    try {
      for (var i = 0; i < selectionResult.length; i++) {
        if (selectionResult[i].primaryProvider != null) {
          if (selectionResult[i].primaryProvider?.additionalInfo != null) {
            if (selectionResult[i]
                    .primaryProvider
                    ?.additionalInfo
                    ?.moduleAccess !=
                null) {
              enableModuleAccess();
              for (var j = 0;
                  j <
                      selectionResult[i]
                          .primaryProvider!
                          .additionalInfo!
                          .moduleAccess!
                          .length;
                  j++) {
                var isAccess = selectionResult[i]
                        .primaryProvider!
                        .additionalInfo!
                        .moduleAccess![j]
                        .name ??
                    '';
                if (isAccess == strVitalsModule) {
                  isVitalModuleDisable.value = false;
                }
                if (isAccess == strSymptomsModule) {
                  isSymptomModuleDisable.value = false;
                }
              }
            }
          }
        }
      }
    } catch (e, stackTrace) {
      CommonUtil().appLogs(message: e, stackTrace: stackTrace);
    }
  }

  getModuleAccess() async {
    if (CommonUtil.isUSRegion()) {
      HealthReportListForUserRepository healthReportListForUserRepository =
          HealthReportListForUserRepository();
      await healthReportListForUserRepository
          .getDeviceSelection()
          .then((value) {
        GetDeviceSelectionModel? selectionResult = value;
        if (selectionResult!.isSuccess!) {
          if (selectionResult?.result != null) {
            updateModuleAccess(selectionResult!.result!);
          }
          sheelaAIController?.isAllowSheelaLiveReminders = (selectionResult!
                          .result![0].profileSetting!.sheelaLiveReminders !=
                      null &&
                  selectionResult!
                          .result![0].profileSetting!.sheelaLiveReminders !=
                      '')
              ? selectionResult!
                      .result![0].profileSetting!.sheelaLiveReminders ??
                  true
              : true;
          print('----------isAllowBoolQurhome: ' +
              (sheelaAIController?.isAllowSheelaLiveReminders ?? true)
                  .toString());
        }
      });
    }
  }

  enableModuleAccess() {
    if (CommonUtil.isUSRegion()) {
      isVitalModuleDisable.value = true;
      isSymptomModuleDisable.value = true;
    }
  }

  getPatientAlertList() async {
    loadingPatientData.value = true;
    patientAlert = await _apiProvider
        .getPatientAlertList(careGiverPatientListResult?.childId ?? '');
    loadingPatientData.value = false;

    if (patientAlert != null &&
        patientAlert?.result != null &&
        patientAlert?.result?.data != null &&
        (patientAlert?.isSuccess ?? false)) {
      try {
        patientAlert?.result?.data?.sort((a, b) =>
            (b?.createdOn?.compareTo(a?.createdOn ?? DateTime.now()) ?? 0));

        update(["newUpdate"]);
      } catch (e, stackTrace) {
        CommonUtil().appLogs(message: e, stackTrace: stackTrace);

        return;
      }
    } else {
      return;
    }
  }

  clear() {
    loadingData = false.obs;
    forPatientList = false.obs;
    careGiverPatientListResult = null;
    currentSelectedTab = 0.obs;
    isPatientClicked = false.obs;

    careCoordinatorIdEmptyMsg = "".obs;

    patientAlert = null;
    loadingPatientData = false.obs;

    nextAlertPosition = 0;
    currentIndex = 0;
    patientDashboardCurSelectedIndex.value = 0;
  }

  Future<bool> careGiverOkAction(
      CareGiverPatientListResult? careGiverPatientListResult,
      PatientAlertData patientAlertData) async {
    try {
      loadingPatientData.value = true;
      var responseBool = await _apiProvider.careGiverOKAction(
          careGiverPatientListResult, patientAlertData);
      loadingPatientData.value = false;
      return responseBool;
    } catch (e, stackTrace) {
      CommonUtil().appLogs(message: e, stackTrace: stackTrace);

      return false;
    }
  }

  Future<bool> caregiverEscalateAction(PatientAlertData patientAlertData,
      String activityName, bool escalateValue,
      {String? notes}) async {
    try {
      loadingPatientData.value = true;
      var responseBool = await _apiProvider.careGiverEscalateAction(
          patientAlertData,
          careGiverPatientListResult,
          activityName,
          patientAlert?.result?.healthOrganizationId ?? '',
          escalateValue,
          notes: notes);
      loadingPatientData.value = false;
      return responseBool;
    } catch (e, stackTrace) {
      CommonUtil().appLogs(message: e, stackTrace: stackTrace);

      return false;
    }
  }
}
