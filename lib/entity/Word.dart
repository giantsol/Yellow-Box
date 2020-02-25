
import 'package:yellow_box/datasource/AppDatabase.dart';

class Word {
  final String word;
  final int dateMillis;

  static Word fromDatabase(Map<String, dynamic> map) {
    return Word(
      map[AppDatabase.COLUMN_WORD] ?? '',
      map[AppDatabase.COLUMN_DATE_MILLIS] ?? 0,
    );
  }

  const Word(
    this.word,
    this.dateMillis,
    );
}