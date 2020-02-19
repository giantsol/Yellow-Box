
import 'package:path/path.dart';
import 'package:rxdart/subjects.dart';
import 'package:sqflite/sqflite.dart';

class AppDatabase {
  static const String TABLE_WORDS = 'words';

  static const String COLUMN_WORD = 'word';
  static const String COLUMN_DATE_MILLIS = 'date_millis';

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
}