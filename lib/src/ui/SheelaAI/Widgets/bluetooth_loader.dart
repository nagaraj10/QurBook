import 'dart:async';

import 'package:flutter/material.dart';
import '../../../../common/CommonUtil.dart';

import 'common_bluetooth_widget.dart';
import 'sheela_ble_circular_progress_indicator.dart';

class BluetoothLoader extends StatefulWidget {
  const BluetoothLoader({Key? key}) : super(key: key);

  @override
  State<BluetoothLoader> createState() => _BluetoothLoaderState();
}

class _BluetoothLoaderState extends State<BluetoothLoader> {
  late Timer timerBlinkingBLEIcon;
  double percentBlinkingBLEIcon = 0.0;
  @override
  void initState() {
    timerBlinkingBLEIcon = Timer.periodic(
        const Duration(
          seconds: 1,
        ), (timer) {
      setState(() {
        percentBlinkingBLEIcon += 0.044;
        if (percentBlinkingBLEIcon > 1.0) {
          percentBlinkingBLEIcon = 0.0;
        }
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    timerBlinkingBLEIcon.cancel();
    super.dispose();
  }

  double getCircularPercentIndicatorRadius() =>
      (CommonUtil().isTablet ?? false) ? 22 : 16;
  @override
  Widget build(BuildContext context) {
    return CircularPercentIndicator(
      radius: getCircularPercentIndicatorRadius(),
      lineWidth: 2,
      percent: percentBlinkingBLEIcon,
      backgroundColor: Colors.transparent,
      progressColor: Colors.grey,
      center: CommonBluetoothWidget.getDisabledBluetoothIcon(),
    );
    ;
  }
}
