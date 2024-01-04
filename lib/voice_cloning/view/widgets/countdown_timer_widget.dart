import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:myfhb/common/CommonUtil.dart';
import 'package:myfhb/constants/fhb_constants.dart';
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
      ///Starting the countdown timer once  dialog has visible.
      Provider.of<VoiceCloningController>(context, listen: false).startCountDownTimer();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    /// Retrieving and Listening to VoiceCloningController reference from the Provider
      mControllerWatch =Provider.of<VoiceCloningController>(context);
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      padding: EdgeInsets.all(6),
      child: Column(
        children: [
          Align(
            alignment: Alignment.centerRight,
            child: InkWell(
              onTap: ()=>Navigator.pop(context),
              child: Icon(Icons.close,
              color: Colors.white,
              size:40,),
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  makeSureNotInNoiseDescription,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
                ),
                SizedBox(
                  height: 20.h,
                ),
                Text(
                  readTheDisplayContentDescription,
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
          )
        ],
      ),
    );
  }
  @override
  void dispose() {
    ///cancelling the countdown timer if dialog as disappears.
    mControllerWatch.countDownTimer?.cancel();
    super.dispose();
  }
}
