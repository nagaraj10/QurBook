import 'dart:async';
import 'dart:io';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:myfhb/common/CommonUtil.dart';
import 'package:myfhb/common/PreferenceUtil.dart';
import 'package:myfhb/constants/HeaderRequest.dart';
import 'package:myfhb/constants/fhb_constants.dart';
import 'package:myfhb/constants/variable_constant.dart';
import 'package:myfhb/src/resources/network/AppException.dart';
import 'package:myfhb/src/resources/network/api_services.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../../constants/fhb_constants.dart' as Constants;
import 'package:myfhb/constants/fhb_query.dart' as query;
import '../../../constants/variable_constant.dart' as variable;
import 'models/available_devices/TroubleShootingModel.dart';
import 'package:myfhb/more_menu/models/available_devices/TroubleShootingModel.dart';

class TroubleShootController extends GetxController {
  var isFirstTym = true.obs;
  double progressValue = 0.0;
  double addValue = 0.12;
  bool isLatestVersion = false;
  bool isStoragePermission = false;
  bool isMicrophone = false;
  bool isLocation = false;
  bool isCameraPermission = false;
  bool isBluetoothEnabled = false;
  bool _isNetworkAvailable = false;
  bool isAuthTokenValid = false;
  var isTroubleShootCompleted = false.obs;
  var progressText = '0 %'.obs;
  var testSuccess = false.obs;
  var testMsg = ''.obs;
  bool isAppAdded = false;
  bool isStorageAdded = false;
  bool isMicrophoneAdded = true;
  bool isLocationAdded = true;
  bool isBluetoothAdded = false;
  bool isCameraAdded = false;
  bool isInternetAdded = false;
  bool isAuthTokenAdded = false;

  List<TroubleShootingModel> troubleShootingList = [];

  troubleShootingApp() async {
    isTroubleShootCompleted.value = false;
    isFirstTym.value = false;

    if (troubleShootingList.length > 0) {
      isAppAdded = false;
      isStorageAdded = false;
      isAuthTokenAdded = false;
      isCameraAdded = false;
      isMicrophoneAdded = true;
      isLocationAdded = true;
      isInternetAdded = false;
      isBluetoothAdded = false;

      troubleShootingList.clear();
      troubleShootingList = [];
    }
    new Timer.periodic(Duration(milliseconds: 500), (Timer timer) {
      if (progressValue >= 0.96) {
        timer.cancel();
        if (!isTroubleShootCompleted.value) switchCaseMethod();
      } else {
        if (!isTroubleShootCompleted.value) switchCaseMethod();
      }
    });
  }

  checkIfAppIsLatest() async {
    print("App latest");

    await CommonUtil().versionCheck(Get.context, showDialog: false);
    if (CommonUtil.isVersionLatest == true) {
      isLatestVersion = true;
    } else {
      isLatestVersion = false;
    }
    if (!isAppAdded) {
      troubleShootingList.add(new TroubleShootingModel(
          strAppCompatibilty,
          isLatestVersion,
          ImageIcon(
            AssetImage(icon_compatibilty),
            size: CommonUtil().isTablet! ? imageCloseTab : imageCloseMobile,
          )));
      isAppAdded = true;
      increaseProgressValue(addValue);
    }
  }

  checkStorage({bool progressalue = true}) async {
    final storagePermission = await Platform.isAndroid
        ? await Permission.storage.status
        : await Permission.photos.status;
    if (!storagePermission.isGranted)
      isStoragePermission = false;
    else
      isStoragePermission = true;
    if (progressalue && !isStorageAdded) {
      troubleShootingList.add(new TroubleShootingModel(
          strStorage, isStoragePermission, Icon(Icons.storage)));
      isStorageAdded = true;
      increaseProgressValue(addValue);
    } else {
      if (!storagePermission.isGranted) {
        final result = Platform.isAndroid
            ? await Permission.storage.request()
            : await Permission.photos.request();

        if (result.isPermanentlyDenied ||
            storagePermission == PermissionStatus.denied ||
            storagePermission == PermissionStatus.permanentlyDenied) {
          await moveToOpenSettings(result);
        }
      }
    }
  }

  moveToOpenSettings(var status) async {
    if (Platform.isAndroid) {
      if (status == PermissionStatus.permanentlyDenied ||
          status == LocationPermission.deniedForever ||
          status.isPermanentlyDenied) {
        await openAppSettings();
      }
    } else {
      await openAppSettings();
    }
  }

