import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:gmiwidgetspackage/widgets/flutterToast.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';

import '../../../../QurHub/Controller/HubListViewController.dart';
import '../../../../Qurhome/BleConnect/ApiProvider/ble_connect_api_provider.dart';
import '../../../../Qurhome/BleConnect/Models/ble_data_model.dart';
import '../../../../Qurhome/QurHomeVitals/viewModel/VitalDetailController.dart';
import '../../../../Qurhome/QurhomeDashboard/Controller/QurhomeDashboardController.dart';
import '../../../../Qurhome/QurhomeDashboard/Controller/QurhomeRegimenController.dart';
import '../../../../common/CommonUtil.dart';
import '../../../../common/PreferenceUtil.dart';
import '../../../../constants/fhb_constants.dart';
import '../Controller/SheelaAIController.dart';
import '../Models/SheelaResponse.dart';
import '../Models/sheela_arguments.dart';
import '../Views/SheelaAIMainScreen.dart';

class SheelaBLEController extends GetxController {
  late SheelaAIController SheelaController;
  late HubListViewController hublistController;
  EventChannel bleStream = const EventChannel('QurbookBLE/stream');
  MethodChannel bleMethodChannel = const MethodChannel('QurbookBLE/method');
  late Stream stream;
  StreamSubscription? timerSubscription;

  Timer? timeOutTimer;
  final String conversationType = "BLESheelaConversations";
  List<SheelaResponse> playConversations = [];
  bool isPlaying = false;
  bool isCompleted = false;
  bool isFromVitals = false;
  bool isFromRegiment = false;
  bool addingDevicesInHublist = false;
  bool receivedData = false;
  late AudioPlayer player;
  int randomNum = 0;
  String weightUnit = "";
  String filteredDeviceType = '';

  @override
  void onInit() {
    super.onInit();
    player = AudioPlayer();
    listnerForAudioPlayer();
    SheelaController = Get.find();
    hublistController = Get.find();
    stream = bleStream.receiveBroadcastStream();
  }

  listnerForAudioPlayer() {
    player.onPlayerStateChanged.listen(
      (event) async {
        if (event == PlayerState.COMPLETED) {
          isPlaying = false;
          if ((playConversations).isNotEmpty) {
            playTTS();
          } else if (isCompleted) {
            await Future.delayed(const Duration(seconds: 4));
            stopTTS();
            if (SheelaController.isSheelaScreenActive) Get.back();
          }
        }
      },
    );
  }

  setupListenerForReadings() async {
    try {
      if ((CommonUtil.isUSRegion() &&
          Get.find<QurhomeDashboardController>().isVitalModuleDisable.value)) {
        return;
      } else {
        bool status = await checkForBLEEnableConditions();
        if (!status) {
          return;
        }
        _enableTimer();
      }
    } catch (e) {
      CommonUtil().appLogs(message: e.toString());

      print(e.toString());
    }
  }

  refreshTimeoutTimer() {
    removeTimeOutTimer();
    if (timeOutTimer == null) {
      timeOutTimer = Timer(
        const Duration(
          seconds: 180,
        ),
        () {
          showFailure();
        },
      );
    }
  }

