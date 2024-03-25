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
