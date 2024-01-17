import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:myfhb/Qurhome/QurhomeDashboard/Api/QurHomeApiProvider.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:myfhb/Qurhome/QurhomeDashboard/model/carecoordinatordata.dart';
import 'package:myfhb/Qurhome/QurhomeDashboard/model/errorAppLogDataModel.dart';
import 'package:myfhb/Qurhome/QurhomeDashboard/model/location_data_model.dart';
import 'package:myfhb/Qurhome/QurhomeDashboard/model/soscallagentnumberdata.dart';
import 'package:myfhb/authentication/constants/constants.dart';
import 'package:myfhb/common/PreferenceUtil.dart';
import 'package:myfhb/constants/fhb_constants.dart';
import 'package:myfhb/constants/variable_constant.dart';
import 'package:myfhb/regiment/models/regiment_data_model.dart';
import 'package:myfhb/regiment/models/regiment_response_model.dart';
import 'package:myfhb/common/CommonUtil.dart';
import 'package:gmiwidgetspackage/widgets/flutterToast.dart';
import 'package:flutter/material.dart';
import 'package:myfhb/src/model/user/MyProfileModel.dart';
import 'package:myfhb/src/ui/SheelaAI/Controller/SheelaAIController.dart';
import 'package:myfhb/video_call/utils/audiocall_provider.dart';
import 'package:provider/provider.dart';
import '../../../../constants/fhb_constants.dart' as constants;

class QurhomeRegimenController extends GetxController {
  final _apiProvider = QurHomeApiProvider();
  var loadingData = false.obs;
  var loadingDataWithoutProgress = false.obs;
  var loadingCalendar = false.obs;

  // QurHomeRegimenResponseModel qurHomeRegimenResponseModel;
  RegimentResponseModel? qurHomeRegimenResponseModel;
  RegimentResponseModel? qurHomeRegimenCalendarResponseModel;
  int nextRegimenPosition = 0;
  int currentIndex = 0;

  var timerProgress = 1.0.obs;
  var isShowTimerDialog = true.obs;

  var careCoordinatorId = "".obs;
  var careCoordinatorName = "".obs;
  var isFromSOS = true.obs;
  var careCoordinatorIdEmptyMsg = "".obs;
  var userName = "".obs;
  var userId = "".obs;
  var userProfilePic = "".obs;
  var userDOB = "".obs;
  var userMobNo = "".obs;
  var onGoingSOSCall = false.obs;
  var resultId = "".obs;
  var callStartTime = "".obs;
  var meetingId = "".obs;
  var UID = "".obs;
  var resourceId = "".obs;
  var sid = "".obs;
  //var isSIMInserted = false.obs;
  var isSOSAgentCallDialogOpen = false.obs;
  var isTodaySelected = false.obs;
  var SOSAgentNumber = "".obs;
  var statusText = "".obs;
  var SOSAgentNumberEmptyMsg = "".obs;
  var currLoggedEID = "".obs;

  var dateHeader = "".obs;
  var selectedDate = DateTime.now().obs;
  var selectedCalendar = DateTime.now().obs;
  static MyProfileModel prof =
      PreferenceUtil.getProfileData(constants.KEY_PROFILE)!;
  List<DateTime?> remainderTimestamps = [];

  Location? locationModel;
  var qurhomeDashboardController =
      CommonUtil().onInitQurhomeDashboardController();

  var isFirstTime = true.obs;

  var isShowSOSButton = false.obs;

  Rx<bool> isErrorAppLogDialogShowing = false.obs;
  List<ErrorAppLogDataModel>? errorAppLogList = [];
  Timer? remainderQueueTimer;
  Timer? evryOneMinuteRemainder;
  Timer? updateUITimer;

  startUpdateUITimer() {
    updateUITimer = Timer.periodic(const Duration(seconds: 30), (timer) async {
      var regimentList = qurHomeRegimenResponseModel?.regimentsList ?? [];
      loadingDataWithoutProgress.value = true;
      loadingData.value = true;
      await Future.delayed(Duration(seconds: 2));
      await refreshTheNextActivity(regimentList,null);
      loadingData.value = false;
      loadingDataWithoutProgress.value = false;
    });
  }

