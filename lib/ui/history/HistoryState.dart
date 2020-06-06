
import 'package:yellow_box/entity/AppTheme.dart';
import 'package:yellow_box/entity/Idea.dart';
import 'package:yellow_box/entity/Word.dart';

class HistoryState {

  final AppTheme appTheme;
  final bool isWordTab;
  final List<Word> words;
  final List<Idea> ideas;
  final WordItemDialog wordItemDialog;
  final IdeaItemDialog ideaItemDialog;
  final SelectionMode selectionMode;
  final Map<Word, bool> selectedWords;
  final Map<Idea, bool> selectedIdeas;
  final bool isDeleteWordsDialogShown;
  final bool isDeleteIdeasDialogShown;
  final bool isBlockIdeasDialogShown;
  final bool isProgressShown;

  const HistoryState({
    this.appTheme = AppTheme.DEFAULT,
    this.isWordTab = true,
    this.words = const [],
    this.ideas = const [],
    this.wordItemDialog = WordItemDialog.NONE,
    this.ideaItemDialog = IdeaItemDialog.NONE,
    this.selectionMode = SelectionMode.NONE,
    this.selectedWords = const {},
    this.selectedIdeas = const {},
    this.isDeleteWordsDialogShown = false,
    this.isDeleteIdeasDialogShown = false,
    this.isBlockIdeasDialogShown = false,
    this.isProgressShown = true,
  });

  bool get isScrimVisible => wordItemDialog.isValid() || ideaItemDialog.isValid()
    || isDeleteWordsDialogShown || isDeleteIdeasDialogShown
    || isBlockIdeasDialogShown;

  HistoryState buildNew({
    AppTheme appTheme,
    bool isWordTab,
    List<Word> words,
    List<Idea> ideas,
    WordItemDialog wordItemDialog,
    IdeaItemDialog ideaItemDialog,
    SelectionMode selectionMode,
    Map<Word, bool> selectedWords,
    Map<Idea, bool> selectedIdeas,
    bool isDeleteWordsDialogShown,
    bool isDeleteIdeasDialogShown,
    bool isBlockIdeasDialogShown,
    bool isProgressShown,
  }) {
    return HistoryState(
      appTheme: appTheme ?? this.appTheme,
      isWordTab: isWordTab ?? this.isWordTab,
      words: words ?? this.words,
      ideas: ideas ?? this.ideas,
      wordItemDialog: wordItemDialog ?? this.wordItemDialog,
      ideaItemDialog: ideaItemDialog ?? this.ideaItemDialog,
      selectionMode: selectionMode ?? this.selectionMode,
      selectedWords: selectedWords ?? this.selectedWords,
      selectedIdeas: selectedIdeas ?? this.selectedIdeas,
      isDeleteWordsDialogShown: isDeleteWordsDialogShown ?? this.isDeleteWordsDialogShown,
      isDeleteIdeasDialogShown: isDeleteIdeasDialogShown ?? this.isDeleteIdeasDialogShown,
      isBlockIdeasDialogShown: isBlockIdeasDialogShown ?? this.isBlockIdeasDialogShown,
      isProgressShown: isProgressShown ?? this.isProgressShown,
    );
  }
}

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

enum SelectionMode {
  NONE,
  WORDS,
  IDEAS,
}
