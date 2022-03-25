
import 'package:yellow_box/datasource/AppDatabase.dart';

class Idea {
  static const NONE = Idea('', 0, false, false);

  final String title;
  final int dateMillis;
  final bool isFavorite;
  final bool isBlocked;

  static Idea fromDatabase(Map<String, dynamic> map) {
    return Idea(
      map[AppDatabase.COLUMN_TITLE] ?? '',
      map[AppDatabase.COLUMN_DATE_MILLIS] ?? 0,
      map[AppDatabase.COLUMN_FAVORITE] == 1,
      map[AppDatabase.COLUMN_BLOCKED] == 1,
    );
  }

  const Idea(
    this.title,
    this.dateMillis,
    this.isFavorite,
    this.isBlocked,
    );

  Idea buildNew({
    bool? isFavorite,
    bool? isBlocked,
  }) {
    return Idea(
      this.title,
      this.dateMillis,
      isFavorite ?? this.isFavorite,
      isBlocked ?? this.isBlocked,
    );
  }

  bool isValid() => title.isNotEmpty && dateMillis > 0;
}