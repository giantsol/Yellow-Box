
import 'package:path/path.dart';
import 'package:rxdart/subjects.dart';
import 'package:sqflite/sqflite.dart';
import 'package:yellow_box/entity/Combination.dart';
import 'package:yellow_box/entity/Word.dart';

class AppDatabase {
  static const String TABLE_WORDS = 'words';
  static const String TABLE_COMBINATIONS = 'combinations';

  static const String COLUMN_WORD = 'word';
  static const String COLUMN_DATE_MILLIS = 'date_millis';
  static const String COLUMN_COMBINATION = 'combination';
  static const String COLUMN_FAVORITE = 'favorite';

  // ignore: close_sinks
  final _database = BehaviorSubject<Database>();

  AppDatabase() {
    _initDatabase();
  }

  Future<void> _initDatabase() async {
    final dbPath = join(await getDatabasesPath(), 'yellowbox.db');
    _database.value = await openDatabase(
      dbPath,
      onCreate: (db, version) async {
        await db.execute(
          """
          CREATE TABLE $TABLE_COMBINATIONS(
            $COLUMN_COMBINATION TEXT NOT NULL PRIMARY KEY,
            $COLUMN_DATE_MILLIS INTEGER NOT NULL,
            $COLUMN_FAVORITE INTEGER NOT NULL
           );
           """
        );
        return db.execute(
          """
          CREATE TABLE $TABLE_WORDS(
            $COLUMN_WORD TEXT NOT NULL PRIMARY KEY,
            $COLUMN_DATE_MILLIS INTEGER NOT NULL
           );
           """
        );
      },
      version: 1,
    );
  }

  Future<bool> hasWord(String word) async {
    final db = await _database.first;
    final map = await db.query(
      TABLE_WORDS,
      where: '$COLUMN_WORD = ?',
      whereArgs: [word],
    );
    return map.isNotEmpty;
  }

  Future<void> addWord(Word entity) async {
    final db = await _database.first;
    return db.insert(
      TABLE_WORDS,
      {
        COLUMN_WORD: entity.word,
        COLUMN_DATE_MILLIS: entity.dateMillis,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }
  
  Future<void> removeWord(Word item) async {
    final db = await _database.first;
    return db.delete(
      TABLE_WORDS,
      where: '$COLUMN_WORD = ?',
      whereArgs: [item.word],
    );
  }

  Future<int> getWordsCount() async {
    final db = await _database.first;
    return Sqflite.firstIntValue(await db.rawQuery(
      'SELECT COUNT(*) FROM $TABLE_WORDS'
    ));
  }

  Future<List<String>> getRandomWordStrings(int count) async {
    final db = await _database.first;
    List<Map<String, dynamic>> rows = await db.rawQuery(
      'SELECT $COLUMN_WORD FROM $TABLE_WORDS ORDER BY RANDOM() LIMIT $count'
    );

    final List<String> result = [];
    for (int i = 0; i < rows.length; i++) {
      final word = rows[i][COLUMN_WORD];
      result.add(word);
    }
    return result;
  }

  Future<List<Word>> getWords() async {
    final db = await _database.first;
    List<Map<String, dynamic>> maps = await db.query(
      TABLE_WORDS,
      orderBy: '$COLUMN_DATE_MILLIS DESC'
    );
    final List<Word> result = [];
    for (int i = 0; i < maps.length; i++) {
      final word = Word.fromDatabase(maps[i]);
      result.add(word);
    }
    return result;
  }

  Future<bool> hasCombination(String combination) async {
    final db = await _database.first;
    final map = await db.query(
      TABLE_COMBINATIONS,
      where: '$COLUMN_COMBINATION = ?',
      whereArgs: [combination],
    );
    return map.isNotEmpty;
  }

  Future<void> addCombination(Combination entity) async {
    final db = await _database.first;
    return db.insert(
      TABLE_COMBINATIONS,
      {
        COLUMN_COMBINATION: entity.combination,
        COLUMN_DATE_MILLIS: entity.dateMillis,
        COLUMN_FAVORITE: entity.isFavorite ? 1 : 0,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> removeCombination(Combination item) async {
    final db = await _database.first;
    return db.delete(
      TABLE_COMBINATIONS,
      where: '$COLUMN_COMBINATION = ?',
      whereArgs: [item.combination],
    );
  }

  Future<List<Combination>> getCombinations() async {
    final db = await _database.first;
    List<Map<String, dynamic>> maps = await db.query(
      TABLE_COMBINATIONS,
      orderBy: '$COLUMN_FAVORITE DESC, $COLUMN_DATE_MILLIS DESC'
    );
    final List<Combination> result = [];
    for (int i = 0; i < maps.length; i++) {
      final combination = Combination.fromDatabase(maps[i]);
      result.add(combination);
    }
    return result;
  }
}