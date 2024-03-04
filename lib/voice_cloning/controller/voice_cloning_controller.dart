import 'dart:async';
import 'dart:io';

import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gmiwidgetspackage/widgets/flutterToast.dart';
import 'package:myfhb/constants/fhb_constants.dart';
import 'package:myfhb/constants/router_variable.dart';
import 'package:myfhb/voice_cloning/model/voice_clone_status_arguments.dart';
import 'package:myfhb/voice_cloning/services/voice_clone_services.dart';
import 'package:myfhb/voice_cloning/view/widgets/countdown_timer_widget.dart';
import 'package:path_provider/path_provider.dart';

import '../../common/CommonUtil.dart';
import '../../constants/fhb_parameters.dart';

class VoiceCloningController extends ChangeNotifier {
  var countdown = 10;
  var progressValue = 0.0;
  var recordingDurationTxt = '0:00:00';
  bool isRecorderView = true;
  bool isPlayerLoading = false;
  bool canStopRecording = false;
  bool isRecording = false;
  String mPath = 'recorder.m4a';
  List<double> audioWaveData = [];
  Timer? countDownTimer;

  double playPosition = 0.0;

  double maxPlayerDuration = 1.0;

  ///Audio And recorder Controllers
  late RecorderController recorderController;
  late PlayerController playerController;
  VoiceCloneServices voiceCloneServices = VoiceCloneServices();

  void disposeRecorder() {
    isRecorderView = true;
    isRecording = false;
    recorderController.dispose();
    playerController.dispose();
  }

  void getDir() async {
    var appDirectory = await getApplicationDocumentsDirectory();
    mPath = "${appDirectory.path}/recording.m4a";
    notifyListeners();
  }

  void initialiseControllers() {
    canStopRecording = false;
    playerController = PlayerController();

    recorderController = RecorderController()
      ..androidEncoder = AndroidEncoder.aac
      ..androidOutputFormat = AndroidOutputFormat.mpeg4
      ..iosEncoder = IosEncoder.kAudioFormatMPEG4AAC
      ..sampleRate = 44100;
    recorderController.onCurrentDuration.listen((duration) {
      ///Added this condition because min player duration should be 1 sec
      ///so enabling the stop button after one sec
      if (duration >= Duration(seconds: 1)) {
        canStopRecording = true;
      }
      recordingDurationTxt = duration.toHHMMSS();
      notifyListeners();
    });
  }

  Future<void> toggleResumePause() async {
    if (recorderController.isRecording) {
      recorderController.pause();
      isRecording = false;
    } else {
      ///Checking the Mic permission before starting recording.
      if (await checkForMicPermission() == true) {
        await recorderController.record(path: mPath);
        isRecording = true;
      }
    }
    notifyListeners();
  }

  pauseRecorderAndPlayer() async {
    if(recorderController.isRecording){
      await recorderController.pause();
      isRecording =false;
      notifyListeners();
    }
    else if (playerController.playerState.isPlaying) {
      await playerController.pausePlayer();
    }

  }

  checkForMicPermission() async {
    final status =
        await CommonUtil.askPermissionForCameraAndMic(isAudioCall: true);
    if (!status) {
      FlutterToast().getToast(
        strMicPermission,
        Colors.red,
      );
      return false;
    }
    return true;
  }

  void startRecording() async {
    try {
      await recorderController.record(path: mPath);
      isRecording = true;
      notifyListeners();
    } catch (e) {}
  }

  void stopRecording() async {
    /// Clears WaveData and labels from the list. This will effectively remove
    /// waves and labels from the UI.
    recorderController.reset();
    recorderController.refresh();
    mPath = (await recorderController.stop(false))!;
    if (mPath != null) {}
    recordingDurationTxt = '0:00:00';
    isRecorderView = false;
    isRecording = false;
    playPosition = 0.0;
    maxPlayerDuration = 1.0;
    notifyListeners();
    startPlayer();
  }

