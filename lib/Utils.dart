
import 'package:fluttertoast/fluttertoast.dart';

class Utils {
  static void showToast(String msg, {
    Toast toastLength = Toast.LENGTH_SHORT,
  }) {
    Fluttertoast.cancel();

    final iosLength = toastLength == Toast.LENGTH_SHORT ? 1 : 2;
    Fluttertoast.showToast(msg: msg, toastLength: toastLength, timeInSecForIos: iosLength);
  }
}