  void _enableTimer() {
    if (!addingDevicesInHublist) {
      final devicesList =
          (hublistController.hubListResponse!.result!.userDeviceCollection ??
              []);
      if (devicesList.isEmpty) {
        return;
      }
    }

    if (timerSubscription != null) {
      return;
    }

    timerSubscription = stream.listen(
      (val) async {
        print("Val in ");
        if (val == null || val == "") {
          return;
        }
        print("Val in " + val.toString());
        final List<String>? receivedValues = val.split('|');
        if ((receivedValues ?? []).length > 0) {
          switch (receivedValues!.first) {
            case "scanstarted":
              SheelaController.isBLEStatus.value = BLEStatus.Searching;
              break;
            case "enablebluetooth":
              FlutterToast().getToast(
                receivedValues.last ?? 'Please enable the Bluetooth and re-try',
                Colors.red,
              );
              if (addingDevicesInHublist)
                hublistController.searchingBleDevice(false);
              break;
            case "permissiondenied":
              FlutterToast().getToast(
                receivedValues.last ??
                    'Please enable the Bluetooth Permission and re-try',
                Colors.red,
              );
              if (addingDevicesInHublist)
                hublistController.searchingBleDevice(false);
              break;
            case "macid":
              hublistController.bleMacId = CommonUtil().validString(
                receivedValues.last,
              );
              break;
            case "manufacturer":
              hublistController.manufacturer = receivedValues.last;
              break;
            case "bleDeviceType":
              hublistController.bleDeviceType = CommonUtil().validString(
                receivedValues.last,
              );
              if (addingDevicesInHublist) {
                if (checkForParedDevice()) {
                  return;
                }
                stopScanning();
                hublistController.searchingBleDevice(false);
                hublistController.navigateToAddDeviceScreen();
                return;
              }
              break;
            case "connected":
              if (addingDevicesInHublist) {
                return;
              }
              receivedData = false;
              if (!checkForParedDevice()) {
                return;
              }
              if ((hublistController.bleMacId ?? '').isNotEmpty &&
                  (hublistController.bleDeviceType ?? '').isNotEmpty &&
                  (hublistController.manufacturer ?? '').isNotEmpty) {
                String deviceType =
                    hublistController.bleDeviceType!.toLowerCase();
                if (deviceType == "spo2" ||
                    deviceType == "bp" ||
                    deviceType == "weight" ||
                    deviceType == "bgl") {
                  SheelaController.isBLEStatus.value = BLEStatus.Connected;
                  if (isFromVitals || isFromRegiment) {
                    Get.back();
                  }
                  if (SheelaController.isSheelaScreenActive) return;
                  Get.to(
                    SheelaAIMainScreen(
                      arguments: SheelaArgument(
                        deviceType: hublistController.bleDeviceType,
                        takeActiveDeviceReadings: true,
                      ),
                    ),
                  )?.then((_) {
                    Future.delayed(const Duration(seconds: 1)).then((_) {
                      if (Get.isRegistered<VitalDetailController>())
                        Get.find<VitalDetailController>().getData();
                    });

                    Future.delayed(const Duration(seconds: 1)).then((_) {
                      if (Get.isRegistered<QurhomeRegimenController>()) {
                        Get.find<QurhomeRegimenController>()
                            .currLoggedEID
                            .value = hublistController.eid ?? '';
                        Get.find<QurhomeRegimenController>().getRegimenList();
                      }
                    });
                  });
                }
              }
              break;
            case "update":
              if (addingDevicesInHublist) {
                return;
              }
              if (SheelaController.isSheelaScreenActive) {
                addToConversationAndPlay(
                  SheelaResponse(
                    recipientId: conversationType,
                    text: receivedValues.last,
                  ),
                );
                return;
              }
              break;
            case "measurement":
              if (addingDevicesInHublist) {
                return;
              }
              if (!checkForParedDevice()) return;
              if ((hublistController.bleMacId ?? '').isNotEmpty &&
                  (hublistController.bleDeviceType ?? '').isNotEmpty &&
                  (hublistController.manufacturer ?? '').isNotEmpty) {
                receivedData = true;
                updateUserData(
                  data: receivedValues.last,
                );
              }

              break;
            case "bgl":
              if (addingDevicesInHublist) {
                return;
              }
              addBGLMessage(receivedValues.last);
              break;
            case "disconnected":
              FlutterToast().getToast(
                "Bluetooth Disconnected",
                Colors.red,
              );
              _disableTimer();
              if (receivedData) {
                return;
              }
              showFailure();
              break;
            case "connectionfailed":
              _disableTimer();
              await Future.delayed(const Duration(seconds: 2));
              //setupListenerForReadings();
              break;

            default:
          }
        }
      },
    );

    if (addingDevicesInHublist) {
      bleMethodChannel.invokeListMethod('scanAll');
    } else {
      final devicesList =
          (hublistController.hubListResponse!.result!.userDeviceCollection ??
              []);
      List pairedDevices = [];
      for (var device in devicesList) {
        var deviceManufacturer = device.manufacturer;
        var deviceType = getDeviceCode(device.device?.deviceType?.code);
        final deviceDetails = {
          'deviceType': deviceType.toString(),
          'manufacture': deviceManufacturer.toString(),
        };
        if (isFromVitals) {
          if (filteredDeviceType.toLowerCase() == deviceType.toLowerCase()) {
            pairedDevices.add(deviceDetails);
          }
        } else {
          pairedDevices.add(deviceDetails);
        }
      }
      bleMethodChannel.invokeListMethod('scanSingle', pairedDevices);
    }
  }

