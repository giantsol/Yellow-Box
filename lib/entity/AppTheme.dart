
import 'package:flutter/rendering.dart';

class AppTheme {

  static const DEFAULT = AppTheme(
    Color(0xFFFFE392),
    Color(0xFFB08236),
    'assets/ic_mic.png',
    'assets/ic_pen.png',
    false,
  );

  final Color lightColor;
  final Color darkColor;
  final String topBackgroundDeco;
  final String bottomBackgroundDeco;
  final bool isDarkTheme;

  const AppTheme(
    this.lightColor,
    this.darkColor,
    this.topBackgroundDeco,
    this.bottomBackgroundDeco,
    this.isDarkTheme,
    );

}