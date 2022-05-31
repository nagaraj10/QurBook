import 'dart:async';
import 'dart:convert';

import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:intl/intl.dart';
import 'package:myfhb/Qurhome/QurhomeDashboard/Api/QurHomeApiProvider.dart';
import 'package:http/http.dart' as http;
import 'package:myfhb/Qurhome/QurhomeDashboard/Api/QurHomeRegimenResponseModel.dart';
import 'package:get/get.dart';
import 'package:myfhb/Qurhome/QurhomeDashboard/model/location_data_model.dart';
import 'package:myfhb/regiment/models/regiment_response_model.dart';
import 'package:myfhb/common/CommonUtil.dart';
import 'package:gmiwidgetspackage/widgets/flutterToast.dart';
import 'package:flutter/material.dart';

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
  String currentAddress;

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
      currentAddress = "";
      if (currentPosition != null) {
        var coordinates =
            Coordinates(currentPosition.latitude, currentPosition.longitude);
        final addresses =
            await Geocoder.local.findAddressesFromCoordinates(coordinates);
        Address address = addresses.first;

        print("_getAddressFromLatLng ${address.toString()}");

        if (address != null) {
          currentAddress += "addressLine ${CommonUtil().validString(address.addressLine)}\n" +
              "Locality ${CommonUtil().validString(address.locality.toString())}\n" +
              "State ${CommonUtil().validString(address.adminArea.toString())}\n" +
              "Pincode ${CommonUtil().validString(address.postalCode.toString())}\n" +
              "Country ${CommonUtil().validString(address.countryName.toString())}\n";
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
      currentAddress += "addressLine ${CommonUtil().validString(locationDataModel.city.toString())} ${CommonUtil().validString(locationDataModel.zip.toString())} ${CommonUtil().validString(locationDataModel.regionName.toString())} ${CommonUtil().validString(locationDataModel.country.toString())}\n" +
          "Locality ${CommonUtil().validString(locationDataModel.city.toString())}\n" +
          "State ${CommonUtil().validString(locationDataModel.regionName.toString())}\n" +
          "Pincode ${CommonUtil().validString(locationDataModel.zip.toString())}\n" +
          "Country ${CommonUtil().validString(locationDataModel.country.toString())}\n";
    } catch (e) {
      print(e);
    }
  }
}
