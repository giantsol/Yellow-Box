
import 'package:yellow_box/ui/App.dart';

class ResetBlockedIdeas {
  final _ideaRepository = dependencies.ideaRepository;

  Future<void> invoke() {
    return _ideaRepository.resetBlockedIdeas();
  }
}