  void submitRecording() async {
    ///Paused the player while submit button taps
    if (playerController.playerState.isPlaying) {
      await playerController.pausePlayer();
    }
    setPlayerLoading(true);

    ///Checking the Recorded file is less than 100 MB.
    var fileInMb = await getFileSizeInMB(mPath);
    if (fileInMb <= 100) {
      var data = await voiceCloneServices.uploadVoiceClone(mPath);
      setPlayerLoading(false);
      if (data.isSuccess == true) {
        Navigator.pop(Get.context!);
        Navigator.pushNamed(Get.context!, rt_VoiceCloningStatus,
                arguments: VoiceCloneStatusArguments(fromMenu: false))
            .then((value) {});
      } else {
        FlutterToast().getToast(data.message.toString(), Colors.red);
      }
    } else {
      setPlayerLoading(false);
      FlutterToast().getToast(fileShouldLess, Colors.red);
    }
  }

  Future<int> getFileSizeInMB(String filePath) async {
    File file = File(filePath);
    int sizeInBytes = await file.length();
    double sizeInMB = sizeInBytes / (1024 * 1024); // Convert bytes to megabytes
    return sizeInMB.round();
  }

  showCountdownDialog() {
    showDialog(
        context: Get.context!,
        builder: (context) {
          return AlertDialog(
            insetPadding: EdgeInsets.zero,
            clipBehavior: Clip.antiAlias,
            contentPadding: EdgeInsets.zero,
            backgroundColor: Colors.black.withOpacity(0.6),
            content: VoiceCloningCountDownWidget(),
          );
        }).then((value) async {
      if (value == true) {
        if (await checkForMicPermission() == true) {
          startRecording();
        }
      } else {
        countDownTimer?.cancel();
      }
    });
  }

  void startCountDownTimer() {
    countdown = 10;
    progressValue = 0;
    isRecorderView = true;
    recordingDurationTxt = '0:00:00';
    audioWaveData.clear();
    notifyListeners();
    countDownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (countdown > 0) {
        countdown--;

        ///progress value supports only 0.1 to 1 so added logic
        /// to achieve from countdown timer.
        progressValue = (10 - countdown) / 10.0;
        notifyListeners();
      } else {
        timer.cancel();
        Navigator.pop(Get.context!, true);
      }
    });
  }

  void setPlayerLoading(bool value) {
    this.isPlayerLoading = value;
    notifyListeners();
  }

  void reRecord() {
    playerController.stopPlayer();
    isRecorderView = true;
    canStopRecording = false;
    recordingDurationTxt = '00:00:00';
    showCountdownDialog();
    notifyListeners();
  }

  Future<void> startPlayer() async {
    setPlayerLoading(true);
    audioWaveData = await playerController.extractWaveformData(
      path: mPath,
    );
    await playerController.preparePlayer(path: mPath);
    maxPlayerDuration = playerController.maxDuration.toDouble();
    /*   maxPlayerDuration =
        (await playerController.getDuration(DurationType.max)).toDouble();*/
    setPlayerLoading(false);

    ///When using Finish mode pause it will allow to play and pause for every time.
    await playerController.startPlayer(finishMode: FinishMode.pause);
    playerController.onCompletion.listen((event) {
      playPosition = 0.0;
      notifyListeners();
    });

    playerController.onCurrentDurationChanged.listen((event) {
      playPosition = event.seconds.inSeconds.toDouble();
      notifyListeners();
    });
    notifyListeners();
  }

  Future<void> playPausePlayer() async {
    if (playerController.playerState.isPlaying) {
      await playerController.pausePlayer();
    } else {
      await playerController.startPlayer(
          finishMode: FinishMode.pause, forceRefresh: true);
    }
    notifyListeners();
  }

  String formatPlayerDuration(double seconds) {
    ///This function will give the duration to hh:mm:ss from double value.
    Duration duration = Duration(milliseconds: seconds.toInt());
    String formattedDuration = '';

    if (duration.inHours > 0) {
      formattedDuration += '${duration.inHours.toString().padLeft(2, '0')}:';
    }
    formattedDuration +=
        '${duration.inMinutes.remainder(60).toString().padLeft(2, '0')}:';
    formattedDuration +=
        (duration.inSeconds.remainder(60)).toString().padLeft(2, '0');

    return formattedDuration;
  }

  @override
  void dispose() {
    audioWaveData.clear();
    super.dispose();
  }
}
