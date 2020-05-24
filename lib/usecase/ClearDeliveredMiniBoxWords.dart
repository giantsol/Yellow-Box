
import 'package:yellow_box/ui/App.dart';

class ClearDeliveredMiniBoxWords {
  final _miniBoxRepository = dependencies.miniBoxRepository;

  void invoke() {
    _miniBoxRepository.clearDeliveredMiniBoxWords();
  }
}