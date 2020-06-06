
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:yellow_box/AppColors.dart';
import 'package:yellow_box/Localization.dart';
import 'package:yellow_box/Utils.dart';
import 'package:yellow_box/entity/AppTheme.dart';
import 'package:yellow_box/entity/ChildScreenKey.dart';
import 'package:yellow_box/entity/IdeaPopUpData.dart';
import 'package:yellow_box/ui/home/HomeBloc.dart';
import 'package:yellow_box/ui/home/HomeNavigator.dart';
import 'package:yellow_box/ui/home/HomeState.dart';
import 'package:yellow_box/ui/widget/AppTextField.dart';
import 'package:yellow_box/ui/widget/CenterProgress.dart';
import 'package:yellow_box/ui/widget/ChildScreenNavigationBar.dart';
import 'package:yellow_box/ui/widget/Scrim.dart';

class HomeScreen extends StatefulWidget {
  @override
  State createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
  with AutomaticKeepAliveClientMixin, TickerProviderStateMixin
  implements HomeNavigator {

  HomeBloc _bloc;

  // one shot flags are not managed in HomeState
  bool _hasShownIdeaBoxFullNoti = false;
  bool _isIdeaBoxFullNotiVisible = false;

  AnimationController _wordAddedAnimation;
  AnimationController _ideaAddedAnimation;

  final GlobalKey _penButtonKey = GlobalKey();
  final GlobalKey _logoKey = GlobalKey();
  final GlobalKey _historyButtonKey = GlobalKey();
  
  AppTheme _prevAppTheme;
  AnimationController _logoInAnimation;
  AnimationController _logoIdleAnimation;

  @override
  void initState() {
    super.initState();
    _bloc = HomeBloc(this);

    _wordAddedAnimation = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..addStatusListener(_wordAddedAnimationStatusListener);
    _ideaAddedAnimation = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..addStatusListener(_ideaAddedAnimationStatusListener);
    _logoInAnimation = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3000),
    )..addStatusListener(_logoInAnimationStatusListener);
    _logoIdleAnimation = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );
  }

  void _wordAddedAnimationStatusListener(AnimationStatus status) {
    if (status == AnimationStatus.completed) {
      _logoIdleAnimation.repeat();
    } else if (status == AnimationStatus.forward) {
      if (_logoInAnimation.isAnimating) {
        _logoInAnimation.reset();
      }
      _logoIdleAnimation.reset();
    }
  }

  void _ideaAddedAnimationStatusListener(AnimationStatus status) {
    if (status == AnimationStatus.completed) {
      _logoIdleAnimation.repeat();
    } else if (status == AnimationStatus.forward) {
      if (_logoInAnimation.isAnimating) {
        _logoInAnimation.reset();
      }
      _logoIdleAnimation.reset();
    }
  }

  void _logoInAnimationStatusListener(AnimationStatus status) {
    if (status == AnimationStatus.completed) {
      _logoIdleAnimation.repeat();
    } else if (status == AnimationStatus.forward) {
      _logoIdleAnimation.reset();
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return StreamBuilder(
      initialData: _bloc.getInitialState(),
      stream: _bloc.observeState(),
      builder: (context, snapshot) => _buildUI(snapshot.data),
    );
  }

  @override
  void dispose() {
    _wordAddedAnimation.removeStatusListener(_wordAddedAnimationStatusListener);
    _wordAddedAnimation.dispose();
    _ideaAddedAnimation.removeStatusListener(_ideaAddedAnimationStatusListener);
    _ideaAddedAnimation.dispose();
    _logoInAnimation.removeStatusListener(_logoInAnimationStatusListener);
    _logoInAnimation.dispose();
    _logoIdleAnimation.dispose();
    super.dispose();
    _bloc.dispose();
  }

  @override
  bool get wantKeepAlive => true;

  Widget _buildUI(HomeState state) {
    final appTheme = state.appTheme;

    if (state.isIdeaBoxFull && !_hasShownIdeaBoxFullNoti) {
      _hasShownIdeaBoxFullNoti = true;
      _isIdeaBoxFullNotiVisible = true;
      _hideIdeaBoxFullNotiAfterDelay();
    } else if (!state.isIdeaBoxFull) {
      _hasShownIdeaBoxFullNoti = false;
    }

    final penButtonPosition = ViewLayoutInfo.create(
      _penButtonKey.currentContext?.findRenderObject(),
    );
    final logoPosition = ViewLayoutInfo.create(
      _logoKey.currentContext?.findRenderObject(),
    );
    final historyButtonPosition = ViewLayoutInfo.create(
      _historyButtonKey.currentContext?.findRenderObject(),
    );

    if (_prevAppTheme != appTheme) {
      _runLogoInAnimation(_prevAppTheme == null ? 500 : 0);
      _prevAppTheme = appTheme;
    }

    if (state.isScrimVisible && _ideaAddedAnimation.isAnimating) {
      _ideaAddedAnimation.reset();
    }

    return WillPopScope(
      onWillPop: () async => !_bloc.handleBackPress(),
      child: Stack(
        children: <Widget>[
          _MainUI(
            appTheme: appTheme,
            bloc: _bloc,
            isWordEditorShown: state.isWordEditorShown,
            penButtonKey: _penButtonKey,
            logoKey: _logoKey,
            historyButtonKey: _historyButtonKey,
            logoInAnimation: _logoInAnimation,
            logoIdleAnimation: _logoIdleAnimation,
            wordAddedAnimation: _wordAddedAnimation,
            ideaAddedAnimation: _ideaAddedAnimation,
          ),
          state.isWordEditorShown ? _WordEditor(
            bloc: _bloc,
            appTheme: appTheme,
            text: state.editingWord,
          ) : const SizedBox.shrink(),
          state.isScrimVisible ? Scrim(
            onTap: _bloc.handleBackPress,
          ) : const SizedBox.shrink(),
          state.isListeningToSpeech ? _ListeningToSpeechView(
            bloc: _bloc,
            appTheme: appTheme,
          ) : const SizedBox.shrink(),
          state.ideaPopUpData.isValid() ? _IdeaPopUpBox(
            bloc: _bloc,
            data: state.ideaPopUpData,
            appTheme: appTheme,
          ) : const SizedBox.shrink(),
          state.isProgressShown ? CenterProgress(
            appTheme: appTheme,
          ) : const SizedBox.shrink(),
          _isIdeaBoxFullNotiVisible ? _IdeaBoxFullNoti(
            onTap: () {
              setState(() {
                _isIdeaBoxFullNotiVisible = false;
              });

              _bloc.onIdeaBoxFullNotiClicked();
            }
          ) : const SizedBox.shrink(),
          _ideaAddedAnimation.isAnimating && logoPosition.isValid && historyButtonPosition.isValid ? PositionedTransition(
            rect: RelativeRectTween(
              begin: logoPosition.createCenterRelativeRect(context, 36, 36),
              end: historyButtonPosition.createCenterRelativeRect(context, 36, 36),
            ).animate(CurvedAnimation(parent: _ideaAddedAnimation, curve: Curves.fastOutSlowIn)),
            child: FadeTransition(
              opacity: Tween<double>(begin: 1, end: 0).animate(_ideaAddedAnimation),
              child: ScaleTransition(
                scale: Tween<double>(begin: 1, end: 0).animate(_ideaAddedAnimation),
                child: Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: appTheme.pointColor,
                  ),
                ),
              ),
            ),
          ) : const SizedBox.shrink(),
        ],
      ),
    );
  }

  // todo: should make this cancelable.. don't know how yet
  void _hideIdeaBoxFullNotiAfterDelay() async {
    await Future.delayed(const Duration(seconds: 5));
    if (mounted) {
      setState(() {
        _isIdeaBoxFullNotiVisible = false;
      });
    }
  }

  Future<void> _runLogoInAnimation(int delayMillis) async {
    await Future<void>.delayed(Duration(milliseconds: delayMillis));
    _logoInAnimation.reset();
    _logoInAnimation.forward();
  }

  @override
  void showEditingWordEmptyMessage() {
    Utils.showToast(AppLocalizations.of(context).editingWordEmpty);
  }

  @override
  void showEditingWordAlreadyExists() {
    Utils.showToast(AppLocalizations.of(context).editingWordAlreadyExists);
  }

  @override
  void showWordBoxFull() {
    Utils.showToast(AppLocalizations.of(context).wordBoxFull);
  }

  @override
  void showSpeechToTextNotReady() {
    Utils.showToast(AppLocalizations.of(context).speechToTextNotReady);
  }

  @override
  void showAddMoreWordsForIdea() {
    Utils.showToast(AppLocalizations.of(context).addMoreWordsForIdea);
  }

  @override
  void showIdeaBoxFull() {
    Utils.showToast(AppLocalizations.of(context).ideaBoxFullToast);
  }

  @override
  void showWordAddedAnimation() {
    setState(() { });
    _wordAddedAnimation.reset();
    _wordAddedAnimation.forward();
  }

  @override
  void showIdeaAddedAnimation() {
    setState(() { });
    _ideaAddedAnimation.reset();
    _ideaAddedAnimation.forward();
  }

}

