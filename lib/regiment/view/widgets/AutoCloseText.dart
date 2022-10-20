import 'dart:async';
import 'package:get/get.dart';

import '../../../src/utils/screenutils/size_extensions.dart';
import 'package:flutter/material.dart';
import 'package:myfhb/constants/fhb_constants.dart';

class AutoCloseText extends StatefulWidget {
  const AutoCloseText({Key key}) : super(key: key);

  @override
  State<AutoCloseText> createState() => _AutoCloseTextState();
}

class _AutoCloseTextState extends State<AutoCloseText> {
  Timer timerRun;
  int start = 5;

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  @override
  void dispose() {
    timerRun.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text(autoCloseForm + start.toString() + autoCloseFormSec,
          style: TextStyle(fontSize: 15.sp, color: Colors.grey[600])),
    );
  }

  void startTimer() {
    const oneSec = const Duration(seconds: 1);
    timerRun = new Timer.periodic(
      oneSec,
      (Timer timer) {
        if (start == 0) {
          setState(() {
            timer.cancel();
          });
          Get.back();
        } else {
          setState(() {
            start--;
          });
        }
      },
    );
  }
}
