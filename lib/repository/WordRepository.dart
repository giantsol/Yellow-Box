
import 'package:yellow_box/datasource/AppDatabase.dart';

class WordRepository {
  AppDatabase _database;

  WordRepository(this._database);

  Future<bool> hasWord(String word) {
    return _database.hasWord(word);
  }

  Future<void> addWord(String word) {
    return _database.addWord(word);
  }

  Future<int> getCount() {
    return _database.getWordsCount();
  }

  Future<List<String>> getRandomWords(int count) {
    return _database.getRandomWords(count);
  }

}