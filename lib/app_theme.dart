import 'package:flutter/material.dart';
import 'common/CommonUtil.dart';
import 'constants/variable_constant.dart' as variable;
import 'main.dart';
import 'package:get/get.dart';

class AppTheme{
  final ThemeData themeData = ThemeData(
    fontFamily: variable.font_poppins,
    primaryColor:Color(CommonUtil().getMyPrimaryColor()),
    progressIndicatorTheme: ProgressIndicatorThemeData(
        color:Color(CommonUtil().getMyPrimaryColor())
    ),
    accentColor: Colors.white,
    colorScheme: ColorScheme.light().copyWith(
      primary:Color(CommonUtil().getMyPrimaryColor()),
    ),
    textSelectionTheme: TextSelectionThemeData(
        cursorColor:Color(CommonUtil().getMyPrimaryColor()),
    ),
    /*inputDecorationTheme: InputDecorationTheme(
      floatingLabelStyle:TextStyle(
        color:myPrimaryColor, // Change the label color
      ) ,
    ),*/
    appBarTheme: AppBarTheme().copyWith(
      brightness: Brightness.dark,
    ),
  );
}