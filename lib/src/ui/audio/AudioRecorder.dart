import 'dart:async';
import 'package:flutter/material.dart';

import 'dart:io';
import 'dart:typed_data' show Uint8List;
import 'package:avatar_glow/avatar_glow.dart';
import 'package:gmiwidgetspackage/widgets/flutterToast.dart';
import 'package:intl/intl.dart' show DateFormat;
import 'package:intl/date_symbol_data_local.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:myfhb/common/CommonConstants.dart';
import 'package:myfhb/constants/fhb_constants.dart';
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
import 'package:flutter_sound_platform_interface/flutter_sound_recorder_platform_interface.dart';

class AudioRecorder extends StatefulWidget {
  AudioScreenArguments arguments;
  AudioRecorder({this.arguments});
  @override
  _AudioRecorderState createState() => _AudioRecorderState();
}

class _AudioRecorderState extends State<AudioRecorder> {
  FlutterSoundPlayer _mPlayer = FlutterSoundPlayer();
  FlutterSoundRecorder _mRecorder = FlutterSoundRecorder();
  final String _mPath = 'flutter_sound.aac';
  StreamSubscription _recorderSubscription;
  StreamSubscription _playerSubscription;
  bool _isRecording = false;
  String _recorderTxt = variable.strStartTime;
  String _playerTxt = variable.strStartTime;
  double _dbLevel;
  String audioPathMain = '';
  bool containsAudioMain = true;
  double sliderCurrentPosition = 0.0;
  double maxDuration = 1.0;
  FlutterToast toast = FlutterToast();
  List<CategoryResult> filteredCategoryData;
  CategoryListBlock _categoryListBlock = CategoryListBlock();
  String _tempPath = '';

  @override
  void initState() {
    set_up_audios();
    super.initState();
  }

  set_up_audios() async {
    _mPlayer.openAudioSession().then(
      (value) {
        _mPlayer.setSubscriptionDuration(
          Duration(
            seconds: 1,
          ),
        );
      },
    );

    _mRecorder.openAudioSession().then(
      (value) {
        _mRecorder.setSubscriptionDuration(
          Duration(
            seconds: 1,
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _mPlayer.closeAudioSession();
    _mPlayer = null;
    _mRecorder.closeAudioSession();
    _mRecorder = null;
    super.dispose();
  }

  void record() async {
    try {
      await _mRecorder.startRecorder(
        toFile: _mPath,
        codec: Codec.aacMP4,
        audioSource: AudioSource.microphone,
      );
      _isRecording = true;
      setState(
        () {},
      );
      _mRecorder.onProgress.listen(
        (event) {
          setState(
            () {
              if (event.duration.inSeconds >= 180) {
                stopRecorder();
                toast.getToast(
                  'Maximum duration to record is 3 min',
                  Colors.red,
                );
                this.setState(
                  () {},
                );
              }
              _recorderTxt = _printDuration(event.duration);
              _dbLevel = event.decibels;
            },
          );
        },
      );
    } catch (e) {
      _isRecording = false;
      setState(
        () {},
      );
      _recorderTxt = variable.strStartTime;
    }
  }

  String _printDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "$twoDigitMinutes:$twoDigitSeconds";
  }

  void stopRecorder() async {
    try {
      final value = await _mRecorder.stopRecorder();
      _tempPath = value;
      if (widget.arguments.fromVoice) {
        await PreferenceUtil.saveString(
            Constants.KEY_CATEGORYNAME, Constants.STR_VOICERECORDS);
        await PreferenceUtil.saveString(Constants.KEY_CATEGORYID,
            PreferenceUtil.getStringValue(Constants.KEY_VOICE_ID));
        TextEditingController fileName = new TextEditingController(
            text: Constants.STR_VOICERECORDS +
                '_${DateTime.now().toUtc().millisecondsSinceEpoch}');
        CommonDialogBox().getDialogForVoicerecords(
          context,
          containsAudioMain,
          this._tempPath,
          (containsAudio, audioPath) {
            // audioPathMain = audioPath;
            // containsAudioMain = containsAudio;
            Navigator.of(context).pop();
            setState(
              () {},
            );
          },
          (containsAudio, audioPath) {
            audioPathMain = audioPath;
            containsAudioMain = containsAudio;
            setState(
              () {},
            );
          },
          false,
          fileName,
          fromClass: widget.arguments.fromClass??'',
        );
      } else {
        if (value != null && value != '')
          Navigator.of(context).pop({Constants.keyAudioFile: value});
      }
    } catch (e) {
      print("Failed to stop recorder");
    }
    _isRecording = false;
    if (_recorderSubscription != null) {
      _recorderSubscription.cancel();
      _recorderSubscription = null;
    }
    setState(
      () {},
    );
    _recorderTxt = variable.strStartTime;
  }

  void play() {
    assert(_mRecorder.isStopped && _mPlayer.isStopped);
    _mPlayer
        .startPlayer(
            fromURI: _mPath,
            codec: Codec.aacMP4,
            whenFinished: () {
              setState(
                () {},
              );
            })
        .then(
      (value) {
        setState(
          () {},
        );
      },
    );
  }

  void stopPlayer() {
    _mPlayer.stopPlayer().then(
      (value) {
        setState(
          () {},
        );
      },
    );
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
        title: Text(
          variable.strVoiceRecord,
        ),
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
                      glowColor: Color(
                        new CommonUtil().getMyPrimaryColor(),
                      ),
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
                  visible: _isRecording,
                  child: Container(
                    margin: EdgeInsets.only(top: 12.0, bottom: 16.0),
                    child: Text(
                      this._recorderTxt,
                      style: TextStyle(
                        fontSize: 22.0.sp,
                        color: Colors.black54,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: Container(
                constraints: BoxConstraints(minWidth: 160.0.w),
                decoration: BoxDecoration(
                    color: _isRecording ? Colors.red : Colors.green,
                    borderRadius: BorderRadius.circular(30)),
                child: ClipOval(
                  child: FlatButton(
                    onPressed: () {
                      _mRecorder.isRecording ? stopRecorder() : record();
                    },
                    padding: EdgeInsets.all(8.0),
                    child: recorderAssetImage(),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 40.0.h,
            ),
          ],
        ),
      ),
    );
  }

  Widget recorderAssetImage() {
    return _mRecorder.isStopped
        ? Text(
            variable.strStartrecord,
            style: TextStyle(
              color: Colors.white,
            ),
          )
        : Text(
            variable.strStopRecord,
            style: TextStyle(
              color: Colors.white,
            ),
          );
  }
}
