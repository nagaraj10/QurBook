import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../common/CommonUtil.dart';
import '../../../utils/screenutils/size_extensions.dart';
import '../Controller/SheelaAIController.dart';
import 'sheela_ble_circular_progress_indicator.dart';

class MyBlinkingBLEIcon extends StatefulWidget {
  bool? isEnabled = true;
  MyBlinkingBLEIcon({Key? key, bool isEnabled = true}) : super(key: key);

  @override
  _MyBlinkingBLEIconState createState() => _MyBlinkingBLEIconState();
}

class _MyBlinkingBLEIconState extends State<MyBlinkingBLEIcon>
    with TickerProviderStateMixin {
  late SheelaAIController _sheelaAIController;

  late AnimationController _animationController;
  late Animation<double> _animation;
  double _scaleFactor = 1.0;
  bool _zoomIn = true;

  @override
  void initState() {
    if (!Get.isRegistered<SheelaAIController>()) {
      Get.put(SheelaAIController());
    }
    _sheelaAIController = Get.find();

    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );
    _animation =
        Tween<double>(begin: 0.8, end: 1.1).animate(_animationController);
    _animation.addListener(() {
      setState(() {
        _scaleFactor = _animation.value;
      });
    });
    _animation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _animationController.reverse();
      } else if (status == AnimationStatus.dismissed) {
        _animationController.forward();
      }
    });
    _animationController.forward();
  }

  double getCircularPercentIndicatorRadius() =>
      (CommonUtil().isTablet ?? false) ? 22 : 16;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (_sheelaAIController.isBLEStatus.value == BLEStatus.Searching) {
        return FadeTransition(
          opacity: _animationController,
          child: Icon(
            Icons.bluetooth,
            size: 32.sp,
            color: Colors.blue,
          ),
        );
      } else if (_sheelaAIController.isBLEStatus.value == BLEStatus.Connected) {
        return Icon(
          Icons.bluetooth,
          size: 32.sp,
          color: Colors.green,
        );
      } else {
        if (_sheelaAIController.bleController?.timerSubscription == null) {
          return BLELoader();
        } else {
          return getDisabledBluetoothIcon();
        }
      }
    });
  }

  void toggleZoomDirection() {
    setState(() {
      if (_zoomIn) {
        _animationController.reverse();
      } else {
        _animationController.forward();
      }
      _zoomIn = !_zoomIn;
    });
  }

  @override
  void dispose() {
    _sheelaAIController.percentBlinkingBLEIcon = 0.0;
    _animationController.dispose();
    super.dispose();
  }
}

class BLELoader extends StatefulWidget {
  const BLELoader({Key? key}) : super(key: key);

  @override
  State<BLELoader> createState() => _BLELoaderState();
}

class _BLELoaderState extends State<BLELoader> {
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
      center: getDisabledBluetoothIcon(),
    );
    ;
  }
}

Widget getBluetoothIcon({
  required IconData icon,
  required Color color,
}) =>
    Icon(
      icon,
      size: 24.sp,
      color: color,
    );

Widget getConnectAnimationBluetoothIcon() => getBluetoothIcon(
      icon: Icons.bluetooth,
      color: Colors.blue,
    );

Widget getDisabledBluetoothIcon() {
  return getBluetoothIcon(
    icon: Icons.bluetooth_disabled,
    color: Colors.grey,
  );
}
