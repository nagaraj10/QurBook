import 'dart:io';
import 'dart:typed_data' show Uint8List;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart' show DateFormat;
import 'package:intl/date_symbol_data_local.dart';
import 'dart:async';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:path/path.dart';
import 'CommonUtil.dart';
import '../constants/variable_constant.dart' as variable;
import '../src/utils/screenutils/size_extensions.dart';
import 'package:get/get.dart';
import 'package:myfhb/src/ui/SheelaAI/Controller/SheelaAIController.dart';

enum t_MEDIA {
  FILE,
  BUFFER,
  ASSET,
  STREAM,
}

class AudioWidget extends StatefulWidget {
  String? audioFile;
  String? audioUrl;
  bool isFromChat;
  bool isFromSheela;
  bool isPlayAudioUrl;
  bool isFromSheelaFileUpload;

  Function(bool, String?)? deleteAudioFile;

  AudioWidget(
    this.audioFile,
    this.deleteAudioFile, {
    this.isFromChat = false,
    this.isFromSheela = false,
    this.isPlayAudioUrl = false,
    this.isFromSheelaFileUpload = false,
  });

  @override
  AudioWidgetState createState() => AudioWidgetState();
}

class AudioWidgetState extends State<AudioWidget> {
  final bool _isRecording = false;
  final List<String?> _path = [null, null, null, null, null, null, null];
  StreamSubscription? _recorderSubscription;
  StreamSubscription? _dbPeakSubscription;
  StreamSubscription? _playerSubscription;
  FlutterSoundPlayer? flutterSound;
  String? _pathOfFile;
  final String _recorderTxt = '00:00';
  String _playerTxt = '00:00';
  double? _dbLevel;

  double sliderCurrentPosition = 0;
  double maxDuration = 1;
  final t_MEDIA _media = t_MEDIA.FILE;
  final Codec _codec = Codec.aacADTS;

  bool isPlaying = false;

  String? audioUrl = '';

  SheelaAIController? sheelaAIcontroller =
  CommonUtil().onInitSheelaAIController();


  @override
  void initState() {
    super.initState();
    set_up_audios();
    initializeDateFormatting();
    _pathOfFile = widget.audioFile;
    audioUrl = widget.audioUrl;
    if (!widget.isPlayAudioUrl) {
      if (widget.isFromSheela) {
        Future.delayed(const Duration(milliseconds: 5))
            .then((value) => onStartPlayerPressed());
      }
    }
  }

