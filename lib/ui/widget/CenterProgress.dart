
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:yellow_box/entity/AppTheme.dart';

class CenterProgress extends StatelessWidget {
  final AppTheme appTheme;

  CenterProgress({
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