  getRegimenList({
    bool isLoading = true,
    String? date,
    String? patientId,
  }) async {
    try {
      if (!isLoading) {
        loadingDataWithoutProgress.value = true;
      }
      if (date != null) {
        dateHeader.value = getFormatedDate(date: date);
      } else {
        date = '';
      }
      loadingData.value = true;
      qurHomeRegimenResponseModel =
          await _apiProvider.getRegimenList(date, patientId: patientId);
      var regimentList = qurHomeRegimenResponseModel?.regimentsList ?? [];
      refreshTheNextActivity(regimentList, patientId);
      loadingData.value = false;
    } catch (e, stackTrace) {
      CommonUtil().appLogs(message: e, stackTrace: stackTrace);
      loadingData.value = false;
      if (kDebugMode) {
        printError(info: "Regimentlist: " + e.toString());
      }
    }
  }

  refreshTheNextActivity(List<RegimentDataModel> regimentList, var userId) {
    if (regimentList.length > 0) {
      regimentList.removeWhere((element) {
        bool isOnceInplan = element.dayrepeat?.trim().toLowerCase() ==
            strText.trim().toLowerCase();
        return element.isEventDisabled && !element.isSymptom ||
            !element.scheduled && !isOnceInplan;
      });
      bool allActivitiesCompleted = true;
      statusText.value =
          "${stringViewTotalNumberOfActivites} ${regimentList.length}";
      for (int i = 0; i < regimentList.length; i++) {
        String strCurrLoggedEID = CommonUtil().validString(currLoggedEID.value);
        String strCurrRegimenEID =
            CommonUtil().validString(regimentList[i].eid ?? "");
        if (strCurrLoggedEID.trim().isNotEmpty &&
            strCurrLoggedEID.contains(strCurrRegimenEID)) {
          nextRegimenPosition = i;
          currentIndex = i;
          currLoggedEID.value = "";
          allActivitiesCompleted = false;
          break;
        } else if (DateTime.now().isBefore(regimentList[i].estart!)) {
          if (regimentList[i].ack_local != null) {
            if (regimentList.length > (i + 1)) {
              nextRegimenPosition = i + 1;
              currentIndex = i + 1;
              allActivitiesCompleted = false;
            } else {
              nextRegimenPosition = i;
              currentIndex = i;
              allActivitiesCompleted = false;
            }
          } else {
            nextRegimenPosition = i;
            currentIndex = i;
            allActivitiesCompleted = false;
          }
          break;
        }
      }
      if (allActivitiesCompleted) {
        if (regimentList.length > 0) {
          nextRegimenPosition = regimentList.length - 1;
          currentIndex = regimentList.length - 1;
        }
      }
    }

    update(["newUpdate"]);
    if (isFirstTime.value) {
      isFirstTime.value = false;
      getUserDetails();
      getCareCoordinatorId();
    }
  }

  getCalendarRegimenList(
      {DateTime? nextPreviousDate = null, String? patientId}) async {
    DateTime startDate = DateTime(
            nextPreviousDate != null
                ? nextPreviousDate.year
                : selectedDate.value.year,
            nextPreviousDate != null
                ? nextPreviousDate.month
                : selectedDate.value.month,
            1)
        .subtract(Duration(days: 7));
    DateTime endDate = DateTime(
            nextPreviousDate != null
                ? nextPreviousDate.year
                : selectedDate.value.year,
            nextPreviousDate != null
                ? nextPreviousDate.month
                : selectedDate.value.month + 1,
            0)
        .add(Duration(days: 7));
    loadingCalendar.value = true;
    qurHomeRegimenCalendarResponseModel = await _apiProvider
        .getRegimenListCalendar(startDate, endDate, patientId: patientId);
    loadingCalendar.value = false;
    update(["refreshCalendar"]);
  }

