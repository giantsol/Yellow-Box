
import 'package:flutter/rendering.dart';
import 'package:yellow_box/Localization.dart';

class AppTheme {

  static const DEFAULT = AppTheme(
    primaryColor: Color(0xFFEEB163),
    lightColor: Color(0xFFFFE392),
    darkColor: Color(0xFFB08236),
    pointColor: Color(0xFFFFF763),
    mainLogo: 'assets/yellow_box_main_logo.png',
    titleKey: AppLocalizations.YELLOW_BOX_TITLE,
    subtitleKey: AppLocalizations.YELLOW_BOX_SUBTITLE,
    topBackgroundDeco: 'assets/yellow_box_top_bg.png',
    bottomBackgroundDeco: 'assets/yellow_box_bottom_bg.png',
    isDarkTheme: false,
  );

  final Color primaryColor;
  final Color lightColor;
  final Color darkColor;
  final Color pointColor;
  final String mainLogo;
  final String titleKey;
  final String subtitleKey;
  final String topBackgroundDeco;
  final String bottomBackgroundDeco;
  final bool isDarkTheme;

  const AppTheme({
    required this.primaryColor,
    required this.lightColor,
    required this.darkColor,
    required this.pointColor,
    required this.mainLogo,
    required this.titleKey,
    required this.subtitleKey,
    required this.topBackgroundDeco,
    required this.bottomBackgroundDeco,
    required this.isDarkTheme,
  });

}