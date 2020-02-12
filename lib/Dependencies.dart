
import 'package:yellow_box/repository/ChildScreenRepository.dart';
import 'package:yellow_box/repository/ThemeRepository.dart';

class Dependencies {
  final ChildScreenRepository childScreenRepository = ChildScreenRepository();
  final ThemeRepository themeRepository = ThemeRepository();
}