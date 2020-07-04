
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:yellow_box/AppColors.dart';
import 'package:yellow_box/Localization.dart';

class Tutorial extends StatefulWidget {
  final Widget child;

  Tutorial({
    @required this.child,
  });

  @override
  State createState() => TutorialState();

  static TutorialState of(BuildContext context) {
    return context.findAncestorStateOfType<TutorialState>();
  }
}

class TutorialState extends State<Tutorial> {
  int _currentPhase = -1;

  void Function() _onSkipTutorial;
  void Function() _onStartTutorial;
  void Function() _onTutorialFourFinished;
  void Function() _onTutorialFiveFinished;

  RectFinder _penRectFinder;
  RectFinder _logoRectFinder;
  RectFinder _historyButtonRectFinder;
  RectFinder _wordListRectFinder;

  @override
  Widget build(BuildContext context) {
    final penRect = _penRectFinder?.call() ?? Rect.zero;
    final logoRect = _logoRectFinder?.call() ?? Rect.zero;
    final historyButtonRect = _historyButtonRectFinder?.call() ?? Rect.zero;
    final wordListRect = _wordListRectFinder?.call() ?? Rect.zero;

    return Stack(
      fit: StackFit.expand,
      children: [
        widget.child,
        Visibility(
          visible: _currentPhase == 0,
          child: _TutorialZero(_onSkipTutorial, _onStartTutorial),
        ),
        Visibility(
          visible: _currentPhase == 1 && !penRect.isEmpty,
          child: _TutorialOne(penRect),
        ),
        Visibility(
          visible: _currentPhase == 2 && !logoRect.isEmpty,
          child: _TutorialTwo(logoRect),
        ),
        Visibility(
          visible: _currentPhase == 3 && !historyButtonRect.isEmpty,
          child: _TutorialThree(historyButtonRect),
        ),
        Visibility(
          visible: _currentPhase == 4 && !wordListRect.isEmpty,
          child: _TutorialFour(wordListRect, _onTutorialFourFinished),
        ),
        Visibility(
          visible: _currentPhase == 5,
          child: _TutorialFive(_onTutorialFiveFinished),
        ),
      ],
    );
  }

  void hide() {
    setState(() {
      _currentPhase = -1;
    });
  }

  void showTutorialZero(void Function() onSkipTutorial, void Function() onTutorialZeroFinished) {
    if (_currentPhase == 0) {
      return;
    }

    setState(() {
      _currentPhase = 0;
      _onSkipTutorial = onSkipTutorial;
      _onStartTutorial = onTutorialZeroFinished;
    });
  }

  void showTutorialOne(RectFinder penRectFinder) {
    if (_currentPhase == 1) {
      return;
    }

    setState(() {
      _currentPhase = 1;
      _penRectFinder = penRectFinder;
    });
  }

  void showTutorialTwo(RectFinder logoRectFinder) {
    if (_currentPhase == 2) {
      return;
    }

    setState(() {
      _currentPhase = 2;
      _logoRectFinder = logoRectFinder;
    });
  }

  void showTutorialThree(RectFinder historyButtonRectFinder) {
    if (_currentPhase == 3) {
      return;
    }

    setState(() {
      _currentPhase = 3;
      _historyButtonRectFinder = historyButtonRectFinder;
    });
  }

  void showTutorialFour(RectFinder wordListRectFinder, void Function() onTutorialFourFinished) {
    if (_currentPhase == 4) {
      return;
    }

    setState(() {
      _currentPhase = 4;
      _wordListRectFinder = wordListRectFinder;
      _onTutorialFourFinished = onTutorialFourFinished;
    });
  }

  void showTutorialFive(void Function() onTutorialFiveFinished) {
    if (_currentPhase == 5) {
      return;
    }

    setState(() {
      _currentPhase = 5;
      _onTutorialFiveFinished = onTutorialFiveFinished;
    });
  }
}

typedef RectFinder = Rect Function();

class _TutorialZero extends StatefulWidget {
  final void Function() skipCallback;
  final void Function() startCallback;

  _TutorialZero(this.skipCallback, this.startCallback);

  @override
  State createState() => _TutorialZeroState();
}

class _TutorialZeroState extends State<_TutorialZero> with SingleTickerProviderStateMixin {
  AnimationController _inAnimation;

  @override
  void initState() {
    super.initState();
    _inAnimation = AnimationController(
      duration: const Duration(milliseconds: 3000),
      vsync: this,
    );
    _inAnimation.forward();
  }

