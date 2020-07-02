
import 'package:yellow_box/ui/App.dart';

class ObserveAutoGenerateIntervalHours {
  final _settingsRepository = dependencies.settingsRepository;

  Stream<int> invoke() {
    return _settingsRepository.observeAutoGenerateIntervalHours();
  }
}