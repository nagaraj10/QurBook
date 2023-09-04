import 'package:flutter/material.dart';
import 'package:myfhb/common/AudioWidget.dart';
import 'package:myfhb/src/utils/screenutils/size_extensions.dart';
import 'package:myfhb/widgets/GradientAppBar.dart';

import 'AudioWidgetSheelaPreview.dart';

class AudioScreenPreviewSheela extends StatefulWidget {
  const AudioScreenPreviewSheela(
      {Key? key, @required this.audioUrl, this.title, this.chatMessageId})
      : super(key: key);

  final String? audioUrl;
  final String? title;
  final String? chatMessageId;

  @override
  State<AudioScreenPreviewSheela> createState() =>
      _AudioScreenPreviewSheelaState();
}

class _AudioScreenPreviewSheelaState extends State<AudioScreenPreviewSheela> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: GradientAppBar(),
        elevation: 0.0,
        backgroundColor: Colors.transparent,
        title: Text(
          widget.title ?? '',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18.0.sp,
          ),
        ),
      ),
      body: Container(
          color: Colors.grey[400], child: getAudioWidget(widget.audioUrl)),
    );
  }

  Widget getAudioWidget(String? audioPathMain) {
    return AudioWidgetSheelaPreview(audioPathMain, null,
        chatMessageId: widget.chatMessageId);
  }
}
