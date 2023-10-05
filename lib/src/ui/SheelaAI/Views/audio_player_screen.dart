import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:get/get.dart';
import 'package:myfhb/Qurhome/Common/GradientAppBarQurhome.dart';
import 'package:myfhb/authentication/constants/constants.dart';
import 'package:myfhb/common/CommonUtil.dart';
import 'package:myfhb/common/PreferenceUtil.dart';
import 'package:myfhb/src/ui/SheelaAI/Controller/SheelaAIController.dart';
import 'package:myfhb/src/utils/screenutils/size_extensions.dart';
import 'package:myfhb/widgets/GradientAppBar.dart';

class AudioPlayerScreen extends StatefulWidget {
  final String? audioUrl;

  AudioPlayerScreen({this.audioUrl});

  @override
  AudioPlayerScreenState createState() => AudioPlayerScreenState();
}

class AudioPlayerScreenState extends State<AudioPlayerScreen> {
  StreamSubscription? _playerSubscription;
  FlutterSoundPlayer? flutterSound = FlutterSoundPlayer();
  String _playerTxt = '00:00';
  double sliderCurrentPosition = 0;
  double maxDuration = 1;
  bool isPlaying = false;
  SheelaAIController sheelaAIController = Get.find();

  @override
  void initState() {
    try {
      super.initState();
      sheelaAIController.onStopTTSWithDelay();
      setUpAudios();
    } catch (e, stackTrace) {
      CommonUtil().appLogs(message: e, stackTrace: stackTrace);
    }
  }

  setUpAudios() async {
    try {
      flutterSound?.openAudioSession().then(
        (value) {
          flutterSound?.setSubscriptionDuration(
            Duration(
              seconds: 1,
            ),
          );
        },
      );
      onStartPlayerPressed();
    } catch (e, stackTrace) {
      CommonUtil().appLogs(message: e, stackTrace: stackTrace);
    }
  }

