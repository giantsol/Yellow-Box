
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:yellow_box/AppColors.dart';
import 'package:yellow_box/entity/ChildScreenKey.dart';

class ChildScreenNavigationBar extends StatelessWidget {
  final ChildScreenKey currentChildScreenKey;
  final Function(ChildScreenKey key) onItemClicked;
  final bool isVisible;
  Key? historyButtonKey = null;

  ChildScreenNavigationBar({
    required this.currentChildScreenKey,
    required this.onItemClicked,
    this.isVisible = true,
    this.historyButtonKey,
  });

  @override
  Widget build(BuildContext context) {
    final items = _ChildScreenNavigationBarItem.ITEMS;
    const double height = 60;

    return isVisible ? Container(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom),
      decoration: BoxDecoration(
        color: AppColors.BACKGROUND_WHITE,
        boxShadow: kElevationToShadow[4],
      ),
      child: Row(
        children: List.generate(items.length, (index) {
          final item = items[index];
          return Expanded(
            key: item.key == ChildScreenKey.HISTORY ? historyButtonKey : null,
            child: Material(
              child: InkWell(
                onTap: () => onItemClicked(item.key),
                child: Container(
                  height: height,
                  alignment: Alignment.center,
                  child: Image.asset(item.iconPath,
                    width: 24,
                    height: 24,
                    color: item.key == currentChildScreenKey ? AppColors.TEXT_BLACK : AppColors.TEXT_BLACK_LIGHT,
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    ) : SizedBox(height: height + MediaQuery.of(context).padding.bottom,);
  }
}

class _ChildScreenNavigationBarItem {

  static const ITEMS = const [
    _ChildScreenNavigationBarItem(ChildScreenKey.HOME, "assets/ic_home.png"),
    _ChildScreenNavigationBarItem(ChildScreenKey.HISTORY, "assets/ic_history.png"),
//    NavigationBarItem(ChildScreenKey.THEME, "assets/ic_theme.png"),
    _ChildScreenNavigationBarItem(ChildScreenKey.SETTINGS, "assets/ic_settings.png"),
  ];

  final ChildScreenKey key;
  final String iconPath;

  const _ChildScreenNavigationBarItem(this.key, this.iconPath);

}
