import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:gmiwidgetspackage/widgets/flutterToast.dart';
import 'package:intl/intl.dart';
import 'package:myfhb/QurHub/Controller/HubListViewController.dart';
import 'package:myfhb/constants/router_variable.dart';
import 'package:myfhb/src/ui/SheelaAI/Models/sheela_arguments.dart';
import 'package:path_provider/path_provider.dart';

import '../../../../QurHub/Controller/hub_list_controller.dart';
import '../../../../Qurhome/BleConnect/ApiProvider/ble_connect_api_provider.dart';
import '../../../../Qurhome/BleConnect/Models/ble_data_model.dart';
import '../../../../Qurhome/QurhomeDashboard/Controller/QurhomeDashboardController.dart';
import '../../../../common/CommonUtil.dart';
import '../Controller/SheelaAIController.dart';
import '../Models/SheelaResponse.dart';

class SheelaBLEController extends GetxController {
  SheelaAIController SheelaController;
  HubListViewController hublistController;

  Stream stream = EventChannel('QurbookBLE/stream').receiveBroadcastStream();
  StreamSubscription _timerSubscription;

  Timer timeOutTimer;
  final String conversationType = "BLESheelaConversations";
  List<SheelaResponse> playConversations = [];
  bool isPlaying = false;
  bool isCompleted = false;
  bool isFromVitals = false;
  bool addingDevicesInHublist = false;
  AudioPlayer player;

  @override
  void onInit() {
    super.onInit();
    player = AudioPlayer();
    listnerForAudioPlayer();
    SheelaController = Get.find();
    hublistController = Get.find();
  }

  listnerForAudioPlayer() {
    player.onPlayerStateChanged.listen(
      (event) async {
        if (event == PlayerState.COMPLETED) {
          if ((playConversations ?? []).isNotEmpty) {
            playConversations.removeAt(0);
            isPlaying = false;
            if (isCompleted) {
              await Future.delayed(const Duration(seconds: 4));
              stopTTS();
            }
            if ((playConversations ?? []).isNotEmpty) {
              playTTS();
            }
          }
        }
      },
    );
  }

  setupListenerForReadings() async {
    _enableTimer();
    // timeOutTimer = Timer(
    //   const Duration(seconds: 120),
    //   () {
    //     showFailure();
    //   },
    // );
  }

  void _enableTimer() {
    if (_timerSubscription != null) {
      return;
    }
    _timerSubscription = stream.listen(
      (val) {
        final List<String> receivedValues = val.split('|');
        if ((receivedValues ?? []).length > 0) {
          switch (receivedValues.first ?? "") {
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
              FlutterToast().getToast(
                receivedValues.last,
                Colors.red,
              );
              hublistController.bleMacId = CommonUtil().validString(
                receivedValues.last,
              );
              break;
            case "bleDeviceType":
              FlutterToast().getToast(
                receivedValues.last,
                Colors.red,
              );
              hublistController.bleDeviceType = CommonUtil().validString(
                receivedValues.last,
              );
              break;
            case "connected":
              FlutterToast().getToast(
                receivedValues.last,
                Colors.red,
              );
              if (addingDevicesInHublist) {
                hublistController.searchingBleDevice(false);
                _disableTimer();
                return;
              }

              if (checkForParedDevice()) {
                //found paired device
                if (hublistController.bleDeviceType.toLowerCase() ==
                    "SPO2".toLowerCase()) {
                  _disableTimer();

                  Get.toNamed(
                    rt_Sheela,
                    arguments: SheelaArgument(
                      takeActiveDeviceReadings: true,
                    ),
                  );
                }
              } else {
                FlutterToast().getToastForLongTime(
                  'No device found',
                  Colors.red,
                );
              }

              break;
            case "measurement":
              updateUserData(
                data: receivedValues.last,
              );
              break;
            case "disconnected":
              FlutterToast().getToast(
                "Bluetooth Disconnected",
                Colors.red,
              );
              break;
            default:
          }
        }
      },
    );
  }

  bool checkForParedDevice() {
    try {
      var userDeviceCollection =
          hublistController.hubListResponse.result.userDeviceCollection;
      var index = -1;
      index = userDeviceCollection.indexWhere(
        (element) => (CommonUtil().validString(element.device.serialNumber) ==
            hublistController.bleMacId),
      );
      return index >= 0;
    } catch (e) {
      return false;
    }
  }

