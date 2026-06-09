import 'package:flutter/material.dart';
import 'controllers/theme_controller.dart';
import 'screens/splash_screen.dart';
import 'themes/app_theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: ThemeController.instance.modo,
      builder: (context, modo, _) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Team Sort',
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: modo,
          home: const SplashScreen(),
        );
      },
    );
  }
}
