import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'common/CommonUtil.dart';
import 'constants/variable_constant.dart' as variable;

class AppTheme {
  final ThemeData themeData = ThemeData(
    fontFamily: variable.font_poppins,
    primaryColor: Color(CommonUtil().getMyPrimaryColor()),
    progressIndicatorTheme: ProgressIndicatorThemeData(
        color: Color(CommonUtil().getMyPrimaryColor())),
    textSelectionTheme: TextSelectionThemeData(
      cursorColor: Color(CommonUtil().getMyPrimaryColor()),
    ),
    appBarTheme: AppBarTheme().copyWith(
      systemOverlayStyle: SystemUiOverlayStyle.light,
    ),
    colorScheme: ColorScheme.light()
        .copyWith(
          primary: Color(CommonUtil().getMyPrimaryColor()),
        )
        .copyWith(secondary: Colors.white),
  );
}
