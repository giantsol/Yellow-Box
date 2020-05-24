
import 'package:yellow_box/entity/AppTheme.dart';

class SettingsState {

  final AppTheme appTheme;
  final bool autoGenerateIdeas;
  final bool isResetBlockedIdeasDialogShown;
  final int intervalHours;
  final bool isIntervalDialogShown;

  const SettingsState({
    this.appTheme = AppTheme.DEFAULT,
    this.autoGenerateIdeas = false,
    this.isResetBlockedIdeasDialogShown = false,
    this.intervalHours = 0,
    this.isIntervalDialogShown = false,
  });

  bool get isScrimVisible => isResetBlockedIdeasDialogShown || isIntervalDialogShown;

  SettingsState buildNew({
    AppTheme appTheme,
    bool autoGenerateIdeas,
    bool isResetBlockedIdeasDialogShown,
    int intervalHours,
    bool isIntervalDialogShown,
  }) {
    return SettingsState(
      appTheme: appTheme ?? this.appTheme,
      autoGenerateIdeas: autoGenerateIdeas ?? this.autoGenerateIdeas,
      isResetBlockedIdeasDialogShown: isResetBlockedIdeasDialogShown ?? this.isResetBlockedIdeasDialogShown,
      intervalHours: intervalHours ?? this.intervalHours,
      isIntervalDialogShown: isIntervalDialogShown ?? this.isIntervalDialogShown,
    );
  }
}