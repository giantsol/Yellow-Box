
import 'package:yellow_box/entity/Word.dart';
import 'package:yellow_box/ui/App.dart';

class DeleteWord {
  final _wordRepository = dependencies.wordRepository;

  Future<void> invoke(Word word) {
    return _wordRepository.deleteWord(word);
  }
}