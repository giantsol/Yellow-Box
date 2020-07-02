import 'package:flutter/widgets.dart';
import 'package:rxdart/rxdart.dart';
import 'package:rxdart/subjects.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:yellow_box/Localization.dart';
import 'package:yellow_box/StreamSubscriptionExtension.dart';
import 'package:yellow_box/entity/AddIdeaResult.dart';
import 'package:yellow_box/entity/AddWordResult.dart';
import 'package:yellow_box/entity/ChildScreenKey.dart';
import 'package:yellow_box/entity/IdeaPopUpData.dart';
import 'package:yellow_box/entity/Word.dart';
import 'package:yellow_box/ui/BaseBloc.dart';
import 'package:yellow_box/ui/home/HomeNavigator.dart';
import 'package:yellow_box/ui/home/HomeState.dart';
import 'package:yellow_box/usecase/idea/AddIdea.dart';
import 'package:yellow_box/usecase/word/AddWord.dart';
import 'package:yellow_box/usecase/tutorial/GetTutorialPhase.dart';
import 'package:yellow_box/usecase/idea/IsIdeasFull.dart';
import 'package:yellow_box/usecase/ObserveAppTheme.dart';
import 'package:yellow_box/usecase/idea/ObserveIdeas.dart';
import 'package:yellow_box/usecase/SetChildScreen.dart';
import 'package:yellow_box/usecase/tutorial/SetTutorialPhase.dart';

class HomeBloc extends BaseBloc {

  static const _FIRST_TUTORIAL = 0;
  static const _LAST_TUTORIAL = 3;

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
  final _getTutorialPhase = GetTutorialPhase();
  final _setTutorialPhase = SetTutorialPhase();

  final _stt = SpeechToText();
  bool _sttInitializingOrInitialized = false;

  HomeBloc(this._navigator) {
    _init();
  }

  void _init() async {
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

    final tutorialPhase = await _getTutorialPhase.invoke();
    if (tutorialPhase >= _FIRST_TUTORIAL && tutorialPhase <= _LAST_TUTORIAL) {
      _navigator.showTutorial(tutorialPhase);
      _state.value = _state.value.buildNew(
        isInTutorial: true,
      );
    }
  }

  @override
  void dispose() {
    _subscriptions.dispose();
  }

  void onAddWordClicked() async {
    final isShown = _state.value.isWordEditorShown;
    if (!isShown) {
      _state.value = _state.value.buildNew(
        isWordEditorShown: true
      );

      if ((await _getTutorialPhase.invoke()) == 1) {
        _navigator.hideTutorial();
      }
    }
  }

  void onNavigationBarItemClicked(ChildScreenKey key) async {
    _setChildScreen.invoke(key);

    if (key == ChildScreenKey.HISTORY && (await _getTutorialPhase.invoke()) == 3) {
      _setTutorialPhase.invoke(4);
      _navigator.hideTutorial();

      _state.value = _state.value.buildNew(
        isInTutorial: false,
      );
    }
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

  void onWordEditingAddClicked(BuildContext context) async {
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
      // SUCCESS
      _state.value = _state.value.buildNew(
        isWordEditorShown: false,
        editingWord: '',
      );

      _navigator.showWordAddedAnimation();

      if ((await _getTutorialPhase.invoke()) == 1) {
        _addWord.invoke(Word(AppLocalizations.of(context).tutorialFirstWord, DateTime.now().millisecondsSinceEpoch));
        _addWord.invoke(Word(AppLocalizations.of(context).tutorialSecondWord, DateTime.now().millisecondsSinceEpoch));
        _setTutorialPhase.invoke(2);
        _navigator.showTutorial(2);
      }
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

  void onLogoClicked(BuildContext context) async {
    if (_isProgressShown()) {
      return;
    }

    _showProgress();

    final String fakeIdeaForTutorial = (await _getTutorialPhase.invoke()) == 2 ? "${AppLocalizations.of(context).tutorialFirstWord} ${AppLocalizations.of(context).tutorialSecondWord}"
      : "";
    final result = await _addIdea.invoke(idea: fakeIdeaForTutorial);
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

    if (_state.value.ideaPopUpData.isValid() && (await _getTutorialPhase.invoke()) == 2) {
      _navigator.hideTutorial();
    }
  }

  void onCloseIdeaPopUpClicked() async {
    final bool wasNewIdea = _state.value.ideaPopUpData.type == IdeaPopUpData.TYPE_NEW;
    _state.value = _state.value.buildNew(
      ideaPopUpData: IdeaPopUpData.NONE,
    );

    if (wasNewIdea) {
      _navigator.showIdeaAddedAnimation();
    }

    if ((await _getTutorialPhase.invoke()) == 2) {
      _setTutorialPhase.invoke(3);
      _navigator.showTutorial(3);
    }
  }

  void onIdeaBoxFullNotiClicked() {
    _setChildScreen.invoke(ChildScreenKey.HISTORY);
  }

  void onSkipTutorialClicked() {
    _setTutorialPhase.invoke(5);
    _navigator.hideTutorial();

    _state.value = _state.value.buildNew(
      isInTutorial: false,
    );
  }

  void onTutorialZeroFinished() {
    _setTutorialPhase.invoke(1);
    _navigator.showTutorial(1);
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
