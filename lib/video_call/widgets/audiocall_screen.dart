import 'package:flutter/material.dart';
import 'package:myfhb/common/CommonUtil.dart';

class AudioCallScreen extends StatelessWidget {
  final String avatar;
  AudioCallScreen(
      {this.avatar =
          'https://qurbook.com/wp-content/uploads/2021/02/qurbook-logo-1.png'});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(CommonUtil().getMyPrimaryColor()),
      child: Center(
        child: Container(
          height: 400,
          width: MediaQuery.of(context).size.width,
          child: (avatar != null && avatar != '')
              ? Image.network(avatar)
              : Image.asset('assets/user/profile_pic_ph.png'),
        ),
      ),
    );
  }
}
