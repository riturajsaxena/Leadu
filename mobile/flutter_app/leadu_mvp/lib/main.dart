import 'package:flutter/material.dart';
import 'theme/app_theme.dart';
import 'screens/splash.dart';

void main() {
  runApp(const LeaduApp());
}

class LeaduApp extends StatelessWidget {
  const LeaduApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Leadu',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const SplashScreen(),
    );
  }
}
