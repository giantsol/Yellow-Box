import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:yellow_box/Dependencies.dart';
import 'package:yellow_box/ui/App.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.dark,
  ));

  final dependencies = Dependencies();

  runApp(App(
    dependencies: dependencies,
  ));
}
