
import 'package:rxdart/rxdart.dart';
import 'package:yellow_box/datasource/AppDatabase.dart';
import 'package:yellow_box/entity/Combination.dart';

class CombinationRepository {
  static const MAX_COUNT = 1000;

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

  Future<void> addCombination(String combination) async {
    if (_combinations.value.length >= MAX_COUNT) {
      return;
    }

    final combEntity = Combination(combination, DateTime.now().millisecondsSinceEpoch, false);

    final list = _combinations.value;
    list.insert(0, combEntity);
    _combinations.value = list;

    return _database.addCombination(combEntity);
  }

  Future<void> deleteCombination(Combination item) async {
    final list = _combinations.value;
    final index = list.indexWhere((it) => it.combination == item.combination);
    if (index < 0) {
      return;
    }

    list.removeAt(index);
    _combinations.value = list;

    return _database.removeCombination(item);
  }

  Stream<List<Combination>> observeCombinations() {
    return _combinations;
  }

  Future<void> favoriteItem(Combination item) async {
    if (item.isFavorite) {
      return;
    }

    final favorited = item.buildNew(isFavorite: true);
    final list = _combinations.value;
    final index = list.indexWhere((it) => it.combination == item.combination);
    if (index >= 0) {
      list[index] = favorited;
      list.sort((a, b) {
        final diff = (b.isFavorite ? 1 : 0).compareTo(a.isFavorite ? 1 : 0);
        if (diff != 0) {
          return diff;
        } else {
          return b.dateMillis.compareTo(a.dateMillis);
        }
      });
      _combinations.value = list;
    }

    return _database.addCombination(favorited);
  }

  Future<void> unfavoriteItem(Combination item) async {
    if (!item.isFavorite) {
      return;
    }

    final unfavorited = item.buildNew(isFavorite: false);
    final list = _combinations.value;
    final index = list.indexWhere((it) => it.combination == item.combination);
    if (index >= 0) {
      list[index] = unfavorited;
      list.sort((a, b) {
        final diff = (b.isFavorite ? 1 : 0).compareTo(a.isFavorite ? 1 : 0);
        if (diff != 0) {
          return diff;
        } else {
          return b.dateMillis.compareTo(a.dateMillis);
        }
      });
      _combinations.value = list;
    }

    return _database.addCombination(unfavorited);
  }

}