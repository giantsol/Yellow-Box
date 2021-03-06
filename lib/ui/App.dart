
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:yellow_box/AppColors.dart';
import 'package:yellow_box/Dependencies.dart';
import 'package:yellow_box/Localization.dart';
import 'package:yellow_box/ui/main/MainScreen.dart';

// static dependency injection
Dependencies _sharedDependencies;
Dependencies get dependencies => _sharedDependencies;

class App extends StatelessWidget {
  App({
    Key key,
    Dependencies dependencies,
  }): super(key: key) {
    _sharedDependencies = dependencies;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Yellow Box',
      theme: ThemeData(
        canvasColor: Colors.transparent,
        splashColor: AppColors.RIPPLE,
        textTheme: TextTheme(
          subtitle1: TextStyle(
            textBaseline: TextBaseline.alphabetic
          ),
        ),
      ),
      localizationsDelegates: [
        const AppLocalizationsDelegate(),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('en'),
        const Locale('ko'),
      ],
      localeListResolutionCallback: (locales, supportedLocales) {
        if (locales == null || locales.isEmpty) {
          return const Locale('en');
        } else if (locales[0].languageCode == 'ko'){
          return const Locale('ko');
        } else {
          return const Locale('en');
        }
      },
      builder: (context, widget) {
        // do NOT show red error screen in production build although there's an error
        if (kReleaseMode) {
          ErrorWidget.builder = (FlutterErrorDetails errorDetails) {
            return Container();
          };
        }
        return widget;
      },
      home: MainScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
