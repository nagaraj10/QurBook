import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:myfhb/common/CommonUtil.dart';

class AudioCallScreen extends StatelessWidget {
  final String avatar;
  String patName;
  AudioCallScreen({this.avatar, this.patName});

  @override
  Widget build(BuildContext context) {
    if (patName != null && patName != '') {
      if (patName?.toUpperCase()?.split(' ').length == 2) {
        patName = patName?.toUpperCase()?.split(' ')[0][0] +
            patName?.toUpperCase()?.split(' ')[1][0];
      } else {
        patName = patName?.toUpperCase()?.split(' ')[0][0];
      }
    }

    return Container(
      color: Colors.black45,
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: 120,
              width: 120,
              decoration: BoxDecoration(
                color: Color(CommonUtil.secondaryGrey),
                borderRadius: BorderRadius.all(
                  Radius.circular(100),
                ),
              ),
              child: Center(
                child: Text(
                  '$patName',
                  style: TextStyle(color: Colors.white, fontSize: 50),
                ),
              ),
            ),
            SizedBox(
              height: 100,
              width: 100,
              child: Lottie.asset('assets/loading_wave.json'),
            )
          ],
        ),
      ),
    );
  }
}
