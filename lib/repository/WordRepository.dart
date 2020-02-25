
import 'package:rxdart/rxdart.dart';
import 'package:yellow_box/datasource/AppDatabase.dart';
import 'package:yellow_box/entity/Word.dart';

class WordRepository {
  final AppDatabase _database;

  final _words = BehaviorSubject<List<Word>>.seeded([]);

  WordRepository(this._database) {
    _init();
  }

  Future<void> _init() async {
    final words = await _database.getWords();
    _words.value = words;
  }

  Future<bool> hasWord(String wordString) async {
    return _words.value.any((word) => word.word == wordString);
  }

  Future<void> addWord(String wordString) {
    final wordEntity = Word(wordString, DateTime.now().millisecondsSinceEpoch);

    final list = _words.value;
    list.insert(0, wordEntity);
    _words.value = list;

    return _database.addWord(wordEntity);
  }

  Future<int> getCount() async {
    return _words.value.length;
  }

  Future<List<String>> getRandomWordStrings(int count) {
    return _database.getRandomWordStrings(count);
  }

  Stream<List<Word>> observeWords() {
    return _words.distinct();
  }

}