
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:rxdart/rxdart.dart';
import 'package:yellow_box/entity/Word.dart';

class MiniBoxRepository {

  static const _CHANNEL_PATH = 'com.giantsol.yellow_box';
  static const _METHOD_CHANNEL_NAME = '$_CHANNEL_PATH/methods';

  static const _METHOD_SHOW_MINI_BOX = 'showMiniBox';
  static const _METHOD_INITIALIZED = 'initialized';
  static const _METHOD_DELIVER_MINI_BOX_WORDS = 'deliverMiniBoxWords';
  static const _METHOD_DELIVER_REMAINING_MINI_BOX_WORDS = 'deliverRemainingMiniBoxWords';

  final _methodChannel = MethodChannel(_METHOD_CHANNEL_NAME);

  final _deliveredMiniBoxWords = BehaviorSubject<List<Word>>.seeded([]);

  MiniBoxRepository() {
    _init();
  }

  Future<void> _init() async {
    _methodChannel.setMethodCallHandler((MethodCall call) async {
      if (call.method == _METHOD_DELIVER_MINI_BOX_WORDS) {
        final Map<dynamic, dynamic> words = call.arguments;
        final List<Word> wordEntities = [];
        words.forEach((word, millis) {
          wordEntities.add(Word(word, millis));
        });

        _deliveredMiniBoxWords.value = wordEntities;
      }
    });

    try {
      await _methodChannel.invokeMethod(_METHOD_INITIALIZED);
    } on Exception { }
  }

  Stream<List<Word>> observeDeliveredMiniBoxWords() {
    return _deliveredMiniBoxWords;
  }

  void clearDeliveredMiniBoxWords() {
    _deliveredMiniBoxWords.value = [];
  }

  Future<bool> showMiniBox() async {
    try {
      return (await _methodChannel.invokeMethod(_METHOD_SHOW_MINI_BOX)) == true;
    } on Exception catch (_) {
      return false;
    }
  }

  Future<void> addRemainingMiniBoxWords(List<Word> words) async {
    try {
      final Map<String, int> map = {};
      for (Word word in words) {
        map[word.title] = word.dateMillis;
      }
      return _methodChannel.invokeMethod(_METHOD_DELIVER_REMAINING_MINI_BOX_WORDS, map);
    } on Exception {
      return;
    }
  }

}
