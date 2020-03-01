
import 'package:yellow_box/entity/AppTheme.dart';

class SettingsState {

  final AppTheme appTheme;

  const SettingsState({
    this.appTheme = AppTheme.DEFAULT,
  });

  SettingsState buildNew({
    AppTheme appTheme,
  }) {
    return SettingsState(
      appTheme: appTheme ?? this.appTheme,
    );
  }
}