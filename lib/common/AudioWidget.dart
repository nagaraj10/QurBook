import 'dart:io';
import 'dart:typed_data' show Uint8List;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart' show DateFormat;
import 'package:intl/date_symbol_data_local.dart';
import 'dart:async';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:myfhb/common/CommonUtil.dart';
import 'package:myfhb/constants/variable_constant.dart' as variable;


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
  bool _isRecording = false;
  List<String> _path = [null, null, null, null, null, null, null];
  StreamSubscription _recorderSubscription;
  StreamSubscription _dbPeakSubscription;
  StreamSubscription _playerSubscription;
  FlutterSound flutterSound;

  String _recorderTxt = '00:00';
  String _playerTxt = '00:00';
  double _dbLevel;

  double sliderCurrentPosition = 0.0;
  double maxDuration = 1.0;
  t_MEDIA _media = t_MEDIA.FILE;
  t_CODEC _codec = t_CODEC.CODEC_AAC;

  bool isPlaying = false;

 

  @override
  void initState() {
    super.initState();
    flutterSound = new FlutterSound();
    flutterSound.setSubscriptionDuration(0.01);
    flutterSound.setDbPeakLevelUpdate(0.8);
    flutterSound.setDbLevelEnabled(true);
    initializeDateFormatting();

    _path[_codec.index] = widget.audioFile;
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return getAudioWidgetWithPlayer();
  }

  Widget getAudioWidgetWithPlayer() {
    return Container(
      width: MediaQuery.of(context).size.width,
      color: Colors.grey[200],
      padding: EdgeInsets.all(5),
      child: Row(
        children: <Widget>[
          Expanded(
            flex: 1,
            child: Container(
              width: 56.0,
              height: 50.0,
              child: ClipOval(
                child: FlatButton(
                  onPressed: isPlaying
                      ? onPausePlayerPressed()
                      : flutterSound.audioState == t_AUDIO_STATE.IS_PAUSED
                          ? onPausePlayerPressed()
                          : onStartPlayerPressed(),
                  padding: EdgeInsets.all(4.0),
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
                height: 30.0,
                child: Slider(
                    activeColor: Color(new CommonUtil().getMyPrimaryColor()),
                    inactiveColor: Colors.grey,
                    value: sliderCurrentPosition,
                    min: 0.0,
                    max: maxDuration,
                    onChanged: (double value) async {
                      await flutterSound.seekToPlayer(value.toInt());
                    },
                    divisions: maxDuration.toInt())),
          ),
          Expanded(
            flex: 2,
            child: Center(
                child: Text(
              this._playerTxt,
              style: TextStyle(
                fontSize: 12.0,
                color: Colors.black,
              ),
            )),
          ),
          Expanded(
              flex: 1,
              child: IconButton(
                  icon: Icon(Icons.delete, size: 20, color: Colors.red[600]),
                  onPressed: () {
                    widget.audioFile = '';

                    if (flutterSound.audioState == t_AUDIO_STATE.IS_PLAYING ||
                        flutterSound.audioState == t_AUDIO_STATE.IS_PAUSED) {
                      flutterSound.stopPlayer();
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
        crossAxisAlignment: CrossAxisAlignment.center,
      ),
    );
  }

  void seekToPlayer(int milliSecs) async {
    String result = await flutterSound.seekToPlayer(milliSecs);
  }

  onStartPlayerPressed() {
    if (_media == t_MEDIA.FILE || _media == t_MEDIA.BUFFER) {
      if (_path[_codec.index] == null) return null;
    }
    return (flutterSound.audioState == t_AUDIO_STATE.IS_STOPPED ||
            flutterSound.audioState == t_AUDIO_STATE.IS_PAUSED)
        ? startPlayer
        : null;
  }

  void startPlayer() async {
    isPlaying = true;

    try {
      String path = widget.audioFile;
      if (_media == t_MEDIA.ASSET) {
        Uint8List buffer = (await rootBundle.load(variable.assetSample[_codec.index]))
            .buffer
            .asUint8List();
        path = await flutterSound.startPlayerFromBuffer(
          buffer,
          codec: _codec,
        );
      } else if (_media == t_MEDIA.FILE) {
        // Do we want to play from buffer or from file ?
        if (await fileExists(widget.audioFile))
          path = await flutterSound.startPlayer(widget.audioFile); // From file
      } else if (_media == t_MEDIA.BUFFER) {
        // Do we want to play from buffer or from file ?
        if (await fileExists(_path[_codec.index])) {
          Uint8List buffer = await makeBuffer(this._path[_codec.index]);
          if (buffer != null)
            path = await flutterSound.startPlayerFromBuffer(
              buffer,
              codec: _codec,
            ); // From buffer
        }
      }
      if (path == null) {
        return;
      }
      await flutterSound.setVolume(1.0);

      _playerSubscription = flutterSound.onPlayerStateChanged.listen((e) {
        if (e != null) {
          sliderCurrentPosition = e.currentPosition;
          maxDuration = e.duration;

          DateTime date = new DateTime.fromMillisecondsSinceEpoch(
              e.currentPosition.toInt(),
              isUtc: true);
          String txt = DateFormat('mm:ss', 'en_US').format(date);
          this.setState(() {
            this._playerTxt = txt.substring(0, 5);
          });
        }
      });
    } catch (err) {
      
    }

    setState(() {});
  }

  Future<bool> fileExists(String path) async {
    return await File(path).exists();
  }

// In this simple example, we just load a file in memory.This is stupid but just for demonstation  of startPlayerFromBuffer()
  Future<Uint8List> makeBuffer(String path) async {
    try {
      if (!await fileExists(path)) return null;
      File file = File(path);
      file.openRead();
      var contents = await file.readAsBytes();
      
      return contents;
    } catch (e) {
      return null;
    }
  }

  onPausePlayerPressed() {
    return flutterSound.audioState == t_AUDIO_STATE.IS_PLAYING ||
            flutterSound.audioState == t_AUDIO_STATE.IS_PAUSED
        ? pausePlayer
        : startPlayer;
  }

  void pausePlayer() async {
    String result;
    try {
      if (flutterSound.audioState == t_AUDIO_STATE.IS_PAUSED) {
        result = await flutterSound.resumePlayer();
        
      } else {
        result = await flutterSound.pausePlayer();
      }
    } catch (err) {
    }
    if (result == 'paused player') {
      isPlaying = false;
    } else {
      isPlaying = true;
    }
    setState(() {});
  }

  onStopPlayerPressed() {
    return flutterSound.audioState == t_AUDIO_STATE.IS_PLAYING ||
            flutterSound.audioState == t_AUDIO_STATE.IS_PAUSED
        ? stopPlayer
        : null;
  }

  void stopPlayer() async {
    try {
      String result = await flutterSound.stopPlayer();
      
      if (_playerSubscription != null) {
        _playerSubscription.cancel();
        _playerSubscription = null;
      }
      sliderCurrentPosition = 0.0;
    } catch (err) {
    }
    this.setState(() {});
  }
}
