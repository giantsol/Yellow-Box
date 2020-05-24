
import 'package:yellow_box/ui/App.dart';

class SetAutoGenerateIdeas {
  final _settingsRepository = dependencies.settingsRepository;

  Future<void> invoke(bool value) {
    return _settingsRepository.setAutoGenerateIdeas(value);
  }
}
