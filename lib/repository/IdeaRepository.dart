
import 'package:rxdart/rxdart.dart';
import 'package:yellow_box/datasource/AppDatabase.dart';
import 'package:yellow_box/entity/Idea.dart';

class IdeaRepository {
  static const MAX_COUNT = 1000;

  final AppDatabase _database;

  // includes only unblocked ideas
  final _ideas = BehaviorSubject<List<Idea>>.seeded([]);

  IdeaRepository(this._database) {
    _init();
  }

  Future<void> _init() async {
    final ideas = await _database.getIdeas();
    _ideas.value = ideas;
  }

  // returns whether this idea exists and is not blocked
  Future<bool> hasIdea(String title) async {
    return _ideas.value.any((idea) => idea.title == title);
  }

  Future<void> addIdea(String title) async {
    if (_ideas.value.length >= MAX_COUNT) {
      return;
    }

    final idea = Idea(title, DateTime.now().millisecondsSinceEpoch, false, false);

    final list = _ideas.value;
    list.insert(0, idea);
    _ideas.value = list;

    return _database.addIdea(idea);
  }

  Future<void> deleteIdea(Idea item) async {
    final list = _ideas.value;
    final index = list.indexWhere((it) => it.title == item.title);
    if (index < 0) {
      return;
    }

    list.removeAt(index);
    _ideas.value = list;

    return _database.removeIdea(item);
  }

  Future<void> deleteIdeas(Map<Idea, bool> items) async {
    final list = _ideas.value;
    list.removeWhere((it) => items.containsKey(it));
    _ideas.value = list;

    for (final item in items.keys) {
      _database.removeIdea(item);
    }
    return;
  }

  Future<void> blockIdea(Idea item) async {
    final list = _ideas.value;
    final index = list.indexWhere((it) => it.title == item.title);
    if (index < 0) {
      return;
    }

    list.removeAt(index);
    _ideas.value = list;

    return _database.blockIdea(item);
  }

  Future<void> blockIdeas(Map<Idea, bool> items) async {
    final list = _ideas.value;
    list.removeWhere((it) => items.containsKey(it));
    _ideas.value = list;

    for (final item in items.keys) {
      _database.blockIdea(item);
    }
    return;
  }

  Future<bool> isBlocked(String title) async {
    return _database.isBlockedIdea(title);
  }

  Stream<List<Idea>> observeIdeas() {
    return _ideas;
  }

  Future<void> favoriteItem(Idea item) async {
    if (item.isFavorite) {
      return;
    }

    final favorited = item.buildNew(isFavorite: true);
    final list = _ideas.value;
    final index = list.indexWhere((it) => it.title == item.title);
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
      _ideas.value = list;
    }

    return _database.addIdea(favorited);
  }

  Future<void> unfavoriteItem(Idea item) async {
    if (!item.isFavorite) {
      return;
    }

    final unfavorited = item.buildNew(isFavorite: false);
    final list = _ideas.value;
    final index = list.indexWhere((it) => it.title == item.title);
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
      _ideas.value = list;
    }

    return _database.addIdea(unfavorited);
  }

}