  checkCameraStatus({bool progressalue = true}) async {
    var cameraStatus = await Permission.camera.status;

    if (!cameraStatus.isGranted) {
      isCameraPermission = false;
    } else {
      isCameraPermission = true;
    }
    if (progressalue && !isCameraAdded) {
      troubleShootingList.add(new TroubleShootingModel(
          strCamera,
          isCameraPermission,
          ImageIcon(
            AssetImage(icon_camera),
            size: CommonUtil().isTablet! ? imageCloseTab : imageCloseMobile,
          )));
      isCameraAdded = true;
      increaseProgressValue(addValue);
    } else {
      if (!cameraStatus.isGranted) {
        var result = await Permission.camera.request();

        if (result.isPermanentlyDenied ||
            cameraStatus == PermissionStatus.denied ||
            cameraStatus == PermissionStatus.permanentlyDenied) {
          await moveToOpenSettings(result);
        }
      }
    }
  }

  checkMicrophoneStatus({bool progressalue = true}) async {
    var microPhoneStatus = await Permission.microphone.status;

    if (!microPhoneStatus.isGranted) {
      isMicrophone = false;
    } else {
      isMicrophone = true;
    }
    if (progressalue && isMicrophoneAdded) {
      troubleShootingList.add(new TroubleShootingModel(
          strMicrophone,
          isMicrophone,
          ImageIcon(
            AssetImage(VOICE_ICON_LINK),
            size: CommonUtil().isTablet! ? imageCloseTab : imageCloseMobile,
          )));
      isMicrophoneAdded = false;
      increaseProgressValue(addValue);
    } else {
      if (!microPhoneStatus.isGranted) {
        var result = await Permission.microphone.request();
        if (result.isPermanentlyDenied ||
            microPhoneStatus == PermissionStatus.denied ||
            microPhoneStatus == PermissionStatus.permanentlyDenied) {
          await moveToOpenSettings(result);
        }
      }
    }
  }

  checkLocationStatus({bool progressalue = true}) async {
    var locationStatus = await Permission.location.status;

    if (!locationStatus.isGranted) {
      isLocation = false;
    } else {
      isLocation = true;
    }
    if (progressalue && isLocationAdded) {
      troubleShootingList.add(new TroubleShootingModel(
          strLocation,
          isLocation,
          ImageIcon(
            AssetImage(icon_location),
            size: CommonUtil().isTablet! ? imageCloseTab : imageCloseMobile,
          )));
      isLocationAdded = false;
      increaseProgressValue(addValue);
    } else {
      if (!locationStatus.isGranted) {
        final status = await Geolocator.requestPermission();
        if (status == LocationPermission.deniedForever ||
            locationStatus == PermissionStatus.denied ||
            locationStatus == PermissionStatus.permanentlyDenied) {
          await moveToOpenSettings(status);
        }
      }
    }
  }

  checkBluetoothStatus({bool progressalue = true}) async {
    var isBluetoothEnable = await (CommonUtil().checkBluetoothIsOn());
    if (!isBluetoothEnable!) {
      isBluetoothEnabled = false;
    } else {
      isBluetoothEnabled = true;
    }
    if (progressalue && !isBluetoothAdded) {
      troubleShootingList.add(new TroubleShootingModel(
        strBluetooth,
        isBluetoothEnabled,
        Icon(Icons.bluetooth),
      ));
      isBluetoothAdded = true;
      increaseProgressValue(addValue);
    }
    if (!progressalue && !isBluetoothEnabled) {
      CommonUtil().showAlertDialogWithTextAndButton(
          strAlert, pleaseTurnOnYourBluetoothAndTryAgain, okButton, () {
        Navigator.pop(Get.context!);
      });
    }
  }

  increaseProgressValue(addValueNew) {
    //Future.delayed(const Duration(seconds: 5));
    progressValue = progressValue + addValueNew;
    if (progressValue >= 1) {
      progressValue = 1.00;
    }
    progressText.value = (((progressValue * 100).toInt()).toString()) + ' %';
    print("*********** progressVale" +
        progressValue.toString() +
        " %" +
        progressText.value);
  }

  showAlertToUpgrade() {
    CommonUtil().showAlertDialogWithTextAndButton(
        strAlert, STR_UPDATE_CONTENT, okButton, () {
      Navigator.pop(Get.context!);
    });
  }

  void switchCaseMethod() {
    if (troubleShootingList.length > 0) {
      troubleShootingList = troubleShootingList.toSet().toList();
    }
    print(progressValue);
    int value = (progressValue * 100).toInt();
    switch (value) {
      case 0:
        progressValue = 0.0;
        progressText.value = '0 %';

        checkIfAppIsLatest();
        break;

      case 12:
        checkStorage();
        break;
      case 24:
        checkCameraStatus();
        break;
      case 36:
        checkBluetoothStatus();
        break;

      case 48:
        checkLocationStatus();
        break;

      case 60:
        checkMicrophoneStatus();

        break;

      case 72:
        checkIfInternetAvailable();

        break;

      case 84:
        checkAuthToken();
        break;

      case 96:
        troubleShootingList.sort(
          (a, b) => (a == b ? 0 : (a.isPass ? 1 : -1)),
        );

        isTroubleShootCompleted.value = true;
        setTestMsg();
        break;
      case 100:
        troubleShootingList.sort(
          (a, b) => (a == b ? 0 : (a.isPass ? 1 : -1)),
        );

        isTroubleShootCompleted.value = true;
        setTestMsg();
        break;
    }
  }

