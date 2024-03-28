import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'common/CommonUtil.dart';
import 'common/PreferenceUtil.dart';
import 'more_menu/models/app_theme_type.dart';
import '../../constants/fhb_constants.dart' as Constants;

class AppThemeProvider extends ChangeNotifier {
  static const THEME_STATUS = "THEME_STATUS";
  late  Color _primaryColor;
  late  Color _gradientColor;
  /// This primary and gradient color used for the QurHome application.
  static const Color qurHomePrimaryColor = Color(0xFFFB5422);
  static const Color qurhomeGredientColor = Color(0xFFFd7a2b);
  late EnumAppThemeType _currentEnumAppThemeType;

  EnumAppThemeType get currentEnumAppThemeType => _currentEnumAppThemeType;

  AppThemeProvider() {
    _currentEnumAppThemeType = EnumAppThemeType.Classic;
    _primaryColor = CommonUtil.isUSRegion()
        ? qurHomePrimaryColor
        : Color(PreferenceUtil.getSavedTheme(Constants.keyPriColor) ?? 0xff5f0cf9);
    _gradientColor= CommonUtil.isUSRegion()
        ? qurhomeGredientColor
        : Color(PreferenceUtil.getSavedTheme(Constants.keyGreyColor) ?? 0xff9929ea);
    getPreferences();
  }

  Color get primaryColor => _primaryColor;
  Color get gradientColor => _gradientColor;

  //Switching themes in the flutter apps
  set appThemeType(EnumAppThemeType themeType) {
    _currentEnumAppThemeType = themeType;
    PreferenceUtil.saveCurrentAppTheme(themeType.toShortString());
    notifyListeners();
  }

  void updatePrimaryColor(int colorCode){
    PreferenceUtil.saveTheme(Constants.keyPriColor,
        colorCode);
    _primaryColor = Color(colorCode);
    notifyListeners();
  }
  void updateGradientColor(int colorCode){
    PreferenceUtil.saveTheme(Constants.keyGreyColor,
        colorCode);
    _gradientColor =Color(colorCode);
    notifyListeners();
  }

  /// Gets the current app theme enum based on the stored preference.
  ///
  /// Retrieves the string value for the current theme from preferences,
  /// and returns the corresponding enum value. This allows the rest of the app
  /// to work with the enum representation of the theme.
  EnumAppThemeType getEnumAppThemeType() {
    final currentAppTheme = PreferenceUtil.getCurrentAppTheme();
    return EnumAppThemeType.fromName(currentAppTheme);
  }


  /// Resets the current app theme type to the default classic theme.
  void resetEnumAppThemeType() {
    appThemeType = EnumAppThemeType.Classic;
  }

  /// Gets the current app theme preference from
  /// local storage and updates the enum.
  /// Notifies listeners of the change.
  getPreferences() {
    _currentEnumAppThemeType = getEnumAppThemeType();
    notifyListeners();
  }
}
