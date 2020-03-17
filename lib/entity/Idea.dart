
import 'package:yellow_box/datasource/AppDatabase.dart';

class Idea {
  static const NONE = Idea('', 0, false);

  final String title;
  final int dateMillis;
  final bool isFavorite;

  static Idea fromDatabase(Map<String, dynamic> map) {
    return Idea(
      map[AppDatabase.COLUMN_TITLE] ?? '',
      map[AppDatabase.COLUMN_DATE_MILLIS] ?? 0,
      map[AppDatabase.COLUMN_FAVORITE] == 1,
    );
  }

  const Idea(
    this.title,
    this.dateMillis,
    this.isFavorite,
    );

  Idea buildNew({
    bool isFavorite,
  }) {
    return Idea(
      this.title,
      this.dateMillis,
      isFavorite ?? this.isFavorite,
    );
  }

  bool isValid() => title.isNotEmpty && dateMillis > 0;
}