
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:rxdart/rxdart.dart';
import 'package:rxdart/subjects.dart';
import 'package:yellow_box/StreamSubscriptionExtension.dart';
import 'package:yellow_box/entity/ChildScreenKey.dart';
import 'package:yellow_box/ui/BaseBloc.dart';
import 'package:yellow_box/ui/settings/SettingsNavigator.dart';
import 'package:yellow_box/ui/settings/SettingsState.dart';
import 'package:yellow_box/usecase/ObserveAppTheme.dart';
import 'package:yellow_box/usecase/ObserveAutoGenerateIdeas.dart';
import 'package:yellow_box/usecase/ObserveAutoGenerateIntervalHours.dart';
import 'package:yellow_box/usecase/SetAutoGenerateIdeas.dart';
import 'package:yellow_box/usecase/SetAutoGenerateIntervalHours.dart';
import 'package:yellow_box/usecase/SetChildScreen.dart';
import 'package:yellow_box/usecase/ShowMiniBox.dart';

class SettingsBloc extends BaseBloc {

  final SettingsNavigator _navigator;

  final _state = BehaviorSubject<SettingsState>.seeded(SettingsState());
  SettingsState getInitialState() => _state.value;
  Stream<SettingsState> observeState() => _state.distinct();

  CompositeSubscription _subscriptions = CompositeSubscription();

  final _observeAutoGenerateIdeas = ObserveAutoGenerateIdeas();
  final _observeAutoGenerateIntervalHours = ObserveAutoGenerateIntervalHours();
  final _setAutoGenerateIdeas = SetAutoGenerateIdeas();
  final _setAutoGenerateIntervalHours = SetAutoGenerateIntervalHours();
  final _observeAppTheme = ObserveAppTheme();
  final _setChildScreen = SetChildScreen();
  final _showMiniBox = ShowMiniBox();

  SettingsBloc(this._navigator) {
    _init();
  }

  void _init() {
    _observeAutoGenerateIdeas.invoke()
      .listen((value) {
      _state.value = _state.value.buildNew(
        autoGenerateIdeas: value,
      );
    }).addTo(_subscriptions);

    _observeAutoGenerateIntervalHours.invoke()
      .listen((value) {
      _state.value = _state.value.buildNew(
        intervalHours: value,
      );
    }).addTo(_subscriptions);

    _observeAppTheme.invoke()
      .listen((appTheme) {
      _state.value = _state.value.buildNew(
        appTheme: appTheme,
      );
    }).addTo(_subscriptions);
  }

  void onNavigationBarItemClicked(ChildScreenKey key) {
    _setChildScreen.invoke(key);
  }

  Future<void> onMiniBoxItemClicked() async {
    final success = await _showMiniBox.invoke();
    if (success) {
      SystemNavigator.pop(animated: true);
    } else {
      _navigator.showMiniBoxLaunchFailedMessage();
    }
  }

  void onAutoGenerateIdeasChanged(bool value) {
    _setAutoGenerateIdeas.invoke(value);
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

  void onCloseResetBlockedIdeasClicked() {
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
      isIntervalDialogShown: false,
    );

    _setAutoGenerateIntervalHours.invoke(value);
  }

  void onCloseIntervalDialogClicked() {
    _state.value = _state.value.buildNew(
      isIntervalDialogShown: false,
    );
  }

  bool handleBackPress() {
    if (_state.value.isResetBlockedIdeasDialogShown) {
      onCloseResetBlockedIdeasClicked();
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