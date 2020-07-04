
import 'dart:math';

import 'package:rxdart/rxdart.dart';
import 'package:yellow_box/datasource/AppDatabase.dart';
import 'package:yellow_box/entity/AddWordResult.dart';
import 'package:yellow_box/entity/Word.dart';

class WordRepository {
  static const _MAX_COUNT = 10000;

  final AppDatabase _database;

  final _words = BehaviorSubject<List<Word>>();

  WordRepository(this._database) {
    _init();
  }

  Future<void> _init() async {
    _words.value = await _database.getWords();
  }

  Stream<List<Word>> observeWords() {
    return _words;
  }

  Future<bool> _hasWord(String wordString) async {
    final words = await _words.first;
    return words.any((word) => word.title.toLowerCase() == wordString.toLowerCase());
  }

  Future<AddWordResult> addWord(Word word) async {
    final words = await _words.first;
    if (words.length >= _MAX_COUNT) {
      return AddWordResult.FULL;
    }

    if (await _hasWord(word.title)) {
      return AddWordResult.ALREADY_EXISTS;
    }

    final insertIndex = max(words.indexWhere((it) => it.dateMillis <= word.dateMillis), words.length);
    words.insert(insertIndex, word);
    _words.value = words;

    _database.addWord(word);

    return AddWordResult.SUCCESS;
  }

  // returns leftovers that had not been added due to box full
  Future<List<Word>> addWords(List<Word> words) async {
    final List<Word> leftOvers = [];
    bool skipFromNow = false;

    for (Word word in words) {
      if (skipFromNow) {
        leftOvers.add(word);
      } else {
        final result = await addWord(word);
        if (result == AddWordResult.FULL) {
          leftOvers.add(word);
          skipFromNow = true;
        }
      }
    }

    return leftOvers;
  }

  Future<void> deleteWord(Word item) async {
    final words = await _words.first;
    final index = words.indexWhere((it) => it.title == item.title);
    if (index < 0) {
      return;
    }

    words.removeAt(index);
    _words.value = words;

    return _database.removeWord(item);
  }

  Future<void> deleteWords(Map<Word, bool> items) async {
    final words = await _words.first;
    words.removeWhere((it) => items.containsKey(it));
    _words.value = words;

    for (final item in items.keys) {
      // todo: bulk method?
      _database.removeWord(item);
    }
    return;
  }

  Future<int> getCount() async {
    return (await _words.first).length;
  }

  Future<List<String>> getRandomWordStrings(int count) {
    return _database.getRandomWordStrings(count);
  }

}