  checkForConnectedDevices(
    bool isFromVitalsList, {
    String eid,
    String uid,
  }) async {
    if ((hublistController.hubListResponse.result.userDeviceCollection ?? [])
        .isEmpty) {
      if (!isFromVitalsList) {}
    } else {
      try {
        if (Platform.isAndroid) {
          bool serviceEnabled = await CommonUtil().checkGPSIsOn();
          bool isBluetoothEnable = false;
          isBluetoothEnable = await CommonUtil().checkBluetoothIsOn();
          if (!isBluetoothEnable) {
            FlutterToast().getToast(
                'Please turn on your bluetooth and try again', Colors.red);
            return;
          } else if (!serviceEnabled) {
            FlutterToast().getToast(
                'Please turn on your GPS location services and try again',
                Colors.red);
            return;
          }
        }
      } catch (e) {
        print(e);
      }
    }
  }

  startSheelaBLEDeviceReadings() {
    final arguments = SheelaController.arguments;
    isCompleted = false;
    var msg = '';
    if (arguments.isJumperDevice && (arguments.deviceType ?? '').isNotEmpty) {
      String strText = CommonUtil().validString(arguments.deviceType);
      if (strText.toLowerCase() == "weight") {
        strText = "Weighing scale";
      }
      msg = "Your $strText is connected & reading values. Please wait";
      setupListenerForReadings();
    } else if (arguments.takeActiveDeviceReadings) {
      msg = "Your SPO2 device is connected & reading values. Please wait";
      setupListenerForReadings();
    } else if (arguments.isFromBpReading) {
      msg:
      "Your BP device is connected & reading values. Please wait..";
    }
    if (msg.isNotEmpty) {
      addToConversationAndPlay(
          SheelaResponse(recipientId: conversationType, text: msg));
    }
  }

  addToConversationAndPlay(SheelaResponse conv) {
    playConversations.add(conv);
    playTTS();
  }

  showFailure() async {
    addToConversationAndPlay(
      SheelaResponse(
        recipientId: conversationType,
        text: "Failed to save the values, Please try again",
      ),
    );
    isCompleted = true;
    await Future.delayed(const Duration(seconds: 2));
  }

  updateUserData({String data = ''}) async {
    if ((data ?? '').isNotEmpty && SheelaController.canSpeak) {
      // _disableTimer();
      try {
        final model = BleDataModel.fromJson(
          jsonDecode(data),
        );
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
          showFailure();
        } else if (model.deviceType == "SPO2") {
          if ((model.data.sPO2 ?? '').isNotEmpty &&
              (model.data.pulse ?? '').isNotEmpty) {
            addToConversationAndPlay(
              SheelaResponse(
                recipientId: conversationType,
                text:
                    "Completed reading values. Please take your finger from the device",
              ),
            );
            await Future.delayed(const Duration(seconds: 5));
            addToConversationAndPlay(
              SheelaResponse(
                recipientId: conversationType,
                text:
                    "Thank you. Your last reading for SPO2 is  ${model.data.sPO2} and Pulse is ${model.data.pulse} is successfully recorded, Bye!",
              ),
            );
            await Future.delayed(const Duration(seconds: 2));
          } else {
            showFailure();
          }
        }

        isCompleted = true;
      } catch (e) {
        showFailure();
      }
    }
  }

  playTTS() async {
    if ((playConversations ?? []).isEmpty || isPlaying) {
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
          if ((playConversations ?? []).isNotEmpty) {
            playTTS();
          }
        }
      } catch (e) {
        stopTTS();
      }
    } else {
      String textForPlaying;
      if ((currentPlayingConversation.text ?? '').isNotEmpty) {
        final result = await SheelaController.getGoogleTTSForText(
            currentPlayingConversation.text);
        if ((result.payload?.audioContent ?? '').isNotEmpty) {
          textForPlaying = result.payload.audioContent;
        }
      }
      if ((textForPlaying ?? '').isNotEmpty) {
        try {
          final bytes = const Base64Decoder().convert(textForPlaying);
          if (bytes != null) {
            final dir = await getTemporaryDirectory();
            final file = File('${dir.path}/tempAudioFile.mp3');
            await file.writeAsBytes(bytes);
            final path = "${dir.path}/tempAudioFile.mp3";
            SheelaController.conversations.add(currentPlayingConversation);
            SheelaController.isMicListening.toggle();
            currentPlayingConversation.isPlaying.value = true;
            isPlaying = true;
            await player.play(path, isLocal: true);
          }
        } catch (e) {
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
      Get.back();
    }
  }

  void stopScanning() {
    _disableTimer();
  }

  void _disableTimer() {
    if (_timerSubscription != null) {
      _timerSubscription.cancel();
      _timerSubscription = null;
    }
    if (timeOutTimer != null) {
      timeOutTimer.cancel();
      timeOutTimer = null;
    }
  }
}
