
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
  int currentPhase = -1;

  void Function() _onTutorialZeroFinished;

  RectFinder _penRectFinder;
  RectFinder _logoRectFinder;
  RectFinder _historyButtonFinder;

  @override
  Widget build(BuildContext context) {
    final penRect = _penRectFinder?.call() ?? Rect.zero;
    final logoRect = _logoRectFinder?.call() ?? Rect.zero;
    final historyButtonRect = _historyButtonFinder?.call() ?? Rect.zero;

    return Stack(
      fit: StackFit.expand,
      children: [
        widget.child,
        Visibility(
          visible: currentPhase == 0,
          child: _TutorialZero(_onTutorialZeroFinished),
        ),
        Visibility(
          visible: currentPhase == 1 && !penRect.isEmpty,
          child: _TutorialOne(penRect),
        ),
        Visibility(
          visible: currentPhase == 2 && !logoRect.isEmpty,
          child: _TutorialTwo(logoRect),
        ),
        Visibility(
          visible: currentPhase == 3 && !historyButtonRect.isEmpty,
          child: _TutorialThree(historyButtonRect),
        ),
      ],
    );
  }

  void hide() {
    setState(() {
      currentPhase = -1;
    });
  }

  void showTutorialZero(void Function() onTutorialZeroFinished) {
    if (currentPhase == 0) {
      return;
    }

    setState(() {
      currentPhase = 0;
      _onTutorialZeroFinished = onTutorialZeroFinished;
    });
  }

  void showTutorialOne(RectFinder penRectFinder) {
    if (currentPhase == 1) {
      return;
    }

    setState(() {
      currentPhase = 1;
      _penRectFinder = penRectFinder;
    });
  }

  void showTutorialTwo(RectFinder logoRectFinder) {
    if (currentPhase == 2) {
      return;
    }

    setState(() {
      currentPhase = 2;
      _logoRectFinder = logoRectFinder;
    });
  }

  void showTutorialThree(RectFinder historyButtonFinder) {
    if (currentPhase == 3) {
      return;
    }

    setState(() {
      currentPhase = 3;
      _historyButtonFinder = historyButtonFinder;
    });
  }
}

typedef RectFinder = Rect Function();

class _TutorialZero extends StatefulWidget {
  final void Function() callback;

  _TutorialZero(this.callback);

  @override
  State createState() => _TutorialZeroState();
}

class _TutorialZeroState extends State<_TutorialZero> with SingleTickerProviderStateMixin {
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
    return FadeTransition(
      opacity: Tween<double>(begin: 0, end: 1).animate(_inAnimation),
      child: Container(
        color: AppColors.SCRIM,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                AppLocalizations.of(context).tutorialOneTitle,
              ),
              GestureDetector(
                onTap: widget.callback,
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.BACKGROUND_WHITE,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.all(8),
                  child: Text(
                    AppLocalizations.of(context).start,
                  ),
                ),
              ),
            ],
          ),
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
            top: penRect.bottom + 20,
            child: Text(
              'Hello World!',
            ),
          ),
        ],
      ),
    );
  }
}

class _HighlightPainter extends CustomPainter {
  final Rect _targetRect;
  final bool useLongestSide;
  final double highlightSize;

  final Path _path = Path();
  final Paint _paint = Paint()
    ..color = AppColors.SCRIM;

  Rect _circle;

  _HighlightPainter(this._targetRect, {
    this.useLongestSide = true,
    this.highlightSize = 1.5,
  });

  @override
  void paint(Canvas canvas, Size size) {
    _circle = Rect.fromCircle(
      center: _targetRect.center,
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
    return !_circle.contains(position);
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
            top: logoRect.bottom + 20,
            child: Text(
              'Hello World!',
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
            top: historyButtonRect.bottom + 20,
            child: Text(
              'Hello World!',
            ),
          ),
        ],
      ),
    );
  }
}

