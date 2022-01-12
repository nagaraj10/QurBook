import 'dart:io';

import 'package:flutter/material.dart';
import 'package:myfhb/constants/fhb_constants.dart';
import 'package:myfhb/telehealth/features/chat/constants/const.dart';
import 'package:myfhb/widgets/GradientAppBar.dart';
import 'package:photo_view/photo_view.dart';
import 'package:myfhb/src/utils/screenutils/size_extensions.dart';

class FullPhoto extends StatelessWidget {
  final String url;
  final String filePath;

  FullPhoto({Key key, @required this.url, this.filePath}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: GradientAppBar(),
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
          'Attachment',
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
      ),
    );
  }
}

class FullPhotoScreen extends StatefulWidget {
  final String url;
  final String filePath;

  FullPhotoScreen({Key key, @required this.url, this.filePath})
      : super(key: key);

  @override
  State createState() => FullPhotoScreenState(url: url);
}

class FullPhotoScreenState extends State<FullPhotoScreen> {
  final String url;

  FullPhotoScreenState({Key key, @required this.url});

  @override
  void initState() {
    mInitialTime = DateTime.now();
    super.initState();
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
      return Container(child: PhotoView(imageProvider: NetworkImage(url)));
    } else {
      return Container(child: Center(child: Image.file(File(widget.filePath))));
    }
  }
}
