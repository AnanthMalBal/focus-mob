import 'package:flutter/material.dart';

class LocaleProvider extends ChangeNotifier {
  Locale _locale = const Locale('en'); // Default language is English

  Locale get locale => _locale;

  void setLocale(Locale locale) {
    if (!['en', 'ta', 'hi', 'ar'].contains(locale.languageCode)) return;
    _locale = locale;
    notifyListeners(); // Notify UI to update
  }
}