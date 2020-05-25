
import 'package:yellow_box/ui/App.dart';

class MarkLastActiveTime {
  final _settingsRepository = dependencies.settingsRepository;

  Future<void> invoke() {
    return _settingsRepository.setLastActiveTime(DateTime.now().millisecondsSinceEpoch);
  }
}