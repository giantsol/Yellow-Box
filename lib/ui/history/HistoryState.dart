
import 'package:yellow_box/entity/AppTheme.dart';
import 'package:yellow_box/entity/Combination.dart';
import 'package:yellow_box/entity/Word.dart';

class HistoryState {

  final AppTheme appTheme;
  final bool isWordTab;
  final List<Word> words;
  final List<Combination> combinations;
  final Word wordItemDialog;
  final Combination combinationItemDialog;

  const HistoryState({
    this.appTheme = AppTheme.DEFAULT,
    this.isWordTab = true,
    this.words = const [],
    this.combinations = const [],
    this.wordItemDialog = Word.NONE,
    this.combinationItemDialog = Combination.NONE,
  });

  HistoryState buildNew({
    AppTheme appTheme,
    bool isWordTab,
    List<Word> words,
    List<Combination> combinations,
    Word wordItemDialog,
    Combination combinationItemDialog,
  }) {
    return HistoryState(
      appTheme: appTheme ?? this.appTheme,
      isWordTab: isWordTab ?? this.isWordTab,
      words: words ?? this.words,
      combinations: combinations ?? this.combinations,
      wordItemDialog: wordItemDialog ?? this.wordItemDialog,
      combinationItemDialog: combinationItemDialog ?? this.combinationItemDialog,
    );
  }
}