
import 'package:yellow_box/ui/App.dart';

class SetTutorialPhase {
  final _settingsRepository = dependencies.settingsRepository;

  Future<void> invoke(int phase) {
    return _settingsRepository.setTutorialPhase(phase);
  }
}