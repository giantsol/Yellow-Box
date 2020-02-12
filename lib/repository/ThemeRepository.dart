
import 'package:rxdart/subjects.dart';
import 'package:yellow_box/entity/AppTheme.dart';

class ThemeRepository {
  final _currentAppTheme = BehaviorSubject<AppTheme>.seeded(AppTheme.DEFAULT);

  Stream<AppTheme> observeCurrentAppTheme() {
    return _currentAppTheme.distinct();
  }
}