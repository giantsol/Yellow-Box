
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Utils {
  static void showToast(String msg, {
    Toast toastLength = Toast.LENGTH_SHORT,
  }) {
    Fluttertoast.cancel();

    final iosLength = toastLength == Toast.LENGTH_SHORT ? 1 : 2;
    Fluttertoast.showToast(msg: msg, toastLength: toastLength, timeInSecForIos: iosLength);
  }

  static Rect getRect(RenderBox renderBox, {Offset offset = Offset.zero}) {
    if (renderBox == null) {
      return Rect.zero;
    }

    final position = renderBox.localToGlobal(offset);
    final size = renderBox.size;
    return Rect.fromLTRB(position.dx, position.dy, position.dx + size.width, position.dy + size.height);
  }

  static RelativeRect getCenteredRelativeRect(BuildContext context, Rect rect, int width, int height) {
    final Size screenSize = MediaQuery.of(context).size;
    final Offset center = rect.center;
    return RelativeRect.fromLTRB(
      center.dx - width / 2,
      center.dy - height / 2,
      screenSize.width - center.dx - width / 2,
      screenSize.height - center.dy - height / 2,
    );
  }
}