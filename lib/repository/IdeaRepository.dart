
import 'package:rxdart/rxdart.dart';
import 'package:yellow_box/datasource/AppDatabase.dart';
import 'package:yellow_box/entity/CreateIdeaResult.dart';
import 'package:yellow_box/entity/Idea.dart';

class IdeaRepository {
  static const _MAX_COUNT = 5000;

  final AppDatabase _database;

  // includes only unblocked ideas
  final _ideas = BehaviorSubject<List<Idea>>();

  IdeaRepository(this._database) {
    _init();
  }

  Future<void> _init() async {
    _ideas.value = await _database.getIdeas();
  }

  Stream<List<Idea>> observeIdeas() {
    return _ideas;
  }
  
  Future<bool> isFull() async {
    final ideas = await _ideas.first;
    return ideas.length >= _MAX_COUNT;
  }

  // returns whether this idea exists and is not blocked
  Future<bool> _hasIdea(String title) async {
    final ideas = await _ideas.first;
    return ideas.any((idea) => idea.title == title);
  }

  Future<CreateIdeaResult> createIdea(String title) async {
    final ideas = await _ideas.first;
    if (ideas.length >= _MAX_COUNT) {
      return CreateIdeaResult.FULL;
    }

    final isAlreadySavedIdea = await _hasIdea(title);
    if (isAlreadySavedIdea) {
      return CreateIdeaResult.ALREADY_EXISTS;
    }

    final isBlockedIdea = await _isBlocked(title);
    if (isBlockedIdea) {
      return CreateIdeaResult.BLOCKED;
    }

    return CreateIdeaResult.SUCCESS;
  }

  Future<void> addIdea(String title) async {
    final ideas = await _ideas.first;

    final idea = Idea(title, DateTime.now().millisecondsSinceEpoch, false, false);
    ideas.insert(0, idea);
    _ideas.value = ideas;

    return _database.addIdea(idea);
  }

  Future<void> deleteIdea(Idea item) async {
    final ideas = await _ideas.first;
    final index = ideas.indexWhere((it) => it.title == item.title);
    if (index < 0) {
      return;
    }

    ideas.removeAt(index);
    _ideas.value = ideas;

    return _database.deleteIdea(item);
  }

  Future<void> deleteIdeas(Map<Idea, bool> items) async {
    final ideas = await _ideas.first;
    ideas.removeWhere((it) => items.containsKey(it));
    _ideas.value = ideas;

    for (final item in items.keys) {
      // todo: is there bulk delete method?
      _database.deleteIdea(item);
    }
    return;
  }

  Future<void> blockIdea(Idea item) async {
    final ideas = await _ideas.first;
    final index = ideas.indexWhere((it) => it.title == item.title);
    if (index < 0) {
      return;
    }

    ideas.removeAt(index);
    _ideas.value = ideas;

    return _database.blockIdea(item);
  }

  Future<void> blockIdeas(Map<Idea, bool> items) async {
    final ideas = await _ideas.first;
    ideas.removeWhere((it) => items.containsKey(it));
    _ideas.value = ideas;

    for (final item in items.keys) {
      // todo: bulk method?
      _database.blockIdea(item);
    }
    return;
  }

  Future<bool> _isBlocked(String title) async {
    return _database.isBlockedIdea(title);
  }

  Future<void> resetBlockedIdeas() {
    return _database.resetBlockedIdeas();
  }

  Future<void> favoriteIdea(Idea item) async {
    if (item.isFavorite) {
      return;
    }

    final ideas = await _ideas.first;
    final favorited = item.buildNew(isFavorite: true);
    final index = ideas.indexWhere((it) => it.title == item.title);
    if (index >= 0) {
      ideas[index] = favorited;
      _sortIdeas(ideas);
      _ideas.value = ideas;
    }

    return _database.addIdea(favorited);
  }

  Future<void> unfavoriteIdea(Idea item) async {
    if (!item.isFavorite) {
      return;
    }

    final ideas = await _ideas.first;
    final unfavorited = item.buildNew(isFavorite: false);
    final index = ideas.indexWhere((it) => it.title == item.title);
    if (index >= 0) {
      ideas[index] = unfavorited;
      _sortIdeas(ideas);
      _ideas.value = ideas;
    }

    return _database.addIdea(unfavorited);
  }

  void _sortIdeas(List<Idea> ideas) {
    ideas.sort((a, b) {
      final diff = (b.isFavorite ? 1 : 0).compareTo(a.isFavorite ? 1 : 0);
      if (diff != 0) {
        return diff;
      } else {
        return b.dateMillis.compareTo(a.dateMillis);
      }
    });
  }

}