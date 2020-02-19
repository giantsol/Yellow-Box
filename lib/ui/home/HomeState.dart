
import 'package:yellow_box/entity/AppTheme.dart';

class HomeState {

  final AppTheme appTheme;
  final bool isWordEditorShown;
  final String editingWord;
  final bool isProgressShown;

  const HomeState({
    this.appTheme = AppTheme.DEFAULT,
    this.isWordEditorShown = false,
    this.editingWord = '',
    this.isProgressShown = false,
  });

  HomeState buildNew({
    AppTheme appTheme,
    bool isWordEditorShown,
    String editingWord,
    bool isProgressShown,
  }) {
    return HomeState(
      appTheme: appTheme ?? this.appTheme,
      isWordEditorShown: isWordEditorShown ?? this.isWordEditorShown,
      editingWord: editingWord ?? this.editingWord,
      isProgressShown: isProgressShown ?? this.isProgressShown,
    );
  }

}