import 'package:rxdart/rxdart.dart';
import 'package:rxdart/subjects.dart';
import 'package:yellow_box/entity/NavigationBarItem.dart';
import 'package:yellow_box/ui/App.dart';
import 'package:yellow_box/ui/BaseBloc.dart';
import 'package:yellow_box/ui/home/HomeState.dart';

class HomeBloc extends BaseBloc {

  final _state = BehaviorSubject<HomeState>.seeded(HomeState());
  HomeState getInitialState() => _state.value;
  Stream<HomeState> observeState() => _state.distinct();

  final _themeRepository = dependencies.themeRepository;
  final _childScreenRepository = dependencies.childScreenRepository;

  CompositeSubscription _subscriptions = CompositeSubscription();

  HomeBloc() {
    _subscriptions.add(_themeRepository.observeCurrentAppTheme()
      .listen((appTheme) {
      _state.value = _state.value.buildNew(
        appTheme: appTheme,
      );
    }));
  }

  void onAddWordClicked() {
    final isShown = _state.value.isWordEditorShown;
    if (!isShown) {
      _state.value = _state.value.buildNew(
        isWordEditorShown: true
      );
    }
  }

  void onNavigationBarItemClicked(NavigationBarItem item) {
    _childScreenRepository.setCurrentChildScreenKey(item.key);
  }

  void onEditingWordChanged(String s) {
    _state.value = _state.value.buildNew(
      editingWord: s
    );
  }

  void onWordEditingCancelClicked() {
    _state.value = _state.value.buildNew(
      isWordEditorShown: false,
      editingWord: '',
    );
  }

  void onWordEditingAddClicked() {
    _state.value = _state.value.buildNew(
      isWordEditorShown: false,
      editingWord: '',
    );

    // todo: Add adding logic
  }

  bool handleBackPress() {
    if (_state.value.isWordEditorShown) {
      onWordEditingCancelClicked();
      return true;
    }

    return false;
  }

  @override
  void dispose() {
    _subscriptions.dispose();
  }

}
