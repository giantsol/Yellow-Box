
import 'package:yellow_box/entity/AppTheme.dart';

class HomeState {

  final AppTheme appTheme;
  final bool isWordEditorShown;
  final String editingWord;

  const HomeState({
    this.appTheme = AppTheme.DEFAULT,
    this.isWordEditorShown = false,
    this.editingWord = '',
  });

  HomeState buildNew({
    AppTheme appTheme,
    bool isWordEditorShown,
    String editingWord,
  }) {
    return HomeState(
      appTheme: appTheme ?? this.appTheme,
      isWordEditorShown: isWordEditorShown ?? this.isWordEditorShown,
      editingWord: editingWord ?? this.editingWord,
    );
  }

}