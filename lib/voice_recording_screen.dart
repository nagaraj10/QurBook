import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_audio_waveforms/flutter_audio_waveforms.dart';
import 'package:flutter_sound/public/flutter_sound_player.dart';
import 'package:flutter_sound/public/flutter_sound_recorder.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:myfhb/constants/fhb_constants.dart';
import 'package:myfhb/src/utils/screenutils/size_extensions.dart';
import 'package:path_provider/path_provider.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'countdown_timer_widget.dart';

class VoiceRecordingScreen extends StatefulWidget {
  @override
  State<VoiceRecordingScreen> createState() => _VoiceRecordingScreenState();
}

class _VoiceRecordingScreenState extends State<VoiceRecordingScreen> {
  // late final RecorderController recorderController;
/*  String? path;
  String? musicFile;
  bool isRecording = false;
  bool isRecordingCompleted = false;
  bool isLoading = true;
  late Directory appDirectory;*/
  FlutterSoundPlayer? _mPlayer = FlutterSoundPlayer();
  FlutterSoundRecorder? _mRecorder = FlutterSoundRecorder();

  @override
  void initState() {
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
/*      _getDir();
      _initialiseControllers();*/
      _showCountdownDialog();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: WebView(
                initialUrl: 'https://qurhealth.com/',
                javascriptMode: JavascriptMode.unrestricted,
              ),
            ),
            _bottomControllerWidget()
          ],
        ),
      ),
    );
  }

  _bottomControllerWidget() {
    return Container(
      width: double.infinity,
      color: Color(0xffA9A9A9),
      padding: EdgeInsets.only(top: 20.h, bottom: 20.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.all(5),
                decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(8)),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      height: 10,
                      margin: EdgeInsets.only(right: 5),
                      width: 10,
                      decoration: BoxDecoration(
                          color: Colors.red, shape: BoxShape.circle),
                    ),
                    Text(
                      'REC',
                      style: TextStyle(
                          color: Colors.white,
                          letterSpacing: 1,
                          fontWeight: FontWeight.w600),
                    )
                  ],
                ),
              ),
              SizedBox(
                width: 10,
              ),
              Text(
                '1:06:07',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    letterSpacing: 2,
                    fontWeight: FontWeight.w600),
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            SvgPicture.asset(
              icVoiceMic,
              color: Colors.green,
              height: 50,
              width: 50,
            ),
            SizedBox(
              width: 40,
            ),
            SvgPicture.asset(
              icVoiceStop,
              color: Colors.red,
              height: 50,
              width: 50,
            ),
          ]),
        ],
      ),
    );
  }

  _showCountdownDialog() {
    showDialog(
        context: Get.context!,
        builder: (context) {
          return AlertDialog(
            insetPadding: EdgeInsets.all(10),
            clipBehavior: Clip.antiAlias,
            contentPadding: EdgeInsets.zero,
            backgroundColor: Colors.transparent,
            content: VoiceCloningCountDownWidget(),
          );
        });
  }

/*  void _getDir() async {
    appDirectory = await getApplicationDocumentsDirectory();
    path = "${appDirectory.path}/recording.mp3";
    isLoading = false;
    setState(() {});
  }
  void _initialiseControllers() {
    recorderController = RecorderController()
      ..androidEncoder = AndroidEncoder.aac
      ..androidOutputFormat = AndroidOutputFormat.mpeg4
      ..iosEncoder = IosEncoder.kAudioFormatMPEG4AAC
      ..sampleRate = 44100;
  }*/

}
