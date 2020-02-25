
import 'package:rxdart/rxdart.dart';
import 'package:yellow_box/datasource/AppDatabase.dart';
import 'package:yellow_box/entity/Combination.dart';

class CombinationRepository {
  final AppDatabase _database;

  final _combinations = BehaviorSubject<List<Combination>>.seeded([]);

  CombinationRepository(this._database) {
    _init();
  }

  Future<void> _init() async {
    final combinations = await _database.getCombinations();
    _combinations.value = combinations;
  }

  Future<bool> hasCombination(String str) async {
    return _combinations.value.any((comb) => comb.combination == str);
  }

  Future<void> addCombination(String combination) {
    final combEntity = Combination(combination, DateTime.now().millisecondsSinceEpoch, false);

    final list = _combinations.value;
    list.insert(0, combEntity);
    _combinations.value = list;

    return _database.addCombination(combEntity);
  }

  Stream<List<Combination>> observeCombinations() {
    return _combinations.distinct();
  }

}