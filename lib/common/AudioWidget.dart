import 'dart:io';
import 'dart:typed_data' show Uint8List;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart' show DateFormat;
import 'package:intl/date_symbol_data_local.dart';
import 'dart:async';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:flutter/services.dart' show rootBundle;
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
  FlutterSound flutterSound;

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
    flutterSound = FlutterSound();
    // flutterSound.thePlayer.setSubscriptionDuration(0.01);
    // flutterSound.thePlayer.setDbPeakLevelUpdate(0.8);
    // flutterSound.thePlayer.setDbLevelEnabled(true);
    initializeDateFormatting();

    _path[_codec.index] = widget.audioFile;
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();

    flutterSound.thePlayer.stopPlayer();
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
          Expanded(
            child: Container(
              width: 56.0.w,
              height: 50.0.h,
              child: ClipOval(
                child: FlatButton(
                  onPressed: isPlaying
                      ? onPausePlayerPressed()
                      : flutterSound.thePlayer.playerState ==
                              PlayerState.isPaused
                          ? onPausePlayerPressed()
                          : onStartPlayerPressed(),
                  padding: EdgeInsets.all(4),
                  child: onStartPlayerPressed() != null
                      ? Icon(
                          Icons.play_arrow,
                        )
                      : Icon(Icons.pause),
                ),
              ),
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
                      await flutterSound.thePlayer.seekToPlayer(
                        Duration(
                          seconds: value.round(),
                        ),
                      );
                    },
                    divisions: maxDuration.toInt())),
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
            )),
          ),
          Expanded(
              child: IconButton(
                  icon:
                      Icon(Icons.delete, size: 20.0.sp, color: Colors.red[600]),
                  onPressed: () {
                    widget.audioFile = '';

                    if (flutterSound.thePlayer.playerState ==
                            PlayerState.isPlaying ||
                        flutterSound.thePlayer.playerState ==
                            PlayerState.isPaused) {
                      flutterSound.thePlayer.stopPlayer();
                      setState(() {
                        widget.deleteAudioFile(false, widget.audioFile);
                      });
                    } else {
                      setState(() {
                        widget.deleteAudioFile(false, widget.audioFile);
                      });
                    }
                  }))
        ],
        mainAxisAlignment: MainAxisAlignment.center,
      ),
    );
  }

  void seekToPlayer(int milliSecs) async {
    await flutterSound.thePlayer.seekToPlayer(
      Duration(
        milliseconds: milliSecs,
      ),
    );
  }

  onStartPlayerPressed() {
    if (_media == t_MEDIA.FILE || _media == t_MEDIA.BUFFER) {
      if (_path[_codec.index] == null) return null;
    }
    return (flutterSound.thePlayer.playerState == PlayerState.isStopped ||
            flutterSound.thePlayer.playerState == PlayerState.isPaused)
        ? startPlayer
        : null;
  }

  void startPlayer() async {
    isPlaying = true;

    try {
      var path = widget.audioFile;
      if (_media == t_MEDIA.ASSET) {
        var buffer = (await rootBundle.load(variable.assetSample[_codec.index]))
            .buffer
            .asUint8List();
        // path = await flutterSound.thePlayerstartPlayerFromBuffer(
        //   buffer,
        //   codec: _codec,
        // );
        await flutterSound.thePlayer.startPlayerFromStream(
          codec: _codec,
        );
      } else if (_media == t_MEDIA.FILE) {
        // Do we want to play from buffer or from file ?
        if (await fileExists(widget.audioFile)) {
          var buffer = await makeBuffer(widget.audioFile);
          if (buffer != null) {
            await flutterSound.thePlayer.startPlayer(
              fromDataBuffer: buffer,
            );
          }
        } // From file
      } else if (_media == t_MEDIA.BUFFER) {
        // Do we want to play from buffer or from file ?
        if (await fileExists(_path[_codec.index])) {
          var buffer = await makeBuffer(_path[_codec.index]);
          if (buffer != null) {
            await flutterSound.thePlayer.startPlayer(
              fromDataBuffer: buffer,
              codec: _codec,
            );
          } // From buffer
        }
      }
      if (path == null) {
        return;
      }
      await flutterSound.thePlayer.setVolume(1.0);

      // _playerSubscription =
      //     flutterSound.thePlayer.onPlayerStateChanged.listen((e) {
      //   if (e != null) {
      //     sliderCurrentPosition = e.currentPosition;
      //     maxDuration = e.duration;
      //
      //     final date = DateTime.fromMillisecondsSinceEpoch(
      //         e.currentPosition.toInt(),
      //         isUtc: true);
      //     final txt =
      //         DateFormat(variable.strDatems, variable.strenUs).format(date);
      //     setState(() {
      //       _playerTxt = txt.substring(0, 5);
      //     });
      //   }
      // });
      //TODO: Check for audio
    } catch (err) {}

    setState(() {});
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
    return flutterSound.thePlayer.playerState == PlayerState.isPlaying ||
            flutterSound.thePlayer.playerState == PlayerState.isPaused
        ? pausePlayer
        : startPlayer;
  }

  void pausePlayer() async {
    String result;
    try {
      if (flutterSound.thePlayer.playerState == PlayerState.isPaused) {
        await flutterSound.thePlayer.resumePlayer();
        isPlaying = true;
      } else {
        await flutterSound.thePlayer.pausePlayer();
        isPlaying = false;
      }
    } catch (err) {}
    if (result == variable.st_pausedplayer) {
      isPlaying = false;
    } else {
      isPlaying = true;
    }
    setState(() {});
  }

  onStopPlayerPressed() {
    return flutterSound.thePlayer.playerState == PlayerState.isPlaying ||
            flutterSound.thePlayer.playerState == PlayerState.isPaused
        ? stopPlayer
        : null;
  }

  void stopPlayer() async {
    try {
      await flutterSound.thePlayer.stopPlayer();

      if (_playerSubscription != null) {
        await _playerSubscription.cancel();
        _playerSubscription = null;
      }
      sliderCurrentPosition = 0.0;
    } catch (err) {}
    setState(() {});
  }
}
