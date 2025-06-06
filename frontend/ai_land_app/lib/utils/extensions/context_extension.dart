import 'package:flutter/material.dart';

extension ContextExtension on BuildContext {
  bool get isDark => Theme.of(this).brightness == Brightness.dark;

  Brightness get platformBrightness => MediaQuery.platformBrightnessOf(this);

  double get appBarHeight => MediaQuery.paddingOf(this).top + kToolbarHeight;

  double get safeAreaBottom => MediaQuery.paddingOf(this).bottom;

  IconThemeData get iconTheme => Theme.of(this).iconTheme;

  Color get scaffoldBackgroundColor => Theme.of(this).scaffoldBackgroundColor;

  Color get backgroundColor => isDark ? Colors.black : Colors.white;

  Color? get iconColor => Theme.of(this).iconTheme.color;
}
