
import 'package:yellow_box/datasource/AppDatabase.dart';

class CombinationRepository {
  AppDatabase _database;

  CombinationRepository(this._database);

  Future<bool> hasCombination(String combination) {
    return _database.hasCombination(combination);
  }

  Future<void> addCombination(String combination) {
    return _database.addCombination(combination);
  }
}