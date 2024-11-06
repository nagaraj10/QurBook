import 'package:flutter/material.dart';
import 'package:myfhb/src/utils/screenutils/size_extensions.dart';

class CommonBluetoothWidget {
  static Widget getBluetoothIcon({
    required IconData icon,
    required Color color,
  }) =>
      Icon(
        icon,
        size: 24.sp,
        color: color,
      );

  static Widget getConnectAnimationBluetoothIcon() => getBluetoothIcon(
        icon: Icons.bluetooth,
        color: Colors.blue,
      );

  static Widget getDisabledBluetoothIcon() => getBluetoothIcon(
        icon: Icons.bluetooth_disabled,
        color: Colors.grey,
      );
}
