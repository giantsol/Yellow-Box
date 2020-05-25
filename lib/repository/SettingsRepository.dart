
import 'package:rxdart/rxdart.dart';
import 'package:yellow_box/datasource/AppPreferences.dart';

class SettingsRepository {
  final AppPreferences _prefs;

  final BehaviorSubject<bool> _autoGenerateIdeas = BehaviorSubject();
  final BehaviorSubject<int> _autoGenerateIntervalHours = BehaviorSubject();

  SettingsRepository(this._prefs) {
    _init();
  }

  Future<void> _init() async {
    _autoGenerateIdeas.value = await _prefs.getAutoGenerateIdeas();
    _autoGenerateIntervalHours.value = await _prefs.getAutoGenerateIntervalHours();
  }

  Stream<bool> observeAutoGenerateIdeas() {
    return _autoGenerateIdeas;
  }

  Future<void> setAutoGenerateIdeas(bool value) async {
    await _autoGenerateIdeas.first;
    _autoGenerateIdeas.value = value;
    return _prefs.setAutoGenerateIdeas(value);
  }

  Stream<int> observeAutoGenerateIntervalHours() {
    return _autoGenerateIntervalHours;
  }

  Future<void> setAutoGenerateIntervalHours(int value) async {
    await _autoGenerateIntervalHours.first;
    _autoGenerateIntervalHours.value = value;
    return _prefs.setAutoGenerateIntervalHours(value);
  }

  Future<int> getLastActiveTime() {
    return _prefs.getLastActiveTime();
  }

  Future<void> setLastActiveTime(int time) {
    return _prefs.setLastActiveTime(time);
  }
}