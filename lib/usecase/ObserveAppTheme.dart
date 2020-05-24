
import 'package:yellow_box/entity/AppTheme.dart';
import 'package:yellow_box/ui/App.dart';

class ObserveAppTheme {
  final _themeRepository = dependencies.themeRepository;
  
  Stream<AppTheme> invoke() {
    return _themeRepository.observeAppTheme();
  }
}