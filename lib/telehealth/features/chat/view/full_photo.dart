import 'dart:io';

import 'package:flutter/material.dart';
import 'package:myfhb/Qurhome/Common/GradientAppBarQurhome.dart';
import 'package:myfhb/chat_socket/service/ChatSocketService.dart';
import 'package:myfhb/common/PreferenceUtil.dart';
import 'package:myfhb/constants/fhb_constants.dart';
import 'package:myfhb/widgets/GradientAppBar.dart';
import 'package:photo_view/photo_view.dart';
import 'package:myfhb/src/utils/screenutils/size_extensions.dart';

class FullPhoto extends StatelessWidget {
  final String? url;
  final String? filePath;
  final String? titleSheelaPreview;
  final String? chatMessageId;

  FullPhoto(
      {Key? key,
      required this.url,
      this.filePath,
      this.titleSheelaPreview,
      this.chatMessageId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: (PreferenceUtil.getIfQurhomeisAcive())
            ? GradientAppBarQurhome()
            : GradientAppBar(),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            size: 24.0.sp,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Text(
          titleSheelaPreview ?? 'Attachment',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16.0.sp,
          ),
        ),
        centerTitle: false,
      ),
      body: FullPhotoScreen(
        url: url,
        filePath: filePath,
        chatMessageId: chatMessageId,
      ),
    );
  }
}

class FullPhotoScreen extends StatefulWidget {
  final String? url;
  final String? filePath;
  final String? chatMessageId;

  FullPhotoScreen(
      {Key? key, required this.url, this.filePath, this.chatMessageId})
      : super(key: key);

  @override
  State createState() => FullPhotoScreenState(url: url);
}

class FullPhotoScreenState extends State<FullPhotoScreen> {
  final String? url;

  FullPhotoScreenState({Key? key, required this.url});

  ChatSocketService _chatSocketService = ChatSocketService();

  @override
  void initState() {
    mInitialTime = DateTime.now();
    super.initState();
    if (widget.chatMessageId != null && widget.chatMessageId != '') {
      callChatunreadMessageApi();
    }
  }

  callChatunreadMessageApi() {
    _chatSocketService.getUnreadChatWithMsgId(widget.chatMessageId ?? '');
  }

  @override
  void dispose() {
    super.dispose();
    fbaLog(eveName: 'qurbook_screen_event', eveParams: {
      'eventTime': '${DateTime.now()}',
      'pageName': 'Profile Picture Screen',
      'screenSessionTime':
          '${DateTime.now().difference(mInitialTime).inSeconds} secs'
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.filePath == null) {
      return Container(child: PhotoView(imageProvider: NetworkImage(url!)));
    } else {
      return Container(child: PhotoView(imageProvider: FileImage(File(widget.filePath??''))));
    }
  }
}