  set_up_audios() async {
    flutterSound = FlutterSoundPlayer();
    flutterSound!.openAudioSession().then(
      (value) {
        flutterSound!.setSubscriptionDuration(
          Duration(
            seconds: 1,
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    stopPlayer();
    flutterSound!.closeAudioSession();
    flutterSound = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.isFromSheela
        ? getAudioWidgetWithPlayerForSheela()
        : widget.isFromSheelaFileUpload
            ? getAudioWidgetSheelaFileUpload()
            : getAudioWidgetWithPlayer();
  }

  Widget getAudioWidgetWithPlayerForSheela() {
    return Container(
      width: 1.sw,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(
          4,
        ),
      ),
      padding: const EdgeInsets.all(
        5,
      ),
      child: Row(
        children: <Widget>[
          Container(
            child: Row(
              children: [
                IconButton(
                  iconSize: 30,
                  onPressed: () {
                    isPlaying ? onPausePlayerPressed() : onStartPlayerPressed();
                    if (isPlaying) {
                      sheelaAIcontroller?.isLoading.value = true;
                    }
                  },
                  icon: !isPlaying
                      ? Icon(
                          Icons.play_arrow,
                          size: 30,
                        )
                      : Icon(
                          Icons.pause,
                          size: 30,
                        ),
                ),
                IconButton(
                  iconSize: 30,
                  onPressed: () {
                    onStopPlayerPressed();
                    setState(() {});
                    startPlayer();
                  },
                  icon: Icon(
                    Icons.repeat,
                    size: 30,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 7,
            child: Container(
              height: 30.0.h,
              child: Slider(
                activeColor: Color(CommonUtil().getMyPrimaryColor()),
                inactiveColor: Colors.grey,
                value: sliderCurrentPosition,
                min: 0,
                max: maxDuration,
                onChanged: (value) async {
                  await flutterSound!.seekToPlayer(
                    Duration(
                      seconds: value.round(),
                    ),
                  );
                },
                divisions: maxDuration.toInt(),
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Center(
              child: Text(
                _playerTxt,
                style: TextStyle(
                  fontSize: 14.0.sp,
                  color: Colors.black,
                ),
              ),
            ),
          ),
        ],
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
      ),
    );
  }

  Widget getAudioWidgetWithPlayer() => Container(
        width: widget.isFromChat ? 1.sw / 1.7 : 1.sw,
        color: Colors.grey[200],
        padding: EdgeInsets.all(5),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              height: 30,
              width: 30,
              child: IconButton(
                onPressed: () {
                  isPlaying ? onPausePlayerPressed() : onStartPlayerPressed();
                },
                padding: EdgeInsets.all(2),
                icon: !isPlaying
                    ? Icon(
                        Icons.play_arrow,
                        size: 30,
                      )
                    : Icon(
                        Icons.pause,
                        size: 30,
                      ),
              ),
            ),
            Expanded(
              flex: 3,
              child: Container(
                height: 30.0.h,
                child: Slider(
                  activeColor: Color(CommonUtil().getMyPrimaryColor()),
                  inactiveColor: Colors.grey,
                  value: sliderCurrentPosition,
                  min: 0,
                  max: maxDuration,
                  onChanged: (value) async {
                    await flutterSound!.seekToPlayer(
                      Duration(
                        seconds: value.round(),
                      ),
                    );
                  },
                  divisions:
                      maxDuration.toInt() > 0 ? maxDuration.toInt() : null,
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Center(
                child: Text(
                  _playerTxt,
                  style: TextStyle(
                    fontSize: 14.0.sp,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
            if (!widget.isFromChat)
              Expanded(
                child: IconButton(
                  icon:
                      Icon(Icons.delete, size: 20.0.sp, color: Colors.red[600]),
                  padding: EdgeInsets.only(right: 2),
                  onPressed: () {
                    widget.audioFile = '';

                    if (flutterSound!.playerState == PlayerState.isPlaying ||
                        flutterSound!.playerState == PlayerState.isPaused) {
                      flutterSound!.stopPlayer();
                      setState(
                        () {
                          widget.deleteAudioFile!(false, widget.audioFile);
                        },
                      );
                    } else {
                      setState(
                        () {
                          widget.deleteAudioFile!(false, widget.audioFile);
                        },
                      );
                    }
                  },
                ),
              )
          ],
          mainAxisAlignment: MainAxisAlignment.center,
        ),
      );

  Widget getAudioWidgetSheelaFileUpload(){
    return Container(
      width: 1.sw / 1.9,
      color: Colors.grey[200],
      padding: EdgeInsets.all(5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            height: 30.h,
            width: 30.w,
            child: IconButton(
              onPressed: () {
                sheelaAIcontroller?.isSheelaScreenActive = false;
                isPlaying ? onPausePlayerPressed() : onStartPlayerPressed();
              },
              padding: EdgeInsets.all(2),
              icon: !isPlaying
                  ? Icon(
                Icons.play_arrow,
                size: 30,
              )
                  : Icon(
                Icons.pause,
                size: 30,
              ),
            ),
          ),
          Expanded(
            flex: 4,
            child: Container(
              height: 30.0.h,
              child: Slider(
                activeColor: Color(CommonUtil().getMyPrimaryColor()),
                inactiveColor: Colors.grey,
                value: sliderCurrentPosition,
                min: 0,
                max: maxDuration,
                onChanged: (value) async {
                  await flutterSound!.seekToPlayer(
                    Duration(
                      seconds: value.round(),
                    ),
                  );
                },
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Center(
              child: Text(
                _playerTxt,
                style: TextStyle(
                  fontSize: 14.0.sp,
                  color: Colors.black,
                ),
              ),
            ),
          ),
        ],
        mainAxisAlignment: MainAxisAlignment.center,
      ),
    );
  }

  onStartPlayerPressed() {
    return flutterSound!.playerState == PlayerState.isPaused
        ? pausePlayer()
        : startPlayer();
  }

  void startPlayer() async {
    isPlaying = true;
    if (widget.isFromSheela) {
      sheelaAIcontroller?.isLoading.value = true;
    }
    if (widget.isFromSheelaFileUpload) {
      // Check if the widget indicates that the file is from Sheela File Upload

      // If the condition is true, stop the Text-to-Speech (TTS) controller associated with Sheela
      sheelaAIcontroller?.stopTTS();
    }

    try {
      var path = widget.audioFile!;
      final file = File(path);
      var fileExention = extension(file.path);
      if (_media == t_MEDIA.FILE && fileExention == '.mp3') {
        // Do we want to play from buffer or from file ?
        if (await fileExists(widget.audioFile!)) {
          var buffer = await makeBuffer(widget.audioFile!);
          if (buffer != null) {
            Duration? DuarationOfFile = await (flutterSound!.startPlayer(
              fromDataBuffer: buffer,
              whenFinished: () {
                if (widget.isFromSheelaFileUpload) {
                  // Check if the widget indicates that the file is from Sheela File Upload

                  // If true, update the timer in the Sheela AI controller (presumably to indicate some time-related information)
                  sheelaAIcontroller?.updateTimer(enable: true);

                  // Also, set Sheela screen as active
                  sheelaAIcontroller?.isSheelaScreenActive = true;
                }

                stopPlayer();
              },
            ));
            maxDuration = DuarationOfFile!.inSeconds.toDouble();
          }
        }
      } else {
        Duration? DuarationOfFile = await (flutterSound!.startPlayer(
          fromURI: path,
          codec: Codec.aacMP4,
          whenFinished: () {
            if (widget.isFromSheelaFileUpload) {
              // Check if the widget indicates that the file is from Sheela File Upload

              // If true, update the timer in the Sheela AI controller (presumably to indicate some time-related information)
              sheelaAIcontroller?.updateTimer(enable: true);

              // Also, set Sheela screen as active
              sheelaAIcontroller?.isSheelaScreenActive = true;
            }
            stopPlayer();
          },
        ));
        maxDuration = DuarationOfFile!.inSeconds.toDouble();
      }
      // if (_media == t_MEDIA.ASSET) {
      //   var buffer = (await rootBundle.load(variable.assetSample[_codec.index]))
      //       .buffer
      //       .asUint8List();
      //   // path = await flutterSound.thePlayerstartPlayerFromBuffer(
      //   //   buffer,
      //   //   codec: _codec,
      //   // );
      //   await flutterSound.startPlayerFromStream(
      //     codec: _codec,
      //   );
      // } else if (_media == t_MEDIA.FILE) {
      //   // Do we want to play from buffer or from file ?
      //   if (await fileExists(widget.audioFile)) {
      //     var buffer = await makeBuffer(widget.audioFile);
      //     if (buffer != null) {
      //       await flutterSound.startPlayer(
      //         fromDataBuffer: buffer,
      //       );
      //     }
      //   } // From file
      // } else if (_media == t_MEDIA.BUFFER) {
      //   // Do we want to play from buffer or from file ?
      //   if (await fileExists(_path[_codec.index])) {
      //     var buffer = await makeBuffer(_path[_codec.index]);
      //     if (buffer != null) {
      //       await flutterSound.startPlayer(
      //         fromDataBuffer: buffer,
      //         codec: _codec,
      //       );
      //     } // From buffer
      //   }
      // }
      // if (path == null) {
      //   return;
      // }
      await flutterSound!.setVolume(1.0);

      _playerSubscription = flutterSound!.onProgress!.listen(
        (e) {
          if (e != null) {
            setState(
              () {
                isPlaying = true;

                sliderCurrentPosition = e.position.inSeconds.toDouble();
                print(sliderCurrentPosition);
                _playerTxt = _printDuration(e.position);
              },
            );
          }
        },
      );
      //TODO: Check for audio
    } catch (err,stackTrace) {
      print(err.toString());
      CommonUtil().appLogs(message: err.toString(),stackTrace:stackTrace.toString());
    }

    setState(
      () {},
    );
  }

  String _printDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "$twoDigitMinutes:$twoDigitSeconds";
  }

  Future<bool> fileExists(String path) async {
    return await File(path).exists();
  }

  Future<Uint8List?> makeBuffer(String path) async {
    try {
      if (!await fileExists(path)) return null;
      var file = File(path);
      file.openRead();
      final contents = await file.readAsBytes();

      return contents;
    } catch (e,stackTrace) {
      CommonUtil().appLogs(message: e,stackTrace:stackTrace);
      return null;
    }
  }

  onPausePlayerPressed() {
    return flutterSound!.playerState == PlayerState.isPlaying ||
            flutterSound!.playerState == PlayerState.isPaused
        ? pausePlayer()
        : startPlayer();
  }

  void pausePlayer() async {
    String result;
    try {
      if (flutterSound!.playerState == PlayerState.isPaused) {
        await flutterSound!.resumePlayer();
        if (widget.isFromSheela) {
          sheelaAIcontroller?.isLoading.value = true;
        }

        print("Inside pause player resume");
        isPlaying = true;
      } else {
        await flutterSound!.pausePlayer();
        if (widget.isFromSheela) {
          sheelaAIcontroller?.isLoading.value = false;
        }

        print("Inside pause player pause");

        isPlaying = false;
      }
    } catch (err,stackTrace) {
      CommonUtil().appLogs(message: err.toString(),stackTrace:stackTrace.toString());
    }

    setState(() {});
  }

  onStopPlayerPressed() {
    return flutterSound!.playerState == PlayerState.isPlaying ||
            flutterSound!.playerState == PlayerState.isPaused
        ? stopPlayer()
        : null;
  }

  void stopPlayer() async {
    try {
      if (widget.isFromSheela) {
        sheelaAIcontroller?.isLoading.value = false;
      }

      await flutterSound!.stopPlayer();
      if (_playerSubscription != null) {
        await _playerSubscription!.cancel();
        _playerSubscription = null;
      }
      sliderCurrentPosition = 0.0;
      _playerTxt = '00:00';
      isPlaying = false;
    } catch (err,stackTrace) {
      CommonUtil().appLogs(message: err.toString(),stackTrace:stackTrace.toString());
    }
    setState(() {});
  }
}
