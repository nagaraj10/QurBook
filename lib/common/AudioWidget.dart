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

enum t_MEDIA {
  FILE,
  BUFFER,
  ASSET,
  STREAM,
}

class AudioWidget extends StatefulWidget {
  String audioFile;
  Function(bool, String) deleteAudioFile;

  AudioWidget(this.audioFile, this.deleteAudioFile);

  @override
  AudioWidgetState createState() => AudioWidgetState();
}

class AudioWidgetState extends State<AudioWidget> {
  final bool _isRecording = false;
  final List<String> _path = [null, null, null, null, null, null, null];
  StreamSubscription _recorderSubscription;
  StreamSubscription _dbPeakSubscription;
  StreamSubscription _playerSubscription;
  FlutterSoundPlayer flutterSound;
  String _pathOfFile;
  final String _recorderTxt = '00:00';
  String _playerTxt = '00:00';
  double _dbLevel;

  double sliderCurrentPosition = 0;
  double maxDuration = 1;
  final t_MEDIA _media = t_MEDIA.FILE;
  final Codec _codec = Codec.aacADTS;

  bool isPlaying = false;

  @override
  void initState() {
    super.initState();
    set_up_audios();
    initializeDateFormatting();
    _pathOfFile = widget.audioFile;
  }

  set_up_audios() async {
    flutterSound = FlutterSoundPlayer();
    flutterSound.openAudioSession().then(
          (value) {
        flutterSound.setSubscriptionDuration(
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
    flutterSound.closeAudioSession();
    flutterSound = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return getAudioWidgetWithPlayer();
  }

  Widget getAudioWidgetWithPlayer() {
    return Container(
      width: 1.sw,
      color: Colors.grey[200],
      padding: EdgeInsets.all(5),
      child: Row(
        children: <Widget>[
          Container(
            height: 24,
            width: 24,
            child: IconButton(
              onPressed:
              isPlaying ? onPausePlayerPressed() : onStartPlayerPressed(),
              padding: EdgeInsets.all(2),
              icon: !isPlaying
                  ? Icon(
                Icons.play_arrow,
              )
                  : Icon(Icons.pause),
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
                  await flutterSound.seekToPlayer(
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
          Expanded(
            child: IconButton(
              icon: Icon(Icons.delete, size: 20.0.sp, color: Colors.red[600]),
              padding: EdgeInsets.only(right: 2),
              onPressed: () {
                widget.audioFile = '';

                if (flutterSound.playerState == PlayerState.isPlaying ||
                    flutterSound.playerState == PlayerState.isPaused) {
                  flutterSound.stopPlayer();
                  setState(
                        () {
                      widget.deleteAudioFile(false, widget.audioFile);
                    },
                  );
                } else {
                  setState(
                        () {
                      widget.deleteAudioFile(false, widget.audioFile);
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
  }

  onStartPlayerPressed() {
    return flutterSound.playerState == PlayerState.isPaused
        ? pausePlayer
        : startPlayer;
  }

  void startPlayer() async {
    isPlaying = true;
    try {
      var path = widget.audioFile;
      final file = File(path);
      var fileExention = extension(file.path);
      if (_media == t_MEDIA.FILE && fileExention == '.mp3') {
        // Do we want to play from buffer or from file ?
        if (await fileExists(widget.audioFile)) {
          var buffer = await makeBuffer(widget.audioFile);
          if (buffer != null) {
            final DuarationOfFile = await flutterSound.startPlayer(
              fromDataBuffer: buffer,
              whenFinished: () {
                stopPlayer();
              },
            );
            maxDuration = DuarationOfFile.inSeconds.toDouble();
          }
        }
      } else {
        final DuarationOfFile = await flutterSound.startPlayer(
          fromURI: path,
          whenFinished: () {
            stopPlayer();
          },
        );
        maxDuration = DuarationOfFile.inSeconds.toDouble();
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
      await flutterSound.setVolume(1.0);

      _playerSubscription = flutterSound.onProgress.listen(
            (e) {
          if (e != null) {
            setState(
                  () {
                sliderCurrentPosition = e.position.inSeconds.toDouble();
                print(sliderCurrentPosition);
                _playerTxt = _printDuration(e.position);
              },
            );
          }
        },
      );
      //TODO: Check for audio
    } catch (err) {
      print(err.toString());
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

  Future<Uint8List> makeBuffer(String path) async {
    try {
      if (!await fileExists(path)) return null;
      var file = File(path);
      file.openRead();
      final contents = await file.readAsBytes();

      return contents;
    } catch (e) {
      return null;
    }
  }

  onPausePlayerPressed() {
    return flutterSound.playerState == PlayerState.isPlaying ||
        flutterSound.playerState == PlayerState.isPaused
        ? pausePlayer
        : startPlayer;
  }

  void pausePlayer() async {
    String result;
    try {
      if (flutterSound.playerState == PlayerState.isPaused) {
        await flutterSound.resumePlayer();
        print("Inside pause player resume");
        isPlaying = true;
      } else {
        await flutterSound.pausePlayer();
        print("Inside pause player pause");

        isPlaying = false;
      }
    } catch (err) {}

    setState(() {});
  }

  onStopPlayerPressed() {
    return flutterSound.playerState == PlayerState.isPlaying ||
        flutterSound.playerState == PlayerState.isPaused
        ? stopPlayer
        : null;
  }

  void stopPlayer() async {
    try {
      await flutterSound.stopPlayer();
      if (_playerSubscription != null) {
        await _playerSubscription.cancel();
        _playerSubscription = null;
      }
      sliderCurrentPosition = 0.0;
      _playerTxt = '00:00';
      isPlaying = false;
    } catch (err) {
      print('Failed to stop');
    }
    setState(() {});
  }
}
