
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:yellow_box/AppColors.dart';
import 'package:yellow_box/Localization.dart';
import 'package:yellow_box/entity/ChildScreenKey.dart';
import 'package:yellow_box/entity/NavigationBarItem.dart';
import 'package:yellow_box/ui/settings/SettingsBloc.dart';
import 'package:yellow_box/ui/settings/SettingsNavigator.dart';
import 'package:yellow_box/ui/settings/SettingsState.dart';

class SettingsScreen extends StatefulWidget {
  @override
  State createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> implements SettingsNavigator {
  SettingsBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = SettingsBloc(this);
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      initialData: _bloc.getInitialState(),
      stream: _bloc.observeState(),
      builder: (context, snapshot) {
        return _buildUI(snapshot.data);
      }
    );
  }

  @override
  void dispose() {
    super.dispose();
    _bloc.dispose();
  }

  Widget _buildUI(SettingsState state) {
    final isDarkTheme = state.appTheme.isDarkTheme;

    return SafeArea(
      child: Column(
        verticalDirection: VerticalDirection.up,
        children: <Widget>[
          _NavigationBar(
            bloc: _bloc,
          ),
          Spacer(),
          _SettingsGroup(
            isDarkTheme: isDarkTheme,
            title: AppLocalizations.of(context).general,
            children: [
              _ArrowSettingsItem(
                isDarkTheme: isDarkTheme,
                title: AppLocalizations.of(context).miniBoxTitle,
                subtitle: AppLocalizations.of(context).miniBoxSubtitle,
                onTap: () => _bloc.onMiniBoxItemClicked(),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  void showMiniBoxLaunchFailedMessage() {
    _showToast(AppLocalizations.of(context).failedToLaunchMiniBox);
  }

  void _showToast(String msg) {
    Fluttertoast.cancel();
    Fluttertoast.showToast(msg: msg);
  }

}

class _NavigationBar extends StatelessWidget {
  final SettingsBloc bloc;

  _NavigationBar({
    @required this.bloc,
  });

  @override
  Widget build(BuildContext context) {
    final items = NavigationBarItem.ITEMS;
    return Container(
      decoration: BoxDecoration(
        color: AppColors.BACKGROUND_WHITE,
        boxShadow: [
          BoxShadow(
            color: AppColors.SHADOW,
            offset: Offset(0, -1),
            blurRadius: 4,
          ),
        ],
      ),
      child: Row(
        children: List.generate(items.length, (index) {
          final item = items[index];
          return Expanded(
            child: Material(
              child: InkWell(
                onTap: () => bloc.onNavigationBarItemClicked(item),
                child: Container(
                  height: 60,
                  alignment: Alignment.center,
                  child: Image.asset(item.iconPath,
                    width: 24,
                    height: 24,
                    color: item.key == ChildScreenKey.SETTINGS ? AppColors.TEXT_BLACK : AppColors.TEXT_BLACK_LIGHT,
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}


class _SettingsGroup extends StatelessWidget {
  final bool isDarkTheme;
  final String title;
  final List<Widget> children;

  _SettingsGroup({
    @required this.isDarkTheme,
    @required this.title,
    @required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(left: 32, top: 32),
          child: Text(
            title,
            style: TextStyle(
              fontSize: 12,
              color: isDarkTheme ? AppColors.TEXT_WHITE_LIGHT : AppColors.TEXT_BLACK_LIGHT,
            ),
            strutStyle: StrutStyle(
              fontSize: 12,
            ),
          ),
        ),
        const SizedBox(height: 4),
        ...children,
      ],
    );
  }
}

class _ArrowSettingsItem extends StatelessWidget {
  final bool isDarkTheme;
  final String title;
  final String subtitle;
  final Function onTap;

  _ArrowSettingsItem({
    @required this.isDarkTheme,
    @required this.title,
    @required this.subtitle,
    @required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 24,),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 18,
                          color: isDarkTheme ? AppColors.TEXT_WHITE : AppColors.TEXT_BLACK,
                        ),
                        strutStyle: StrutStyle(
                          fontSize: 18,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        subtitle,
                        style: TextStyle(
                          fontSize: 12,
                          color: isDarkTheme ? AppColors.TEXT_WHITE_LIGHT : AppColors.TEXT_BLACK_LIGHT,
                        ),
                        strutStyle: StrutStyle(
                          fontSize: 12,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 24),
                  child: Image.asset(
                    'assets/ic_right_arrow.png',
                    color: isDarkTheme ? AppColors.TEXT_WHITE : AppColors.TEXT_BLACK,
                  ),
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Container(
            height: 1,
            color: isDarkTheme ? AppColors.DIVIDER_WHITE : AppColors.DIVIDER_BLACK,
          ),
        ),
      ],
    );
  }
}