class ViewLayoutInfo {
  static ViewLayoutInfo create(RenderBox renderBox, {
    Offset offset = Offset.zero,
  }) {
    if (renderBox == null) {
      return ViewLayoutInfo(left: -1, top: -1, right: -1, bottom: -1);
    } else {
      final position = renderBox.localToGlobal(offset);
      final size = renderBox.size;
      return ViewLayoutInfo(
        left: position.dx, top: position.dy,
        right: position.dx + size.width, bottom: position.dy + size.height);
    }
  }

  final double left;
  final double top;
  final double right;
  final double bottom;

  const ViewLayoutInfo({
    @required this.left,
    @required this.top,
    @required this.right,
    @required this.bottom,
  });

  bool get isValid => left != -1 && top != -1 && right != -1 && bottom != -1;
  double get centerX => (left + right) / 2;
  double get centerY => (top + bottom) / 2;

  RelativeRect createCenterRelativeRect(BuildContext context, int width, int height) {
    final Size screenSize = MediaQuery.of(context).size;
    return RelativeRect.fromLTRB(
      centerX - width / 2,
      centerY - height / 2,
      screenSize.width - centerX - width / 2,
      screenSize.height - centerY - height / 2,
    );
  }

  @override
  String toString() {
    return 'ViewLayoutInfo(left: $left, top: $top, right: $right, bottom: $bottom)';
  }
}

