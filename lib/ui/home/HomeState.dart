
import 'package:yellow_box/entity/AppTheme.dart';

class HomeState {

  final AppTheme appTheme;

  const HomeState({
    this.appTheme = AppTheme.DEFAULT,
  });

  HomeState buildNew({
    AppTheme appTheme,
  }) {
    return HomeState(
      appTheme: appTheme ?? this.appTheme,
    );
  }

}