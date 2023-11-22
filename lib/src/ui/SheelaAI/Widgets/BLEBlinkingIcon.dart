import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../common/CommonUtil.dart';
import '../../../utils/screenutils/size_extensions.dart';
import '../Controller/SheelaAIController.dart';
import 'sheela_ble_circular_progress_indicator.dart';

class MyBlinkingBLEIcon extends StatefulWidget {
  const MyBlinkingBLEIcon({Key? key}) : super(key: key);

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

  double _percent = 0.0;
  late Timer _timer;

  @override
  void initState() {
    if (!Get.isRegistered<SheelaAIController>()) {
      Get.put(SheelaAIController());
    }
    _sheelaAIController = Get.find();
    _timer = Timer.periodic(const Duration(milliseconds: 350), (timer) {
      setState(() {
        _percent += 0.015;
        if (_percent > 1.0) {
          _percent = 0.0;
        }
      });
    });
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
        return CircularPercentIndicator(
          radius: getCircularPercentIndicatorRadius(),
          lineWidth: 2,
          percent: _percent,
          backgroundColor: Colors.transparent,
          progressColor: Colors.grey,
          center: getBluetoothIcon(
            icon: Icons.bluetooth_disabled,
            color: Colors.grey,
          ),
        );
      }
    });
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
    _animationController.dispose();
    super.dispose();
  }
}
