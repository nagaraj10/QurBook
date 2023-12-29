import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myfhb/common/CommonUtil.dart';
import 'package:myfhb/constants/app_strings.dart';
import 'package:myfhb/src/utils/screenutils/size_extensions.dart';
import 'package:myfhb/voice_cloning_controller.dart';

class VoiceCloningCountDownWidget extends StatefulWidget {
  @override
  State<VoiceCloningCountDownWidget> createState() =>
      _VoiceCloningCountDownWidgetState();
}

class _VoiceCloningCountDownWidgetState
    extends State<VoiceCloningCountDownWidget> with TickerProviderStateMixin {
  final VoiceCloningController _voiceCloningController =
      CommonUtil().onInitVoiceCloningController();
  late Timer _timer;

  @override
  void initState() {
    startTimer();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            AppStrings.makeSureNotInNoiseDescription,
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
          ),
          SizedBox(
            height: 20.h,
          ),
          Text(
            AppStrings.readTheDisplayContentDescription,
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
          ),
          SizedBox(
            height: 40.h,
          ),
          Stack(
            alignment: Alignment.center,
            children: [
              Obx((){
                return Container(
                  height: 100.h,
                  width: 100.h,
                  child:CircularProgressIndicator(
                    strokeWidth: 10,
                    value: _voiceCloningController.progressValue.value,
                    valueColor: AlwaysStoppedAnimation<Color>(
                        Color(CommonUtil().getMyPrimaryColor())),
                    backgroundColor: Colors.white,
                  ),
                );
              }),
              Obx(()=>Text(
                '${_voiceCloningController.countdown}',
                style: TextStyle(
                    fontSize: 50.h,
                    fontWeight: FontWeight.w500,
                    color: Color(CommonUtil().getMyPrimaryColor())),
              )
              )
            ],
          )
        ],
      ),
    );
  }

  void startTimer() {
    _voiceCloningController.countdown.value=10;
    _voiceCloningController.progressValue.value=0;
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_voiceCloningController.countdown.value > 0) {
        _voiceCloningController.countdown--;
        _voiceCloningController.progressValue.value = (10 - _voiceCloningController.countdown.value) / 10.0;
      } else {
        timer.cancel();
        Navigator.pop(context,true);
      }
    });
  }
  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }
}
