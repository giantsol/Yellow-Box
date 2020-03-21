
import 'package:yellow_box/datasource/AppPreferences.dart';

class SettingsRepository {
  final AppPreferences _prefs;

  SettingsRepository(this._prefs);

  Future<bool> getAutoGenerateIdeas() {
    return _prefs.getAutoGenerateIdeas();
  }

  Future<void> setAutoGenerateIdeas(bool value) {
    return _prefs.setAutoGenerateIdeas(value);
  }

  Future<int> getAutoGenerateIntervalHours() {
    return _prefs.getAutoGenerateIntervalHours();
  }

  Future<void> setAutoGenerateIntervalHours(int value) {
    return _prefs.setAutoGenerateIntervalHours(value);
  }
}