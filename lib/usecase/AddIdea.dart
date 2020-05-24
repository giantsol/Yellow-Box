
import 'package:tuple/tuple.dart';
import 'package:yellow_box/entity/AddIdeaResult.dart';
import 'package:yellow_box/ui/App.dart';

class AddIdea {
  final _wordRepository = dependencies.wordRepository;
  final _ideaRepository = dependencies.ideaRepository;

  Future<Tuple2<AddIdeaResult, String>> invoke() async {
    final savedWordCount = await _wordRepository.getCount();
    if (savedWordCount < 2) {
      return Tuple2(AddIdeaResult.NEED_MORE_WORDS, "");
    }

    final title = (await _wordRepository.getRandomWordStrings(2)).join(" ");
    return Tuple2(await _ideaRepository.addIdea(title), title);
  }
}
