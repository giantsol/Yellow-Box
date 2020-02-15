
import 'package:yellow_box/entity/ChildScreenKey.dart';

class NavigationBarItem {

  static const ITEMS = const [
    NavigationBarItem(ChildScreenKey.HOME, "assets/ic_home.png"),
    NavigationBarItem(ChildScreenKey.HISTORY, "assets/ic_history.png"),
    NavigationBarItem(ChildScreenKey.THEME, "assets/ic_theme.png"),
    NavigationBarItem(ChildScreenKey.SETTINGS, "assets/ic_settings.png"),
  ];

  final ChildScreenKey key;
  final String iconPath;

  const NavigationBarItem(this.key, this.iconPath);

}