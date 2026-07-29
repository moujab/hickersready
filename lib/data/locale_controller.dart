import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// App-wide language choice (Arabic by default), persisted on-device so the
/// selection made on the login screen sticks across restarts.
class LocaleController {
  LocaleController._();

  static final LocaleController instance = LocaleController._();

  static const _localePrefsKey = 'appLocale';

  final ValueNotifier<Locale> locale = ValueNotifier<Locale>(const Locale('ar'));

  bool get isArabic => locale.value.languageCode == 'ar';

  Future<void> restore() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getString(_localePrefsKey);
    if (saved != null && saved.isNotEmpty) {
      locale.value = Locale(saved);
    }
  }

  Future<void> toggle() async {
    locale.value = Locale(isArabic ? 'en' : 'ar');
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_localePrefsKey, locale.value.languageCode);
  }
}
