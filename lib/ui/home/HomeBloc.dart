import 'package:flutter/foundation.dart';
import 'package:rxdart/rxdart.dart';
import 'package:rxdart/subjects.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:yellow_box/entity/NavigationBarItem.dart';
import 'package:yellow_box/ui/App.dart';
import 'package:yellow_box/ui/BaseBloc.dart';
import 'package:yellow_box/ui/home/HomeNavigator.dart';
import 'package:yellow_box/ui/home/HomeState.dart';

class HomeBloc extends BaseBloc {

  final HomeNavigator _navigator;

  final _state = BehaviorSubject<HomeState>.seeded(HomeState());
  HomeState getInitialState() => _state.value;
  Stream<HomeState> observeState() => _state.distinct();

  final _themeRepository = dependencies.themeRepository;
  final _childScreenRepository = dependencies.childScreenRepository;
  final _wordRepository = dependencies.wordRepository;

  CompositeSubscription _subscriptions = CompositeSubscription();

  HomeBloc(this._navigator) {
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

  void onWordEditingAddClicked() async {
    if (_isProgressShown()) {
      return;
    }

    final word = _state.value.editingWord;
    if (word.isEmpty) {
      _navigator.showEditingWordEmptyMessage();
      return;
    }

    _showProgress();
    final isThisWordAlreadySaved = await _wordRepository.hasWord(word);
    if (isThisWordAlreadySaved) {
      _navigator.showEditingWordAlreadyExists();
      _hideProgress();
      return;
    }

    await _wordRepository.addWord(word);

    _state.value = _state.value.buildNew(
      isWordEditorShown: false,
      editingWord: '',
      isProgressShown: false,
    );
  }

  void onMicIconClicked() async {
    final stt = SpeechToText();
    final available = await stt.initialize(onStatus: (status) {
      debugPrint('stt status: $status');
    }, onError: (errorNotification) {
      debugPrint('stt error: ${errorNotification.errorMsg}');
    });

    if (available) {
      stt.listen(onResult: (result) {
        debugPrint('stt recognizedWords: ${result.recognizedWords}');
      });
    } else {
      debugPrint('stt not available');
    }
  }

  bool handleBackPress() {
    if (_state.value.isWordEditorShown) {
      onWordEditingCancelClicked();
      return true;
    }

    return false;
  }

  bool _isProgressShown() {
    return _state.value.isProgressShown;
  }

  void _showProgress() {
    _state.value = _state.value.buildNew(
      isProgressShown: true,
    );
  }

  void _hideProgress() {
    _state.value = _state.value.buildNew(
      isProgressShown: false,
    );
  }

  @override
  void dispose() {
    _subscriptions.dispose();
  }

}
