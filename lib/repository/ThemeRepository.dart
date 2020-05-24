
import 'package:rxdart/subjects.dart';
import 'package:yellow_box/entity/AppTheme.dart';

class ThemeRepository {
  final BehaviorSubject<AppTheme> _currentAppTheme = BehaviorSubject();

  ThemeRepository() {
    _currentAppTheme.value = AppTheme.DEFAULT;
  }

  Stream<AppTheme> observeAppTheme() {
    return _currentAppTheme;
  }
}