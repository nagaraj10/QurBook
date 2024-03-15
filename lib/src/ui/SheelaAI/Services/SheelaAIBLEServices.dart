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
  StreamSubscription? troubleShootTimerSubscription;

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
  String troubleShootStatus = '';

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
          // for play buttons
          SheelaController.afterCompletedAudioPlayer();
          if ((playConversations).isNotEmpty) {
            await playTTS();
          } else if (isCompleted) {
            // Check if isDeviceConnectSheelaScreen's value is true and isLastActivityDevice is false or null.
            if ((SheelaController.isDeviceConnectSheelaScreen.value) && (!(SheelaController.isLastActivityDevice ?? true))) {
              // If isDeviceConnectSheelaScreen is true and isLastActivityDevice is false or null:

              // Delay execution of the subsequent code block by 2 seconds.
              Future.delayed(const Duration(seconds: 2)).then((value) {
                // After 2 seconds, call getAIAPIResponseFor with sheelaQueueShowRemind as the parameter.
                SheelaController.getAIAPIResponseFor(sheelaQueueShowRemind, null);
              });
            } else {
              // If isDeviceConnectSheelaScreen is false or isLastActivityDevice is true:

              // Delay execution of the subsequent code block by 4 seconds.
              await Future.delayed(const Duration(seconds: 4));

              // Stop Text-to-Speech functionality.
              stopTTS();

              // Check if Sheela screen is active and if true, navigate back.
              if (SheelaController.isSheelaScreenActive) Get.back();
            }

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
    } catch (e, stackTrace) {
      CommonUtil().appLogs(message: e, stackTrace: stackTrace);

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
      final devicesList = (hublistController.hubListResponse?.result ?? []);
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
              /*FlutterToast().getToast(
                SearchingForDevices,
                Colors.green,
              );*/
              break;
            case "enablebluetooth":
              FlutterToast().getToast(
                receivedValues.last ?? pleaseTurnOnYourBluetoothAndTryAgain,
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
/*                  FlutterToast().getToast(
                    deviceConnected,
                    Colors.green,
                  );*/
                  if (isFromVitals || isFromRegiment) {
                    Get.back();
                  }
                  // Check if Sheela screen is active and there is a retry for scan failure
                  if (SheelaController.isSheelaScreenActive &&
                      (SheelaController.isRetryScanFailure ?? false)) {
                    // Set device type in SheelaController arguments based on bleDeviceType from hublistController
                    SheelaController.arguments?.deviceType =
                        hublistController.bleDeviceType;

                    // this is for enable the takeActiveDeviceReadings flow
                    SheelaController.arguments?.takeActiveDeviceReadings = true;

                    // Clear the reconnect timer in SheelaController
                    SheelaController.clearReconnectTimer();

                    // Start reading Sheela BLE device readings
                    startSheelaBLEDeviceReadings();

                    // Reset the retry scan failure flag
                    SheelaController.isRetryScanFailure = false;

                    // Set loading state to true in SheelaController
                    SheelaController.isLoading(true);
                  } // Check if Sheela screen is active and if isDeviceConnectSheelaScreen's value is true.
                  else if (SheelaController.isSheelaScreenActive &&
                      (SheelaController.isDeviceConnectSheelaScreen.value)) {
                    // If Sheela screen is active and isDeviceConnectSheelaScreen is true:

                    // Set the device type in SheelaController arguments based on bleDeviceType from hublistController.
                    SheelaController.arguments?.deviceType = hublistController.bleDeviceType;

                    // Check if the shortName of the last conversation's deviceData in SheelaController matches the deviceType.
                    if (SheelaController
                        .conversations
                        .last
                        ?.additionalInfoSheelaResponse
                        ?.deviceData
                        ?.shortName
                        ?.toString()
                        .toLowerCase() ==
                        deviceType) {
                      // If the shortName matches the deviceType:

                      // Set isSameVitalDevice to true in SheelaController.
                      SheelaController.isSameVitalDevice = true;

                      // Set takeActiveDeviceReadings to true in SheelaController arguments.
                      SheelaController.arguments?.takeActiveDeviceReadings = true;

                      // Start reading Sheela BLE device readings.
                      startSheelaBLEDeviceReadings();

                      // Clear the clearDeviceConnectionTimer timer in SheelaController
                      SheelaController.clearDeviceConnectionTimer();

                      // Set loading state to true in SheelaController.
                      SheelaController.isLoading(true);
                    } else {
                      // If shortName doesn't match deviceType, exit the loop (not shown in provided code).
                      break;
                    }
                  } else {
                    Get.to(
                      () => SheelaAIMainScreen(
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
                    // this is for disable the isSameVitalDevice for other device try to connect
                    SheelaController.isSameVitalDevice = false;
                  }
                }
              }
              break;
            case "update":
              if (addingDevicesInHublist) {
                return;
              }
              if (SheelaController.isSheelaScreenActive) {
                String? strTextMsg = await SheelaController.getTextTranslate(
                    receivedValues.last ?? '');
                addToConversationAndPlay(
                  SheelaResponse(
                    recipientId: conversationType,
                    text: strTextMsg,
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
              if (SheelaController.isSheelaScreenActive &&
                  (SheelaController.isDeviceConnectSheelaScreen.value) &&
                  (!(SheelaController.isSameVitalDevice ?? false))) {
                Future.delayed(const Duration(seconds: 2)).then((value) {
                  SheelaController.resetBLE();
                });
                break;
              }
              _disableTimer();
              showFailure();
              await Future.delayed(const Duration(seconds: 2));
              break;

            default:
          }
        }
      },
    );

    if (addingDevicesInHublist) {
      bleMethodChannel.invokeListMethod('scanAll');
    } else {
      final devicesList = (hublistController.hubListResponse?.result ?? []);
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

  void troubleShootTheBluetooth() {
    troubleShootTimerSubscription = stream.listen(
      (event) {
        if (event == null || event == "") {
          return;
        }
        final List<String>? receivedValues = event.split('|');
        if ((receivedValues ?? []).isNotEmpty) {
          troubleShootStatus = receivedValues!.first;
        }
      },
    );
    bleMethodChannel.invokeListMethod('scanAll');
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
      final devicesList = (hublistController.hubListResponse?.result ?? []);
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
    } catch (e, stackTrace) {
      CommonUtil().appLogs(message: e, stackTrace: stackTrace);

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
          FlutterToast()
              .getToast(pleaseTurnOnYourBluetoothAndTryAgain, Colors.red);
          return false;
        } else if (!serviceEnabled) {
          FlutterToast().getToast(
              strTurnOnGPS,
              Colors.red);
          return false;
        }
        return true;
      } else {
        return true;
      }
    } catch (e, stackTrace) {
      CommonUtil().appLogs(message: e, stackTrace: stackTrace);

      printError(info: e.toString());
      return false;
    }
  }

  startSheelaBLEDeviceReadings() async {
    final arguments = SheelaController.arguments!;
    isCompleted = false;
    var msg = '';
    var strText = CommonUtil().validString(arguments.deviceType);
    if ((arguments.deviceType ?? '').isNotEmpty) {
      if (strText.toLowerCase() == "bgl") {
        msg = "Your Blood Glucose Monitor is connected.";
      } else {
        if (strText.toLowerCase() == "weight") {
          strText = "Weighing scale";
        }
        msg = "Your $strText device is connected & reading values. Please wait";
      }
    }

    if (msg.isNotEmpty) {
      String? strTextMsg = await SheelaController.getTextTranslate(msg ?? '');
      addToConversationAndPlay(
        SheelaResponse(
          recipientId: conversationType,
          text: strTextMsg,
        ),
      );
      if (strText.toLowerCase().contains("bgl")) {
        String? strTextMsg = await SheelaController.getTextTranslate(
            "Make sure the strip is inserted and a blood sample is added after insertion.");
        playConversations.add(SheelaResponse(
          recipientId: conversationType,
          text: strTextMsg,
        ));
      }
      refreshTimeoutTimer();
    }
  }

  addBGLMessage(String msg) async {
    String? strTextMsg = await SheelaController.getTextTranslate(msg ?? '');
    final conv = SheelaResponse(
      recipientId: conversationType,
      text: strTextMsg,
    );
    if (isPlaying) {
      playConversations.add(conv);
    } else {
      addToConversationAndPlay(conv);
    }
  }

  addToConversationAndPlay(SheelaResponse conv,{bool playButtons = false}) {
    playConversations.add(conv);
    //if(playButtons){
      SheelaController.isLoading.value = false;
    //}
    playTTS(playButtons: playButtons);
  }

  // Method to handle failure scenario
  showFailure() async {
    // Check if Sheela screen is active and the operation is not completed and no data is received
    if (SheelaController.isSheelaScreenActive && !isCompleted && !receivedData) {

      // Get translated failure message
      String? strTextMsg = await SheelaController.getTextTranslate(
          "Failed to save the values, Please try again");

      // Set loading state to true in SheelaController
      SheelaController.isLoading.value = true;

      // Set retry scan failure flag to true in SheelaController
      SheelaController.isRetryScanFailure = true;

      // Display failure message with options for retry
      addToConversationAndPlay(
        SheelaResponse(
          recipientId: conversationType,
          text: strTextMsg,
          buttons: await SheelaController.sheelaFailureRetryButtons(),
          endOfConv: false,
          endOfConvDiscardDialog: false,
          singleuse: true,
          isActionDone: false,
          isButtonNumber: false,
        ),
        playButtons: false,
      );

      // Set loading state to false in SheelaController
      SheelaController.isLoading.value = false;

      // Reset completed status
      isCompleted = false;

      // Introduce a delay before proceeding (2 seconds in this case)
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
          } catch (e, stackTrace) {
            CommonUtil().appLogs(message: e, stackTrace: stackTrace);
          }
          if ((weightUnit).isEmpty) {
            weightUnit = CommonUtil.REGION_CODE == "IN"
                ? STR_VAL_WEIGHT_IND
                : STR_VAL_WEIGHT_US;
          }
          double convertedWeight = 1.000;
          try {
            convertedWeight = double.parse(model.data!.weight!);
          } catch (e, stackTrace) {
            convertedWeight = 1.000;
            CommonUtil().appLogs(message: e, stackTrace: stackTrace);
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
            String? strTextMsg = await SheelaController.getTextTranslate(
                "Completed reading values. Please take your finger from the device");
            addToConversationAndPlay(
              SheelaResponse(
                recipientId: conversationType,
                text: strTextMsg,
              ),
            );
            String? strTextMsgTwo = await SheelaController.getTextTranslate(
                "Thank you. Your last reading for SPO2 ${model.data!.sPO2} and Pulse ${model.data!.pulse} are successfully recorded. Bye.");
            playConversations.add(
              SheelaResponse(
                recipientId: conversationType,
                text: strTextMsgTwo,
              ),
            );
            await Future.delayed(const Duration(seconds: 2));
          } else {
            receivedData = false;
            showFailure();
          }
        } else if (model.deviceType?.toLowerCase() == "bgl") {
          if ((model.data?.bgl ?? '').isNotEmpty) {
            String? strTextMsg = await SheelaController.getTextTranslate(
                "Your Blood Glucose value ${model.data!.bgl} is recorded successfully.");
            addToConversationAndPlay(
              SheelaResponse(
                recipientId: conversationType,
                text: strTextMsg,
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
            String? strTextMsg = await SheelaController.getTextTranslate(
                "Thank you. Your BP ${model.data!.systolic} "
                "over ${model.data!.diastolic} "
                "and pulse ${model.data!.pulse} are successfully recorded. Bye.");
            addToConversationAndPlay(
              SheelaResponse(
                recipientId: conversationType,
                text: strTextMsg,
              ),
            );
            await Future.delayed(const Duration(seconds: 2));
          } else {
            receivedData = false;
            showFailure();
          }
        } else if (model.deviceType?.toLowerCase() == "weight") {
          if ((model.data!.weight ?? '').isNotEmpty) {
            String? strTextMsg = await SheelaController.getTextTranslate(
                "Thank you. Your Weight ${model.data!.weight} ${weightUnit} is successfully recorded. Bye.");
            addToConversationAndPlay(
              SheelaResponse(
                recipientId: conversationType,
                text: strTextMsg,
              ),
            );
            await Future.delayed(const Duration(seconds: 2));
          } else {
            receivedData = false;
            showFailure();
          }
        }
        isCompleted = true;
        SheelaController.isRetryScanFailure = false;
        // this is for disable the isSameVitalDevice for other device try to connect
        SheelaController.isSameVitalDevice = false;
      } catch (e, stackTrace) {
        CommonUtil().appLogs(message: e, stackTrace: stackTrace);

        receivedData = false;
        showFailure();
      }
    }
  }

  playTTS({bool playButtons = false}) async {
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
              (getPronunciationText(currentPlayingConversation)
                      .trim()
                      .isNotEmpty
                  ? getPronunciationText(currentPlayingConversation)
                  : (currentPlayingConversation.text)));
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
      } catch (e, stackTrace) {
        CommonUtil().appLogs(message: e, stackTrace: stackTrace);

        stopTTS();
      }
    } else {
      String? textForPlaying;
        if ((currentPlayingConversation.text ?? '').isNotEmpty) {
          final result = await SheelaController.getGoogleTTSForText(
              (getPronunciationText(currentPlayingConversation).trim().isNotEmpty
                  ? getPronunciationText(currentPlayingConversation)
                  : (currentPlayingConversation?.text)));
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
            // Assign the 'currentPlayingConversation' to 'SheelaController.currentPlayingConversation'
            SheelaController.currentPlayingConversation = currentPlayingConversation;
            SheelaController.conversations.add(currentPlayingConversation);
            SheelaController.isMicListening.toggle();
            currentPlayingConversation.isPlaying.value = true;
            isPlaying = true;
            SheelaController.scrollToEnd();
            await player.play('${dir.path}/tempAudioFile$randomNum.mp3',
                isLocal: true);
          }
        } catch (e, stackTrace) {
          CommonUtil().appLogs(message: e, stackTrace: stackTrace);

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

  String getPronunciationText(SheelaResponse? currentPlayingConversation) {
    return CommonUtil()
        .validString(currentPlayingConversation!.pronunciationText ?? '');
  }
}
