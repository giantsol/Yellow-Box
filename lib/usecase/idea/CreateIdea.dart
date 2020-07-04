import 'package:tuple/tuple.dart';
import 'package:yellow_box/entity/CreateIdeaResult.dart';
import 'package:yellow_box/ui/App.dart';

class CreateIdea {
  final _wordRepository = dependencies.wordRepository;
  final _ideaRepository = dependencies.ideaRepository;

  Future<Tuple2<CreateIdeaResult, String>> invoke({String idea = ""}) async {
    if (idea.isNotEmpty) {
      return Tuple2(await _ideaRepository.createIdea(idea), idea);
    } else {
      final savedWordCount = await _wordRepository.getCount();
      if (savedWordCount < 2) {
        return Tuple2(CreateIdeaResult.NEED_MORE_WORDS, "");
      }

      final title = (await _wordRepository.getRandomWordStrings(2)).join(" ");
      return Tuple2(await _ideaRepository.createIdea(title), title);
    }
  }
}
