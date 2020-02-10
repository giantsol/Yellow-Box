
import 'package:yellow_box/entity/ChildScreenKey.dart';
import 'package:yellow_box/entity/NavigationBarItem.dart';

class MainState {
  final ChildScreenKey currentChildScreenKey;
  final List<NavigationBarItem> navigationBarItems;

  const MainState({
    this.currentChildScreenKey = ChildScreenKey.HOME,
    this.navigationBarItems = const [
      NavigationBarItem(ChildScreenKey.HOME, "assets/ic_home.png"),
      NavigationBarItem(ChildScreenKey.HISTORY, "assets/ic_history.png"),
      NavigationBarItem(ChildScreenKey.THEME, "assets/ic_theme.png"),
      NavigationBarItem(ChildScreenKey.SETTINGS, "assets/ic_settings.png"),
    ],
  });

  MainState buildNew({
    ChildScreenKey currentChildScreenKey,
  }) {
    return MainState(
      currentChildScreenKey: currentChildScreenKey ?? this.currentChildScreenKey,
    );
  }
}