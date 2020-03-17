
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:yellow_box/AppColors.dart';
import 'package:yellow_box/Localization.dart';
import 'package:yellow_box/entity/AppTheme.dart';
import 'package:yellow_box/entity/ChildScreenKey.dart';
import 'package:yellow_box/entity/CombinationPopUpData.dart';
import 'package:yellow_box/entity/NavigationBarItem.dart';
import 'package:yellow_box/ui/home/HomeBloc.dart';
import 'package:yellow_box/ui/home/HomeNavigator.dart';
import 'package:yellow_box/ui/home/HomeState.dart';
import 'package:yellow_box/ui/widget/AppTextField.dart';

class HomeScreen extends StatefulWidget {

  @override
  State createState() => _HomeScreenState();

}

class _HomeScreenState extends State<HomeScreen> implements HomeNavigator {
  HomeBloc _bloc;

  bool _hasShownIdeaBoxFullNoti = false;
  bool _isIdeaBoxFullNotiVisible = false;

  @override
  void initState() {
    super.initState();
    _bloc = HomeBloc(this);
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
    final isScrimVisible = state.isListeningToSpeech
      || state.combinationPopUpData.isValid();

    if (state.isIdeaBoxFull && !_hasShownIdeaBoxFullNoti) {
      _hasShownIdeaBoxFullNoti = true;
      _isIdeaBoxFullNotiVisible = true;
      _hideIdeaBoxFullNotiAfterDelay();
    } else if (!state.isIdeaBoxFull) {
      _hasShownIdeaBoxFullNoti = false;
    }

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
          isScrimVisible ? _Scrim() : const SizedBox.shrink(),
          state.isListeningToSpeech ? _ListeningToSpeechView(
            bloc: _bloc,
            appTheme: appTheme,
          ) : const SizedBox.shrink(),
          state.combinationPopUpData.isValid() ? _CombinationPopUpBox(
            bloc: _bloc,
            data: state.combinationPopUpData,
            appTheme: appTheme,
          ) : const SizedBox.shrink(),
          state.isProgressShown ? _OverlayProgress(
            appTheme: appTheme,
          ) : const SizedBox.shrink(),
          _isIdeaBoxFullNotiVisible ? _IdeaBoxFullNoti(
            bloc: _bloc,
          ) : const SizedBox.shrink(),
        ],
      ),
    );
  }

  void _hideIdeaBoxFullNotiAfterDelay() async {
    await Future.delayed(const Duration(seconds: 5));
    setState(() {
      _isIdeaBoxFullNotiVisible = false;
    });
  }

  @override
  void showEditingWordEmptyMessage() {
    _showToast(AppLocalizations.of(context).editingWordEmpty);
  }

  void _showToast(String msg) {
    Fluttertoast.cancel();
    Fluttertoast.showToast(msg: msg);
  }

  @override
  void showEditingWordAlreadyExists() {
    _showToast(AppLocalizations.of(context).editingWordAlreadyExists);
  }

  @override
  void showSpeechToTextNotReady() {
    _showToast(AppLocalizations.of(context).speechToTextNotReady);
  }

  @override
  void showAddMoreWordsForCombination() {
    _showToast(AppLocalizations.of(context).addMoreWordsForCombination);
  }

  @override
  void showIdeaBoxFull() {
    _showToast(AppLocalizations.of(context).ideaBoxFullToast);
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
                  GestureDetector(
                    onTap: () => bloc.onLogoClicked(),
                    behavior: HitTestBehavior.opaque,
                    child: SizedBox(
                      width: 160,
                      height: 160,
                      child: Placeholder(),
                    ),
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
    return !isWordEditorShown ? Container(
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
                    color: item.key == ChildScreenKey.HOME ? AppColors.TEXT_BLACK : AppColors.TEXT_BLACK_LIGHT,
                  ),
                ),
              ),
            ),
          );
        }),
      ),
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
            boxShadow: [
              BoxShadow(
                color: AppColors.SHADOW,
                offset: Offset(0, -1),
                blurRadius: 4,
              ),
            ],
          ),
          child: Material(
            child: Row(
              children: <Widget>[
                const SizedBox(width: 6,),
                InkWell(
                  onTap: () => bloc.onMicIconClicked(),
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
                      onEditingComplete: () => bloc.onWordEditingAddClicked(),
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

class _OverlayProgress extends StatelessWidget {
  final AppTheme appTheme;

  _OverlayProgress({
    @required this.appTheme,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation(appTheme.darkColor),
      ),
    );
  }

}

class _Scrim extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.SCRIM,
    );
  }
}

