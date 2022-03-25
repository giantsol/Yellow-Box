
import 'package:flutter/widgets.dart';
import 'package:yellow_box/AppColors.dart';

class Scrim extends StatelessWidget {
  final Function() onTap;

  Scrim({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        color: AppColors.SCRIM,
      ),
    );
  }
}