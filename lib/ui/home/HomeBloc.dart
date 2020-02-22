import 'package:flutter/foundation.dart';
import 'package:rxdart/rxdart.dart';
import 'package:rxdart/subjects.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:yellow_box/entity/CombinationPopUpData.dart';
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
  final _combinationRepository = dependencies.combinationRepository;

  CompositeSubscription _subscriptions = CompositeSubscription();

  final _stt = SpeechToText();

  HomeBloc(this._navigator) {
    _stt.initialize(onStatus: (status) {
      _state.value = _state.value.buildNew(
        isListeningToSpeech: status == SpeechToText.listeningStatus,
      );
    }, onError: (error) {
      _state.value = _state.value.buildNew(
        isListeningToSpeech: false,
      );
    });

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
    if (_stt.isAvailable && !_state.value.isListeningToSpeech) {
      _stt.listen(onResult: (result) {
        if (result.finalResult) {
          final recognizedWord = result.recognizedWords;
          if (recognizedWord.isNotEmpty) {
            _state.value = _state.value.buildNew(
              editingWord: _state.value.editingWord + recognizedWord,
            );
          }
        }
      });
    } else {
      _navigator.showSpeechToTextNotReady();
    }
  }

  void onStopSpeechRecognizerClicked() {
    _stt.cancel();
  }

  void onLogoClicked() async {
    if (_isProgressShown()) {
      return;
    }

    _showProgress();

    final savedWordCount = await _wordRepository.getCount();
    if (savedWordCount < 2) {
      _navigator.showAddMoreWordsForCombination();
      _hideProgress();
      return;
    }

    final combination = (await _wordRepository.getRandomWords(2)).join(" ");
    final isAlreadySavedCombination = await _combinationRepository.hasCombination(combination);
    if (isAlreadySavedCombination) {
      _state.value = _state.value.buildNew(
        combinationPopUpData: CombinationPopUpData(combination, false),
      );
    } else {
      _state.value = _state.value.buildNew(
        combinationPopUpData: CombinationPopUpData(combination, true),
      );
    }

    _hideProgress();
  }

  void onNahClicked() {
    _state.value = _state.value.buildNew(
      combinationPopUpData: CombinationPopUpData.NONE,
    );
  }

  void onCleverClicked() async {
    if (_isProgressShown()) {
      return;
    }

    _showProgress();
    final combination = _state.value.combinationPopUpData.combination;
    await _combinationRepository.addCombination(combination);

    _state.value = _state.value.buildNew(
      combinationPopUpData: CombinationPopUpData.NONE,
      isProgressShown: false,
    );
  }

  void onCloseCombinationPopUpClicked() {
    _state.value = _state.value.buildNew(
      combinationPopUpData: CombinationPopUpData.NONE,
    );
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
