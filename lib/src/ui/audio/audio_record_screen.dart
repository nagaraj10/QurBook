
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
import 'package:myfhb/constants/fhb_constants.dart';
import 'package:myfhb/src/utils/language/language_utils.dart';
import 'package:myfhb/src/blocs/Category/CategoryListBlock.dart';
import 'package:myfhb/src/model/Category/catergory_result.dart';
import 'package:myfhb/src/ui/audio/AudioScreenArguments.dart';
import 'package:myfhb/src/utils/colors_utils.dart';
import 'package:myfhb/widgets/GradientAppBar.dart';
import 'package:myfhb/common/CommonDialogBox.dart';
import 'package:myfhb/common/PreferenceUtil.dart';
import 'package:myfhb/constants/fhb_constants.dart' as Constants;
import 'package:myfhb/common/CommonUtil.dart';
import 'package:myfhb/constants/variable_constant.dart' as variable;
import 'package:myfhb/src/utils/screenutils/size_extensions.dart';

enum t_MEDIA {
  FILE,
  BUFFER,
  ASSET,
  STREAM,
}

class AudioRecordScreen extends StatefulWidget {
  AudioScreenArguments? arguments;

  AudioRecordScreen({this.arguments});
  @override
  _AudioRecordScreenState createState() => new _AudioRecordScreenState();
}

class _AudioRecordScreenState extends State<AudioRecordScreen> {
  bool _isRecording = false;
  List<String?> _path = [null, null, null, null, null, null, null];
  StreamSubscription? _recorderSubscription;
  StreamSubscription? _dbPeakSubscription;
  StreamSubscription? _playerSubscription;
  late FlutterSound flutterSound;

  String _recorderTxt = variable.strStartTime;
  String _playerTxt = variable.strStartTime;
  double? _dbLevel;
  String? audioPathMain = '';
  bool containsAudioMain = true;
  double sliderCurrentPosition = 0.0;
  double maxDuration = 1.0;
  t_MEDIA _media = t_MEDIA.FILE;
  Codec _codec = Codec.aacADTS;

  FlutterToast toast = new FlutterToast();

  List<CategoryResult> filteredCategoryData = [];
  CategoryListBlock _categoryListBlock = new CategoryListBlock();

  @override
  void initState() {
    mInitialTime = DateTime.now();
    super.initState();
    flutterSound = new FlutterSound();
    // flutterSound.setSubscriptionDuration(0.01);
    // flutterSound.setDbPeakLevelUpdate(0.8);
    // flutterSound.setDbLevelEnabled(true);
    initializeDateFormatting();
  }

