
import 'package:yellow_box/entity/AppTheme.dart';

class HomeState {

  final AppTheme appTheme;
  final bool isWordEditorShown;
  final String editingWord;
  final bool isProgressShown;
  final bool isListeningToSpeech;

  const HomeState({
    this.appTheme = AppTheme.DEFAULT,
    this.isWordEditorShown = false,
    this.editingWord = '',
    this.isProgressShown = false,
    this.isListeningToSpeech = false,
  });

  HomeState buildNew({
    AppTheme appTheme,
    bool isWordEditorShown,
    String editingWord,
    bool isProgressShown,
    bool isListeningToSpeech,
  }) {
    return HomeState(
      appTheme: appTheme ?? this.appTheme,
      isWordEditorShown: isWordEditorShown ?? this.isWordEditorShown,
      editingWord: editingWord ?? this.editingWord,
      isProgressShown: isProgressShown ?? this.isProgressShown,
      isListeningToSpeech: isListeningToSpeech ?? this.isListeningToSpeech,
    );
  }

}