import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:myfhb/Qurhome/QurhomeDashboard/Api/QurHomeApiProvider.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:myfhb/Qurhome/QurhomeDashboard/model/carecoordinatordata.dart';
import 'package:myfhb/Qurhome/QurhomeDashboard/model/location_data_model.dart';
import 'package:myfhb/Qurhome/QurhomeDashboard/model/soscallagentnumberdata.dart';
import 'package:myfhb/authentication/constants/constants.dart';
import 'package:myfhb/common/PreferenceUtil.dart';
import 'package:myfhb/constants/fhb_constants.dart';
import 'package:myfhb/regiment/models/regiment_data_model.dart';
import 'package:myfhb/regiment/models/regiment_response_model.dart';
import 'package:myfhb/common/CommonUtil.dart';
import 'package:gmiwidgetspackage/widgets/flutterToast.dart';
import 'package:flutter/material.dart';
import 'package:myfhb/src/model/user/MyProfileModel.dart';
import 'package:myfhb/video_call/utils/audiocall_provider.dart';
import 'package:provider/provider.dart';
import '../../../../constants/fhb_constants.dart' as constants;
import 'QurhomeDashboardController.dart';

class QurhomeRegimenController extends GetxController {
  final _apiProvider = QurHomeApiProvider();
  var loadingData = false.obs;
  var loadingDataWithoutProgress = false.obs;

  // QurHomeRegimenResponseModel qurHomeRegimenResponseModel;
  RegimentResponseModel qurHomeRegimenResponseModel;
  int nextRegimenPosition = 0;
  int currentIndex = 0;

  var timerProgress = 1.0.obs;
  var isShowTimerDialog = true.obs;

  var careCoordinatorId = "".obs;
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
  var SOSAgentNumber = "".obs;
  var SOSAgentNumberEmptyMsg = "".obs;
  var currLoggedEID = "".obs;

  static MyProfileModel prof =
      PreferenceUtil.getProfileData(constants.KEY_PROFILE);

  Location locationModel;

  var qurhomeDashboardController = Get.find<QurhomeDashboardController>();

  Timer timer;

  getRegimenList({bool isLoading = true}) async {
    try {
      if (!isLoading) {
        loadingDataWithoutProgress.value = true;
      }
      loadingData.value = true;
      qurHomeRegimenResponseModel = await _apiProvider.getRegimenList("");
      loadingData.value = false;
      loadingDataWithoutProgress.value = false;
      qurHomeRegimenResponseModel.regimentsList.removeWhere((element) =>
          element?.isEventDisabled && !element?.isSymptom ||
          !element?.scheduled);
      for (int i = 0;
          i < qurHomeRegimenResponseModel?.regimentsList?.length ?? 0;
          i++) {
        String strCurrLoggedEID = CommonUtil().validString(currLoggedEID.value);
        String strCurrRegimenEID = CommonUtil().validString(
            qurHomeRegimenResponseModel?.regimentsList[i]?.eid ?? "");
        if (strCurrLoggedEID.trim().isNotEmpty &&
            strCurrLoggedEID.contains(strCurrRegimenEID)) {
          nextRegimenPosition = i;
          currentIndex = i;
          currLoggedEID.value = "";
          restartTimer();
          break;
        } else if (DateTime.now()
            .isBefore(qurHomeRegimenResponseModel?.regimentsList[i]?.estart)) {
          if (qurHomeRegimenResponseModel?.regimentsList[i]?.ack_local !=
              null) {
            if (qurHomeRegimenResponseModel?.regimentsList?.length > (i + 1)) {
              nextRegimenPosition = i + 1;
              currentIndex = i + 1;
            } else {
              nextRegimenPosition = i;
              currentIndex = i;
            }
          } else {
            nextRegimenPosition = i;
            currentIndex = i;
          }
          break;
        }
      }
      for (int i = 0;
          i < qurHomeRegimenResponseModel?.regimentsList?.length ?? 0;
          i++) {
        if (qurHomeRegimenResponseModel?.regimentsList[i]?.activityOrgin !=
            null) {
          if (qurHomeRegimenResponseModel?.regimentsList[i]?.activityOrgin ==
              'Appointment') {
            if (qurHomeRegimenResponseModel?.regimentsList[i]?.estart != null &&
                qurHomeRegimenResponseModel?.regimentsList[i]?.estart != '') {
              if (qurHomeRegimenResponseModel?.regimentsList[i]?.eid != null &&
                  qurHomeRegimenResponseModel?.regimentsList[i]?.eid != '') {
                var apiReminder = qurHomeRegimenResponseModel.regimentsList[i];
                const platform = MethodChannel(APPOINTMENT_DETAILS);
                if (Platform.isIOS) {
                  platform.invokeMethod(
                      APPOINTMENT_DETAILS, apiReminder.toJson());
                } else {
                  await platform.invokeMethod(APPOINTMENT_DETAILS,
                      {'data': jsonEncode(apiReminder.toJson())});
                }
              }
            }
          }
        }
      }

      qurhomeDashboardController.getValuesNativeAppointment();

      update(["newUpdate"]);
      getUserDetails();
      getCareCoordinatorId();
    } catch (e) {
      print(e.toString());
      loadingData.value = false;
      loadingDataWithoutProgress.value = false;
    }
  }

