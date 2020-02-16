
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:yellow_box/AppColors.dart';
import 'package:yellow_box/Localization.dart';
import 'package:yellow_box/entity/AppTheme.dart';
import 'package:yellow_box/entity/ChildScreenKey.dart';
import 'package:yellow_box/entity/NavigationBarItem.dart';
import 'package:yellow_box/ui/home/HomeBloc.dart';
import 'package:yellow_box/ui/home/HomeState.dart';
import 'package:yellow_box/ui/widget/AppTextField.dart';

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

    return WillPopScope(
      onWillPop: () async => !_bloc.handleBackPress(),
      child: Stack(
        children: <Widget>[
          _MainUI(
            appTheme: appTheme,
            bloc: _bloc,
            isWordEditorShown: state.isWordEditorShown,
          ),
          state.isWordEditorShown ? _WordEditor(
            bloc: _bloc,
            appTheme: appTheme,
            text: state.editingWord,
          ) : const SizedBox.shrink(),
        ],
      ),
    );
  }

}

class _MainUI extends StatelessWidget {
  final AppTheme appTheme;
  final HomeBloc bloc;
  final bool isWordEditorShown;

  _MainUI({
    @required this.appTheme,
    @required this.bloc,
    @required this.isWordEditorShown,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        verticalDirection: VerticalDirection.up,
        children: <Widget>[
          _NavigationBar(
            bloc: bloc,
            isWordEditorShown: isWordEditorShown
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
  final bool isWordEditorShown;

  _NavigationBar({
    @required this.bloc,
    @required this.isWordEditorShown,
  });

  @override
  Widget build(BuildContext context) {
    final items = NavigationBarItem.ITEMS;
    return !isWordEditorShown ? Align(
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
    ) : const SizedBox(height: 60,);
  }

}

class _WordEditor extends StatelessWidget {
  final HomeBloc bloc;
  final AppTheme appTheme;
  final String text;

  _WordEditor({
    @required this.bloc,
    @required this.appTheme,
    @required this.text,
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
            borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
          ),
          child: Material(
            child: Row(
              children: <Widget>[
                const SizedBox(width: 6,),
                InkWell(
                  onTap: () { },
                  child: Padding(
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
                ),
                const SizedBox(width: 6,),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8,),
                    child: AppTextField(
                      text: text,
                      textSize: 16,
                      textColor: AppColors.TEXT_BLACK,
                      hintText: AppLocalizations.of(context).wordEditorHint,
                      hintTextSize: 16,
                      hintTextColor: AppColors.TEXT_BLACK_LIGHT,
                      cursorColor: appTheme.darkColor,
                      autoFocus: true,
                      onChanged: (s) => bloc.onEditingWordChanged(s),
                    ),
                  ),
                ),
                const SizedBox(width: 8,),
                ConstrainedBox(
                  constraints: BoxConstraints(
                    minWidth: 52,
                    minHeight: 36,
                  ),
                  child: InkWell(
                    onTap: () => bloc.onWordEditingCancelClicked(),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 11, horizontal: 8),
                      child: Text(
                        AppLocalizations.of(context).cancel,
                        textAlign: TextAlign.center,
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
                ),
                const SizedBox(width: 4,),
                ConstrainedBox(
                  constraints: BoxConstraints(
                    minWidth: 52,
                    minHeight: 36,
                  ),
                  child: InkWell(
                    onTap: () => bloc.onWordEditingAddClicked(),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 11, horizontal: 8),
                      child: Text(
                        AppLocalizations.of(context).add,
                        textAlign: TextAlign.center,
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
                ),
                const SizedBox(width: 1,),
              ],
            ),
          ),
        ),
      ),
    );
  }

}

