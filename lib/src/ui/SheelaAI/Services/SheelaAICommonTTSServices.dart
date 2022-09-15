import 'dart:convert';
import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import '../Controller/SheelaAIController.dart';

class SheelaAICommonTTSService {
  AudioPlayer player;
  SheelaAIController controller = Get.find<SheelaAIController>();

  stopTTS() {
    player?.stop();
    player = null;
    if (controller.useLocalTTSEngine) {
      controller.playUsingLocalTTSEngineFor("", close: true);
    }
  }

  playTTS(String msg, Function completedPlaying) async {
    if (controller.useLocalTTSEngine) {
      try {
        final status = await controller.playUsingLocalTTSEngineFor(msg);
        completedPlaying();
      } catch (e) {
        //failed to play in local tts
        completedPlaying();
      }
    } else {
      String textForPlaying;
      final result = await controller.getGoogleTTSForText(msg);
      if ((result.payload?.audioContent ?? '').isNotEmpty) {
        textForPlaying = result.payload.audioContent;
      }
      if ((textForPlaying ?? '').isNotEmpty) {
        try {
          final bytes = const Base64Decoder().convert(textForPlaying);
          if (bytes != null) {
            final dir = await getTemporaryDirectory();
            final file = File('${dir.path}/tempAudioFile.mp3');
            await file.writeAsBytes(bytes);
            final path = "${dir.path}/tempAudioFile.mp3";
            player = null;
            player = AudioPlayer();
            player.play(path, isLocal: true);
            player.onPlayerStateChanged.listen(
              (event) {
                if (event == PlayerState.COMPLETED) {
                  completedPlaying();
                }
              },
            );
          }
        } catch (e) {
          //failed play the audio
          print(e.toString());
          completedPlaying();
        }
      } else {
        completedPlaying();
      }
    }
  }
}
