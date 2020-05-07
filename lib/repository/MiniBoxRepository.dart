
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:yellow_box/entity/Word.dart';
import 'package:yellow_box/ui/App.dart';

class MiniBoxRepository {

  static const _CHANNEL_PATH = 'com.giantsol.yellow_box';
  static const _METHOD_CHANNEL_NAME = '$_CHANNEL_PATH/methods';

  static const _METHOD_SHOW_MINI_BOX = 'showMiniBox';
  static const _METHOD_INITIALIZED = 'initialized';
  static const _METHOD_DELIVER_MINI_BOX_WORDS = 'deliverMiniBoxWords';

  final _methodChannel = MethodChannel(_METHOD_CHANNEL_NAME);

  MiniBoxRepository() {
    _methodChannel.setMethodCallHandler((MethodCall call) async {
      if (call.method == _METHOD_DELIVER_MINI_BOX_WORDS) {
        final Map<dynamic, dynamic> words = call.arguments;
        final List<Word> wordEntities = [];
        words.forEach((word, millis) {
          wordEntities.add(Word(word, millis));
        });
        dependencies.wordRepository.addWords(wordEntities);
      }
    });

    _methodChannel.invokeMethod(_METHOD_INITIALIZED);
  }

  Future<bool> showMiniBox() {
    return _methodChannel.invokeMethod(_METHOD_SHOW_MINI_BOX);
  }

}
