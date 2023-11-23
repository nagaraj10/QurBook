import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myfhb/Qurhome/QurhomeDashboard/Controller/QurhomeDashboardController.dart';

import '../../../../common/CommonUtil.dart';
import '../../../utils/screenutils/size_extensions.dart';
import '../Controller/SheelaAIController.dart';
import 'bluetooth_loader.dart';
import 'common_bluetooth_widget.dart';

class MyBlinkingBLEIcon extends StatefulWidget {
  bool? isEnabled = true;
  MyBlinkingBLEIcon({Key? key, bool isEnabled = true}) : super(key: key);

  @override
  _MyBlinkingBLEIconState createState() => _MyBlinkingBLEIconState();
}

class _MyBlinkingBLEIconState extends State<MyBlinkingBLEIcon>
    with TickerProviderStateMixin {
  late SheelaAIController _sheelaAIController;
  late QurhomeDashboardController _qurhomeDashboardController;

  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    if (!Get.isRegistered<SheelaAIController>()) {
      Get.put(SheelaAIController());
    }
    if (!Get.isRegistered<QurhomeDashboardController>()) {
      Get.put(QurhomeDashboardController());
    }

    _sheelaAIController = Get.find();
    _qurhomeDashboardController = Get.find();

    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );
    _animation =
        Tween<double>(begin: 0.8, end: 1.1).animate(_animationController);
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
        if (_qurhomeDashboardController.getBleTimer == null) {
          return CommonBluetoothWidget.getDisabledBluetoothIcon();
        } else if (_sheelaAIController.bleController?.timerSubscription ==
            null) {
          return BluetoothLoader();
        } else {
          return CommonBluetoothWidget.getDisabledBluetoothIcon();
        }
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}
