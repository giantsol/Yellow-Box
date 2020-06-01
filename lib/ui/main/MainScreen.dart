
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:yellow_box/Localization.dart';
import 'package:yellow_box/Utils.dart';
import 'package:yellow_box/entity/AppTheme.dart';
import 'package:yellow_box/entity/ChildScreenKey.dart';
import 'package:yellow_box/ui/history/HistoryScreen.dart';
import 'package:yellow_box/ui/home/HomeScreen.dart';
import 'package:yellow_box/ui/main/MainBloc.dart';
import 'package:yellow_box/ui/main/MainNavigator.dart';
import 'package:yellow_box/ui/main/MainState.dart';
import 'package:yellow_box/ui/settings/SettingsScreen.dart';
import 'package:yellow_box/ui/theme/ThemeScreen.dart';

class MainScreen extends StatefulWidget {
  @override
  State createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> implements MainNavigator {
  MainBloc _bloc;

  PageController _pageController;
  final Map<ChildScreenKey, int> _childScreenKeys = {
    ChildScreenKey.HOME: 0,
    ChildScreenKey.HISTORY: 1,
    ChildScreenKey.THEME: 2,
    ChildScreenKey.SETTINGS: 3,
  };
  final List<Widget> _childScreens = [
    HomeScreen(),
    HistoryScreen(),
    ThemeScreen(),
    SettingsScreen(),
  ];

  @override
  void initState() {
    super.initState();
    _bloc = MainBloc(this);
    _pageController = PageController();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      initialData: _bloc.getInitialState(),
      stream: _bloc.observeState(),
      builder: (context, snapshot) => _buildUI(snapshot.data),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _bloc.dispose();
    _pageController.dispose();
  }

  Widget _buildUI(MainState state) {
    final appTheme = state.appTheme;
    final int page = _childScreenKeys[state.currentChildScreenKey];
    if (_pageController.hasClients && _pageController.page != null && _pageController.page != page) {
      _pageController.jumpToPage(page);
    }

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
            PageView(
              controller: _pageController,
              children: _childScreens,
              physics: NeverScrollableScrollPhysics(),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void showRemainingMiniBoxWordsCount(int count) {
    Utils.showToast(AppLocalizations.of(context).getRemainingMiniBoxWordsCount(count), toastLength: Toast.LENGTH_LONG);
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
