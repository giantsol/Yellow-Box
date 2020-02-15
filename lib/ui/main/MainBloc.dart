
import 'dart:async';

import 'package:rxdart/rxdart.dart';
import 'package:rxdart/subjects.dart';
import 'package:yellow_box/ui/App.dart';
import 'package:yellow_box/ui/BaseBloc.dart';
import 'package:yellow_box/ui/main/MainState.dart';

class MainBloc extends BaseBloc {

  final _state = BehaviorSubject<MainState>.seeded(MainState());
  MainState getInitialState() => _state.value;
  Stream<MainState> observeState() => _state.distinct();

  final _childScreenRepository = dependencies.childScreenRepository;
  final _themeRepository = dependencies.themeRepository;

  CompositeSubscription _subscriptions = CompositeSubscription();

  MainBloc() {
    _subscriptions.add(_childScreenRepository.observeCurrentChildScreenKey()
      .listen((key) {
      _state.value = _state.value.buildNew(
        currentChildScreenKey: key,
      );
    }));

    _subscriptions.add(_themeRepository.observeCurrentAppTheme()
      .listen((appTheme) {
      _state.value = _state.value.buildNew(
        appTheme: appTheme,
      );
    }));
  }

  @override
  void dispose() {
    _subscriptions.dispose();
  }

}