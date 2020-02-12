
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:yellow_box/AppColors.dart';
import 'package:yellow_box/entity/ChildScreenKey.dart';
import 'package:yellow_box/entity/NavigationBarItem.dart';
import 'package:yellow_box/ui/history/HistoryScreen.dart';
import 'package:yellow_box/ui/home/HomeScreen.dart';
import 'package:yellow_box/ui/main/MainBloc.dart';
import 'package:yellow_box/ui/main/MainState.dart';
import 'package:yellow_box/ui/settings/SettingsScreen.dart';
import 'package:yellow_box/ui/theme/ThemeScreen.dart';

class MainScreen extends StatefulWidget {

  @override
  State createState() => _MainScreenState();

}

class _MainScreenState extends State<MainScreen> {
  MainBloc _bloc;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  final Map<ChildScreenKey, Widget> _childScreenWidgets = {};

  @override
  void initState() {
    super.initState();
    _bloc = MainBloc();
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

  Widget _buildUI(MainState state) {
    final currentChildScreenKey = state.currentChildScreenKey;
    final appTheme = state.appTheme;

    return Scaffold(
      backgroundColor: appTheme.bgColor,
      body: SafeArea(
        child: Scaffold(
          key: _scaffoldKey,
          body: Column(
            children: <Widget>[
              _ChildScreen(
                widget: _getOrCreateChildScreenWidget(currentChildScreenKey),
              ),
              _NavigationBar(
                bloc: _bloc,
                items: state.navigationBarItems,
                currentKey: currentChildScreenKey,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _getOrCreateChildScreenWidget(ChildScreenKey key) {
    if (!_childScreenWidgets.containsKey(key)) {
      switch (key) {
        case ChildScreenKey.HOME:
          _childScreenWidgets[key] = HomeScreen();
          break;
        case ChildScreenKey.HISTORY:
          _childScreenWidgets[key] = HistoryScreen();
          break;
        case ChildScreenKey.THEME:
          _childScreenWidgets[key] = ThemeScreen();
          break;
        case ChildScreenKey.SETTINGS:
          _childScreenWidgets[key] = SettingsScreen();
          break;
      }
    }
    return _childScreenWidgets[key];
  }

}

class _ChildScreen extends StatelessWidget {
  final Widget widget;

  _ChildScreen({
    @required this.widget,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: widget,
    );
  }

}

class _NavigationBar extends StatelessWidget {
  final MainBloc bloc;
  final List<NavigationBarItem> items;
  final ChildScreenKey currentKey;

  _NavigationBar({
    @required this.bloc,
    @required this.items,
    @required this.currentKey,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        color: AppColors.BACKGROUND_WHITE,
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
                      color: currentKey == item.key ? AppColors.TEXT_BLACK : AppColors.TEXT_BLACK_LIGHT,
                    ),
                  ),
                ),
              ),
            );
          }),
        ),
      )
    );
  }

}
