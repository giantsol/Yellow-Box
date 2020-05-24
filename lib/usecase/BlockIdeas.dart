
import 'package:yellow_box/entity/Idea.dart';
import 'package:yellow_box/ui/App.dart';

class BlockIdeas {
  final _ideaRepository = dependencies.ideaRepository;

  Future<void> invoke(Map<Idea, bool> items) {
    return _ideaRepository.blockIdeas(items);
  }
}