  @override
  void dispose() {
    super.dispose();
    fbaLog(eveName: 'qurbook_screen_event', eveParams: {
      'eventTime': '${DateTime.now()}',
      'pageName': 'Audio Record Screen',
      'screenSessionTime':
          '${DateTime.now().difference(mInitialTime).inSeconds} secs'
    });
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
      //TODO: Check for audio
      // String path = await flutterSound.startRecorder(
      //   codec: _codec,
      // );
      //
      // _recorderSubscription = flutterSound.onRecorderStateChanged.listen((e) {
      //   DateTime date = new DateTime.fromMillisecondsSinceEpoch(
      //       e.currentPosition.toInt(),
      //       isUtc: true);
      //   String txt =
      //       DateFormat(variable.strDatems, variable.strenUs).format(date);
      //
      //   this.setState(() {
      //     this._recorderTxt = txt.substring(0, 5);
      //   });
      //
      //   if (e.currentPosition.toInt() >= 180000) {
      //     stopRecorder();
      //     toast.getToast('Maximum duration to record is 3 min', Colors.red);
      //     this.setState(() {});
      //   }
      // });
      // _dbPeakSubscription =
      //     flutterSound.onRecorderDbPeakChanged.listen((value) {
      //   setState(() {
      //     this._dbLevel = value;
      //   });
      // });
      //TODO: Check for audio

      // this.setState(() {
      //   this._isRecording = true;
      //   this._path[_codec.index] = path;
      // });
    } catch (err) {
      setState(() {
        this._isRecording = false;
      });
    }
  }

  void stopRecorder() async {
    String? result;
    try {
      // result = await flutterSound.stopRecorder();
      //TODO: Check for audio

      if (_recorderSubscription != null) {
        _recorderSubscription!.cancel();
        _recorderSubscription = null;
      }
      if (_dbPeakSubscription != null) {
        _dbPeakSubscription!.cancel();
        _dbPeakSubscription = null;
      }
    } catch (err) {}
    this.setState(() {
      this._isRecording = false;
    });
    if (widget.arguments!.fromVoice!) {
      PreferenceUtil.saveString(
              Constants.KEY_CATEGORYNAME, AppConstants.voiceRecords)
          .then((value) {
        PreferenceUtil.saveString(Constants.KEY_CATEGORYID,
                PreferenceUtil.getStringValue(Constants.KEY_VOICE_ID)!)
            .then((value) {
          TextEditingController fileName = new TextEditingController(
              text: AppConstants.voiceRecords +
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
          }, false, fileName, fromClass: widget.arguments!.fromClass);
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

  Future<Uint8List?> makeBuffer(String path) async {
    try {
      if (!await fileExists(path)) return null;
      File file = File(path);
      file.openRead();
      var contents = await file.readAsBytes();

      return contents;
    } catch (e,stackTrace) {
                  CommonUtil().appLogs(message: e,stackTrace:stackTrace);

      return null;
    }
  }

  void startPlayer() async {
    try {
      String? path = null;
      if (_media == t_MEDIA.ASSET) {
        Uint8List buffer =
            (await rootBundle.load(variable.assetSample[_codec.index]))
                .buffer
                .asUint8List();
        // path = await flutterSound.startPlayerFromBuffer(
        //   buffer,
        //   codec: _codec,
        // );
        //TODO: Check for audio
      } else if (_media == t_MEDIA.FILE) {
        // Do we want to play from buffer or from file ?
        if (await fileExists(_path[_codec.index]!)) {}
        //TODO: Check for audio
        // path = await flutterSound
        //     .startPlayer(this._path[_codec.index]); // From file
      } else if (_media == t_MEDIA.BUFFER) {
        // Do we want to play from buffer or from file ?
        if (await fileExists(_path[_codec.index]!)) {
          Uint8List? buffer = await makeBuffer(this._path[_codec.index]!);
          // if (buffer != null)
          // path = await flutterSound.thePlayer.startPlayerFromBuffer(
          //   buffer,
          //   codec: _codec,
          // ); // From buffer
          //TODO: Check for audio
        }
      }
      if (path == null) {
        return;
      }
      await flutterSound.thePlayer.setVolume(1.0);

      // _playerSubscription = flutterSound.onPlayerStateChanged.listen((e) {
      //   if (e != null) {
      //     sliderCurrentPosition = e.currentPosition;
      //     maxDuration = e.duration;
      //
      //     DateTime date = new DateTime.fromMillisecondsSinceEpoch(
      //         e.currentPosition.toInt(),
      //         isUtc: true);
      //     String txt =
      //         DateFormat(variable.strDatems, variable.strenUs).format(date);
      //     this.setState(() {
      //       this._playerTxt = txt.substring(0, 5);
      //     });
      //   }
      // });
      //TODO: Check for audio
    } catch (err) {}
    setState(() {});
  }

  void stopPlayer() async {
    try {
      await flutterSound.thePlayer.stopPlayer();
      if (_playerSubscription != null) {
        _playerSubscription!.cancel();
        _playerSubscription = null;
      }
      sliderCurrentPosition = 0.0;
    } catch (err) {}
    this.setState(() {
      //this._isPlaying = false;
    });
  }

  void pausePlayer() async {
    try {
      if (flutterSound.thePlayer.playerState == PlayerState.isPaused) {
        await flutterSound.thePlayer.resumePlayer();
      } else {
        await flutterSound.thePlayer.pausePlayer();
      }
    } catch (err) {}
    setState(() {});
  }

  void seekToPlayer(int milliSecs) async {
    await flutterSound.thePlayer.seekToPlayer(
      Duration(
        milliseconds: milliSecs,
      ),
    );
  }

  onPausePlayerPressed() {
    return flutterSound.thePlayer.playerState == PlayerState.isPlaying ||
            flutterSound.thePlayer.playerState == PlayerState.isPaused
        ? pausePlayer
        : null;
  }

  onStopPlayerPressed() {
    return flutterSound.thePlayer.playerState == PlayerState.isPlaying ||
            flutterSound.thePlayer.playerState == PlayerState.isPaused
        ? stopPlayer
        : null;
  }

  onStartPlayerPressed() {
    if (_media == t_MEDIA.FILE || _media == t_MEDIA.BUFFER) {
      if (_path[_codec.index] == null) return null;
    }
    return flutterSound.thePlayer.playerState == PlayerState.isStopped
        ? startPlayer
        : null;
  }

  onStartRecorderPressed() {
    if (_media == t_MEDIA.ASSET || _media == t_MEDIA.BUFFER) return null;
    // if (flutterSound.thePlayer.playerState == PlayerState.IS_RECORDING)
    //   return stopRecorder;
    //TODO: Check for audio

    return flutterSound.thePlayer.playerState == PlayerState.isStopped
        ? startRecorder
        : null;
  }

  Widget recorderAssetImage() {
    if (onStartRecorderPressed() == null)
      return Icon(
        Icons.mic_off,
        color: Colors.white54,
        size: 24.0.sp,
      );
    return flutterSound.thePlayer.playerState == PlayerState.isStopped
        ? Text(
            variable.strStartrecord,
            style: TextStyle(color: Colors.white),
          )
        : Text(variable.strStopRecord, style: TextStyle(color: Colors.white));
  }

  setCodec(Codec codec) async {
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
          child: Icon(
            Icons.arrow_back_ios,
            size: 24.0.sp,
          ),
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
                    height: 120.0.h,
                    width: 120.0.h,
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
                            size: 40.0.sp,
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
                    height: 120.0.h,
                    width: 120.0.h,
                    padding: EdgeInsets.all(10),
                    child: Material(
                      color: Colors.transparent,
                      shadowColor: Colors.transparent,
                      shape: CircleBorder(),
                      child: CircleAvatar(
                        backgroundColor: ColorUtils.greycolor,
                        child: Icon(
                          Icons.mic,
                          size: 40.0.sp,
                          color: Colors.black,
                        ),
                        radius: 30.0,
                      ),
                    ),
                  ),
            Container(
                height: 60.0.h,
                child: Center(
                  child: Visibility(
                      visible: _isRecording ? true : false,
                      child: Container(
                        margin: EdgeInsets.only(top: 12.0, bottom: 16.0),
                        child: Text(
                          this._recorderTxt,
                          style: TextStyle(
                            fontSize: 22.0.sp,
                            color: Colors.black54,
                          ),
                        ),
                      )),
                )),
            Align(
              alignment: Alignment.center,
              child: Container(
                constraints: BoxConstraints(minWidth: 160.0.w),
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
            SizedBox(height: 40.0.h),
          ],
        ),
      ),
    );
  }
}
