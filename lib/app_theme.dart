import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'common/CommonUtil.dart';
import 'constants/variable_constant.dart' as variable;
import 'main.dart';

class AppTheme {
  final ThemeData themeData = ThemeData(
    fontFamily: variable.font_poppins,
    primaryColor: mAppThemeProvider.primaryColor,
    progressIndicatorTheme: ProgressIndicatorThemeData(
        color: mAppThemeProvider.primaryColor),
    textSelectionTheme: TextSelectionThemeData(
      cursorColor: mAppThemeProvider.primaryColor,
    ),
    appBarTheme: AppBarTheme().copyWith(
      systemOverlayStyle: SystemUiOverlayStyle.light,
    ),
    colorScheme: ColorScheme.light(
      primary:mAppThemeProvider.primaryColor,
      secondary:Colors.white
    ),
    splashFactory: NoSplash.splashFactory,
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.transparent,
        elevation: 0,
        shadowColor: Colors.transparent,
      ),
    ),
  );
}
