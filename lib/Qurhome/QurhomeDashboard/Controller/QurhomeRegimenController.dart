import 'dart:convert';

import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:myfhb/Qurhome/QurhomeDashboard/Api/QurHomeApiProvider.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:myfhb/Qurhome/QurhomeDashboard/model/carecoordinatordata.dart';
import 'package:myfhb/Qurhome/QurhomeDashboard/model/location_data_model.dart';
import 'package:myfhb/authentication/constants/constants.dart';
import 'package:myfhb/common/PreferenceUtil.dart';
import 'package:myfhb/regiment/models/regiment_response_model.dart';
import 'package:myfhb/common/CommonUtil.dart';
import 'package:gmiwidgetspackage/widgets/flutterToast.dart';
import 'package:flutter/material.dart';
import 'package:myfhb/src/model/user/MyProfileModel.dart';
import 'package:myfhb/video_call/utils/audiocall_provider.dart';
import 'package:provider/provider.dart';
import '../../../../constants/fhb_constants.dart' as constants;

class QurhomeRegimenController extends GetxController {
  final _apiProvider = QurHomeApiProvider();
  var loadingData = false.obs;
  // QurHomeRegimenResponseModel qurHomeRegimenResponseModel;
  RegimentResponseModel qurHomeRegimenResponseModel;
  int nextRegimenPosition = 0;
  int currentIndex = 0;

  var timerProgress = 1.0.obs;
  var isShowTimerDialog = true.obs;

  Position currentPosition;

  var careCoordinatorId = "".obs;
  var userName = "".obs;
  var userId = "".obs;
  var userProfilePic = "".obs;
  var userDOB = "".obs;
  var userMobNo = "".obs;
  var onGoingSOSCall = false.obs;

  static MyProfileModel prof =
      PreferenceUtil.getProfileData(constants.KEY_PROFILE);

  Location locationModel;

  getRegimenList() async {
    try {
      loadingData.value = true;

      qurHomeRegimenResponseModel = await _apiProvider.getRegimenList("");
      loadingData.value = false;
      qurHomeRegimenResponseModel.regimentsList
          .removeWhere((element) => element?.isEventDisabled);
      for (int i = 0;
          i < qurHomeRegimenResponseModel.regimentsList.length;
          i++) {
        if (DateTime.now()
            .isBefore(qurHomeRegimenResponseModel.regimentsList[i].estart)) {
          if (qurHomeRegimenResponseModel.regimentsList[i].ack_local != null) {
            if (qurHomeRegimenResponseModel.regimentsList.length > (i + 1)) {
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
      update(["newUpdate"]);
      getUserDetails();
      getCareCoordinatorId();
    } catch (e) {
      print(e.toString());
      loadingData.value = false;
    }
  }

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
      Geolocator.getCurrentPosition(
              desiredAccuracy: LocationAccuracy.best,
              forceAndroidLocationManager: true)
          .then((Position position) {
        currentPosition = position;
        getAddressFromLatLng();
      }).catchError((e) {
        print(e);
      });
    } catch (e) {
      print(e);
    }
  }

  getAddressFromLatLng() async {
    try {
      if (currentPosition != null) {
        var coordinates =
            Coordinates(currentPosition.latitude, currentPosition.longitude);
        final addresses =
            await Geocoder.local.findAddressesFromCoordinates(coordinates);
        Address address = addresses.first;

        if (address != null) {
          locationModel = Location(
              latitude:
                  CommonUtil().validString(currentPosition.latitude.toString()),
              longitude: CommonUtil()
                  .validString(currentPosition.longitude.toString()),
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
        } else {
          getNetworkBasedLocation();
        }
      } else {
        getNetworkBasedLocation();
      }
    } catch (e) {
      print(e);
    }
  }

  getNetworkBasedLocation() async {
    try {
      http.Response data = await http.get(Uri.parse('http://ip-api.com/json'));
      LocationDataModel locationDataModel =
          LocationDataModel.fromJson(jsonDecode(data.body));
      locationModel = Location(
          latitude: CommonUtil().validString(locationDataModel.lat.toString()),
          longitude: CommonUtil().validString(locationDataModel.lon.toString()),
          addressLine: CommonUtil().validString(
              '${CommonUtil().validString(locationDataModel.city.toString())} ${CommonUtil().validString(locationDataModel.zip.toString())} ${CommonUtil().validString(locationDataModel.regionName.toString())} ${CommonUtil().validString(locationDataModel.country.toString())}'),
          countryName: CommonUtil().validString(locationDataModel.country),
          countryCode: CommonUtil().validString(locationDataModel.countryCode),
          featureName: CommonUtil().validString(""),
          postalCode: CommonUtil().validString(locationDataModel.zip),
          adminArea: CommonUtil().validString(locationDataModel.regionName),
          subAdminArea: CommonUtil().validString(locationDataModel.city),
          locality: CommonUtil().validString(locationDataModel.city),
          subLocality: CommonUtil().validString(locationDataModel.city),
          thoroughfare: CommonUtil().validString(""),
          subThoroughfare: CommonUtil().validString(""));
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
        // failed to get the data, we are showing the error on UI
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
      bool isInternetOn = await CommonUtil().checkInternetConnection();
      if (!isInternetOn) {
        FlutterToast()
            .getToast('Please turn on your internet and try again', Colors.red);
        return;
      }

      onGoingSOSCall.value = true;

      loadingData.value = true;

      final status = await VideoCallCommonUtils()
          .getCurrentVideoCallRelatedPermission(isAudioCall: true);
      var bookinId = getMyMeetingID().toString();
      print("bookinId $bookinId");

      if (status) {
        var _bookinId = getMyMeetingID().toString();

        Provider.of<AudioCallProvider>(Get.context, listen: false)
            .enableAudioCall();

        VideoCallCommonUtils()
            .makeCallToPatient(
                context: Get.context,
                bookId: _bookinId,
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
          onGoingSOSCall.value = true;
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
      print(e);
    }
  }
}
