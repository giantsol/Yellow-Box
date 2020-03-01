
import 'package:rxdart/rxdart.dart';
import 'package:rxdart/subjects.dart';
import 'package:yellow_box/entity/NavigationBarItem.dart';
import 'package:yellow_box/ui/App.dart';
import 'package:yellow_box/ui/BaseBloc.dart';
import 'package:yellow_box/ui/settings/SettingsState.dart';

class SettingsBloc extends BaseBloc {
  final _state = BehaviorSubject<SettingsState>.seeded(SettingsState());
  SettingsState getInitialState() => _state.value;
  Stream<SettingsState> observeState() => _state.distinct();

  final _themeRepository = dependencies.themeRepository;
  final _childScreenRepository = dependencies.childScreenRepository;

  CompositeSubscription _subscriptions = CompositeSubscription();

  SettingsBloc() {
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

  void onMiniBoxItemClicked() {
    // todo
  }

  @override
  void dispose() {
    _subscriptions.dispose();
  }
}