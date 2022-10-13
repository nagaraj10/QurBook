import 'dart:async';
import '../../../src/utils/screenutils/size_extensions.dart';
import 'package:flutter/material.dart';
import 'package:myfhb/constants/fhb_constants.dart';

class AutoCloseText extends StatefulWidget {
  const AutoCloseText({Key key}) : super(key: key);

  @override
  State<AutoCloseText> createState() => _AutoCloseTextState();
}

class _AutoCloseTextState extends State<AutoCloseText> {
  Timer _timer;
  int _start = 5;

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text(autoCloseForm + _start.toString() + autoCloseFormSec,
          style: TextStyle(fontSize: 15.sp, color: Colors.grey[600])),
    );
  }

  void startTimer() {
    const oneSec = const Duration(seconds: 1);
    _timer = new Timer.periodic(
      oneSec,
      (Timer timer) {
        if (_start == 0) {
          setState(() {
            timer.cancel();
          });
        } else {
          setState(() {
            _start--;
          });
        }
      },
    );
  }
}