  String getDeviceCode(String? deviceCode) {
    String deviceType;
    switch (deviceCode) {
      case 'BPMONT':
        deviceType = 'BP';
        break;
      case 'GLUCMT':
        deviceType = 'BGL';
        break;
      case 'PULOXY':
        deviceType = 'SPO2';
        break;
      case 'THERMO':
        deviceType = 'Temp';
        break;
      case 'WEIGHS':
        deviceType = 'Weight';
        break;
      default:
        deviceType = 'All';
    }
    return deviceType;
  }

  bool checkForParedDevice() {
    try {
      final devicesList =
          (hublistController.hubListResponse!.result!.userDeviceCollection ??
              []);
      if (devicesList.isEmpty) {
        return false;
      }
      var index = -1;
      index = devicesList.indexWhere(
        (element) => (CommonUtil().validString(element.device!.serialNumber) ==
            hublistController.bleMacId),
      );
      String deviceType = hublistController.bleDeviceType?.toLowerCase() ?? '';
      bool filteredDeviceTypeCheck = true;
      if (isFromVitals || isFromRegiment) {
        if (filteredDeviceType.isNotEmpty) {
          if (deviceType != filteredDeviceType) filteredDeviceTypeCheck = false;
        }
      }
      return (index >= 0 && filteredDeviceTypeCheck);
    } catch (e) {
      CommonUtil().appLogs(message: e.toString());

      printError(info: e.toString());
      return false;
    }
  }

  checkForBLEEnableConditions() async {
    try {
      if (Platform.isAndroid) {
        bool serviceEnabled = await CommonUtil().checkGPSIsOn();
        bool? isBluetoothEnable = false;
        isBluetoothEnable = await (CommonUtil().checkBluetoothIsOn());
        if (!isBluetoothEnable!) {
          FlutterToast().getToast(
              'Please turn on your bluetooth and try again', Colors.red);
          return false;
        } else if (!serviceEnabled) {
          FlutterToast().getToast(
              'Please turn on your GPS location services and try again',
              Colors.red);
          return false;
        }
        return true;
      } else {
        return true;
      }
    } catch (e) {
      CommonUtil().appLogs(message: e.toString());

      printError(info: e.toString());
      return false;
    }
  }

  startSheelaBLEDeviceReadings() {
    final arguments = SheelaController.arguments!;
    isCompleted = false;
    var msg = '';
    if ((arguments.deviceType ?? '').isNotEmpty) {
      String strText = CommonUtil().validString(arguments.deviceType);
      if (strText.toLowerCase() == "bgl") {
        msg =
            "Your Blood Glucose Monitor is connected. Please insert the test strip.";
      } else {
        if (strText.toLowerCase() == "weight") {
          strText = "Weighing scale";
        }
        msg = "Your $strText device is connected & reading values. Please wait";
      }
    }

    if (msg.isNotEmpty) {
      addToConversationAndPlay(
        SheelaResponse(
          recipientId: conversationType,
          text: msg,
        ),
      );
      if (strText.toLowerCase().contains("bgl")) {
        playConversations.add(SheelaResponse(
          recipientId: conversationType,
          text: "Please insert strip",
        ));
      }
      refreshTimeoutTimer();
    }
  }

  addBGLMessage(String msg) {
    final conv = SheelaResponse(
      recipientId: conversationType,
      text: msg,
    );
    if (isPlaying) {
      playConversations.add(conv);
    } else {
      addToConversationAndPlay(conv);
    }
  }

  addToConversationAndPlay(SheelaResponse conv) {
    playConversations.add(conv);
    playTTS();
  }