  @override
  void onClose() {
    try {
      remainderQueueTimer?.cancel();
      updateUITimer?.cancel();
      updateUITimer = null;
      super.onClose();
    } catch (e, stackTrace) {
      CommonUtil().appLogs(message: e, stackTrace: stackTrace);

      if (kDebugMode) {
        printError(info: e.toString());
      }
    }
  }

  @override
  void onInit() {
    startUpdateUITimer();
    super.onInit();
  }

  updateTimerValue(double value) async {
    timerProgress.value = value;
  }

  updateisShowTimerDialog(bool value) async {
    isShowTimerDialog.value = value;
  }

  getCurrentLocation() async {
    try {
      if (Platform.isAndroid) {
        const platform = MethodChannel(GET_CURRENT_LOCATION);
        var result = await platform.invokeMethod(GET_CURRENT_LOCATION);
        result = CommonUtil().validString(result.toString());
        if (result.trim().isNotEmpty) {
          List<String> receivedValues = result.split('|');
          getAddressFromLatLng(double.parse("${receivedValues.first}"),
              double.parse("${receivedValues.last}"));
        }
      } else {
        Geolocator.getCurrentPosition(
                desiredAccuracy: LocationAccuracy.best,
                forceAndroidLocationManager: true)
            .then((Position position) {
          getAddressFromLatLng(position.latitude, position.longitude);
        }).catchError((e) {
          if (kDebugMode) {
            printError(info: e.toString());
          }
        });
      }
    } catch (e, stackTrace) {
      CommonUtil().appLogs(message: e, stackTrace: stackTrace);

      if (kDebugMode) {
        printError(info: e.toString());
      }
    }
  }

  getAddressFromLatLng(double latitude, double longitude) async {
    try {
      if (latitude != null && longitude != null) {
        var coordinates = Coordinates(latitude, longitude);
        final addresses =
            await Geocoder.local.findAddressesFromCoordinates(coordinates);
        Address address = addresses.first; //FU2.5
        // var address;//  FU2.5

        if (address != null) {
          locationModel = Location(
              latitude: CommonUtil().validString(latitude.toString()),
              longitude: CommonUtil().validString(longitude.toString()),
              addressLine: CommonUtil().validString(address.addressLine),
              countryName: CommonUtil().validString(address.countryName),
              countryCode: CommonUtil().validString(address.countryCode),
              featureName: CommonUtil().validString(address.featureName),
              postalCode: CommonUtil().validString(address.postalCode),
              adminArea: CommonUtil().validString(address.adminArea),
              subAdminArea: CommonUtil().validString(address.subAdminArea),
              locality: CommonUtil().validString(address.locality),
              subLocality: CommonUtil().validString(address.subLocality),
              thoroughfare: CommonUtil().validString(address.thoroughfare),
              subThoroughfare:
                  CommonUtil().validString(address.subThoroughfare));

          String subAdminArea = (locationModel?.subAdminArea ?? '');
          if (subAdminArea.trim().isEmpty) {
            locationModel?.subAdminArea =
                CommonUtil().getLocalityName(addresses);
          }
        }
      }
    } catch (e, stackTrace) {
      CommonUtil().appLogs(message: e, stackTrace: stackTrace);

      if (kDebugMode) {
        printError(info: e.toString());
      }
    }
  }

