
import 'package:yellow_box/entity/AppTheme.dart';
import 'package:yellow_box/entity/ChildScreenKey.dart';

class MainState {
  final ChildScreenKey currentChildScreenKey;
  final AppTheme appTheme;

  const MainState({
    this.currentChildScreenKey = ChildScreenKey.HOME,
    this.appTheme = AppTheme.DEFAULT,
  });

  MainState buildNew({
    ChildScreenKey currentChildScreenKey,
    AppTheme appTheme,
  }) {
    return MainState(
      currentChildScreenKey: currentChildScreenKey ?? this.currentChildScreenKey,
      appTheme: appTheme ?? this.appTheme,
    );
  }
}