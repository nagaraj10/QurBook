import 'dart:io';
import 'dart:typed_data' show Uint8List;
import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:gmiwidgetspackage/widgets/flutterToast.dart';
import 'package:intl/intl.dart' show DateFormat;
import 'package:intl/date_symbol_data_local.dart';
import 'dart:async';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:myfhb/common/CommonConstants.dart';
import 'package:myfhb/src/utils/colors_utils.dart';
import 'package:myfhb/widgets/GradientAppBar.dart';
import 'package:myfhb/common/CommonDialogBox.dart';
import 'package:myfhb/common/PreferenceUtil.dart';
import 'package:myfhb/constants/fhb_constants.dart' as Constants;
import 'package:myfhb/common/CommonUtil.dart';
import 'package:myfhb/constants/variable_constant.dart' as variable;

enum t_MEDIA {
  FILE,
  BUFFER,
  ASSET,
  STREAM,
}

class AudioRecordScreen extends StatefulWidget {
  final bool fromVoice;

  AudioRecordScreen({this.fromVoice});
  @override
  _AudioRecordScreenState createState() => new _AudioRecordScreenState();
}

class _AudioRecordScreenState extends State<AudioRecordScreen> {
  bool _isRecording = false;
  List<String> _path = [null, null, null, null, null, null, null];
  StreamSubscription _recorderSubscription;
  StreamSubscription _dbPeakSubscription;
  StreamSubscription _playerSubscription;
  FlutterSound flutterSound;

  String _recorderTxt = variable.strStartTime;
  String _playerTxt = variable.strStartTime;
  double _dbLevel;
  String audioPathMain = '';
  bool containsAudioMain = true;
  double sliderCurrentPosition = 0.0;
  double maxDuration = 1.0;
  t_MEDIA _media = t_MEDIA.FILE;
  t_CODEC _codec = t_CODEC.CODEC_AAC;

  FlutterToast toast = new FlutterToast();

  @override
  void initState() {
    super.initState();
    flutterSound = new FlutterSound();
    flutterSound.setSubscriptionDuration(0.01);
    flutterSound.setDbPeakLevelUpdate(0.8);
    flutterSound.setDbLevelEnabled(true);
    initializeDateFormatting();
  }

  void startRecorder() async {
    try {
      // String path = await flutterSound.startRecorder
      // (
      //   paths[_codec.index],
      //   codec: _codec,
      //   sampleRate: 16000,
      //   bitRate: 16000,
      //   numChannels: 1,
      //   androidAudioSource: AndroidAudioSource.MIC,
      // );
      String path = await flutterSound.startRecorder(
        codec: _codec,
      );

      _recorderSubscription = flutterSound.onRecorderStateChanged.listen((e) {
        DateTime date = new DateTime.fromMillisecondsSinceEpoch(
            e.currentPosition.toInt(),
            isUtc: true);
        String txt =
            DateFormat(variable.strDatems, variable.strenUs).format(date);

        this.setState(() {
          this._recorderTxt = txt.substring(0, 5);
        });

        if (e.currentPosition.toInt() >= 180000) {
          stopRecorder();
          toast.getToast('Maximum duration to record is 3 min', Colors.red);
          this.setState(() {});
        }
      });
      _dbPeakSubscription =
          flutterSound.onRecorderDbPeakChanged.listen((value) {
        setState(() {
          this._dbLevel = value;
        });
      });

      this.setState(() {
        this._isRecording = true;
        this._path[_codec.index] = path;
      });
    } catch (err) {
      setState(() {
        this._isRecording = false;
      });
    }
  }

