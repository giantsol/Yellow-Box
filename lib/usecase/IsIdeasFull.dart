
import 'package:yellow_box/ui/App.dart';

class IsIdeasFull {
  final _ideaRepository = dependencies.ideaRepository;

  Future<bool> invoke() {
    return _ideaRepository.isFull();
  }
}