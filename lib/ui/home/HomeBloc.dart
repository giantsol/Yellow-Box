import 'package:rxdart/rxdart.dart';
import 'package:rxdart/subjects.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:yellow_box/StreamSubscriptionExtension.dart';
import 'package:yellow_box/entity/AddIdeaResult.dart';
import 'package:yellow_box/entity/AddWordResult.dart';
import 'package:yellow_box/entity/ChildScreenKey.dart';
import 'package:yellow_box/entity/IdeaPopUpData.dart';
import 'package:yellow_box/entity/Word.dart';
import 'package:yellow_box/ui/BaseBloc.dart';
import 'package:yellow_box/ui/home/HomeNavigator.dart';
import 'package:yellow_box/ui/home/HomeState.dart';
import 'package:yellow_box/usecase/AddIdea.dart';
import 'package:yellow_box/usecase/AddWord.dart';
import 'package:yellow_box/usecase/IsIdeasFull.dart';
import 'package:yellow_box/usecase/ObserveAppTheme.dart';
import 'package:yellow_box/usecase/ObserveIdeas.dart';
import 'package:yellow_box/usecase/SetChildScreen.dart';

class HomeBloc extends BaseBloc {

  final HomeNavigator _navigator;

  final _state = BehaviorSubject<HomeState>.seeded(HomeState());
  HomeState getInitialState() => _state.value;
  Stream<HomeState> observeState() => _state.distinct();

  CompositeSubscription _subscriptions = CompositeSubscription();

  final _observeAppTheme = ObserveAppTheme();
  final _observeIdeas = ObserveIdeas();
  final _isIdeasFull = IsIdeasFull();
  final _addWord = AddWord();
  final _addIdea = AddIdea();
  final _setChildScreen = SetChildScreen();

  final _stt = SpeechToText();
  bool _sttInitializingOrInitialized = false;

  HomeBloc(this._navigator) {
    _init();
  }

  void _init() {
    _observeAppTheme.invoke()
      .listen((appTheme) {
      _state.value = _state.value.buildNew(
        appTheme: appTheme,
      );
    }).addTo(_subscriptions);

    _observeIdeas.invoke()
      .listen((ideas) async {
      _state.value = _state.value.buildNew(
        isIdeaBoxFull: await _isIdeasFull.invoke(),
      );
    }).addTo(_subscriptions);
  }

  @override
  void dispose() {
    _subscriptions.dispose();
  }

  void onAddWordClicked() {
    final isShown = _state.value.isWordEditorShown;
    if (!isShown) {
      _state.value = _state.value.buildNew(
        isWordEditorShown: true
      );
    }
  }

  void onNavigationBarItemClicked(ChildScreenKey key) {
    _setChildScreen.invoke(key);
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

    final result = await _addWord.invoke(Word(word, DateTime.now().millisecondsSinceEpoch));
    if (result == AddWordResult.FULL) {
      _navigator.showWordBoxFull();
    } else if (result == AddWordResult.ALREADY_EXISTS) {
      _navigator.showEditingWordAlreadyExists();
    } else {
      _state.value = _state.value.buildNew(
        isWordEditorShown: false,
        editingWord: '',
      );
    }

    _hideProgress();
  }

  void onMicIconClicked() async {
    if (!_sttInitializingOrInitialized) {
      _sttInitializingOrInitialized = true;
      _sttInitializingOrInitialized = await _stt.initialize(onStatus: (status) {
        _state.value = _state.value.buildNew(
          isListeningToSpeech: status == SpeechToText.listeningStatus,
        );
      }, onError: (error) {
        _state.value = _state.value.buildNew(
          isListeningToSpeech: false,
        );
      });

      if (_sttInitializingOrInitialized) {
        onMicIconClicked();
      }
    } else if (!_stt.isAvailable) {
      _navigator.showSpeechToTextNotReady();
    } else if (!_state.value.isListeningToSpeech) {
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

    final result = await _addIdea.invoke();
    switch (result.item1) {
      case AddIdeaResult.SUCCESS:
        _state.value = _state.value.buildNew(
          ideaPopUpData: IdeaPopUpData(result.item2, IdeaPopUpData.TYPE_NEW),
        );
        break;
      case AddIdeaResult.NEED_MORE_WORDS:
        _navigator.showAddMoreWordsForIdea();
        break;
      case AddIdeaResult.FULL:
        _navigator.showIdeaBoxFull();
        break;
      case AddIdeaResult.ALREADY_EXISTS:
        _state.value = _state.value.buildNew(
          ideaPopUpData: IdeaPopUpData(result.item2, IdeaPopUpData.TYPE_EXISTS),
        );
        break;
      case AddIdeaResult.BLOCKED:
      // show oops! you picked out a blocked idea!
        _state.value = _state.value.buildNew(
          ideaPopUpData: IdeaPopUpData(result.item2, IdeaPopUpData.TYPE_BLOCKED),
        );
        break;
    }

    _hideProgress();
  }

  void onCloseIdeaPopUpClicked() {
    _state.value = _state.value.buildNew(
      ideaPopUpData: IdeaPopUpData.NONE,
    );
  }

  void onIdeaBoxFullNotiClicked() {
    _setChildScreen.invoke(ChildScreenKey.HISTORY);
  }

  bool handleBackPress() {
    if (_state.value.isListeningToSpeech) {
      onStopSpeechRecognizerClicked();
      return true;
    }

    if (_state.value.isWordEditorShown) {
      onWordEditingCancelClicked();
      return true;
    }

    if (_state.value.ideaPopUpData.isValid()) {
      onCloseIdeaPopUpClicked();
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

}
