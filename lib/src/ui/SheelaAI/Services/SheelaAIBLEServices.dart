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

import '../../../../QurHub/Controller/hub_list_controller.dart';
import '../../../../Qurhome/BleConnect/ApiProvider/ble_connect_api_provider.dart';
import '../../../../Qurhome/BleConnect/Models/ble_data_model.dart';
import '../../../../Qurhome/QurhomeDashboard/Controller/QurhomeDashboardController.dart';
import '../../../../common/CommonUtil.dart';
import '../Controller/SheelaAIController.dart';
import '../Models/SheelaResponse.dart';

class SheelaBLEController {
  SheelaAIController controller = Get.find<SheelaAIController>();
  static const stream = EventChannel('QurbookBLE/stream');
  StreamSubscription _timerSubscription;
  HubListController hublistController;
  QurhomeDashboardController qurhomeController;
  Timer timeOutTimer;
  final String conversationType = "BLESheelaConversations";
  List<SheelaResponse> playConversations = [];
  bool isPlaying = false;
  bool isCompleted = false;
  AudioPlayer player;

  startSheelaBLEDeviceReadings() {
    final arguments = controller.arguments;
    player = AudioPlayer();
    listnerForAudioPlayer();
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
      updateBPUserData();
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

  setupListenerForReadings({bool forJumperDevices = false}) async {
    _enableTimer();
    timeOutTimer = Timer(
      const Duration(seconds: 60),
      () {
        showFailure();
      },
    );
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

  void _enableTimer() {
    _timerSubscription ??= stream.receiveBroadcastStream().listen((val) {
      final List<String> receivedValues = val.split('|');
      if ((receivedValues ?? []).length > 0) {
        switch (receivedValues.first ?? "") {
          case "enablebluetooth":
            FlutterToast()
                .getToast(receivedValues.last ?? 'Request Timeout', Colors.red);
            break;
          case "permissiondenied":
            FlutterToast()
                .getToast(receivedValues.last ?? 'Request Timeout', Colors.red);
            showFailure();
            break;
          case "measurement":
            updateUserData(data: receivedValues.last);
            break;
          case "disconnected":
            FlutterToast().getToast("Disconnected", Colors.red);
            showFailure();
            break;
          default:
        }
      }
    });
  }

  updateUserData({String data = ''}) async {
    if ((data ?? '').isNotEmpty && controller.canSpeak) {
      _disableTimer();
      try {
        hublistController = Get.find<HubListController>();
        final model = BleDataModel.fromJson(
          jsonDecode(data),
        );
        model.hubId = hublistController.virtualHubId;
        model.deviceId = hublistController.bleMacId.value;
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
        // else if (model.deviceType.toLowerCase() == "weight") {
        //   if ((model.data.weight ?? '').isNotEmpty) {
        //     addToConversationAndPlay(
        //       SheelaResponse(
        //         recipientId: conversationType,
        //         text:
        //             "Thank you. Your Weight is  ${model.data.weight} kilograms is successfully recorded, Bye!",
        //       ),
        //     );
        //   } else {
        //     showFailure();
        //   }
        // } else if (model.deviceType == "BP") {
        //   if ((model.data.systolic ?? '').isNotEmpty &&
        //       (model.data.diastolic ?? '').isNotEmpty &&
        //       (model.data.pulse ?? '').isNotEmpty) {
        //     addToConversationAndPlay(
        //       SheelaResponse(
        //         recipientId: conversationType,
        //         text:
        //             "Thank you. Your Systolic is ${model.data.systolic},Diastolic is ${model.data.diastolic} and Pulse is ${model.data.pulse} is successfully recorded, Bye!",
        //       ),
        //     );
        //   } else {
        //     showFailure();
        //   }
        // }
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
    if (!controller.canSpeak) {
      stopTTS();
      return;
    }
    if (controller.useLocalTTSEngine) {
      try {
        if ((currentPlayingConversation.text ?? '').isNotEmpty) {
          controller.conversations.add(currentPlayingConversation);
          controller.isMicListening.toggle();
          isPlaying = true;
          final status = await controller
              .playUsingLocalTTSEngineFor(currentPlayingConversation.text);
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
        //failed to play in local tts
        stopTTS();
      }
    } else {
      String textForPlaying;
      if ((currentPlayingConversation.text ?? '').isNotEmpty) {
        final result = await controller
            .getGoogleTTSForText(currentPlayingConversation.text);
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
            controller.conversations.add(currentPlayingConversation);
            controller.isMicListening.toggle();
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
    if (controller.useLocalTTSEngine) {
      controller.playUsingLocalTTSEngineFor("", close: true);
    }
    playConversations = [];
    isPlaying = false;
    _disableTimer();
    controller.isMicListening(false);
    controller.bleController = null;
    if (controller.isSheelaScreenActive) {
      Get.back();
    }
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

  updateBPUserData() async {
    try {
      hublistController = Get.find<HubListController>();
      qurhomeController = Get.find<QurhomeDashboardController>();
      final now = DateTime.now();
      final formatterDateTime = DateFormat('yyyy-MM-dd HH:mm:ss');
      final String actualDateTime = formatterDateTime.format(now);

      final bool response = await BleConnectApiProvider()
          .uploadBleBPDataReadings(
              ackLocal: actualDateTime,
              hubId: hublistController.virtualHubId,
              eId: hublistController.eid,
              uId: hublistController.uid,
              qurHomeBpScanResult: qurhomeController?.qurHomeBpScanResultModel);
      if (response &&
          qurhomeController
                  ?.qurHomeBpScanResultModel?.measurementRecords.first !=
              null) {
        final data = qurhomeController
            ?.qurHomeBpScanResultModel?.measurementRecords.first;
        addToConversationAndPlay(
          SheelaResponse(
            recipientId: conversationType,
            text: "Thank you. Your BP systolic is ${data.systolicKey} "
                ", Diastolic is ${data.diastolicKey} "
                "and Pulse is ${data.pulseRateKey} is successfully recorded, Bye!",
          ),
        );
      } else {
        showFailure();
      }

      isCompleted = true;
    } catch (e) {
      showFailure();
    }
  }
}
