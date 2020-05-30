
import 'package:flutter/rendering.dart';
import 'package:yellow_box/Localization.dart';

class AppTheme {

  static const DEFAULT = AppTheme(
    lightColor: Color(0xFFFFE392),
    darkColor: Color(0xFFB08236),
    mainLogo: 'assets/main_logo_yellow_box.png',
    titleKey: AppLocalizations.YELLOW_BOX_TITLE,
    subtitleKey: AppLocalizations.YELLOW_BOX_SUBTITLE,
    topBackgroundDeco: 'assets/ic_mic.png',
    bottomBackgroundDeco: 'assets/ic_pen.png',
    isDarkTheme: false,
  );

  final Color lightColor;
  final Color darkColor;
  final String mainLogo;
  final String titleKey;
  final String subtitleKey;
  final String topBackgroundDeco;
  final String bottomBackgroundDeco;
  final bool isDarkTheme;

  const AppTheme({
    this.lightColor,
    this.darkColor,
    this.mainLogo,
    this.titleKey,
    this.subtitleKey,
    this.topBackgroundDeco,
    this.bottomBackgroundDeco,
    this.isDarkTheme,
  });

}