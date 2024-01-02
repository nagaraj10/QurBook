import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myfhb/common/CommonUtil.dart';
import 'package:myfhb/constants/app_strings.dart';
import 'package:myfhb/constants/router_variable.dart';
import 'package:myfhb/src/utils/screenutils/size_extensions.dart';
import 'package:myfhb/voice_cloning/controller/voice_cloning_controller.dart';
import 'package:provider/provider.dart';

class VoiceCloningCountDownWidget extends StatefulWidget {
  @override
  State<VoiceCloningCountDownWidget> createState() =>
      _VoiceCloningCountDownWidgetState();
}

class _VoiceCloningCountDownWidgetState
    extends State<VoiceCloningCountDownWidget> {
  late VoiceCloningController mControllerWatch;

  @override
  void initState() {
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      Provider.of<VoiceCloningController>(context, listen: false).startCountDownTimer();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
      mControllerWatch =Provider.of<VoiceCloningController>(context);
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      padding: EdgeInsets.all(6),
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
              Container(
                height: 100.h,
                width: 100.h,
                child:CircularProgressIndicator(
                  strokeWidth: 10,
                  value: mControllerWatch.progressValue,
                  valueColor: AlwaysStoppedAnimation<Color>(
                      Color(CommonUtil().getMyPrimaryColor())),
                  backgroundColor: Colors.white,
                ),
              ),
              Text(
                '${mControllerWatch.countdown}',
                style: TextStyle(
                    fontSize: 50.h,
                    fontWeight: FontWeight.w500,
                    color: Color(CommonUtil().getMyPrimaryColor())),
              )
            ],
          )
        ],
      ),
    );
  }
  @override
  void dispose() {
    mControllerWatch.countDownTimer?.cancel();
    super.dispose();
  }
}
