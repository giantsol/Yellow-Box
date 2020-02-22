
import 'package:path/path.dart';
import 'package:rxdart/subjects.dart';
import 'package:sqflite/sqflite.dart';

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

  Future<void> addWord(String word) async {
    final db = await _database.first;
    return db.insert(
      TABLE_WORDS,
      {
        COLUMN_WORD: word,
        COLUMN_DATE_MILLIS: DateTime.now().millisecondsSinceEpoch,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<int> getWordsCount() async {
    final db = await _database.first;
    return Sqflite.firstIntValue(await db.rawQuery(
      'SELECT COUNT(*) FROM $TABLE_WORDS'
    ));
  }

  Future<List<String>> getRandomWords(int count) async {
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

  Future<bool> hasCombination(String combination) async {
    final db = await _database.first;
    final map = await db.query(
      TABLE_COMBINATIONS,
      where: '$COLUMN_COMBINATION = ?',
      whereArgs: [combination],
    );
    return map.isNotEmpty;
  }

  Future<void> addCombination(String combination) async {
    final db = await _database.first;
    return db.insert(
      TABLE_COMBINATIONS,
      {
        COLUMN_COMBINATION: combination,
        COLUMN_DATE_MILLIS: DateTime.now().millisecondsSinceEpoch,
        COLUMN_FAVORITE: 0,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }
}