  showFailure() async {
    if (SheelaController.isSheelaScreenActive &&
        !isCompleted &&
        !receivedData) {
      addToConversationAndPlay(
        SheelaResponse(
          recipientId: conversationType,
          text: "Failed to save the values, Please try again",
        ),
      );
      isCompleted = true;
      await Future.delayed(const Duration(seconds: 2));
    }
  }

// final model = BleDataModel(
//         data: Data(bgl: "115.0"),
//         status: "Measurement",
//         deviceType: "BGL",
//       );
// Future.delayed(const Duration(seconds: 5)).then((_) {
//                   updateUserData();
//                 });
  updateUserData({String data = ''}) async {
    // await Future.delayed(
    //   const Duration(
    //     seconds: 2,
    //   ),
    // );
    if ((data).isNotEmpty &&
        SheelaController.canSpeak &&
        (SheelaController.arguments?.takeActiveDeviceReadings ?? false)) {
      try {
        final model = BleDataModel.fromJson(
          jsonDecode(data),
        );

        if (model.deviceType?.toLowerCase() == "bgl" &&
            (model.data!.bgl ?? '').isNotEmpty) {
          var val = double.tryParse(model.data!.bgl!) ?? 0.0;
          model.data!.bgl = val.truncate().toString();
        }
        if (model.deviceType?.toLowerCase() == "weight" &&
            (model.data!.weight ?? '').isNotEmpty) {
          model.deviceType = model.deviceType?.toUpperCase();
          try {
            weightUnit = PreferenceUtil.getStringValue(STR_KEY_WEIGHT)!;
          } catch (e) {
            CommonUtil().appLogs(message: e.toString());
          }
          if ((weightUnit).isEmpty) {
            weightUnit = CommonUtil.REGION_CODE == "IN"
                ? STR_VAL_WEIGHT_IND
                : STR_VAL_WEIGHT_US;
          }
          double convertedWeight = 1.000;
          try {
            convertedWeight = double.parse(model.data!.weight!);
          } catch (e) {
            convertedWeight = 1.000;
            CommonUtil().appLogs(message: e.toString());
          }
          if (weightUnit == STR_VAL_WEIGHT_US) {
            convertedWeight = (convertedWeight * 2.205);
          }
          model.data!.weight = convertedWeight.toStringAsFixed(2);
        }
        // model.hubId = hublistController.virtualHubId;
        model.deviceId = hublistController.bleMacId;
        model.eid = hublistController.eid;
        model.uid = hublistController.uid;
        final DateFormat formatterDateTime = DateFormat('yyyy-MM-dd HH:mm:ss');
        final String actualDateTime = formatterDateTime.format(DateTime.now());
        model.ackLocal = actualDateTime;
        hublistController.eid = null;
        hublistController.uid = null;
        final bool response =
            await BleConnectApiProvider().uploadBleDataReadings(
          model,
        );
        if (!response) {
          receivedData = false;
          showFailure();
        } else if (model.deviceType == "SPO2") {
          if ((model.data!.sPO2 ?? '').isNotEmpty &&
              (model.data!.pulse ?? '').isNotEmpty) {
            addToConversationAndPlay(
              SheelaResponse(
                recipientId: conversationType,
                text:
                    "Completed reading values. Please take your finger from the device",
              ),
            );
            playConversations.add(
              SheelaResponse(
                recipientId: conversationType,
                text:
                    "Thank you. Your last reading for SPO2 ${model.data!.sPO2} and Pulse ${model.data!.pulse} are successfully recorded. Bye!.",
              ),
            );
            await Future.delayed(const Duration(seconds: 2));
          } else {
            receivedData = false;
            showFailure();
          }
        } else if (model.deviceType?.toLowerCase() == "bgl") {
          if ((model.data?.bgl ?? '').isNotEmpty) {
            addToConversationAndPlay(
              SheelaResponse(
                recipientId: conversationType,
                text:
                    "Your Blood Glucose value ${model.data!.bgl} mg/dL is recorded successfully.",
              ),
            );
            await Future.delayed(const Duration(seconds: 2));
          } else {
            receivedData = false;
            showFailure();
          }
        } else if (model.deviceType == "BP") {
          if ((model.data!.systolic ?? '').isNotEmpty &&
              (model.data!.diastolic ?? '').isNotEmpty &&
              (model.data!.pulse ?? '').isNotEmpty) {
            addToConversationAndPlay(
              SheelaResponse(
                recipientId: conversationType,
                text: "Thank you. Your BP systolic ${model.data!.systolic} "
                    ", Diastolic ${model.data!.diastolic} "
                    "and Pulse ${model.data!.pulse} are successfully recorded. Bye!.",
              ),
            );
            await Future.delayed(const Duration(seconds: 2));
          } else {
            receivedData = false;
            showFailure();
          }
        } else if (model.deviceType?.toLowerCase() == "weight") {
          if ((model.data!.weight ?? '').isNotEmpty) {
            addToConversationAndPlay(
              SheelaResponse(
                recipientId: conversationType,
                text:
                    "Thank you. Your Weight ${model.data!.weight} ${weightUnit} is successfully recorded. Bye!.",
              ),
            );
            await Future.delayed(const Duration(seconds: 2));
          } else {
            receivedData = false;
            showFailure();
          }
        }
        isCompleted = true;
      } catch (e) {
        CommonUtil().appLogs(message: e.toString());

        receivedData = false;
        showFailure();
      }
    }
  }

