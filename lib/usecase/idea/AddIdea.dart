
import 'package:yellow_box/ui/App.dart';

class AddIdea {
  final _ideaRepository = dependencies.ideaRepository;

  Future<void> invoke(String idea) {
    return _ideaRepository.addIdea(idea);
  }
}
