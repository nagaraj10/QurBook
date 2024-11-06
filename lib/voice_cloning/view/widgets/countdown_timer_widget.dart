import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../common/CommonUtil.dart';
import '../../../constants/fhb_constants.dart';
import '../../../main.dart';
import '../../../src/utils/screenutils/size_extensions.dart';
import '../../controller/voice_cloning_controller.dart';

class VoiceCloningCountDownWidget extends StatefulWidget {
  const VoiceCloningCountDownWidget({super.key});

  @override
  State<VoiceCloningCountDownWidget> createState() =>
      _VoiceCloningCountDownWidgetState();
}

class _VoiceCloningCountDownWidgetState
    extends State<VoiceCloningCountDownWidget> {
  late VoiceCloningController mControllerWatch;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      ///Starting the countdown timer once  dialog has visible.
      Provider.of<VoiceCloningController>(
        context,
        listen: false,
      ).startCountDownTimer();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    /// Retrieving and Listening to VoiceCloningController
    /// reference from the Provider
    mControllerWatch = Provider.of<VoiceCloningController>(context);
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      padding: const EdgeInsets.all(6),
      child: Column(
        children: [
          Align(
            alignment: Alignment.centerRight,
            child: InkWell(
              onTap: () => Navigator.pop(context),
              child: const Icon(
                Icons.close,
                color: Colors.white,
                size: 40,
              ),
            ),
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  makeSureNotInNoiseDescription,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(
                  height: 20.h,
                ),
                Text(
                  readTheDisplayContentDescription,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600),
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
                      child: CircularProgressIndicator(
                        strokeWidth: 10,
                        value: mControllerWatch.progressValue,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          mAppThemeProvider.primaryColor,
                        ),
                        backgroundColor: Colors.white,
                      ),
                    ),
                    Text(
                      '${mControllerWatch.countdown}',
                      style: TextStyle(
                          fontSize: 50.h,
                          fontWeight: FontWeight.w500,
                          color: mAppThemeProvider.primaryColor),
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
