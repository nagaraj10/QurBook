import 'package:flutter/material.dart';

class ColorUtils {
  static Color greycolor = HexColor("F2F2F3");
  static Color blackcolor = HexColor("0B0B0B");
  static Color lightgraycolor = HexColor("555C59");
  static Color greencolor = HexColor("41b88e");
  static Color greycolor1 = HexColor("8C8C8C");
  static Color lightwhitecolor = HexColor("F6F6F6");
  static Color adddescripcolor = HexColor("9FA9BA");
  static Color darkbluecolor = HexColor("252A3D");
  static Color myFamilyGreyColor = HexColor("8f8f8f");
  static Color lightPrimaryColor = HexColor("9e76ed");
  static Color countColor = HexColor("F19B10");
  static Color badgeQueue = HexColor("ff3333");
}

class HexColor extends Color {
  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF" + hexColor;
    }
    return int.parse(hexColor, radix: 16);
  }

  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));
}