  void stopRecorder() async {
    String result;
    try {
      result = await flutterSound.stopRecorder();

      if (_recorderSubscription != null) {
        _recorderSubscription.cancel();
        _recorderSubscription = null;
      }
      if (_dbPeakSubscription != null) {
        _dbPeakSubscription.cancel();
        _dbPeakSubscription = null;
      }
    } catch (err) {}
    this.setState(() {
      this._isRecording = false;
    });
    if (widget.fromVoice) {
      PreferenceUtil.saveString(
              Constants.KEY_CATEGORYNAME, Constants.STR_VOICERECORDS)
          .then((value) {
        PreferenceUtil.saveString(Constants.KEY_CATEGORYID,
                PreferenceUtil.getStringValue(Constants.KEY_VOICE_ID))
            .then((value) {
          TextEditingController fileName = new TextEditingController(
              text: Constants.STR_VOICERECORDS +
                  '_${DateTime.now().toUtc().millisecondsSinceEpoch}');

          new CommonDialogBox().getDialogForVoicerecords(
              context, containsAudioMain, this._path[_codec.index],
              (containsAudio, audioPath) {
            audioPathMain = audioPath;
            containsAudioMain = containsAudio;
            setState(() {});
          }, (containsAudio, audioPath) {
            audioPathMain = audioPath;
            containsAudioMain = containsAudio;
            setState(() {});
          }, false, fileName);
        });
      });
    } else {
      if (result != null && result != '')
        Navigator.of(context)
            .pop({Constants.keyAudioFile: this._path[_codec.index]});
    }
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

  void startPlayer() async {
    try {
      String path = null;
      if (_media == t_MEDIA.ASSET) {
        Uint8List buffer =
            (await rootBundle.load(variable.assetSample[_codec.index]))
                .buffer
                .asUint8List();
        path = await flutterSound.startPlayerFromBuffer(
          buffer,
          codec: _codec,
        );
      } else if (_media == t_MEDIA.FILE) {
        // Do we want to play from buffer or from file ?
        if (await fileExists(_path[_codec.index]))
          path = await flutterSound
              .startPlayer(this._path[_codec.index]); // From file
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
          String txt =
              DateFormat(variable.strDatems, variable.strenUs).format(date);
          this.setState(() {
            this._playerTxt = txt.substring(0, 5);
          });
        }
      });
    } catch (err) {}
    setState(() {});
  }

  void stopPlayer() async {
    try {
      String result = await flutterSound.stopPlayer();
      if (_playerSubscription != null) {
        _playerSubscription.cancel();
        _playerSubscription = null;
      }
      sliderCurrentPosition = 0.0;
    } catch (err) {}
    this.setState(() {
      //this._isPlaying = false;
    });
  }

  void pausePlayer() async {
    String result;
    try {
      if (flutterSound.audioState == t_AUDIO_STATE.IS_PAUSED) {
        result = await flutterSound.resumePlayer();
      } else {
        result = await flutterSound.pausePlayer();
      }
    } catch (err) {}
    setState(() {});
  }

  void seekToPlayer(int milliSecs) async {
    String result = await flutterSound.seekToPlayer(milliSecs);
  }

  onPausePlayerPressed() {
    return flutterSound.audioState == t_AUDIO_STATE.IS_PLAYING ||
            flutterSound.audioState == t_AUDIO_STATE.IS_PAUSED
        ? pausePlayer
        : null;
  }

  onStopPlayerPressed() {
    return flutterSound.audioState == t_AUDIO_STATE.IS_PLAYING ||
            flutterSound.audioState == t_AUDIO_STATE.IS_PAUSED
        ? stopPlayer
        : null;
  }

  onStartPlayerPressed() {
    if (_media == t_MEDIA.FILE || _media == t_MEDIA.BUFFER) {
      if (_path[_codec.index] == null) return null;
    }
    return flutterSound.audioState == t_AUDIO_STATE.IS_STOPPED
        ? startPlayer
        : null;
  }

  onStartRecorderPressed() {
    if (_media == t_MEDIA.ASSET || _media == t_MEDIA.BUFFER) return null;
    if (flutterSound.audioState == t_AUDIO_STATE.IS_RECORDING)
      return stopRecorder;

    return flutterSound.audioState == t_AUDIO_STATE.IS_STOPPED
        ? startRecorder
        : null;
  }

  Widget recorderAssetImage() {
    if (onStartRecorderPressed() == null)
      return Icon(
        Icons.mic_off,
        color: Colors.white54,
      );
    return flutterSound.audioState == t_AUDIO_STATE.IS_STOPPED
        ? Text(
            variable.strStartrecord,
            style: TextStyle(color: Colors.white),
          )
        : Text(variable.strStopRecord, style: TextStyle(color: Colors.white));
  }

  setCodec(t_CODEC codec) async {
    setState(() {
      _codec = codec;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: GradientAppBar(),
        backgroundColor: Colors.transparent,
        leading: InkWell(
          child: Icon(Icons.arrow_back_ios),
          onTap: () {
            Navigator.of(context).pop();
          },
        ),
        elevation: 0,
        title: Text(variable.strVoiceRecord),
        centerTitle: true,
      ),
      body: Center(
        child: ListView(
          shrinkWrap: true,
          children: <Widget>[
            _isRecording
                ? Container(
                    height: 120,
                    width: 120,
                    child: AvatarGlow(
                      startDelay: Duration(milliseconds: 200),
                      glowColor: Color(new CommonUtil().getMyPrimaryColor()),
                      endRadius: 100.0,
                      duration: Duration(milliseconds: 2000),
                      repeat: true,
                      showTwoGlows: true,
                      repeatPauseDuration: Duration(milliseconds: 100),
                      child: Material(
                        color: Colors.transparent,
                        shadowColor: Colors.transparent,
                        shape: CircleBorder(),
                        child: CircleAvatar(
                          backgroundColor:
                              ColorUtils.greycolor.withOpacity(0.5),
                          child: Icon(
                            Icons.mic,
                            size: 40,
                            color: Colors.black,
                          ),
                          radius: 30.0,
                        ),
                      ),
                      shape: BoxShape.circle,
                      animate: true,
                      curve: Curves.fastOutSlowIn,
                    ),
                  )
                : Container(
                    height: 120,
                    width: 120,
                    padding: EdgeInsets.all(10),
                    child: Material(
                      color: Colors.transparent,
                      shadowColor: Colors.transparent,
                      shape: CircleBorder(),
                      child: CircleAvatar(
                        backgroundColor: ColorUtils.greycolor,
                        child: Icon(
                          Icons.mic,
                          size: 40,
                          color: Colors.black,
                        ),
                        radius: 30.0,
                      ),
                    ),
                  ),
            Container(
                height: 60,
                child: Center(
                  child: Visibility(
                      visible: _isRecording ? true : false,
                      child: Container(
                        margin: EdgeInsets.only(top: 12.0, bottom: 16.0),
                        child: Text(
                          this._recorderTxt,
                          style: TextStyle(
                            fontSize: 22.0,
                            color: Colors.black54,
                          ),
                        ),
                      )),
                )),
            Align(
              alignment: Alignment.center,
              child: Container(
                constraints: BoxConstraints(minWidth: 160),
                decoration: BoxDecoration(
                    color: _isRecording ? Colors.red : Colors.green,
                    borderRadius: BorderRadius.circular(30)),
                child: ClipOval(
                  child: FlatButton(
                      onPressed: onStartRecorderPressed(),
                      padding: EdgeInsets.all(8.0),
                      child: recorderAssetImage()),
                ),
              ),
            ),
            SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
