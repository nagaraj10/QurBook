import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:gmiwidgetspackage/widgets/flutterToast.dart';
import 'package:intl/intl.dart';
import '../../../../Qurhome/QurhomeDashboard/Controller/QurhomeRegimenController.dart';
import 'package:path_provider/path_provider.dart';

import '../../../../QurHub/Controller/HubListViewController.dart';
import '../../../../Qurhome/BleConnect/ApiProvider/ble_connect_api_provider.dart';
import '../../../../Qurhome/BleConnect/Models/ble_data_model.dart';
import '../../../../Qurhome/QurHomeVitals/viewModel/VitalDetailController.dart';
import '../../../../common/CommonUtil.dart';
import '../Controller/SheelaAIController.dart';
import '../Models/SheelaResponse.dart';
import '../Models/sheela_arguments.dart';
import '../Views/SheelaAIMainScreen.dart';

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
  bool isFromRegiment = false;
  bool addingDevicesInHublist = false;
  bool receivedData = false;
  AudioPlayer player;
  int randomNum = 0;

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
    try {
      bool status = await checkForBLEEnableConditions();
      if (!status) {
        return;
      }
      _enableTimer();
    } catch (e) {
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
    if (_timerSubscription != null) {
      return;
    }

    _timerSubscription = stream.listen(
      (val) async {
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
              // FlutterToast().getToast(
              //   receivedValues.last,
              //   Colors.red,
              // );
              hublistController.bleMacId = CommonUtil().validString(
                receivedValues.last,
              );
              break;
            case "bleDeviceType":
              // FlutterToast().getToast(
              //   receivedValues.last,
              //   Colors.red,
              // );
              hublistController.bleDeviceType = CommonUtil().validString(
                receivedValues.last,
              );
              if (addingDevicesInHublist) {
                hublistController.searchingBleDevice(false);
                hublistController.navigateToAddDeviceScreen();
                _disableTimer();
                return;
              }
              break;
            case "connected":
              receivedData = false;
              // FlutterToast().getToast(
              //   receivedValues.last,
              //   Colors.red,
              // );
              if (!checkForParedDevice()) {
                _disableTimer();
                return;
              }
              if (hublistController.bleDeviceType.toLowerCase() ==
                      "SPO2".toLowerCase() ||
                  hublistController.bleDeviceType.toLowerCase() ==
                      "BP".toLowerCase() ||
                  hublistController.bleDeviceType.toLowerCase() ==
                      "weight".toLowerCase()) {
                //show next method
                if (isFromVitals || isFromRegiment) {
                  Get.back();
                }
                Get.to(
                  SheelaAIMainScreen(
                    arguments: SheelaArgument(
                      deviceType: hublistController.bleDeviceType,
                      takeActiveDeviceReadings: true,
                    ),
                  ),
                ).then((_) {
                  Future.delayed(const Duration(seconds: 1)).then((value) {
                    Get.find<VitalDetailController>().getData();
                  });
                  Future.delayed(const Duration(seconds: 1)).then((value) {
                    Get.find<QurhomeRegimenController>().currLoggedEID.value =
                        hublistController.eid;
                    Get.find<QurhomeRegimenController>().getRegimenList();
                  });
                });
              }
              break;
            case "measurement":
              receivedData = true;
              if (hublistController.bleDeviceType.toLowerCase() ==
                  "BP".toLowerCase()) {
                //show next method
                if (SheelaController.isSheelaScreenActive) {
                  updateUserData(
                    data: receivedValues.last,
                  );
                  return;
                }
                if (isFromVitals || isFromRegiment) {
                  Get.back();
                }
                Get.to(
                  SheelaAIMainScreen(
                    arguments: SheelaArgument(
                      takeActiveDeviceReadings: true,
                    ),
                  ),
                ).then((_) {
                  Future.delayed(const Duration(seconds: 1)).then((value) {
                    Get.find<VitalDetailController>().getData();
                  });
                  Future.delayed(const Duration(seconds: 1)).then((value) {
                    Get.find<QurhomeRegimenController>().currLoggedEID.value =
                        hublistController.eid;
                    Get.find<QurhomeRegimenController>().getRegimenList();
                  });
                });
                await Future.delayed(const Duration(seconds: 4));
              }
              updateUserData(
                data: receivedValues.last,
              );
              break;
            case "disconnected":
              // FlutterToast().getToast(
              //   "Bluetooth Disconnected",
              //   Colors.red,
              // );
              break;
            default:
          }
        }
      },
    );
  }

  bool checkForParedDevice() {
    try {
      final devicesList =
          (hublistController.hubListResponse.result.userDeviceCollection ?? []);
      if (devicesList.isEmpty) {
        //no paired devices
        return false;
      }
      var index = -1;
      index = devicesList.indexWhere(
        (element) => (CommonUtil().validString(element.device.serialNumber) ==
            hublistController.bleMacId),
      );
      return index >= 0;
    } catch (e) {
      printError(info: e.toString());
      return false;
    }
  }

  checkForBLEEnableConditions() async {
    try {
      if (Platform.isAndroid) {
        bool serviceEnabled = await CommonUtil().checkGPSIsOn();
        bool isBluetoothEnable = false;
        isBluetoothEnable = await CommonUtil().checkBluetoothIsOn();
        if (!isBluetoothEnable) {
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
      printError(info: e.toString());
      return false;
    }
  }

  startSheelaBLEDeviceReadings() {
    final arguments = SheelaController.arguments;
    isCompleted = false;
    var msg = '';
    if ((arguments.deviceType ?? '').isNotEmpty) {
      String strText = CommonUtil().validString(arguments.deviceType);
      if (strText.toLowerCase() == "weight") {
        strText = "Weighing scale";
      }
      msg = "Your $strText device is connected & reading values. Please wait";
    }

    if (msg.isNotEmpty) {
      addToConversationAndPlay(
        SheelaResponse(
          recipientId: conversationType,
          text: msg,
        ),
      );
      refreshTimeoutTimer();
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

  updateUserData({String data = ''}) async {
    await Future.delayed(
      const Duration(
        seconds: 2,
      ),
    );
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
          receivedData = false;
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
            receivedData = false;
            showFailure();
          }
        } else if (model.deviceType == "BP") {
          if ((model.data.systolic ?? '').isNotEmpty &&
              (model.data.diastolic ?? '').isNotEmpty &&
              (model.data.pulse ?? '').isNotEmpty) {
            addToConversationAndPlay(
              SheelaResponse(
                recipientId: conversationType,
                text: "Thank you. Your BP systolic is ${model.data.systolic} "
                    ", Diastolic is ${model.data.diastolic} "
                    "and Pulse is ${model.data.pulse} is successfully recorded, Bye!",
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
        receivedData = false;
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
          final bytes = base64Decode(textForPlaying);
          if (bytes != null) {
            final dir = await getTemporaryDirectory();
            randomNum++;
            if (randomNum > 4) {
              randomNum = 0;
            }
            final tempFile =
                await File('${dir.path}/tempAudioFile$randomNum.mp3').create();
            await tempFile.writeAsBytesSync(
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
        Future.delayed(const Duration(seconds: 1)).then((value) {
          Get.find<VitalDetailController>().getData();
        });
      }
      if (isFromRegiment) {
        Future.delayed(const Duration(seconds: 1)).then((value) {
          Get.find<QurhomeRegimenController>().currLoggedEID.value =
              hublistController.eid;
          Get.find<QurhomeRegimenController>().getRegimenList();
        });
      }
      Get.back();
    }
  }

  void stopScanning() {
    _disableTimer();
  }

  removeTimeOutTimer() {
    if (timeOutTimer != null) {
      timeOutTimer.cancel();
      timeOutTimer = null;
    }
  }

  void _disableTimer() {
    isFromRegiment = false;
    addingDevicesInHublist = false;
    isFromVitals = false;
    if (_timerSubscription != null) {
      _timerSubscription.cancel();
      _timerSubscription = null;
    }
    removeTimeOutTimer();
  }
}
