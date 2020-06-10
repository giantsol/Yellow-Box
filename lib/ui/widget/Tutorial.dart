
import 'package:flutter/widgets.dart';
import 'package:yellow_box/ui/home/HomeScreen.dart';

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

  ViewLayoutInfoFinder _penButtonFinder;

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        widget.child,
        Visibility(
          visible: _currentPhase == 0,
          child: _TutorialOne(_penButtonFinder),
        ),
      ],
    );
  }

  void showTutorialOne(ViewLayoutInfoFinder penButtonFinder) {
    if (_currentPhase == 0) {
      return;
    }

    setState(() {
      _currentPhase = 0;
      _penButtonFinder = penButtonFinder;
    });
  }
}

typedef ViewLayoutInfoFinder = ViewLayoutInfo Function();

class _TutorialOne extends StatelessWidget {
  final ViewLayoutInfoFinder _penButtonFinder;

  _TutorialOne(this._penButtonFinder);

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size.infinite,
      painter: _TutorialOnePainter(_penButtonFinder),
    );
  }
}

class _TutorialOnePainter extends CustomPainter {
  final ViewLayoutInfoFinder _penButtonFinder;

  final Path _path = Path();
  final Paint _paint = Paint()
    ..color = Color.fromRGBO(0, 0, 0, 0.5);

  Rect _circle;

  _TutorialOnePainter(this._penButtonFinder);

  @override
  void paint(Canvas canvas, Size size) {
    final penLayoutInfo = _penButtonFinder();
    _circle = Rect.fromCircle(
      center: Offset(penLayoutInfo.centerX, penLayoutInfo.centerY),
      radius: size.width * 0.45);
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
