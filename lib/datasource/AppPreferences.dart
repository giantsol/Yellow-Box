
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppPreferences {
  static const KEY_AUTO_GENERATE_IDEAS = 'auto.generate.ideas';
  
  final _prefs = BehaviorSubject<SharedPreferences>();

  AppPreferences() {
    _init();
  }

  void _init() async {
    _prefs.value = await SharedPreferences.getInstance();
  }

  Future<bool> getAutoGenerateIdeas() async {
    final prefs = await _prefs.first;
    return prefs.getBool(KEY_AUTO_GENERATE_IDEAS);
  }
  
  Future<void> setAutoGenerateIdeas(bool value) async {
    final prefs = await _prefs.first;
    return prefs.setBool(KEY_AUTO_GENERATE_IDEAS, value);
  }
}