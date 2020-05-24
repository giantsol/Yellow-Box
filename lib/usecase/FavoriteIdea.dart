
import 'package:yellow_box/entity/Idea.dart';
import 'package:yellow_box/ui/App.dart';

class FavoriteIdea {
  final _ideaRepository = dependencies.ideaRepository;

  Future<void> invoke(Idea idea) {
    return _ideaRepository.favoriteIdea(idea);
  }
}