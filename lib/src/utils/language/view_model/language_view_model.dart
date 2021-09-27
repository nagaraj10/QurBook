import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:myfhb/src/utils/language/languages.dart';
import 'package:myfhb/src/utils/language/model/language_data.dart';

class LanguageProvider extends ChangeNotifier {
  Locale _currentLocale = Locale(Languages.languages[0].code);

  get locale => _currentLocale;

  loadLanguage(LanguageDataModel languageData) async {
    _currentLocale = Locale(languageData.code);
    //TODO: Save In Local
    notifyListeners();
  }
}
