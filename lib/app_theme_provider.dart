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

  late EnumAppThemeType _currentEnumAppThemeType;

  EnumAppThemeType get currentEnumAppThemeType => _currentEnumAppThemeType;

  AppThemeProvider() {
    _currentEnumAppThemeType = EnumAppThemeType.Classic;
    _primaryColor = CommonUtil.isUSRegion()
        ? qurHomePrimaryColor
        : Color(PreferenceUtil.getSavedTheme(Constants.keyPriColor) ?? 0xff5f0cf9);
    _gradientColor= CommonUtil.isUSRegion()
        ? qurhomeGradientColor
        : Color(PreferenceUtil.getSavedTheme(Constants.keyGreyColor) ?? 0xff9929ea);
    getPreferences();
  }

/// primary and secondary color of the app.
  Color get primaryColor => _primaryColor;
  Color get gradientColor => _gradientColor;

  /// This primary and gradient color used for the QurHome application.
 Color get qurHomePrimaryColor => Color(0xFFFB5422);
 Color get qurhomeGradientColor => Color(0xFFFd7a2b);
 Color get qurHomeCardColor => Color(0xFFF6000F);

 ///Gradients
  LinearGradient getQurhomeLinearGradient() => LinearGradient(
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
      colors: [
        qurHomeCardColor,
        qurhomeGradientColor
      ],
      stops: [
        0.1,
        1.0,
      ],
    );

  ///Common Primary color
  Color getCommonPrimaryColorQurHomeBook() => (PreferenceUtil.getIfQurhomeisAcive())
        ? qurHomePrimaryColor
        : primaryColor;

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