class _ListeningToSpeechView extends StatelessWidget {
  final HomeBloc bloc;
  final AppTheme appTheme;

  _ListeningToSpeechView({
    @required this.bloc,
    @required this.appTheme,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            Align(
              alignment: Alignment.topLeft,
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () => bloc.onStopSpeechRecognizerClicked(),
                child: Padding(
                  padding: const EdgeInsets.all(29),
                  child: Image.asset('assets/ic_close.png'),
                ),
              ),
            ),
            _SpeechAnimatingView(
              color: appTheme.darkColor,
            ),
          ],
        ),
      ),
    );
  }
}

class _SpeechAnimatingView extends StatefulWidget {
  final Color color;

  _SpeechAnimatingView({
    @required this.color,
  });

  @override
  State createState() => _SpeechAnimatingViewState();

}

class _SpeechAnimatingViewState extends State<_SpeechAnimatingView> with SingleTickerProviderStateMixin {
  AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_controller.isAnimating) {
      _controller.repeat();
    }

    return Center(
      child: Container(
        width: 72,
        height: 72,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: AppColors.TEXT_WHITE,
            width: 2,
          ),
          color: widget.color,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            _WhiteDot(
              animation: Tween<double>(
                begin: 0,
                end: pi * 2,
              ).animate(CurvedAnimation(
                parent: CurvedAnimation(
                  parent: _controller,
                  curve: Interval(0, 0.8),
                ),
                curve: Curves.fastOutSlowIn,
              )),
            ),
            const SizedBox(width: 4,),
            _WhiteDot(
              animation: Tween<double>(
                begin: 0,
                end: pi * 2,
              ).animate(CurvedAnimation(
                parent: CurvedAnimation(
                  parent: _controller,
                  curve: Interval(0.1, 0.9),
                ),
                curve: Curves.fastOutSlowIn,
              )),
            ),
            const SizedBox(width: 4,),
            _WhiteDot(
              animation: Tween<double>(
                begin: 0,
                end: pi * 2,
              ).animate(CurvedAnimation(
                parent: CurvedAnimation(
                  parent: _controller,
                  curve: Interval(0.2, 1.0),
                ),
                curve: Curves.fastOutSlowIn,
              )),
            ),
          ],
        ),
      ),
    );
  }
}

class _WhiteDot extends AnimatedWidget {
  _WhiteDot({
    Animation<double> animation,
  }) : super(listenable: animation);

  @override
  Widget build(BuildContext context) {
    final anim = listenable as Animation<double>;
    return FractionalTranslation(
      translation: Offset(0, 0.6 * sin(anim.value)),
      child: Container(
        width: 8,
        height: 8,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: AppColors.TEXT_WHITE,
        ),
      ),
    );
  }
}

class _CombinationPopUpBox extends StatelessWidget {
  final HomeBloc bloc;
  final CombinationPopUpData data;
  final AppTheme appTheme;

  _CombinationPopUpBox({
    @required this.bloc,
    @required this.data,
    @required this.appTheme,
  });

