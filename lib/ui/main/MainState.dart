
import 'package:yellow_box/entity/AppTheme.dart';
import 'package:yellow_box/entity/ChildScreenKey.dart';
import 'package:yellow_box/entity/NavigationBarItem.dart';

class MainState {
  final ChildScreenKey currentChildScreenKey;
  final List<NavigationBarItem> navigationBarItems;
  final AppTheme appTheme;

  const MainState({
    this.currentChildScreenKey = ChildScreenKey.HOME,
    this.navigationBarItems = const [
      NavigationBarItem(ChildScreenKey.HOME, "assets/ic_home.png"),
      NavigationBarItem(ChildScreenKey.HISTORY, "assets/ic_history.png"),
      NavigationBarItem(ChildScreenKey.THEME, "assets/ic_theme.png"),
      NavigationBarItem(ChildScreenKey.SETTINGS, "assets/ic_settings.png"),
    ],
    this.appTheme = AppTheme.DEFAULT,
  });

  MainState buildNew({
    ChildScreenKey currentChildScreenKey,
    AppTheme appTheme,
  }) {
    return MainState(
      currentChildScreenKey: currentChildScreenKey ?? this.currentChildScreenKey,
      navigationBarItems: this.navigationBarItems,
      appTheme: appTheme ?? this.appTheme,
    );
  }
}