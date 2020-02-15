
import 'package:yellow_box/entity/AppTheme.dart';

class HomeState {

  final AppTheme appTheme;
  final bool isWordEditorShown;

  const HomeState({
    this.appTheme = AppTheme.DEFAULT,
    this.isWordEditorShown = false,
  });

  HomeState buildNew({
    AppTheme appTheme,
    bool isWordEditorShown,
  }) {
    return HomeState(
      appTheme: appTheme ?? this.appTheme,
      isWordEditorShown: isWordEditorShown ?? this.isWordEditorShown,
    );
  }

}