
import 'package:yellow_box/entity/Idea.dart';
import 'package:yellow_box/ui/App.dart';

class DeleteIdeas {
  final _ideaRepository = dependencies.ideaRepository;

  Future<void> invoke(Map<Idea, bool> items) {
    return _ideaRepository.deleteIdeas(items);
  }
}