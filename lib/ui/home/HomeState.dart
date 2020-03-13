
import 'package:yellow_box/entity/AppTheme.dart';
import 'package:yellow_box/entity/CombinationPopUpData.dart';

class HomeState {

  final AppTheme appTheme;
  final bool isWordEditorShown;
  final String editingWord;
  final bool isProgressShown;
  final bool isListeningToSpeech;
  final CombinationPopUpData combinationPopUpData;
  final bool isIdeaBoxFull;

  const HomeState({
    this.appTheme = AppTheme.DEFAULT,
    this.isWordEditorShown = false,
    this.editingWord = '',
    this.isProgressShown = false,
    this.isListeningToSpeech = false,
    this.combinationPopUpData = CombinationPopUpData.NONE,
    this.isIdeaBoxFull = false,
  });

  HomeState buildNew({
    AppTheme appTheme,
    bool isWordEditorShown,
    String editingWord,
    bool isProgressShown,
    bool isListeningToSpeech,
    CombinationPopUpData combinationPopUpData,
    bool isIdeaBoxFull,
  }) {
    return HomeState(
      appTheme: appTheme ?? this.appTheme,
      isWordEditorShown: isWordEditorShown ?? this.isWordEditorShown,
      editingWord: editingWord ?? this.editingWord,
      isProgressShown: isProgressShown ?? this.isProgressShown,
      isListeningToSpeech: isListeningToSpeech ?? this.isListeningToSpeech,
      combinationPopUpData: combinationPopUpData ?? this.combinationPopUpData,
      isIdeaBoxFull: isIdeaBoxFull ?? this.isIdeaBoxFull,
    );
  }

}