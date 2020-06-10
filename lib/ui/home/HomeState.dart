
import 'package:yellow_box/entity/AppTheme.dart';
import 'package:yellow_box/entity/IdeaPopUpData.dart';

class HomeState {

  final AppTheme appTheme;
  final bool isWordEditorShown;
  final String editingWord;
  final bool isProgressShown;
  final bool isListeningToSpeech;
  final IdeaPopUpData ideaPopUpData;
  final bool isIdeaBoxFull;
  final bool isInTutorial;

  const HomeState({
    this.appTheme = AppTheme.DEFAULT,
    this.isWordEditorShown = false,
    this.editingWord = '',
    this.isProgressShown = false,
    this.isListeningToSpeech = false,
    this.ideaPopUpData = IdeaPopUpData.NONE,
    this.isIdeaBoxFull = false,
    this.isInTutorial = false,
  });

  bool get isScrimVisible => isListeningToSpeech || ideaPopUpData.isValid();

  HomeState buildNew({
    AppTheme appTheme,
    bool isWordEditorShown,
    String editingWord,
    bool isProgressShown,
    bool isListeningToSpeech,
    IdeaPopUpData ideaPopUpData,
    bool isIdeaBoxFull,
    bool isInTutorial,
  }) {
    return HomeState(
      appTheme: appTheme ?? this.appTheme,
      isWordEditorShown: isWordEditorShown ?? this.isWordEditorShown,
      editingWord: editingWord ?? this.editingWord,
      isProgressShown: isProgressShown ?? this.isProgressShown,
      isListeningToSpeech: isListeningToSpeech ?? this.isListeningToSpeech,
      ideaPopUpData: ideaPopUpData ?? this.ideaPopUpData,
      isIdeaBoxFull: isIdeaBoxFull ?? this.isIdeaBoxFull,
      isInTutorial: isInTutorial ?? this.isInTutorial,
    );
  }

}