  void checkIfInternetAvailable({bool progressalue = true}) async {
    var connStatus = await Connectivity().checkConnectivity();
    if (connStatus == ConnectivityResult.mobile ||
        connStatus == ConnectivityResult.wifi) {
      _isNetworkAvailable = true;
    } else {
      _isNetworkAvailable = false;
    }
    if (progressalue && !isInternetAdded) {
      troubleShootingList.add(new TroubleShootingModel(
          strCommunication,
          _isNetworkAvailable,
          ImageIcon(
            AssetImage(icon_network),
            size: CommonUtil().isTablet! ? imageCloseTab : imageCloseMobile,
          )));
      isInternetAdded = true;
      increaseProgressValue(addValue);
    }

    if (!progressalue && !_isNetworkAvailable) {
      CommonUtil().showAlertDialogWithTextAndButton(
          strAlert, STR_NO_CONNECTIVITY, okButton, () {
        Navigator.pop(Get.context!);
      });
    }
  }

  void checkAuthToken({bool progressalue = true}) async {
    final authToken = PreferenceUtil.getStringValue(Constants.KEY_AUTHTOKEN);

    var responseJson;
    HeaderRequest headerRequest = HeaderRequest();
    String userID = PreferenceUtil.getStringValue(KEY_USERID)!;

    if (progressalue) {
      var url = query.qr_user +
          userID +
          query.qr_slash +
          query.qr_sections +
          query.qr_generalInfo;
      try {
        if (!_isNetworkAvailable) {
          isAuthTokenValid = false;
        } else if (_isNetworkAvailable && !isAuthTokenAdded) {
          try {
            var response = await ApiServices.get(BASE_URL + url,
                headers: await headerRequest.getRequestHeadersAuthAccept());
            if (response?.statusCode == 201 ||
                response?.statusCode == 400 ||
                response?.statusCode == 401 ||
                response?.statusCode == null) {
              isAuthTokenValid = false;
            } else {
              isAuthTokenValid = true;
            }
          } catch (e, stackTraceTree) {
            isAuthTokenValid = false;

            CommonUtil().appLogs(message: e, stackTrace: stackTraceTree);
          }
        }

        if (!isAuthTokenAdded) {
          troubleShootingList.add(new TroubleShootingModel(
              strConfirmUserValidity,
              isAuthTokenValid,
              ImageIcon(
                AssetImage(icon_validity),
                size: CommonUtil().isTablet! ? imageCloseTab : imageCloseMobile,
              )));
          isAuthTokenAdded = true;
          increaseProgressValue(addValue);
        }
      } on SocketException {
        isAuthTokenValid = false;
        troubleShootingList.add(new TroubleShootingModel(
            strConfirmUserValidity,
            isAuthTokenValid,
            ImageIcon(
              AssetImage(icon_validity),
              size: CommonUtil().isTablet! ? imageCloseTab : imageCloseMobile,
            )));
        isAuthTokenAdded = true;

        increaseProgressValue(addValue);
        throw FetchDataException(variable.strNoInternet);
      }
    } else {
      CommonUtil().showAlertDialogWithTextAndButton(
          strAlert, strReloginMsg, strRelogin, () {
        CommonUtil().logout(CommonUtil().moveToLoginPage());
      });
    }
  }

  void onTapOfDiagnosicResult(TroubleShootingModel troubleShootModel) {
    switch (troubleShootModel.name) {
      case strAppCompatibilty:
        showAlertToUpgrade();
        break;
      case strStorage:
        checkStorage(progressalue: false);
        break;
      case strCamera:
        checkCameraStatus(progressalue: false);

        break;
      case strMicrophone:
        checkMicrophoneStatus(progressalue: false);

        break;
      case strLocation:
        checkLocationStatus(progressalue: false);

        break;
      case strBluetooth:
        checkBluetoothStatus(progressalue: false);

        break;
      case strCommunication:
        checkIfInternetAvailable(progressalue: false);

        break;
      case strConfirmUserValidity:
        checkAuthToken(progressalue: false);
        break;
    }
  }

  void setTestMsg() {
    int count = 0;
    for (TroubleShootingModel troubleShootingModel in troubleShootingList) {
      if (!troubleShootingModel.isPass) {
        count++;
      }
    }

    if (count == 0) {
      testMsg.value = 'Normal';
      testSuccess.value = true;
    } else {
      testMsg.value = count.toString() + " items pending";
      testSuccess.value = false;
    }
  }
}
