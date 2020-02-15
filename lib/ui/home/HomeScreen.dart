
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:yellow_box/AppColors.dart';
import 'package:yellow_box/Localization.dart';
import 'package:yellow_box/entity/AppTheme.dart';
import 'package:yellow_box/entity/ChildScreenKey.dart';
import 'package:yellow_box/entity/NavigationBarItem.dart';
import 'package:yellow_box/ui/home/HomeBloc.dart';
import 'package:yellow_box/ui/home/HomeState.dart';

class HomeScreen extends StatefulWidget {

  @override
  State createState() => _HomeScreenState();

}

class _HomeScreenState extends State<HomeScreen> {
  HomeBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = HomeBloc();
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

  Widget _buildUI(HomeState state) {
    final appTheme = state.appTheme;

    return Stack(
      children: <Widget>[
        _MainUI(
          appTheme: appTheme,
          bloc: _bloc,
        ),
        state.isWordEditorShown ? _WordEditor(
          appTheme: appTheme,
        ) : const SizedBox.shrink(),
      ],
    );
  }

}

class _MainUI extends StatelessWidget {
  final AppTheme appTheme;
  final HomeBloc bloc;

  _MainUI({
    @required this.appTheme,
    @required this.bloc,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        verticalDirection: VerticalDirection.up,
        children: <Widget>[
          _NavigationBar(
            bloc: bloc,
          ),
          Expanded(
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  SizedBox(
                    width: 178,
                    height: 64,
                    child: Placeholder(),
                  ),
                  const SizedBox(height: 32,),
                  SizedBox(
                    width: 160,
                    height: 160,
                    child: Placeholder(),
                  ),
                  const SizedBox(height: 68,),
                  FloatingActionButton(
                    child: Image.asset('assets/ic_pen.png'),
                    backgroundColor: appTheme.darkColor,
                    onPressed: () => bloc.onAddWordClicked(),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _NavigationBar extends StatelessWidget {
  final HomeBloc bloc;

  _NavigationBar({
    @required this.bloc,
  });

  @override
  Widget build(BuildContext context) {
    final items = NavigationBarItem.ITEMS;
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
                      color: item.key == ChildScreenKey.HOME ? AppColors.TEXT_BLACK : AppColors.TEXT_BLACK_LIGHT,
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

class _WordEditor extends StatelessWidget {
  final AppTheme appTheme;

  _WordEditor({
    @required this.appTheme,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Align(
        alignment: Alignment.bottomCenter,
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.BACKGROUND_WHITE,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: <Widget>[
              const SizedBox(width: 6,),
              Padding(
                padding: const EdgeInsets.all(10),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 11),
                  decoration: BoxDecoration(
                    color: appTheme.darkColor,
                    shape: BoxShape.circle,
                  ),
                  child: Image.asset('assets/ic_mic.png'),
                ),
              ),
              const SizedBox(width: 6,),
              Expanded(
                child: TextField(

                ),
              ),
              ConstrainedBox(
                constraints: BoxConstraints(
                  minWidth: 52,
                  minHeight: 36,
                ),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 11, horizontal: 8),
                  child: Text(
                    AppLocalizations.of(context).cancel,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppColors.TEXT_BLACK_LIGHT,
                      fontSize: 12,
                    ),
                    strutStyle: StrutStyle(
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 4,),
              ConstrainedBox(
                constraints: BoxConstraints(
                  minWidth: 52,
                  minHeight: 36,
                ),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 11, horizontal: 8),
                  child: Text(
                    AppLocalizations.of(context).add,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: appTheme.darkColor,
                      fontSize: 12,
                    ),
                    strutStyle: StrutStyle(
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 1,),
            ],
          ),
        ),
      ),
    );
  }

}

