
import 'package:yellow_box/ui/App.dart';

class ObserveAutoGenerateIdeas {
  final _settingsRepository = dependencies.settingsRepository;

  Stream<bool> invoke() {
    return _settingsRepository.observeAutoGenerateIdeas();
  }
}