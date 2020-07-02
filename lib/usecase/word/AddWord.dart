
import 'package:yellow_box/entity/AddWordResult.dart';
import 'package:yellow_box/entity/Word.dart';
import 'package:yellow_box/ui/App.dart';

class AddWord {
  final _wordRepository = dependencies.wordRepository;

  Future<AddWordResult> invoke(Word word) {
    return _wordRepository.addWord(word);
  }
}
