
import 'package:yellow_box/entity/Word.dart';
import 'package:yellow_box/ui/App.dart';

class ObserveWords {
  final _wordRepository = dependencies.wordRepository;

  Stream<List<Word>> invoke() {
    return _wordRepository.observeWords();
  }
}