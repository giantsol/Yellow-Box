
import 'package:yellow_box/entity/AppTheme.dart';

class SettingsState {

  final AppTheme appTheme;
  final bool autoGenerateIdeas;
  final bool isResetBlockedIdeasDialogShown;

  const SettingsState({
    this.appTheme = AppTheme.DEFAULT,
    this.autoGenerateIdeas = false,
    this.isResetBlockedIdeasDialogShown = false,
  });

  SettingsState buildNew({
    AppTheme appTheme,
    bool autoGenerateIdeas,
    bool isResetBlockedIdeasDialogShown,
  }) {
    return SettingsState(
      appTheme: appTheme ?? this.appTheme,
      autoGenerateIdeas: autoGenerateIdeas ?? this.autoGenerateIdeas,
      isResetBlockedIdeasDialogShown: isResetBlockedIdeasDialogShown ?? this.isResetBlockedIdeasDialogShown,
    );
  }
}