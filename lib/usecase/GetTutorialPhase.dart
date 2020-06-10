
import 'package:yellow_box/ui/App.dart';

class GetTutorialPhase {
  final _settingsRepository = dependencies.settingsRepository;

  Future<int> invoke() {
    return _settingsRepository.getTutorialPhase();
  }
}