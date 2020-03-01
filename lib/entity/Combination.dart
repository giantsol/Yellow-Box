
import 'package:yellow_box/datasource/AppDatabase.dart';

class Combination {
  static const NONE = Combination('', 0, false);

  final String combination;
  final int dateMillis;
  final bool isFavorite;

  static Combination fromDatabase(Map<String, dynamic> map) {
    return Combination(
      map[AppDatabase.COLUMN_COMBINATION] ?? '',
      map[AppDatabase.COLUMN_DATE_MILLIS] ?? 0,
      map[AppDatabase.COLUMN_FAVORITE] == 1,
    );
  }

  const Combination(
    this.combination,
    this.dateMillis,
    this.isFavorite,
    );

  Combination buildNew({
    bool isFavorite,
  }) {
    return Combination(
      this.combination,
      this.dateMillis,
      isFavorite ?? this.isFavorite,
    );
  }

  bool isValid() => combination.isNotEmpty && dateMillis > 0;
}