class _MainUI extends StatelessWidget {
  final AppTheme appTheme;
  final HomeBloc bloc;
  final bool isWordEditorShown;
  final Key penButtonKey;
  final Key logoKey;
  final Key historyButtonKey;
  final Animation<double> logoInAnimation;
  final Animation<double> logoIdleAnimation;
  final Animation<double> wordAddedAnimation;
  final Animation<double> ideaAddedAnimation;

  _MainUI({
    @required this.appTheme,
    @required this.bloc,
    @required this.isWordEditorShown,
    @required this.penButtonKey,
    @required this.logoKey,
    @required this.historyButtonKey,
    @required this.logoInAnimation,
    @required Animation<double> logoIdleAnimation,
    @required Animation<double> wordAddedAnimation,
    @required Animation<double> ideaAddedAnimation,
  }) : this.logoIdleAnimation = Tween<double>(
    begin: 0,
    end: pi,
  ).animate(CurvedAnimation(parent: logoIdleAnimation, curve: Curves.easeInOutQuad)),
      this.wordAddedAnimation = Tween<double>(
        begin: 0,
        end: pi * 2,
      ).animate(CurvedAnimation(parent: wordAddedAnimation, curve: Curves.fastOutSlowIn)),
      this.ideaAddedAnimation = Tween<double>(
        begin: 0,
        end: pi,
      ).animate(CurvedAnimation(parent: ideaAddedAnimation, curve: Interval(0, 0.4, curve: Curves.fastOutSlowIn)));

