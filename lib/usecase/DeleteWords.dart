
import 'package:yellow_box/entity/Word.dart';
import 'package:yellow_box/ui/App.dart';

class DeleteWords {
  final _wordRepository = dependencies.wordRepository;

  Future<void> invoke(Map<Word, bool> items) {
    return _wordRepository.deleteWords(items);
  }
}