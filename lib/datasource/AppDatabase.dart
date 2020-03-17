
import 'package:path/path.dart';
import 'package:rxdart/subjects.dart';
import 'package:sqflite/sqflite.dart';
import 'package:yellow_box/entity/Idea.dart';
import 'package:yellow_box/entity/Word.dart';

class AppDatabase {
  static const String TABLE_WORDS = 'words';
  static const String TABLE_IDEAS = 'ideas';

  static const String COLUMN_TITLE = 'title';
  static const String COLUMN_DATE_MILLIS = 'date_millis';
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
          CREATE TABLE $TABLE_IDEAS(
            $COLUMN_TITLE TEXT NOT NULL PRIMARY KEY,
            $COLUMN_DATE_MILLIS INTEGER NOT NULL,
            $COLUMN_FAVORITE INTEGER NOT NULL
           );
           """
        );
        return db.execute(
          """
          CREATE TABLE $TABLE_WORDS(
            $COLUMN_TITLE TEXT NOT NULL PRIMARY KEY,
            $COLUMN_DATE_MILLIS INTEGER NOT NULL
           );
           """
        );
      },
      version: 1,
    );
  }

  Future<bool> hasWord(String title) async {
    final db = await _database.first;
    final map = await db.query(
      TABLE_WORDS,
      where: '$COLUMN_TITLE = ?',
      whereArgs: [title],
    );
    return map.isNotEmpty;
  }

  Future<void> addWord(Word entity) async {
    final db = await _database.first;
    return db.insert(
      TABLE_WORDS,
      {
        COLUMN_TITLE: entity.title,
        COLUMN_DATE_MILLIS: entity.dateMillis,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }
  
  Future<void> removeWord(Word item) async {
    final db = await _database.first;
    return db.delete(
      TABLE_WORDS,
      where: '$COLUMN_TITLE = ?',
      whereArgs: [item.title],
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
      'SELECT $COLUMN_TITLE FROM $TABLE_WORDS ORDER BY RANDOM() LIMIT $count'
    );

    final List<String> result = [];
    for (int i = 0; i < rows.length; i++) {
      final title = rows[i][COLUMN_TITLE];
      result.add(title);
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

  Future<bool> hasIdea(String title) async {
    final db = await _database.first;
    final map = await db.query(
      TABLE_IDEAS,
      where: '$COLUMN_TITLE = ?',
      whereArgs: [title],
    );
    return map.isNotEmpty;
  }

  Future<void> addIdea(Idea entity) async {
    final db = await _database.first;
    return db.insert(
      TABLE_IDEAS,
      {
        COLUMN_TITLE: entity.title,
        COLUMN_DATE_MILLIS: entity.dateMillis,
        COLUMN_FAVORITE: entity.isFavorite ? 1 : 0,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> removeIdea(Idea item) async {
    final db = await _database.first;
    return db.delete(
      TABLE_IDEAS,
      where: '$COLUMN_TITLE = ?',
      whereArgs: [item.title],
    );
  }

  Future<List<Idea>> getIdeas() async {
    final db = await _database.first;
    List<Map<String, dynamic>> maps = await db.query(
      TABLE_IDEAS,
      orderBy: '$COLUMN_FAVORITE DESC, $COLUMN_DATE_MILLIS DESC'
    );
    final List<Idea> result = [];
    for (int i = 0; i < maps.length; i++) {
      final idea = Idea.fromDatabase(maps[i]);
      result.add(idea);
    }
    return result;
  }
}