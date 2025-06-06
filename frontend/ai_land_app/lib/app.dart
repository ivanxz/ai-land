import 'package:ai_land/providers/common/theme_mode_controller.dart';
import 'package:ai_land/router/router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'widgets/toast.dart';

class App extends ConsumerWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    const primaryColor = Color(0xff6f61e8);

    /// Light theme
    final lightTheme = ThemeData(
      primaryColor: primaryColor,
      scaffoldBackgroundColor: const Color(0xfff5f5f7),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.white60,
      ),
      colorScheme: ColorScheme.fromSeed(
        primary: primaryColor,
        seedColor: primaryColor,
        surfaceTint: Colors.transparent,
      ),
      useMaterial3: true,
    );

    /// Dark theme
    final darkTheme = ThemeData(
      primaryColor: primaryColor,
      colorScheme: const ColorScheme.dark(
        primary: primaryColor,
        surfaceTint: Colors.transparent,
      ),
      dividerTheme: DividerThemeData(
        color: Colors.grey[700],
      ),
      useMaterial3: true,
    );

    final themeMode = ref.watch(themeModeControllerProvider);

    final smartDialog = FlutterSmartDialog.init(
      toastBuilder: (String msg) => CustomToast(msg: msg),
    );

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'AI Land',
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('zh', 'CN'), // 中文
      ],
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: themeMode,
      routerConfig: router,
      builder: (context, child) {
        child = smartDialog(context, child);
        child = MediaQuery(
          data: MediaQuery.of(context).copyWith(
            textScaler: TextScaler.noScaling,
          ),
          child: child,
        );
        child = KeyboardDismissOnTap(
          child: child,
        );
        return child;
      },
    );
  }
}
