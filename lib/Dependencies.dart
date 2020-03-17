
import 'package:yellow_box/datasource/AppDatabase.dart';
import 'package:yellow_box/repository/ChildScreenRepository.dart';
import 'package:yellow_box/repository/IdeaRepository.dart';
import 'package:yellow_box/repository/ThemeRepository.dart';
import 'package:yellow_box/repository/WordRepository.dart';

final AppDatabase _database = AppDatabase();

class Dependencies {
  final ChildScreenRepository childScreenRepository = ChildScreenRepository();
  final ThemeRepository themeRepository = ThemeRepository();
  final WordRepository wordRepository = WordRepository(_database);
  final IdeaRepository ideaRepository = IdeaRepository(_database);
}