  @override
  void dispose() {
    try {
      stopPlayer();
      flutterSound?.closeAudioSession();
      flutterSound = null;
      sheelaAIController.isAudioScreenLoading.value = false;
      super.dispose();
    } catch (e, stackTrace) {
      CommonUtil().appLogs(message: e, stackTrace: stackTrace);
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          Get.back();
          return false;
        },
        child: Scaffold(
            appBar: AppBar(
                flexibleSpace: PreferenceUtil.getIfQurhomeisAcive()
                    ? GradientAppBarQurhome()
                    : GradientAppBar(),
                leading: IconButton(
                    icon: Icon(
                      Icons.arrow_back_ios,
                      size: 24.0.sp,
                    ),
                    color: Colors.white,
                    onPressed: () {
                      try {
                        Get.back();
                      } catch (e, stackTrace) {
                        CommonUtil().appLogs(
                            message: e.toString(), stackTrace: stackTrace);
                      }
                    }),
                elevation: 0.0,
                backgroundColor: Colors.transparent,
                title: Text(
                  strAudioTitle,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.0.sp,
                  ),
                )),
            body: Obx(() => sheelaAIController.isAudioScreenLoading.value
                ? Center(
                    child: CircularProgressIndicator(
                        color: Color(CommonUtil().getMyPrimaryColor())))
                : getAudioWidgetWithPlayer())));
  }

  Widget getAudioWidgetWithPlayer() {
    return Column(
      children: [
        Expanded(
            child: Icon(
          Icons.mic,
          size: 92.sp,
        )),
        Container(
          margin: EdgeInsets.only(bottom: 40),
          child: Column(
            children: [
              IconButton(
                iconSize: 62.sp,
                color: (PreferenceUtil.getIfQurhomeisAcive())
                    ? Color(CommonUtil().getQurhomePrimaryColor())
                    : Color(CommonUtil().getMyPrimaryColor()),
                onPressed: () {
                  isPlaying ? onPausePlayerPressed() : onStartPlayerPressed();
                },
                icon: isPlaying
                    ? Icon(
                        Icons.pause_circle,
                      )
                    : Icon(
                        Icons.play_circle,
                      ),
              ),
              SizedBox(height: 2.h),
              Container(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      child: Container(
                        height: 30.0.h,
                        child: Slider(
                          activeColor: (PreferenceUtil.getIfQurhomeisAcive())
                              ? Color(CommonUtil().getQurhomePrimaryColor())
                              : Color(CommonUtil().getMyPrimaryColor()),
                          inactiveColor: Colors.grey,
                          value: sliderCurrentPosition,
                          min: 0,
                          max: maxDuration,
                          onChanged: (value) async {
                            try {
                              await flutterSound?.seekToPlayer(
                                Duration(
                                  seconds: value.round(),
                                ),
                              );
                            } catch (e, stackTrace) {
                              CommonUtil()
                                  .appLogs(message: e, stackTrace: stackTrace);
                            }
                          },
                        ),
                      ),
                    ),
                  ],
                  mainAxisAlignment: MainAxisAlignment.center,
                ),
              ),
              SizedBox(height: 2.h),
              Center(
                child: Text(
                  _playerTxt,
                  style: TextStyle(
                    fontSize: 18.0.sp,
                    color: Colors.black,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  onStartPlayerPressed() {
    return flutterSound?.playerState == PlayerState.isPaused
        ? pausePlayer()
        : startPlayer();
  }

  void startPlayer() async {
    sheelaAIController.isAudioScreenLoading.value = true;
    isPlaying = true;
    try {
      final DuarationOfFile = await (flutterSound?.startPlayer(
        fromURI: (widget.audioUrl ?? ''),
        whenFinished: () {
          stopPlayer();
        },
      ));
      maxDuration = DuarationOfFile!.inSeconds.toDouble();
      await flutterSound?.setVolume(1.0);
      sheelaAIController.isAudioScreenLoading.value = false;
      _playerSubscription = flutterSound?.onProgress!.listen(
        (e) {
          if (e != null) {
            setState(
              () {
                isPlaying = true;
                sliderCurrentPosition = e.position.inSeconds.toDouble();
                _playerTxt = printDuration(e.position);
              },
            );
          }
        },
      );
      setState(
        () {},
      );
    } catch (err, stackTrace) {
      CommonUtil()
          .appLogs(message: err.toString(), stackTrace: stackTrace.toString());
    }
  }

  String printDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "$twoDigitMinutes:$twoDigitSeconds";
  }

  Future<bool> fileExists(String path) async {
    return await File(path).exists();
  }

  onPausePlayerPressed() {
    return flutterSound?.playerState == PlayerState.isPlaying ||
            flutterSound?.playerState == PlayerState.isPaused
        ? pausePlayer()
        : startPlayer();
  }

  void pausePlayer() async {
    try {
      if (flutterSound?.playerState == PlayerState.isPaused) {
        await flutterSound?.resumePlayer();
        isPlaying = true;
      } else {
        await flutterSound?.pausePlayer();
        isPlaying = false;
      }
      setState(() {});
    } catch (err, stackTrace) {
      CommonUtil()
          .appLogs(message: err.toString(), stackTrace: stackTrace.toString());
    }
  }

  onStopPlayerPressed() {
    return flutterSound?.playerState == PlayerState.isPlaying ||
            flutterSound?.playerState == PlayerState.isPaused
        ? stopPlayer()
        : null;
  }

  void stopPlayer() async {
    try {
      await flutterSound?.stopPlayer();
      if (_playerSubscription != null) {
        await _playerSubscription!.cancel();
        _playerSubscription = null;
      }
      sliderCurrentPosition = 0.0;
      _playerTxt = '00:00';
      isPlaying = false;
      setState(() {});
    } catch (err, stackTrace) {
      CommonUtil()
          .appLogs(message: err.toString(), stackTrace: stackTrace.toString());
    }
  }
}