  playTTS() async {
    if ((playConversations).isEmpty || isPlaying) {
      return;
    }
    final currentPlayingConversation = playConversations.first;
    if (!SheelaController.canSpeak) {
      stopTTS();
      return;
    }
    if (SheelaController.useLocalTTSEngine) {
      try {
        if ((currentPlayingConversation.text ?? '').isNotEmpty) {
          SheelaController.conversations.add(currentPlayingConversation);
          SheelaController.isMicListening.toggle();
          isPlaying = true;
          final status = await SheelaController.playUsingLocalTTSEngineFor(
              currentPlayingConversation.text);
          playConversations.removeAt(0);
          isPlaying = false;
          if (isCompleted) {
            await Future.delayed(const Duration(seconds: 4));

            stopTTS();
          }
          if ((playConversations).isNotEmpty) {
            playTTS();
          }
        }
      } catch (e) {
        CommonUtil().appLogs(message: e.toString());

        stopTTS();
      }
    } else {
      String? textForPlaying;
      if ((currentPlayingConversation.text ?? '').isNotEmpty) {
        final result = await SheelaController.getGoogleTTSForText(
            currentPlayingConversation.text);
        if ((result!.payload!.audioContent ?? '').isNotEmpty) {
          textForPlaying = result.payload!.audioContent;
        }
      }
      playConversations.removeAt(0);
      if ((textForPlaying ?? '').isNotEmpty) {
        try {
          final bytes = base64Decode(textForPlaying!);
          if (bytes != null) {
            final dir = await getTemporaryDirectory();
            randomNum++;
            if (randomNum > 4) {
              randomNum = 0;
            }
            final tempFile =
                await File('${dir.path}/tempAudioFile$randomNum.mp3').create();
            tempFile.writeAsBytesSync(
              bytes,
            );

            SheelaController.conversations.add(currentPlayingConversation);
            SheelaController.isMicListening.toggle();
            currentPlayingConversation.isPlaying.value = true;
            isPlaying = true;
            await player.play('${dir.path}/tempAudioFile$randomNum.mp3',
                isLocal: true);
          }
        } catch (e) {
          CommonUtil().appLogs(message: e.toString());

          //failed play the audio
          print(e.toString());
          stopTTS();
        }
      }
    }
  }

  stopTTS() {
    player.stop();
    if (SheelaController.useLocalTTSEngine) {
      SheelaController.playUsingLocalTTSEngineFor("", close: true);
    }
    playConversations = [];
    isPlaying = false;
    _disableTimer();
    SheelaController.isMicListening(false);
    SheelaController.bleController = null;
    if (SheelaController.isSheelaScreenActive) {
      if (isFromVitals) {
        if (Get.isRegistered<VitalDetailController>())
          Future.delayed(const Duration(seconds: 1)).then((value) {
            Get.find<VitalDetailController>().getData();
          });
      }
      if (isFromRegiment) {
        if (Get.isRegistered<QurhomeRegimenController>())
          Future.delayed(const Duration(seconds: 1)).then((value) {
            Get.find<QurhomeRegimenController>().currLoggedEID.value =
                hublistController.eid!;
            Get.find<QurhomeRegimenController>().getRegimenList();
          });
      }
    }
  }

  void stopScanning() {
    _disableTimer();
  }

  removeTimeOutTimer() {
    if (timeOutTimer != null) {
      timeOutTimer!.cancel();
    }
    timeOutTimer = null;
  }

  void _disableTimer() {
    if (timerSubscription != null) {
      timerSubscription!.cancel();
    }
    timerSubscription = null;
    isFromRegiment = false;
    addingDevicesInHublist = false;
    isFromVitals = false;
    filteredDeviceType = '';
    removeTimeOutTimer();
    SheelaController.isBLEStatus.value = BLEStatus.Disabled;
  }
}
