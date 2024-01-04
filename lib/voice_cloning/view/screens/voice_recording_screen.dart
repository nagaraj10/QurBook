import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import '../../../common/CommonUtil.dart';
import '../../../constants/fhb_constants.dart';
import '../../../constants/variable_constant.dart';
import '../../../more_menu/screens/terms_and_conditon.dart';
import '../../../src/utils/screenutils/size_extensions.dart';
import '../../../widgets/app_primary_button.dart';
import '../../controller/voice_cloning_controller.dart';
import '../widgets/webcontent_widget.dart';

class VoiceRecordingScreen extends StatefulWidget {
  const VoiceRecordingScreen({super.key});

  @override
  State<VoiceRecordingScreen> createState() => _VoiceRecordingScreenState();
}

class _VoiceRecordingScreenState extends State<VoiceRecordingScreen> {
  late VoiceCloningController _voiceCloningController;

  @override
  void initState() {
    ///Initializing the audio and player controllers
    Provider.of<VoiceCloningController>(context, listen: false)
        .initialiseControllers();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<VoiceCloningController>(context, listen: false).getDir();
      Provider.of<VoiceCloningController>(context, listen: false)
          .showCountdownDialog();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    /// Retrieving and Listening to VoiceCloningController
    ///  reference from the Provider
    _voiceCloningController = Provider.of<VoiceCloningController>(context);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            size: 24.0.sp,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: AppBarForVoiceCloning().getVoiceCloningAppBar(),
        centerTitle: false,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: WebContentWidget(
                  selectedUrl: CommonUtil.PORTAL_URL + voice_transcript_html,
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

  ///Widget for the Recorder
  Container _recorderControllerWidget() => Container(
        width: double.infinity,
        color: const Color(0xFF333232),
        padding: EdgeInsets.only(top: 20.h, bottom: 20.h),
        child: Column(
          children: [
            AudioWaveforms(
              enableGesture: true,
              size: const Size(double.infinity, 100),
              recorderController: _voiceCloningController.recorderController,
              waveStyle: const WaveStyle(
                waveColor: Colors.white,
                extendWaveform: true,
                showMiddleLine: false,
              ),
              padding: const EdgeInsets.only(left: 18),
              margin: const EdgeInsets.symmetric(horizontal: 15),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(8)),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        height: 10,
                        margin: const EdgeInsets.only(right: 5),
                        width: 10,
                        decoration: const BoxDecoration(
                            color: Colors.red, shape: BoxShape.circle),
                      ),
                      const Text(
                        rec,
                        style: TextStyle(
                            color: Colors.white,
                            letterSpacing: 1,
                            fontWeight: FontWeight.w600),
                      )
                    ],
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Text(
                  _voiceCloningController.recordingDurationTxt,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      letterSpacing: 2,
                      fontWeight: FontWeight.w600),
                ),
              ],
            ),
            const SizedBox(
              height: 30,
            ),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              InkWell(
                onTap: () {
                  _voiceCloningController.toggleResumePause();
                },
                child: SvgPicture.asset(
                  _voiceCloningController.isRecording
                      ? icVoicePause
                      : icVoiceMic,
                  color: _voiceCloningController.isRecording
                      ? Colors.red.withOpacity(0.5)
                      : Colors.green,
                  height: 50,
                  width: 50,
                ),
              ),
              const SizedBox(
                width: 40,
              ),
              InkWell(
                onTap: () => _voiceCloningController.canStopRecording
                    ? _voiceCloningController.stopRecording()
                    : null,
                child: SvgPicture.asset(
                  icVoiceStop,
                  color: Colors.red.withOpacity(
                      _voiceCloningController.canStopRecording ? 1 : 0.4),
                  height: 50,
                  width: 50,
                ),
              ),
            ]),
          ],
        ),
      );

  ///Widget for Player controller
  Container _playerControllerWidget() => Container(
        width: double.infinity,
        color: const Color(0xFF333232),
        padding: EdgeInsets.only(top: 20.h, bottom: 20.h),
        child: _voiceCloningController.isPlayerLoading
            ? Container(
                alignment: Alignment.center,
                height: 150,
                width: double.infinity,
                child: const CircularProgressIndicator(
                  color: Colors.white,
                ),
              )
            : Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AudioFileWaveforms(
                    size: Size(MediaQuery.of(context).size.width, 100),
                    playerController: _voiceCloningController.playerController,
                    enableSeekGesture: false,
                    waveformData: _voiceCloningController.audioWaveData,
                    playerWaveStyle: PlayerWaveStyle(
                      fixedWaveColor: Colors.white,
                      liveWaveColor: Color(CommonUtil().getMyPrimaryColor()),
                      spacing: 6,
                    ),
                  ),
                  Slider(
                    activeColor: Color(CommonUtil().getMyPrimaryColor())
                        .withOpacity(0.5),
                    inactiveColor: Colors.white,
                    value: _voiceCloningController.playPosition,
                    max: _voiceCloningController.maxPlayerDuration > 0
                        ? _voiceCloningController.maxPlayerDuration
                        : 1.0,
                    onChanged: (value) {
                      _voiceCloningController.playerController
                          .seekTo(value.round());
                    },
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10.w),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            _voiceCloningController.formatPlayerDuration(
                                _voiceCloningController.playPosition),
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                        Expanded(
                          child: InkWell(
                            onTap: () {
                              _voiceCloningController.playPausePlayer();
                            },
                            child: SvgPicture.asset(
                              _voiceCloningController
                                      .playerController.playerState.isPlaying
                                  ? icVoicePause
                                  : icVoicePlay,
                              color: Colors.white,
                              height: 45,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Text(
                            _voiceCloningController.formatPlayerDuration(
                                _voiceCloningController.maxPlayerDuration),
                            textAlign: TextAlign.right,
                            style: const TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: AppPrimaryButton(
                              text: reRecord,
                              textSize: 14.0.sp,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(25),
                                  color: Colors.white),
                              textColor:
                                  Color(CommonUtil().getMyPrimaryColor()),
                              onTap: () {
                                _voiceCloningController.reRecord();
                              }),
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        Expanded(
                          child: AppPrimaryButton(
                              text: SUBMIT,
                              textSize: 14.0.sp,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(25),
                                  color:
                                      Color(CommonUtil().getMyPrimaryColor())),
                              textColor: Colors.white,
                              onTap: () {
                                _voiceCloningController.submitRecording();
                              }),
                        ),
                      ],
                    ),
                  )
                ],
              ),
      );

  @override
  void dispose() {
    ///Dispose the player and recorder to avoid  memory leaks.
    _voiceCloningController.disposeRecorder();
    super.dispose();
  }
}
