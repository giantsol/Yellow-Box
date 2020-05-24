
import 'package:yellow_box/entity/Idea.dart';
import 'package:yellow_box/ui/App.dart';

class ObserveIdeas {
  final _ideaRepository = dependencies.ideaRepository;

  Stream<List<Idea>> invoke() {
    return _ideaRepository.observeIdeas();
  }

}