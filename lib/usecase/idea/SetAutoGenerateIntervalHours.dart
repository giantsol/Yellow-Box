
import 'package:yellow_box/ui/App.dart';

class SetAutoGenerateIntervalHours {
  final _settingsRepository = dependencies.settingsRepository;

  Future<void> invoke(int value) {
    return _settingsRepository.setAutoGenerateIntervalHours(value);
  }
}