  getCareCoordinatorId() async {
    try {
      careCoordinatorId = "".obs;
      userId = "".obs;
      http.Response response = await _apiProvider.getCareCoordinatorId();
      if (response == null) {
        careCoordinatorId.value = "";
      } else {
        CareCoordinatorData careCoordinatorData =
            CareCoordinatorData.fromJson(json.decode(response.body));
        if (careCoordinatorData.result != null &&
            careCoordinatorData.result!.length > 0 &&
            careCoordinatorData.isSuccess!) {
          var careCoordinatorDetails = careCoordinatorData.result!;
          var activeUser = "care coordinator";

          final index = careCoordinatorDetails.indexWhere(
            (element) => (CommonUtil()
                .validString(element.userType)
                .toLowerCase()
                .contains(
                  activeUser,
                )),
          );
          if (index >= 0) {
            careCoordinatorId.value = CommonUtil()
                .validString(careCoordinatorData.result![index].userId);
            careCoordinatorName.value = CommonUtil()
                .validString(careCoordinatorData.result![index].name);
            userId.value = CommonUtil()
                .validString(careCoordinatorData.result![index].patientId);
          }
        }
      }
    } catch (e, stackTrace) {
      CommonUtil().appLogs(message: e, stackTrace: stackTrace);

      if (kDebugMode) {
        printError(info: e.toString());
      }
    }
  }

  callSOSEmergencyServices(int flag) async {
    try {
      //flag == 0 SOS Call
      //flag == 1 Normal Call
      String ccID = CommonUtil().validString(careCoordinatorId.value);
      if (flag == 0) {
        isFromSOS.value = true;
      } else {
        isFromSOS.value = false;
      }
      if (ccID.trim().isEmpty) {
        FlutterToast().getToast(
            '${CommonUtil().validString(careCoordinatorIdEmptyMsg.value)}',
            Colors.red);
        return;
      }

      loadingData.value = true;
      final status = await VideoCallCommonUtils()
          .getCurrentVideoCallRelatedPermission(isAudioCall: true);

      if (status) {
        var bookinId = getMyMeetingID().toString();
        print("bookinId $bookinId");

        Provider.of<AudioCallProvider>(Get.context!, listen: false)
            .enableAudioCall();

        VideoCallCommonUtils()
            .makeCallToPatient(
                context: Get.context,
                bookId: bookinId,
                appointmentId: '',
                patName: careCoordinatorName.value,
                patientDOB: userDOB.value,
                patId: userId.value,
                patChatId: userId.value,
                patientPicUrl: userProfilePic.value,
                gender: '',
                isFromAppointment: false,
                healthRecord: null,
                patienInfo: null,
                patientPrescriptionId: userId.value,
                callType: 'audio',
                isFrom: isFromSOS.value ? "SOS" : "")
            .then((value) {
          //onGoingSOSCall.value = true;
        });
      } else {
        FlutterToast().getToast(
          'Could not start call due to permission issue',
          Colors.red,
        );
      }
    } catch (e, stackTrace) {
      CommonUtil().appLogs(message: e, stackTrace: stackTrace);

      if (kDebugMode) {
        printError(info: e.toString());
      }
    }
  }

  getUserDetails() {
    try {
      prof = PreferenceUtil.getProfileData(constants.KEY_PROFILE)!;
      userName.value = prof.result != null
          ? CommonUtil().validString(
              prof.result!.firstName! + ' ' + prof.result!.lastName!)
          : '';
      userId.value = PreferenceUtil.getStringValue(constants.KEY_USERID)!;
      userProfilePic.value = prof.result != null
          ? CommonUtil().validString(prof.result!.profilePicThumbnailUrl)
          : '';
      userDOB.value = prof.result != null
          ? CommonUtil().validString(prof.result!.dateOfBirth)
          : '';
      userMobNo.value = prof.result != null
          ? CommonUtil()
              .validString(prof.result!.userContactCollection3![0]!.phoneNumber)
          : '';
    } catch (e, stackTrace) {
      CommonUtil().appLogs(message: e, stackTrace: stackTrace);

      if (kDebugMode) {
        printError(info: e.toString());
      }
    }
  }