  @override
  void dispose() {
    _inAnimation.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(
        parent: _inAnimation,
        curve: Interval(0, 0.33, curve: Curves.easeInQuint),
      )),
      child: Container(
        color: AppColors.SCRIM,
        child: Stack(
          fit: StackFit.expand,
          children: [
            Center(
              child: Text(
                AppLocalizations.of(context).tutorialZeroTitle,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.TEXT_WHITE,
                  fontSize: 16,
                ),
                strutStyle: StrutStyle(
                  fontSize: 16,
                ),
              ),
            ),
            FadeTransition(
              opacity: Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(
                parent: _inAnimation,
                curve: Interval(0.66, 1.0),
              )),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Material(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 16, top: 16, right: 16, bottom: 76),
                    child: Row(
                      children: [
                        InkWell(
                          splashColor: AppColors.SELECTION_WHITE,
                          onTap: widget.skipCallback,
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            child: Text(
                              AppLocalizations.of(context).skip,
                              style: TextStyle(
                                fontSize: 12,
                                color: AppColors.TEXT_WHITE,
                              ),
                              strutStyle: StrutStyle(
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ),
                        const Spacer(),
                        InkWell(
                          splashColor: AppColors.SELECTION_WHITE,
                          onTap: widget.startCallback,
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            child: Text(
                              AppLocalizations.of(context).start,
                              style: TextStyle(
                                fontSize: 20,
                                color: AppColors.TEXT_WHITE,
                              ),
                              strutStyle: StrutStyle(
                                fontSize: 20,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TutorialOne extends StatefulWidget {
  final Rect penRect;

  _TutorialOne(this.penRect);

  @override
  State createState() => _TutorialOneState();
}

class _TutorialOneState extends State<_TutorialOne> with SingleTickerProviderStateMixin {
  AnimationController _inAnimation;

  @override
  void initState() {
    super.initState();
    _inAnimation = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _inAnimation.forward();
  }

  @override
  void dispose() {
    _inAnimation.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final penRect = widget.penRect;

    return FadeTransition(
      opacity: Tween<double>(begin: 0, end: 1).animate(_inAnimation),
      child: Stack(
        fit: StackFit.expand,
        children: [
          CustomPaint(
            size: Size.infinite,
            painter: _HighlightPainter(penRect),
          ),
          Positioned(
            left: 0,
            right: 0,
            top: penRect.top - (penRect.longestSide / 4) - 48,
            child: Text(
              AppLocalizations.of(context).tutorialOneTitle,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: AppColors.TEXT_WHITE,
              ),
              strutStyle: StrutStyle(
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

enum _HighlightGravity {
  TOP,
  CENTER,
  BOTTOM
}

class _HighlightPainter extends CustomPainter {
  final Rect _targetRect;
  final bool useLongestSide;
  final double highlightSize;
  final _HighlightGravity gravity;
  final bool absorbPointer;

  final Path _path = Path();
  final Paint _paint = Paint()
    ..color = AppColors.SCRIM;

  Rect _circle;

  _HighlightPainter(this._targetRect, {
    this.useLongestSide = true,
    this.highlightSize = 1.5,
    this.gravity = _HighlightGravity.CENTER,
    this.absorbPointer = false,
  });

  @override
  void paint(Canvas canvas, Size size) {
    _circle = Rect.fromCircle(
      center: gravity == _HighlightGravity.TOP ? _targetRect.topCenter
        : gravity == _HighlightGravity.BOTTOM ? _targetRect.bottomCenter
        : _targetRect.center,
      radius: (useLongestSide ? _targetRect.longestSide : _targetRect.shortestSide) / 2 * highlightSize);
    _path
      ..reset()
      ..addOval(_circle)
      ..addRect(Rect.fromLTWH(0.0, 0.0, size.width, size.height))
      ..fillType = PathFillType.evenOdd;
    canvas.drawPath(_path, _paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;

  @override
  bool hitTest(Offset position) {
    return absorbPointer || !_circle.contains(position);
  }

}

class _TutorialTwo extends StatefulWidget {
  final Rect logoRect;

  _TutorialTwo(this.logoRect);

  @override
  State createState() => _TutorialTwoState();
}

class _TutorialTwoState extends State<_TutorialTwo> with SingleTickerProviderStateMixin {
  AnimationController _inAnimation;

  @override
  void initState() {
    super.initState();
    _inAnimation = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _inAnimation.forward();
  }

  @override
  void dispose() {
    _inAnimation.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final logoRect = widget.logoRect;

    return FadeTransition(
      opacity: Tween<double>(begin: 0, end: 1).animate(_inAnimation),
      child: Stack(
        fit: StackFit.expand,
        children: [
          CustomPaint(
            size: Size.infinite,
            painter: _HighlightPainter(logoRect),
          ),
          Positioned(
            left: 0,
            right: 0,
            top: logoRect.bottom + (logoRect.longestSide / 4) + 28,
            child: Text(
              AppLocalizations.of(context).tutorialTwoTitle,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: AppColors.TEXT_WHITE,
              ),
              strutStyle: StrutStyle(
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TutorialThree extends StatefulWidget {
  final Rect historyButtonRect;

  _TutorialThree(this.historyButtonRect);

  @override
  State createState() => _TutorialThreeState();
}

class _TutorialThreeState extends State<_TutorialThree> with SingleTickerProviderStateMixin {
  AnimationController _inAnimation;

  @override
  void initState() {
    super.initState();
    _inAnimation = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _inAnimation.forward();
  }

  @override
  void dispose() {
    _inAnimation.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final historyButtonRect = widget.historyButtonRect;

    return FadeTransition(
      opacity: Tween<double>(begin: 0, end: 1).animate(_inAnimation),
      child: Stack(
        fit: StackFit.expand,
        children: [
          CustomPaint(
            size: Size.infinite,
            painter: _HighlightPainter(historyButtonRect, useLongestSide: false),
          ),
          Positioned(
            left: 0,
            right: 0,
            top: historyButtonRect.top - (historyButtonRect.longestSide / 2) - 48,
            child: Text(
              AppLocalizations.of(context).tutorialThreeTitle,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: AppColors.TEXT_WHITE,
              ),
              strutStyle: StrutStyle(
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TutorialFour extends StatefulWidget {
  final Rect wordListRect;
  final void Function() callback;

  _TutorialFour(this.wordListRect, this.callback);

  @override
  State createState() => _TutorialFourState();
}

class _TutorialFourState extends State<_TutorialFour> with SingleTickerProviderStateMixin {
  AnimationController _inAnimation;

  @override
  void initState() {
    super.initState();
    _inAnimation = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _inAnimation.forward();
  }

  @override
  void dispose() {
    _inAnimation.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final wordListRect = widget.wordListRect;

    return FadeTransition(
      opacity: Tween<double>(begin: 0, end: 1).animate(_inAnimation),
      child: Stack(
        fit: StackFit.expand,
        children: [
          CustomPaint(
            size: Size.infinite,
            painter: _HighlightPainter(
              wordListRect,
              useLongestSide: false,
              highlightSize: 1.0,
              gravity: _HighlightGravity.TOP,
              absorbPointer: true,
            ),
          ),
          Center(
            child: Text(
              AppLocalizations.of(context).tutorialFourTitle,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: AppColors.TEXT_WHITE,
              ),
              strutStyle: StrutStyle(
                fontSize: 16,
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Material(
              child: Padding(
                padding: const EdgeInsets.only(left: 16, top: 16, right: 16, bottom: 76),
                child: InkWell(
                  splashColor: AppColors.SELECTION_WHITE,
                  onTap: widget.callback,
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      AppLocalizations.of(context).next,
                      style: TextStyle(
                        fontSize: 20,
                        color: AppColors.TEXT_WHITE,
                      ),
                      strutStyle: StrutStyle(
                        fontSize: 20,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TutorialFive extends StatefulWidget {
  final void Function() callback;

  _TutorialFive(this.callback);

  @override
  State createState() => _TutorialFiveState();
}

class _TutorialFiveState extends State<_TutorialFive> with SingleTickerProviderStateMixin {
  AnimationController _inAnimation;

  @override
  void initState() {
    super.initState();
    _inAnimation = AnimationController(
      duration: const Duration(milliseconds: 3000),
      vsync: this,
    );
    _inAnimation.forward();
  }

  @override
  void dispose() {
    _inAnimation.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(
        parent: _inAnimation,
        curve: Interval(0, 0.33),
      )),
      child: Stack(
        fit: StackFit.expand,
        children: [
          CustomPaint(
            size: Size.infinite,
            painter: _HighlightPainter(
              Rect.zero,
            ),
          ),
          Center(
            child: Text(
              AppLocalizations.of(context).tutorialFiveTitle,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: AppColors.TEXT_WHITE,
              ),
              strutStyle: StrutStyle(
                fontSize: 16,
              ),
            ),
          ),
          FadeTransition(
            opacity: Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(
              parent: _inAnimation,
              curve: Interval(0.66, 1.0),
            )),
            child: Align(
              alignment: Alignment.bottomRight,
              child: Material(
                child: Padding(
                  padding: const EdgeInsets.only(left: 16, top: 16, right: 16, bottom: 76),
                  child: InkWell(
                    splashColor: AppColors.SELECTION_WHITE,
                    onTap: widget.callback,
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      child: Text(
                        AppLocalizations.of(context).done,
                        style: TextStyle(
                          fontSize: 20,
                          color: AppColors.TEXT_WHITE,
                        ),
                        strutStyle: StrutStyle(
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
