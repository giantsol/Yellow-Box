
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:yellow_box/entity/AppTheme.dart';
import 'package:yellow_box/entity/ChildScreenKey.dart';
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

    return Theme(
      data: Theme.of(context).copyWith(
        accentColor: appTheme.darkColor,
      ),
      child: Scaffold(
        backgroundColor: appTheme.lightColor,
        resizeToAvoidBottomInset: false,
        body: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            _BackgroundDeco(
              appTheme: appTheme,
            ),
            _ChildScreen(
              widget: _getOrCreateChildScreenWidget(currentChildScreenKey),
            ),
          ],
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

class _BackgroundDeco extends StatelessWidget {
  final AppTheme appTheme;

  _BackgroundDeco({
    @required this.appTheme,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Stack(
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: Image.asset(
              appTheme.topBackgroundDeco,
              fit: BoxFit.fitWidth,
              alignment: Alignment.topCenter,
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 60),
              child: Image.asset(
                appTheme.bottomBackgroundDeco,
                fit: BoxFit.fitWidth,
                alignment: Alignment.bottomCenter,
              ),
            ),
          ),
        ],
      ),
    );
  }

}

class _ChildScreen extends StatelessWidget {
  final Widget widget;

  _ChildScreen({
    @required this.widget,
  });

  @override
  Widget build(BuildContext context) {
    return widget;
  }

}

