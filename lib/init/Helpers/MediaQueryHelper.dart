import 'package:flutter/material.dart';

class MediaQueryHelper {
  static late double screenWidth;
  static late double screenHeight;
  static late double baseWidth;
  static late double baseHeight;

  static late double widthRatio;
  static late double heightRatio;

  static late double textScaleFactor;

  /// Referans cihazın boyutlarını başlatıyoruz
  static void init(BuildContext context, {double designWidth = 375, double designHeight = 812}) {
    final mediaQuery = MediaQuery.of(context);

    screenWidth = mediaQuery.size.width;
    screenHeight = mediaQuery.size.height;

    // Referans cihazın ölçüleri
    baseWidth = designWidth;
    baseHeight = designHeight;

    // Ölçek oranlarını hesaplıyoruz
    widthRatio = screenWidth / baseWidth;
    heightRatio = screenHeight / baseHeight;

    // Metin ölçek faktörü
    textScaleFactor = mediaQuery.textScaleFactor;
  }

  /// Ekran genişliğini oranlayarak döndürür
  static double width(double value) {
    return value * widthRatio;
  }

  /// Ekran yüksekliğini oranlayarak döndürür
  static double height(double value) {
    return value * heightRatio;
  }

  /// Yazı boyutunu oranlayarak döndürür
  static double fontSize(double value) {
    return value * widthRatio; // Genişlik oranına göre ölçekleme
  }
}
