import 'dart:io';

import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

import '../../../../Qurhome/Common/GradientAppBarQurhome.dart';
import '../../../../chat_socket/service/ChatSocketService.dart';
import '../../../../common/PreferenceUtil.dart';
import '../../../../src/utils/screenutils/size_extensions.dart';
import '../../../../widgets/GradientAppBar.dart';

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
    super.initState();
    if (widget.chatMessageId != null && widget.chatMessageId != '') {
      callChatunreadMessageApi();
    }
  }

  callChatunreadMessageApi() {
    _chatSocketService.getUnreadChatWithMsgId(widget.chatMessageId ?? '');
  }

  @override
  Widget build(BuildContext context) {
    if (widget.filePath == null) {
      return PhotoView(imageProvider: NetworkImage(url!));
    } else {
      return Center(child: Image.file(File(widget.filePath!)));
    }
  }
}
