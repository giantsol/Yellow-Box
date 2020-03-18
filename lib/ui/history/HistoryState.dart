
import 'package:yellow_box/entity/AppTheme.dart';
import 'package:yellow_box/entity/Idea.dart';
import 'package:yellow_box/entity/Word.dart';

class WordItemDialog {
  static const NONE = const WordItemDialog(0, Word.NONE);
  static const TYPE_LIST = 0;
  static const TYPE_CONFIRM_DELETE = 1;

  final int type;
  final Word word;

  const WordItemDialog(this.type, this.word);

  bool isValid() {
    return word.isValid();
  }
}

class IdeaItemDialog {
  static const NONE = const IdeaItemDialog(0, Idea.NONE);
  static const TYPE_LIST = 0;
  static const TYPE_CONFIRM_DELETE = 1;
  static const TYPE_CONFIRM_BLOCK = 2;

  final int type;
  final Idea idea;

  const IdeaItemDialog(this.type, this.idea);

  bool isValid() {
    return idea.isValid();
  }
}

class HistoryState {

  final AppTheme appTheme;
  final bool isWordTab;
  final List<Word> words;
  final List<Idea> ideas;
  final WordItemDialog wordItemDialog;
  final IdeaItemDialog ideaItemDialog;

  const HistoryState({
    this.appTheme = AppTheme.DEFAULT,
    this.isWordTab = true,
    this.words = const [],
    this.ideas = const [],
    this.wordItemDialog = WordItemDialog.NONE,
    this.ideaItemDialog = IdeaItemDialog.NONE,
  });

  HistoryState buildNew({
    AppTheme appTheme,
    bool isWordTab,
    List<Word> words,
    List<Idea> ideas,
    WordItemDialog wordItemDialog,
    IdeaItemDialog ideaItemDialog,
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