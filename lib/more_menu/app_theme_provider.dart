import 'package:flutter/foundation.dart';

import '../common/PreferenceUtil.dart';
import 'models/app_theme_type.dart';

class AppThemeProvider extends ChangeNotifier {
  static const THEME_STATUS = "THEME_STATUS";

  late EnumAppThemeType _currentEnumAppThemeType;

  EnumAppThemeType get currentEnumAppThemeType => _currentEnumAppThemeType;

  AppThemeProvider() {
    _currentEnumAppThemeType = EnumAppThemeType.Classic;
    getPreferences();
  }

  //Switching themes in the flutter apps
  set appThemeType(EnumAppThemeType themeType) {
    _currentEnumAppThemeType = themeType;
    PreferenceUtil.saveCurrentAppTheme(themeType.toShortString());
    notifyListeners();
  }

  EnumAppThemeType getEnumAppThemeType() {
    final currentAppTheme = PreferenceUtil.getCurrentAppTheme();
    return EnumAppThemeType.fromName(currentAppTheme);
  }


  void resetEnumAppThemeType() {
    appThemeType = EnumAppThemeType.Classic;
  }

  getPreferences() {
    _currentEnumAppThemeType = getEnumAppThemeType();
    notifyListeners();
  }
}
