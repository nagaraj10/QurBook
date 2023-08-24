import 'package:flutter/material.dart';
import '../../../../common/CommonUtil.dart';
import '../Controller/SheelaAIController.dart';
import 'package:get/get.dart';

class MyBlinkingBLEIcon extends StatefulWidget {
  @override
  _MyBlinkingBLEIconState createState() => _MyBlinkingBLEIconState();
}

class _MyBlinkingBLEIconState extends State<MyBlinkingBLEIcon>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late SheelaAIController _sheelaAIController;
  @override
  void initState() {
    if (!Get.isRegistered<SheelaAIController>()) {
      Get.put(SheelaAIController());
    }
    _sheelaAIController = Get.find();
    _animationController =
        AnimationController(vsync: this, duration: const Duration(seconds: 1));
    _animationController.repeat(reverse: true);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (_sheelaAIController.isBLEStatus.value == BLEStatus.Searching) {
        return FadeTransition(
          opacity: _animationController,
          child: IconButton(
              onPressed: () {
                if (!_sheelaAIController.isSheelaScreenActive)
                  _sheelaAIController.resetBLE();
              },
              icon: Icon(Icons.bluetooth),
              color: Color(
                CommonUtil().getQurhomeGredientColor(),
              )),
        );
      } else {
        return IconButton(
          onPressed: () {
            _sheelaAIController.resetBLE();
          },
          icon: _sheelaAIController.isBLEStatus.value == BLEStatus.Disabled
              ? Icon(Icons.bluetooth_disabled)
              : Icon(Icons.bluetooth_connected),
          color: _sheelaAIController.isBLEStatus.value == BLEStatus.Disabled
              ? Colors.grey
              : Colors.green,
        );
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}
