
import 'package:yellow_box/ui/App.dart';
import 'package:yellow_box/usecase/idea/AddIdea.dart';

class AutoGenerateAndAddIdeas {
  final _settingsRepository = dependencies.settingsRepository;

  final _addIdea = AddIdea();

  Future<void> invoke() async {
    final bool autoGenerate = await _settingsRepository.observeAutoGenerateIdeas().first;
    if (!autoGenerate) {
      return;
    }

    final int autoGenerateHours = await _settingsRepository.observeAutoGenerateIntervalHours().first;
    final int lastActiveMillis = await _settingsRepository.getLastActiveTime();
    final int currentMillis = DateTime.now().millisecondsSinceEpoch;
    final int deltaMillis = currentMillis - lastActiveMillis;
    final int autoGenerateMillis = autoGenerateHours * 60 * 60 * 1000;

    final int generateCount = deltaMillis ~/ autoGenerateMillis;
    if (generateCount > 0) {
      for (int i = 0; i < generateCount; i++) {
        await _addIdea.invoke();
      }
      _settingsRepository.setLastActiveTime(currentMillis - (deltaMillis % autoGenerateMillis));
    }

    return;
  }
}