  @override
  Widget build(BuildContext context) {
    final isNew = data.isNew;
    final combination = data.combination;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 90, horizontal: 32),
        child: Stack(
          children: <Widget>[
            Container(
              height: 225,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: appTheme.lightColor,
              ),
              padding: const EdgeInsets.only(top: 16),
              child: isNew ? _HappyLogo() : _SadLogo(),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 192,),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: AppColors.BACKGROUND_WHITE,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text(
                      isNew ? AppLocalizations.of(context).newCombination
                        : AppLocalizations.of(context).goodOldOne,
                      style: TextStyle(
                        color: AppColors.TEXT_BLACK,
                        fontSize: 14,
                      ),
                      strutStyle: StrutStyle(
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 16,),
                    Text(
                      combination,
                      maxLines: 4,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: AppColors.TEXT_BLACK,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      strutStyle: StrutStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16,),
                    isNew ? Row(
                      children: <Widget>[
                        Expanded(
                          child: Material(
                            child: InkWell(
                              borderRadius: BorderRadius.circular(24),
                              onTap: () => bloc.onNahClicked(),
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(24),
                                  border: Border.all(
                                    color: AppColors.TEXT_BLACK_LIGHT,
                                    width: 2,
                                  ),
                                ),
                                alignment: Alignment.center,
                                padding: const EdgeInsets.symmetric(vertical: 11),
                                child: Text(
                                  AppLocalizations.of(context).nah,
                                  style: TextStyle(
                                    color: AppColors.TEXT_BLACK_LIGHT,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  strutStyle: StrutStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8,),
                        Expanded(
                          child: Material(
                            color: appTheme.darkColor,
                            borderRadius: BorderRadius.circular(24),
                            child: InkWell(
                              borderRadius: BorderRadius.circular(24),
                              onTap: () => bloc.onCleverClicked(),
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(24),
                                  border: Border.all(
                                    color: appTheme.darkColor,
                                    width: 2,
                                  ),
                                ),
                                alignment: Alignment.center,
                                padding: const EdgeInsets.symmetric(vertical: 11),
                                child: Text(
                                  AppLocalizations.of(context).clever,
                                  style: TextStyle(
                                    color: AppColors.TEXT_WHITE,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  strutStyle: StrutStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ) : Material(
                      color: appTheme.darkColor,
                      borderRadius: BorderRadius.circular(24),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(24),
                        onTap: () => bloc.onCloseCombinationPopUpClicked(),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(24),
                            border: Border.all(
                              color: appTheme.darkColor,
                              width: 2,
                            ),
                          ),
                          alignment: Alignment.center,
                          padding: const EdgeInsets.symmetric(vertical: 11),
                          child: Text(
                            AppLocalizations.of(context).close,
                            style: TextStyle(
                              color: AppColors.TEXT_WHITE,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                            strutStyle: StrutStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      )
    );
  }
}

class _HappyLogo extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: SizedBox(
        width: 160,
        height: 160,
        child: Placeholder(),
      ),
    );
  }
}

class _SadLogo extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: SizedBox(
        width: 160,
        height: 160,
        child: Placeholder(),
      ),
    );
  }
}

class _IdeaBoxFullNoti extends StatelessWidget {
  final HomeBloc bloc;

  _IdeaBoxFullNoti({
    @required this.bloc,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 32),
        child: Material(
          elevation: 2,
          color: AppColors.BACKGROUND_WHITE,
          borderRadius: BorderRadius.all(Radius.circular(24)),
          child: InkWell(
            borderRadius: BorderRadius.all(Radius.circular(24)),
            onTap: () => bloc.onIdeaBoxFullNotiClicked(),
            child: IntrinsicHeight(
              child: Row(
                children: <Widget>[
                  const SizedBox(width: 16,),
                  Image.asset('assets/ic_warning.png'),
                  const SizedBox(width: 8,),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            AppLocalizations.of(context).ideaBoxFullTitle,
                            style: TextStyle(
                              fontSize: 12,
                              color: AppColors.TEXT_BLACK,
                              fontWeight: FontWeight.bold,
                            ),
                            strutStyle: StrutStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            AppLocalizations.of(context).ideaBoxFullSubtitle,
                            style: TextStyle(
                              fontSize: 12,
                              color: AppColors.TEXT_BLACK,
                            ),
                            strutStyle: StrutStyle(
                              fontSize: 12,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    AppLocalizations.of(context).history,
                    style: TextStyle(
                      fontSize: 10,
                      color: AppColors.TEXT_BLACK_LIGHT,
                    ),
                    strutStyle: StrutStyle(
                      fontSize: 10,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Image.asset('assets/ic_arrow_right.png'),
                  const SizedBox(width: 16,),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
