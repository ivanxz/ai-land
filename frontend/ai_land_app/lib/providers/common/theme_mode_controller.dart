import 'package:ai_land/providers/common/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'theme_mode_controller.g.dart';

@riverpod
class ThemeModeController extends _$ThemeModeController {
  static const String key = 'theme_mode';

  @override
  ThemeMode build() {
    final value = ref.watch(sharedPreferencesProvider).getString(key);
    if (value == null) {
      return ThemeMode.light;
    }
    return ThemeMode.values.byName(value);
  }

  void setState(ThemeMode themeMode) {
    state = themeMode;
    ref.read(sharedPreferencesProvider).setString(key, themeMode.name);
  }
}

extension ThemeModeExtension on ThemeMode {
  static ThemeMode fromBrightness(Brightness brightness) =>
      switch (brightness) {
        (Brightness.light) => ThemeMode.light,
        (Brightness.dark) => ThemeMode.dark,
      };
}
