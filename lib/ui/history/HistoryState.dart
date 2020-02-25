
import 'package:yellow_box/entity/AppTheme.dart';
import 'package:yellow_box/entity/Combination.dart';
import 'package:yellow_box/entity/Word.dart';

class HistoryState {

  final AppTheme appTheme;
  final bool isWordTab;
  final List<Word> words;
  final List<Combination> combinations;

  const HistoryState({
    this.appTheme = AppTheme.DEFAULT,
    this.isWordTab = true,
    this.words = const [],
    this.combinations = const [],
  });

  HistoryState buildNew({
    AppTheme appTheme,
    bool isWordTab,
    List<Word> words,
    List<Combination> combinations,
  }) {
    return HistoryState(
      appTheme: appTheme ?? this.appTheme,
      isWordTab: isWordTab ?? this.isWordTab,
      words: words ?? this.words,
      combinations: combinations ?? this.combinations,
    );
  }
}