  @override
  void onClose() {
    try {
      timer?.cancel();
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

  updateTimerValue(double value) async {
    try {
      timerProgress.value = value;
    } catch (e) {
      print(e);
    }
  }

  updateisShowTimerDialog(bool value) async {
    try {
      isShowTimerDialog.value = value;
    } catch (e) {
      print(e);
    }
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
          print(e);
        });
      }
    } catch (e) {
      print(e);
    }
  }

  getAddressFromLatLng(double latitude, double longitude) async {
    try {
      if (latitude != null && longitude != null) {
        var coordinates = Coordinates(latitude, longitude);
        final addresses =
            await Geocoder.local.findAddressesFromCoordinates(coordinates);
        Address address = addresses.first;

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
        }
      }
    } catch (e) {
      print(e);
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
            careCoordinatorData.result.length > 0 &&
            careCoordinatorData.isSuccess) {
          var careCoordinatorDetails = careCoordinatorData.result;
          var activeUser = "care coordinator";

          final index = careCoordinatorDetails.indexWhere((element) =>
              (CommonUtil()
                  .validString(element.userType)
                  .toLowerCase()
                  .contains(activeUser)));
          if (index >= 0) {
            careCoordinatorId.value = CommonUtil()
                .validString(careCoordinatorData.result[index].userId);
            userId.value = CommonUtil()
                .validString(careCoordinatorData.result[index].patientId);
          }
        }
      }
    } catch (e) {
      print(e.toString());
    }
  }

  callSOSEmergencyServices() async {
    try {
      if (CommonUtil().validString(careCoordinatorId.value).trim().isEmpty) {
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

        Provider.of<AudioCallProvider>(Get.context, listen: false)
            .enableAudioCall();

        VideoCallCommonUtils()
            .makeCallToPatient(
                context: Get.context,
                bookId: bookinId,
                appointmentId: '',
                patName: userName.value,
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
                isFrom: "SOS")
            .then((value) {
          //onGoingSOSCall.value = true;
        });
      } else {
        FlutterToast().getToast(
            'Could not start call due to permission issue', Colors.red);
      }
    } catch (e) {
      print(e);
    }
  }

  getUserDetails() {
    try {
      prof = PreferenceUtil.getProfileData(constants.KEY_PROFILE);
      userName.value = prof.result != null
          ? CommonUtil()
              .validString(prof.result.firstName + ' ' + prof.result.lastName)
          : '';
      userId.value = PreferenceUtil.getStringValue(constants.KEY_USERID);
      userProfilePic.value = prof.result != null
          ? CommonUtil().validString(prof.result.profilePicThumbnailUrl)
          : '';
      userDOB.value = prof.result != null
          ? CommonUtil().validString(prof.result.dateOfBirth)
          : '';
      userMobNo.value = prof.result != null
          ? CommonUtil()
              .validString(prof.result.userContactCollection3[0].phoneNumber)
          : '';
    } catch (e) {
      //print(e);
    }
  }

  getSOSAgentNumber(bool isLoading) async {
    try {
      if(isLoading)
      {
        loadingData.value = true;
      }
      SOSAgentNumber = "".obs;
      http.Response response = await _apiProvider.getSOSAgentNumber();
      if(isLoading)
      {
        loadingData.value = false;
      }
      if (response == null)
      {
        SOSAgentNumber.value = "";
      } else {
        SOSCallAgentNumberData sosCallAgentNumberData =
        SOSCallAgentNumberData.fromJson(json.decode(response.body));
        if (sosCallAgentNumberData.result != null &&
            sosCallAgentNumberData.isSuccess) {
          SOSAgentNumber.value = CommonUtil()
              .validString(sosCallAgentNumberData.result.exoPhoneNumber);

        }
      }
    } catch (e) {
      //print(e.toString());
    }
  }

  void updateSOSAgentCallDialogStatus(bool newStatus) {
    try {
      isSOSAgentCallDialogOpen.value = newStatus;
    } catch (e) {
      //print(e);
    }

  }

  void startTimer()
  {
    try {
      timer = Timer.periodic(Duration(seconds: 30), (Timer t) {
        getRegimenList(isLoading: false);
      });
    } catch (e) {
      //print(e);
    }
  }

  void restartTimer() {
    try {
      timer?.cancel();
      startTimer();
    } catch (e) {
      //print(e);
    }
  }

  showCurrLoggedRegimen(RegimentDataModel regimen) {
    try {
      currLoggedEID.value = CommonUtil().validString(regimen.eid.toString());
      getRegimenList();
    } catch (e) {
      //print(e);
    }
  }
}
