import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/shims/dart_ui_real.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:flutter_sound/public/flutter_sound_player.dart';
import 'package:flutter_sound/public/flutter_sound_recorder.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/state_manager.dart';
import 'package:gmiwidgetspackage/widgets/flutterToast.dart';
import 'package:myfhb/constants/fhb_constants.dart';
import 'package:myfhb/src/utils/screenutils/size_extensions.dart';
import 'package:myfhb/voice_cloning/controller/voice_cloning_controller.dart';
import 'package:myfhb/widgets/app_primary_button.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../../common/CommonUtil.dart';
import '../widgets/countdown_timer_widget.dart';

class VoiceRecordingScreen extends StatefulWidget {
  @override
  State<VoiceRecordingScreen> createState() => _VoiceRecordingScreenState();
}

class _VoiceRecordingScreenState extends State<VoiceRecordingScreen> {
  late VoiceCloningController _voiceCloningController;

  @override
  void initState() {
    Provider.of<VoiceCloningController>(context, listen: false)
        .initialiseControllers();
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      Provider.of<VoiceCloningController>(context, listen: false)
          .getDir();
      Provider.of<VoiceCloningController>(context, listen: false)
          .showCountdownDialog();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _voiceCloningController = Provider.of<VoiceCloningController>(context,listen: true);
    return Scaffold(
      body: SafeArea(
        child:Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 5),
                child: WebView(
                  initialUrl: 'https://portal.dev-efhb.vsolgmi.com/assets/voice_transcript.html',
                  javascriptMode: JavascriptMode.unrestricted,
                ),
              ),
            ),
            if (_voiceCloningController.isRecorderView) ...{
              _recorderControllerWidget()
            } else ...{
              _playerControllerWidget()
            }
          ],
        ),
      ),
    );
  }

  _recorderControllerWidget() {
    return Container(
      width: double.infinity,
      color: Color(0xFF333232),
      padding: EdgeInsets.only(top: 20.h, bottom: 20.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          AudioWaveforms(
            enableGesture: true,
            size: Size(
                double.infinity,
                100),
            recorderController: _voiceCloningController.recorderController,
            waveStyle: const WaveStyle(
              waveColor: Colors.white,
              extendWaveform: true,
              showMiddleLine: false,
            ),
            padding: const EdgeInsets.only(left: 18),
            margin: const EdgeInsets.symmetric(
                horizontal: 15),
          ),
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
                '${_voiceCloningController.recordingDurationTxt}',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    letterSpacing: 2,
                    fontWeight: FontWeight.w600),
              ),
            ],
          ),
          SizedBox(
            height: 30,
          ),
          Row(mainAxisAlignment: MainAxisAlignment.center,
              children: [
            InkWell(
              onTap: () {
                _voiceCloningController.toggleResumePause();
              },
              child: SvgPicture.asset(
                _voiceCloningController.isRecording
                    ? icVoicePause
                    : icVoiceMic,
                color:_voiceCloningController.isRecording?Colors.red.withOpacity(0.5): Colors.green,
                height: 50,
                width: 50,
              ),
            ),
            SizedBox(
              width: 40,
            ),
            InkWell(
              onTap: () {
                _voiceCloningController.stopRecording();
              },
              child: SvgPicture.asset(
                icVoiceStop,
                color: Colors.red,
                height: 50,
                width: 50,
              ),
            ),
          ]),
        ],
      ),
    );
  }

  _playerControllerWidget() => Container(
      width: double.infinity,
      color: Color(0xFF333232),
      padding: EdgeInsets.only(top: 20.h, bottom: 20.h),
      child:_voiceCloningController.isPlayerLoading?Container(
        alignment: Alignment.center,
        height: 150,
        width: double.infinity,
        child: CircularProgressIndicator(
          color: Colors.white,
        ),
      ):Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          AudioFileWaveforms(
      size: Size(MediaQuery.of(context).size.width, 100.0),
  playerController: _voiceCloningController.playerController,
  enableSeekGesture: false,
  waveformType: WaveformType.long,
  waveformData:_voiceCloningController.audioData,
  playerWaveStyle: PlayerWaveStyle(
  fixedWaveColor: Colors.white,
  liveWaveColor:Color(CommonUtil().getMyPrimaryColor()),
  spacing: 6,),
  ),
          Slider(
            activeColor: Color(CommonUtil().getMyPrimaryColor()).withOpacity(0.5),
            inactiveColor: Colors.white,
            value:_voiceCloningController.playPosition,
            min: 0,
            max:_voiceCloningController.maxPlayerDuration>0?
            _voiceCloningController.maxPlayerDuration:1.0,
            onChanged: (value) {
             _voiceCloningController.playerController.seekTo(value.round());
            },

          ),
          Padding(
            padding:  EdgeInsets.symmetric(horizontal: 10.w),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text('${_voiceCloningController.formatPlayerDuration(_voiceCloningController.playPosition)}',
                  style:TextStyle(
                    color: Colors.white
                  ),),
                ),
                Expanded(
                  child: InkWell(
                    onTap:(){
                      _voiceCloningController.playPausePlayer();
                    },
                    child: SvgPicture.asset(_voiceCloningController.playerController.playerState.isPlaying?icVoicePause:icVoicePlay,
                      color: Colors.white,
                      height: 40,),
                  ),
                ),
                Expanded(
                  child: Text('${_voiceCloningController.formatPlayerDuration(_voiceCloningController.maxPlayerDuration)}',
                  textAlign: TextAlign.right,
                  style:TextStyle(
                    color: Colors.white,
                  ),),
                ),
              ],
            ),
          ),
          SizedBox(height: 20,),
          Padding(
            padding:  EdgeInsets.symmetric(horizontal: 25),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: AppPrimaryButton(
                    text: 'Re-Record',
                      textSize:12,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25),
                        color: Colors.white
                      ),
                      textColor: (Color(CommonUtil().getMyPrimaryColor())),
                      onTap:(){
                      _voiceCloningController.reRecord();
                  }),
                ),
                SizedBox(width: 20,),
                Expanded(
                  child: AppPrimaryButton(
                      text: SUBMIT,
                      textSize:12,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(25),
                          color: Color(CommonUtil().getMyPrimaryColor())
                      ),
                      textColor: Colors.white,
                      onTap:(){
                        _voiceCloningController.submitRecording();
                      }),
                ),
              ],
            ),
          )
        ],
      ),
    );


  Widget _loader(){
  return  Container(
      height: double.infinity,
      width: double.infinity,
      alignment: Alignment.center,
      child:CircularProgressIndicator(color: Color(CommonUtil().getMyPrimaryColor()),),
    );
  }


  @override
  void dispose() {
    _voiceCloningController.disposeRecorder();
    super.dispose();
  }
}
