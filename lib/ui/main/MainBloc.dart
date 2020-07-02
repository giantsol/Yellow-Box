
import 'dart:async';

import 'package:rxdart/rxdart.dart';
import 'package:rxdart/subjects.dart';
import 'package:yellow_box/StreamSubscriptionExtension.dart';
import 'package:yellow_box/ui/BaseBloc.dart';
import 'package:yellow_box/ui/main/MainNavigator.dart';
import 'package:yellow_box/ui/main/MainState.dart';
import 'package:yellow_box/usecase/ObserveAppTheme.dart';
import 'package:yellow_box/usecase/ObserveChildScreen.dart';
import 'package:yellow_box/usecase/idea/AutoGenerateAndAddIdeas.dart';
import 'package:yellow_box/usecase/word/AddRemainingMiniBoxWords.dart';
import 'package:yellow_box/usecase/word/AddWords.dart';
import 'package:yellow_box/usecase/word/ClearDeliveredMiniBoxWords.dart';
import 'package:yellow_box/usecase/word/ObserveDeliveredMiniBoxWords.dart';

class MainBloc extends BaseBloc {

  final MainNavigator _navigator;

  final _state = BehaviorSubject<MainState>.seeded(MainState());
  MainState getInitialState() => _state.value;
  Stream<MainState> observeState() => _state.distinct();

  CompositeSubscription _subscriptions = CompositeSubscription();

  final _observeChildScreen = ObserveChildScreen();
  final _observeAppTheme = ObserveAppTheme();
  final _observeDeliveredMiniBoxWords = ObserveDeliveredMiniBoxWords();
  final _addWords = AddWords();
  final _clearDeliveredMiniBoxWords = ClearDeliveredMiniBoxWords();
  final _addRemainingMiniBoxWords = AddRemainingMiniBoxWords();
  final _autoGenerateAndAddIdeas = AutoGenerateAndAddIdeas();

  MainBloc(this._navigator) {
    _init();
  }

  void _init() async {
    _observeChildScreen.invoke()
      .listen((key) {
      _state.value = _state.value.buildNew(
        currentChildScreenKey: key,
      );
    }).addTo(_subscriptions);

    _observeAppTheme.invoke()
      .listen((appTheme) {
      _state.value = _state.value.buildNew(
        appTheme: appTheme,
      );
    }).addTo(_subscriptions);

    _observeDeliveredMiniBoxWords.invoke()
      .listen((words) async {
      if (words.isEmpty) {
        return;
      }

      final remainders = await _addWords.invoke(words);
      if (remainders.isNotEmpty) {
        _navigator.showRemainingMiniBoxWordsCount(remainders.length);
        _addRemainingMiniBoxWords.invoke(remainders);
      }

      _clearDeliveredMiniBoxWords.invoke();
    }).addTo(_subscriptions);

    _autoGenerateAndAddIdeas.invoke();
  }

  @override
  void dispose() {
    _subscriptions.dispose();
  }

}