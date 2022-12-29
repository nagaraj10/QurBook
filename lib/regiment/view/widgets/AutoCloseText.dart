import 'dart:async';
import 'package:get/get.dart';
import 'package:myfhb/regiment/view_model/regiment_view_model.dart';
import 'package:provider/provider.dart';

import '../../../src/utils/screenutils/size_extensions.dart';
import 'package:flutter/material.dart';
import 'package:myfhb/constants/fhb_constants.dart';

class AutoCloseText extends StatefulWidget {
  AutoCloseText({Key key, this.needReload = false}) : super(key: key);

  bool needReload;

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
      (Timer timer) async {
        if (start == 0) {
          setState(() {
            timer.cancel();
          });
          Get.back();
          if (widget.needReload) {
            Provider.of<RegimentViewModel>(Get.context, listen: false)
                .cachedEvents = [];
            await Provider.of<RegimentViewModel>(context, listen: false)
                .fetchRegimentData();
          }
        } else {
          setState(() {
            start--;
          });
        }
      },
    );
  }
}
