
import 'package:yellow_box/entity/Word.dart';
import 'package:yellow_box/ui/App.dart';

class AddWords {
  final _wordRepository = dependencies.wordRepository;

  Future<List<Word>> invoke(List<Word> words) {
    return _wordRepository.addWords(words);
  }
}
