
import 'package:rxdart/rxdart.dart';
import 'package:rxdart/subjects.dart';
import 'package:yellow_box/AppMethodChannel.dart';
import 'package:yellow_box/entity/NavigationBarItem.dart';
import 'package:yellow_box/ui/App.dart';
import 'package:yellow_box/ui/BaseBloc.dart';
import 'package:yellow_box/ui/settings/SettingsNavigator.dart';
import 'package:yellow_box/ui/settings/SettingsState.dart';

class SettingsBloc extends BaseBloc {

  final SettingsNavigator _navigator;

  final _state = BehaviorSubject<SettingsState>.seeded(SettingsState());
  SettingsState getInitialState() => _state.value;
  Stream<SettingsState> observeState() => _state.distinct();

  final _themeRepository = dependencies.themeRepository;
  final _childScreenRepository = dependencies.childScreenRepository;
  final _settingsRepository = dependencies.settingsRepository;

  CompositeSubscription _subscriptions = CompositeSubscription();

  final appMethodChannel = dependencies.appMethodChannel;

  SettingsBloc(this._navigator) {
    _init();
  }

  void _init() async {
    final autoGenerateIdeas = await _settingsRepository.getAutoGenerateIdeas();
    final intervalHours = await _settingsRepository.getAutoGenerateIntervalHours();

    _state.value = _state.value.buildNew(
      autoGenerateIdeas: autoGenerateIdeas,
      intervalHours: intervalHours,
    );

    _subscriptions.add(_themeRepository.observeCurrentAppTheme()
      .listen((appTheme) {
      _state.value = _state.value.buildNew(
        appTheme: appTheme,
      );
    }));
  }

  void onNavigationBarItemClicked(NavigationBarItem item) {
    _childScreenRepository.setCurrentChildScreenKey(item.key);
  }

  Future<void> onMiniBoxItemClicked() async {
    bool success;
    try {
      final result = await appMethodChannel.showMiniBox();
      if (result == AppMethodChannel.SHOW_MINI_BOX_RESULT_OK) {
        success = true;
      } else {
        success = false;
      }
    } catch (e) {
      success = false;
    }

    if (!success) {
      _navigator.showMiniBoxLaunchFailedMessage();
    }
  }

  void onAutoGenerateIdeasChanged(bool value) {
    _state.value = _state.value.buildNew(
      autoGenerateIdeas: value,
    );

    _settingsRepository.setAutoGenerateIdeas(value);
  }

  void onResetBlockedIdeasClicked() {
    _state.value = _state.value.buildNew(
      isResetBlockedIdeasDialogShown: true,
    );
  }

  void onConfirmResetBlockedIdeasClicked() {
    // todo

    _state.value = _state.value.buildNew(
      isResetBlockedIdeasDialogShown: false,
    );
  }

  void onCancelResetBlockedIdeasClicked() {
    _state.value = _state.value.buildNew(
      isResetBlockedIdeasDialogShown: false,
    );
  }

  void onIntervalClicked() {
    _state.value = _state.value.buildNew(
      isIntervalDialogShown: true,
    );
  }

  void onIntervalChoiceClicked(int value) {
    _state.value = _state.value.buildNew(
      intervalHours: value,
      isIntervalDialogShown: false,
    );

    _settingsRepository.setAutoGenerateIntervalHours(value);
  }

  void onCloseIntervalDialogClicked() {
    _state.value = _state.value.buildNew(
      isIntervalDialogShown: false,
    );
  }

  bool handleBackPress() {
    if (_state.value.isResetBlockedIdeasDialogShown) {
      onCancelResetBlockedIdeasClicked();
      return true;
    }

    if (_state.value.isIntervalDialogShown) {
      onCloseIntervalDialogClicked();
      return true;
    }

    return false;
  }

  @override
  void dispose() {
    _subscriptions.dispose();
  }
}