import 'dart:async';
import 'dart:io';
import 'dart:typed_data' show Uint8List;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_sound/flutter_sound.dart';
import 'package:get/get.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart' show DateFormat;
import 'package:myfhb/chat_socket/service/ChatSocketService.dart';
import 'package:myfhb/common/CommonUtil.dart';
import 'package:myfhb/common/PreferenceUtil.dart';
import 'package:myfhb/src/ui/SheelaAI/Controller/SheelaAIController.dart';
import 'package:myfhb/src/utils/screenutils/size_extensions.dart';
import 'package:path/path.dart';

enum t_MEDIA {
  FILE,
  BUFFER,
  ASSET,
  STREAM,
}

class AudioWidgetSheelaPreview extends StatefulWidget {
  String? audioFile;
  String? audioUrl;
  bool isFromChat;
  bool isFromSheela;
  bool isPlayAudioUrl;
  String? chatMessageId;

  Function(bool, String?)? deleteAudioFile;

  AudioWidgetSheelaPreview(
    this.audioFile,
    this.deleteAudioFile, {
    this.isFromChat = false,
    this.isFromSheela = false,
    this.isPlayAudioUrl = false,
    this.chatMessageId,
  });

  @override
  AudioWidgetSheelaPreviewState createState() =>
      AudioWidgetSheelaPreviewState();
}

class AudioWidgetSheelaPreviewState extends State<AudioWidgetSheelaPreview> {
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
  late SheelaAIController _sheelaAIController;

  String? audioUrl = '';

  ChatSocketService _chatSocketService = new ChatSocketService();

  @override
  void initState() {
    super.initState();
    set_up_audios();
    initializeDateFormatting();
    _pathOfFile = widget.audioFile;
    audioUrl = widget.audioUrl;
    if (!widget.isPlayAudioUrl) {
      if (widget.isFromSheela) {
        _sheelaAIController = Get.find();
        Future.delayed(const Duration(milliseconds: 5))
            .then((value) => onStartPlayerPressed());
      }
    } else {
      _sheelaAIController = Get.find();
    }

    if (widget.chatMessageId != null && widget.chatMessageId != '') {
      callChatunreadMessageApi();
    }
  }

  callChatunreadMessageApi() {
    _chatSocketService.getUnreadChatWithMsgId(widget.chatMessageId ?? '');
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
    return getAudioWidgetWithPlayer();
  }

  Widget getAudioWidgetWithPlayer() {
    return Column(
      children: [
        Expanded(
            child: Icon(
          Icons.mic,
          size: 92.sp,
        )),
        Container(
          margin: EdgeInsets.only(bottom: 40),
          child: Column(
            children: [
              IconButton(
                iconSize: 62.sp,
                color: (PreferenceUtil.getIfQurhomeisAcive())
                    ? Color(CommonUtil().getQurhomePrimaryColor())
                    : Color(CommonUtil().getMyPrimaryColor()),
                onPressed: () {
                  isPlaying ? onPausePlayerPressed() : onStartPlayerPressed();
                },
                icon: !isPlaying
                    ? Icon(
                        Icons.play_circle,
                      )
                    : Icon(
                        Icons.pause_circle,
                      ),
              ),
              SizedBox(height: 2.h),
              Container(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      child: Container(
                        height: 30.0.h,
                        child: Slider(
                          activeColor: (PreferenceUtil.getIfQurhomeisAcive())
                              ? Color(CommonUtil().getQurhomePrimaryColor())
                              : Color(CommonUtil().getMyPrimaryColor()),
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
                  ],
                  mainAxisAlignment: MainAxisAlignment.center,
                ),
              ),
              SizedBox(height: 2.h),
              Center(
                child: Text(
                  _playerTxt,
                  style: TextStyle(
                    fontSize: 18.0.sp,
                    color: Colors.black,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
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
      _sheelaAIController.isLoading.value = true;
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
            final DuarationOfFile = await (flutterSound!.startPlayer(
              fromDataBuffer: buffer,
              whenFinished: () {
                stopPlayer();
              },
            ));
            maxDuration = DuarationOfFile!.inSeconds.toDouble();
          }
        }
      } else {
        final DuarationOfFile = await (flutterSound!.startPlayer(
          fromURI: path,
          whenFinished: () {
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
    } catch (err, stackTrace) {
      print(err.toString());
      CommonUtil()
          .appLogs(message: err.toString(), stackTrace: stackTrace.toString());
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
    } catch (e, stackTrace) {
      CommonUtil().appLogs(message: e, stackTrace: stackTrace);
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
          _sheelaAIController.isLoading.value = true;
        }

        print("Inside pause player resume");
        isPlaying = true;
      } else {
        await flutterSound!.pausePlayer();
        if (widget.isFromSheela) {
          _sheelaAIController.isLoading.value = false;
        }

        print("Inside pause player pause");

        isPlaying = false;
      }
    } catch (err, stackTrace) {
      CommonUtil()
          .appLogs(message: err.toString(), stackTrace: stackTrace.toString());
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
        _sheelaAIController.isLoading.value = false;
      }

      await flutterSound!.stopPlayer();
      if (_playerSubscription != null) {
        await _playerSubscription!.cancel();
        _playerSubscription = null;
      }
      sliderCurrentPosition = 0.0;
      _playerTxt = '00:00';
      isPlaying = false;
    } catch (err, stackTrace) {
      CommonUtil()
          .appLogs(message: err.toString(), stackTrace: stackTrace.toString());
    }
    setState(() {});
  }
}
