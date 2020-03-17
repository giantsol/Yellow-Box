
import 'package:yellow_box/entity/AppTheme.dart';
import 'package:yellow_box/entity/Idea.dart';
import 'package:yellow_box/entity/Word.dart';

class HistoryState {

  final AppTheme appTheme;
  final bool isWordTab;
  final List<Word> words;
  final List<Idea> ideas;
  final Word wordItemDialog;
  final Idea ideaItemDialog;

  const HistoryState({
    this.appTheme = AppTheme.DEFAULT,
    this.isWordTab = true,
    this.words = const [],
    this.ideas = const [],
    this.wordItemDialog = Word.NONE,
    this.ideaItemDialog = Idea.NONE,
  });

  HistoryState buildNew({
    AppTheme appTheme,
    bool isWordTab,
    List<Word> words,
    List<Idea> ideas,
    Word wordItemDialog,
    Idea ideaItemDialog,
  }) {
    return HistoryState(
      appTheme: appTheme ?? this.appTheme,
      isWordTab: isWordTab ?? this.isWordTab,
      words: words ?? this.words,
      ideas: ideas ?? this.ideas,
      wordItemDialog: wordItemDialog ?? this.wordItemDialog,
      ideaItemDialog: ideaItemDialog ?? this.ideaItemDialog,
    );
  }
}