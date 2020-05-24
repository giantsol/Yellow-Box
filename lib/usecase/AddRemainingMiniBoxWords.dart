
import 'package:yellow_box/entity/Word.dart';
import 'package:yellow_box/ui/App.dart';

class AddRemainingMiniBoxWords {
  final _miniBoxRepository = dependencies.miniBoxRepository;

  Future<void> invoke(List<Word> words) {
    return _miniBoxRepository.addRemainingMiniBoxWords(words);
  }
}