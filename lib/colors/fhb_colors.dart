library fhb_colors;

import 'package:flutter/material.dart';

const bgColorContainer = 0xFFf7f6f5;
const cardColor = 0xFFFFFFFF;
const cardShadowColor = 0xFFe3e2e2;
const bookMarkActiveColor = 0xFF808080;
const bookMarkColor = 0xFF808080;
const circleAvatarBackground = 0xFF9575CD;
const gradient1 = 0XFF6d35de;
const gradient2 = 0XFF5e1fe0;
const transparentColor = 0x00000000;

final darkTheme = ThemeData(
  primaryColor: Colors.black,
  brightness: Brightness.dark,
  backgroundColor: const Color(0xFF212121),
  dividerColor: Colors.black12, colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.grey).copyWith(secondary: Colors.black),
);

final lightTheme = ThemeData(
  primaryColor: Color(0xff5f0cf9),
  brightness: Brightness.light,
  backgroundColor: const Color(0xFFE5E5E5),
  dividerColor: Colors.white54,
  colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.grey)
      .copyWith(secondary: Colors.white),
);

const String actionColor = '#6d35de';
const String colorBlack = '#000000';

// Convert Hex color to color
Color getColorFromHex(String hexColor) {
  hexColor = hexColor.toUpperCase().replaceAll('#', '');

  if (hexColor.length == 6) {
    hexColor = 'FF' + hexColor;
  }

  return Color(int.parse(hexColor, radix: 16));
}