
import 'package:flutter/services.dart';

class AppMethodChannel {
  final _methodChannel = MethodChannel('com.giantsol.yellow_box');

  static const SHOW_MINI_BOX_RESULT_OK = 0;

  Future<int> showMiniBox() {
    return _methodChannel.invokeMethod('showMiniBox');
  }
}