import 'package:flutter/material.dart';

class AppTheme {
  AppTheme._();

  static ThemeData themeData = ThemeData(
    textTheme: const TextTheme(
      headlineSmall: TextStyle(
        fontSize: 15,
        color: Colors.black87,
      ),
      titleSmall: TextStyle(
        fontWeight: FontWeight.w900,
        fontSize: 15
      )

    ),
    colorScheme: ColorScheme.fromSwatch(
      primarySwatch: Colors.yellow, // Genel bir ana renk tanımlanabilir
    ).copyWith(
      primary: const Color(0xFFF48A34),
      secondary: const Color(0xFFf7d6c7),
      surface: Colors.white, // Arka plan rengi
      onPrimary: Colors.white, // Yazı rengi
      onSecondary: Colors.black,
      error: Colors.red, // Hata rengi
      onSurface: Colors.black,
      onBackground: Colors.black87,
    ),
    useMaterial3: true,
  );
}