  @override
  Widget build(BuildContext context) {
    return Column(
      verticalDirection: VerticalDirection.up,
      children: <Widget>[
        ChildScreenNavigationBar(
          currentChildScreenKey: ChildScreenKey.HOME,
          onItemClicked: bloc.onNavigationBarItemClicked,
          isVisible: !isWordEditorShown,
          historyButtonKey: historyButtonKey,
        ),
        Expanded(
          child: SafeArea(
            bottom: false,
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(
                    AppLocalizations.of(context).get(appTheme.titleKey),
                    style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: appTheme.darkColor,
                    ),
                    strutStyle: StrutStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    AppLocalizations.of(context).get(appTheme.subtitleKey),
                    style: TextStyle(
                      fontSize: 18,
                      color: appTheme.darkColor,
                    ),
                    strutStyle: StrutStyle(
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 32,),
                  GestureDetector(
                    onTap: () => bloc.onLogoClicked(),
                    behavior: HitTestBehavior.opaque,
                    child: SlideTransition(
                      position: Tween<Offset>(begin: Offset(0, 0.5), end: Offset(0, 0))
                        .animate(CurvedAnimation(parent: logoInAnimation, curve: Curves.easeOutQuint)),
                      child: FadeTransition(
                        opacity: Tween<double>(begin: 0, end: 1)
                          .animate(CurvedAnimation(parent: logoInAnimation, curve: Curves.easeOutQuint)),
                        child: AnimatedBuilder(
                          animation: logoIdleAnimation,
                          child: AnimatedBuilder(
                            animation: wordAddedAnimation,
                            child: AnimatedBuilder(
                              animation: ideaAddedAnimation,
                              child: SizedBox(
                                key: logoKey,
                                width: 160,
                                height: 160,
                                child: Image.asset(appTheme.mainLogo),
                              ),
                              builder: (context, child) {
                                return Transform.scale(
                                  scale: 1 + 0.2 * sin(ideaAddedAnimation.value),
                                  child: child,
                                );
                              },
                            ),
                            builder: (context, child) {
                              return Transform.scale(
                                scale: 1 + 0.08 * sin(wordAddedAnimation.value),
                                child: child,
                              );
                            },
                          ),
                          builder: (context, child) {
                            return FractionalTranslation(
                              translation: Offset(0, 0.05 * -sin(logoIdleAnimation.value)),
                              child: child,
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 68,),
                  FloatingActionButton(
                    key: penButtonKey,
                    child: Image.asset('assets/ic_pen.png'),
                    backgroundColor: appTheme.darkColor,
                    onPressed: () => bloc.onAddWordClicked(),
                  )
                ],
              ),
            ),
          ),
        ),
      ],
    );
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
            boxShadow: kElevationToShadow[4],
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
            _SpeechAnimatingView(appTheme.darkColor),
          ],
        ),
      ),
    );
  }
}

class _SpeechAnimatingView extends StatefulWidget {
  final Color color;

  _SpeechAnimatingView(this.color);

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
    @required Animation<double> animation,
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

class _IdeaPopUpBox extends StatelessWidget {
  final HomeBloc bloc;
  final IdeaPopUpData data;
  final AppTheme appTheme;

  _IdeaPopUpBox({
    @required this.bloc,
    @required this.data,
    @required this.appTheme,
  });

  @override
  Widget build(BuildContext context) {
    final type = data.type;
    final title = data.title;

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
              child: type == IdeaPopUpData.TYPE_NEW ? _HappyLogo()
                : type == IdeaPopUpData.TYPE_EXISTS ? _SadLogo()
                : _BlockedLogo(),
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
                      type == IdeaPopUpData.TYPE_NEW ? AppLocalizations.of(context).newIdea
                        : type == IdeaPopUpData.TYPE_EXISTS ? AppLocalizations.of(context).goodOldOne
                        : AppLocalizations.of(context).pickedBlockedIdea,
                      style: TextStyle(
                        color: AppColors.TEXT_BLACK,
                        fontSize: 14,
                      ),
                      strutStyle: StrutStyle(
                        fontSize: 14,
                      ),
                    ),
                    type != IdeaPopUpData.TYPE_BLOCKED ? Padding(
                      padding: const EdgeInsets.only(top: 16),
                      child: Text(
                        title,
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
                    ) : const SizedBox.shrink(),
                    const SizedBox(height: 16,),
                    Center(
                      child: SizedBox(
                        width: 152,
                        child: Material(
                          color: appTheme.darkColor,
                          borderRadius: BorderRadius.circular(24),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(24),
                            onTap: () => bloc.onCloseIdeaPopUpClicked(),
                            child: Container(
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

class _BlockedLogo extends StatelessWidget {

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
  final Function() onTap;

  _IdeaBoxFullNoti({
    @required this.onTap,
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
            onTap: onTap,
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
