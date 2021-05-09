import 'dart:ui';

import 'package:flutter_translate/flutter_translate.dart';
import 'package:shared_preferences/shared_preferences.dart';

const String defaultLocale = 'en';
String currentLocale = defaultLocale;

class LocalizationHelper {
  static Future<LocalizationDelegate> get delegate {
    return LocalizationDelegate.create(
      fallbackLocale: defaultLocale,
      basePath: 'assets/i18n',
      supportedLocales: ['en', 'es', 'zh_CN', 'zh_TW'],
      preferences: _TranslatePreferences(),
    );
  }
}

class _TranslatePreferences implements ITranslatePreferences {
  static const String _selectedLocaleKey = 'selected_locale';

  @override
  Future<Locale?> getPreferredLocale() async {
    final preferences = await SharedPreferences.getInstance();
    if (!preferences.containsKey(_selectedLocaleKey)) return null;
    var locale = preferences.getString(_selectedLocaleKey);
    currentLocale = locale ?? currentLocale; //Testing
    return localeFromString(currentLocale);
  }

  @override
  Future savePreferredLocale(Locale locale) async {
    currentLocale = localeToString(locale);
    final preferences = await SharedPreferences.getInstance();
    await preferences.setString(_selectedLocaleKey, currentLocale);
  }
}
