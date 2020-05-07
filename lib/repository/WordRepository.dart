
import 'package:rxdart/rxdart.dart';
import 'package:yellow_box/datasource/AppDatabase.dart';
import 'package:yellow_box/entity/Word.dart';

class WordRepository {
  final AppDatabase _database;

  final _words = BehaviorSubject<List<Word>>();

  WordRepository(this._database) {
    _init();
  }

  Future<void> _init() async {
    final words = await _database.getWords();
    _words.value = words;
  }

  Future<bool> _hasWord(String wordString) async {
    return (await _words.first).any((word) => word.title == wordString);
  }

  Future<bool> addWord(Word word) async {
    if (await _hasWord(word.title)) {
      return false;
    }

    final list = await _words.first;
    final insertIndex = list.indexWhere((it) => it.dateMillis <= word.dateMillis);
    list.insert(insertIndex, word);
    _words.value = list;

    await _database.addWord(word);

    return true;
  }

  void addWords(List<Word> words) {
    // todo: wordcount max size account하도록 해야함
    for (Word word in words) {
      addWord(word);
    }
  }

  Future<void> deleteWord(Word item) async {
    final list = await _words.first;
    final index = list.indexWhere((it) => it.title == item.title);
    if (index < 0) {
      return;
    }

    list.removeAt(index);
    _words.value = list;

    return _database.removeWord(item);
  }

  Future<void> deleteWords(Map<Word, bool> items) async {
    final list = await _words.first;
    list.removeWhere((it) => items.containsKey(it));
    _words.value = list;

    for (final item in items.keys) {
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

  Stream<List<Word>> observeWords() {
    return _words;
  }

}