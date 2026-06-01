import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum Language { id, en }

extension LanguageExtension on Language {
  String get code => name;
}

class LanguageNotifier extends StateNotifier<Language> {
  LanguageNotifier() : super(Language.id) {
    _loadLanguage();
  }

  Future<void> _loadLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    final savedCode = prefs.getString('language_code');

    if (savedCode != null) {
      state = savedCode == 'en' ? Language.en : Language.id;
    } else {
      // Auto-detect system language on first launch
      try {
        final systemLocale = Platform.localeName.toLowerCase();
        if (systemLocale.startsWith('en')) {
          state = Language.en;
        } else {
          state = Language.id;
        }
      } catch (e) {
        state = Language.id;
      }
    }
  }

  Future<void> toggleLanguage() async {
    final newLang = state == Language.id ? Language.en : Language.id;
    state = newLang;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('language_code', newLang.code);
  }

  Future<void> setLanguage(Language lang) async {
    state = lang;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('language_code', lang.code);
  }
}

final languageProvider = StateNotifierProvider<LanguageNotifier, Language>((ref) {
  return LanguageNotifier();
});