  getSOSAgentNumber(bool isLoading) async {
    try {
      if (isLoading) {
        loadingData.value = true;
      }
      SOSAgentNumber = "".obs;
      http.Response response = await _apiProvider.getSOSAgentNumber();
      if (isLoading) {
        await qurhomeDashboardController.getModuleAccess();
        await getSOSButtonStatus();
        loadingData.value = false;
      }
      if (response == null) {
        SOSAgentNumber.value = "";
      } else {
        SOSCallAgentNumberData sosCallAgentNumberData =
            SOSCallAgentNumberData.fromJson(json.decode(response.body));
        if (sosCallAgentNumberData.result != null &&
            sosCallAgentNumberData.isSuccess!) {
          SOSAgentNumber.value = CommonUtil()
              .validString(sosCallAgentNumberData.result!.exoPhoneNumber);
        }
      }
    } catch (e, stackTrace) {
      CommonUtil().appLogs(message: e, stackTrace: stackTrace);

      if (kDebugMode) {
        printError(info: e.toString());
      }
    }
  }

  void updateSOSAgentCallDialogStatus(bool newStatus) {
    isSOSAgentCallDialogOpen.value = newStatus;
  }

  void updateRegimentData() {
    try {
      dateHeader.value = getFormatedDate();
      if (qurhomeDashboardController.forPatientList.value) {
        getRegimenList(
            isLoading: false,
            patientId:
                qurhomeDashboardController.careGiverPatientListResult!.childId);
      } else {
        getRegimenList(isLoading: false);
      }
      if (!isTodaySelected.value) {
        isTodaySelected.value = false;
        statusText.value =
            "${stringViewTotalNumberOfActivites} ${qurHomeRegimenResponseModel?.regimentsList?.length ?? 0}";
        update(["refershStatusText"]);
      }
    } catch (e, stackTrace) {
      CommonUtil().appLogs(message: e, stackTrace: stackTrace);
      if (kDebugMode) {
        printError(info: e.toString());
      }
    }
  }

  showCurrLoggedRegimen(RegimentDataModel regimen) {
    currLoggedEID.value = CommonUtil().validString(regimen.eid?.toString());
    // getRegimenList(date: selectedDate.value.toString());
  }

  String getFormatedDate({String? date = null}) {
    DateTime now = date == null ? DateTime.now() : DateTime.parse(date);
    selectedDate.value = now;
    String prefix = '';
    if (CommonUtil().calculateDifference(now) == 0) {
      //today
      isTodaySelected.value = false;
      // statusText.value = '';
      statusText.value =
          "${stringViewTotalNumberOfActivites} ${qurHomeRegimenResponseModel?.regimentsList?.length ?? 0}";
      prefix = 'Today, ';
    } else if (CommonUtil().calculateDifference(now) < 0) {
      //past
      isTodaySelected.value = false;
      // statusText.value = strViewPastDateRegimen;
      statusText.value =
          "${stringViewTotalNumberOfActivites} ${qurHomeRegimenResponseModel?.regimentsList?.length ?? 0}";
      String formattedDate = DateFormat('EEEE').format(now);
      prefix = formattedDate + ', ';
    } else if (CommonUtil().calculateDifference(now) > 0) {
      //future
      isTodaySelected.value = false;
      // statusText.value = strViewFutureDateRegimen;
      statusText.value =
          "${stringViewTotalNumberOfActivites} ${qurHomeRegimenResponseModel?.regimentsList?.length ?? 0}";
      String formattedDate = DateFormat('EEEE').format(now);
      prefix = formattedDate + ', ';
    } else {
      isTodaySelected.value = false;
      String formattedDate = DateFormat('EEEE').format(now);
      prefix = formattedDate + ', ';
    }
    update(["refershStatusText"]);

    String formattedDate = DateFormat('dd MMM').format(now);
    return prefix + formattedDate;
  }

