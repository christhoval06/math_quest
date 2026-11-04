import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

class LocaleNotifier extends StateNotifier<Locale> {
  final Box _settingsBox;

  LocaleNotifier(this._settingsBox) : super(const Locale('en')) {
    _loadSavedLocale();
  }

  void _loadSavedLocale() {
    final savedCode =
        _settingsBox.get('language_code', defaultValue: 'en') as String;
    state = Locale(savedCode);
  }

  Future<void> setLocale(String languageCode) async {
    state = Locale(languageCode);
    await _settingsBox.put('language_code', languageCode);
  }
}

final localeProvider = StateNotifierProvider<LocaleNotifier, Locale>((ref) {
  final box = Hive.box('app_settings_box');
  return LocaleNotifier(box);
});
