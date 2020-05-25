
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppPreferences {
  static const KEY_AUTO_GENERATE_IDEAS = 'auto.generate.ideas';
  static const KEY_AUTO_GENERATE_INTERVAL_HOURS = 'auto.generate.interval.hours';
  static const KEY_LAST_ACTIVE_TIME = 'last.active.time';

  static const DEFAULT_AUTO_GENERATE_IDEAS = false;
  static const DEFAULT_AUTO_GENERATE_INTERVAL_HOURS = 2;
  
  final _prefs = BehaviorSubject<SharedPreferences>();

  AppPreferences() {
    _init();
  }

  void _init() async {
    _prefs.value = await SharedPreferences.getInstance();
  }

  Future<bool> getAutoGenerateIdeas() async {
    final prefs = await _prefs.first;
    return prefs.getBool(KEY_AUTO_GENERATE_IDEAS) ?? DEFAULT_AUTO_GENERATE_IDEAS;
  }
  
  Future<void> setAutoGenerateIdeas(bool value) async {
    final prefs = await _prefs.first;
    return prefs.setBool(KEY_AUTO_GENERATE_IDEAS, value);
  }

  Future<int> getAutoGenerateIntervalHours() async {
    final prefs = await _prefs.first;
    return prefs.getInt(KEY_AUTO_GENERATE_INTERVAL_HOURS) ?? DEFAULT_AUTO_GENERATE_INTERVAL_HOURS;
  }

  Future<void> setAutoGenerateIntervalHours(int value) async {
    final prefs = await _prefs.first;
    return prefs.setInt(KEY_AUTO_GENERATE_INTERVAL_HOURS, value);
  }

  Future<int> getLastActiveTime() async {
    final prefs = await _prefs.first;
    return prefs.getInt(KEY_LAST_ACTIVE_TIME) ?? DateTime.now().millisecondsSinceEpoch;
  }

  Future<void> setLastActiveTime(int value) async {
    final prefs = await _prefs.first;
    return prefs.setInt(KEY_LAST_ACTIVE_TIME, value);
  }
}