  getSOSButtonStatus() async {
    try {
      await _apiProvider.getSOSButtonStatus();
    } catch (e, stackTrace) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  initRemainderQueue() {
    try {
      remainderQueueTimer = Timer.periodic(
        Duration(minutes: 2),
        (Timer timer) {
          var sheelaAIController = Get.find<SheelaAIController>();
          sheelaAIController.getSheelaBadgeCount(isFromQurHomeRegimen: true);
        },
      );
    } catch (e, stackTrace) {
      CommonUtil().appLogs(message: e, stackTrace: stackTrace);
    }
  }

  initOneRemainderQueue() async {
    String? startDate = PreferenceUtil.getStringValue(SHEELA_REMAINDER_START);
    String? endDate = PreferenceUtil.getStringValue(SHEELA_REMAINDER_END);
    try {
      if (CommonUtil().isTablet == true) {
        if (startDate != null &&
            startDate != "" &&
            endDate != null &&
            endDate != "") {
          var sheelaAIController = Get.find<SheelaAIController>();

          if ((DateTime.parse(startDate ?? '')
                      .isAtSameMomentAs(DateTime.now()) ||
                  DateTime.now().isAfter(DateTime.parse(startDate ?? ''))) &&
              (DateTime.now().isBefore(DateTime.parse(endDate ?? '')))) {
            try {
              //Separte method to show remainder in tablet devices
              sheelaAIController.checkIfWeNeedToShowDialogBox(
                  isNeedSheelaDialog: true);
            } catch (e, stackTrace) {
              CommonUtil().appLogs(message: e, stackTrace: stackTrace);
            }
          } else if ((DateTime.parse(endDate ?? '')
                  .isAtSameMomentAs(DateTime.now())) ||
              (DateTime.now().isAfter(DateTime.parse(endDate ?? '')))) {
            evryOneMinuteRemainder?.cancel();
            PreferenceUtil.saveString(SHEELA_REMAINDER_START, '');
            PreferenceUtil.saveString(SHEELA_REMAINDER_END, '');
          }
        } else {
          callMethodToSaveRemainder();
        }
      }
    } catch (e, stackTrace) {
      CommonUtil().appLogs(message: e, stackTrace: stackTrace);
    }
  }

  void startTimerForSheela() {
    if (CommonUtil().isTablet == true) {
      try {
        evryOneMinuteRemainder = Timer.periodic(
          Duration(minutes: 1),
          (Timer timer) {
            initOneRemainderQueue();
          },
        );
      } catch (e, stackTrace) {
        CommonUtil().appLogs(message: e, stackTrace: stackTrace);
      }
    }
  }

  void callMethodToSaveRemainder() async {
    final controllerQurhomeRegimen =
        CommonUtil().onInitQurhomeRegimenController();
    List<RegimentDataModel>? activitiesFilteredList = [];
    await controllerQurhomeRegimen.getRegimenList();
    activitiesFilteredList =
        controllerQurhomeRegimen.qurHomeRegimenResponseModel?.regimentsList;
    if (activitiesFilteredList != null && activitiesFilteredList.length > 0) {
      int length = activitiesFilteredList?.length ?? 0;
      if ((length ?? 0) > 0) {
        PreferenceUtil.saveString(SHEELA_REMAINDER_START,
            activitiesFilteredList?[0]?.estartNew ?? '');
        PreferenceUtil.saveString(SHEELA_REMAINDER_END,
            activitiesFilteredList?[length - 1]?.estartNew ?? '');
        if (controllerQurhomeRegimen.remainderTimestamps.length >= 0) {
          controllerQurhomeRegimen.remainderTimestamps = [];
          DateTime startTime =
              DateTime.parse(activitiesFilteredList?[0]?.estartNew ?? "");
          DateTime endTime = DateTime.parse(
              activitiesFilteredList?[length - 1]?.estartNew ?? '');

          controllerQurhomeRegimen.remainderTimestamps
              .add(((startTime ?? DateTime.now()).add(Duration(minutes: 30))));
          DateTime clonedTime =
              controllerQurhomeRegimen.remainderTimestamps[0] ?? DateTime.now();
          DateTime storTime = clonedTime;
          do {
            storTime =
                ((storTime ?? DateTime.now()).add(Duration(minutes: 30)));
            if (storTime.isBefore(endTime))
              controllerQurhomeRegimen.remainderTimestamps.add(storTime);
          } while (storTime.isBefore(endTime));
          controllerQurhomeRegimen.remainderTimestamps.add(endTime);
        }
      }
    }
  }
}
