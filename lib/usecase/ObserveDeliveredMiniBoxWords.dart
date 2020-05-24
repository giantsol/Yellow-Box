
import 'package:yellow_box/entity/Word.dart';
import 'package:yellow_box/ui/App.dart';

class ObserveDeliveredMiniBoxWords {
  final _miniBoxRepository = dependencies.miniBoxRepository;

  Stream<List<Word>> invoke() {
    return _miniBoxRepository.observeDeliveredMiniBoxWords();
  }
}