
import 'package:yellow_box/datasource/AppDatabase.dart';

class Word {
  static const NONE = Word('', 0);

  final String title;
  final int dateMillis;

  static Word fromDatabase(Map<String, dynamic> map) {
    return Word(
      map[AppDatabase.COLUMN_TITLE] ?? '',
      map[AppDatabase.COLUMN_DATE_MILLIS] ?? 0,
    );
  }

  const Word(
    this.title,
    this.dateMillis,
    );

  bool isValid() => title.isNotEmpty && dateMillis > 0;
}