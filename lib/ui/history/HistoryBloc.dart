
import 'package:rxdart/rxdart.dart';
import 'package:rxdart/subjects.dart';
import 'package:yellow_box/StreamSubscriptionExtension.dart';
import 'package:yellow_box/entity/ChildScreenKey.dart';
import 'package:yellow_box/entity/Idea.dart';
import 'package:yellow_box/entity/Word.dart';
import 'package:yellow_box/ui/BaseBloc.dart';
import 'package:yellow_box/ui/history/HistoryState.dart';
import 'package:yellow_box/usecase/BlockIdea.dart';
import 'package:yellow_box/usecase/BlockIdeas.dart';
import 'package:yellow_box/usecase/DeleteIdea.dart';
import 'package:yellow_box/usecase/DeleteIdeas.dart';
import 'package:yellow_box/usecase/DeleteWord.dart';
import 'package:yellow_box/usecase/DeleteWords.dart';
import 'package:yellow_box/usecase/FavoriteIdea.dart';
import 'package:yellow_box/usecase/ObserveAppTheme.dart';
import 'package:yellow_box/usecase/ObserveIdeas.dart';
import 'package:yellow_box/usecase/ObserveWords.dart';
import 'package:yellow_box/usecase/SetChildScreen.dart';
import 'package:yellow_box/usecase/UnfavoriteIdea.dart';

class HistoryBloc extends BaseBloc {

  final _state = BehaviorSubject<HistoryState>.seeded(HistoryState());
  HistoryState getInitialState() => _state.value;
  Stream<HistoryState> observeState() => _state.distinct();

  CompositeSubscription _subscriptions = CompositeSubscription();

  final _observeAppTheme = ObserveAppTheme();
  final _observeWords = ObserveWords();
  final _observeIdeas = ObserveIdeas();
  final _setChildScreen = SetChildScreen();
  final _deleteWord = DeleteWord();
  final _deleteIdea = DeleteIdea();
  final _blockIdea = BlockIdea();
  final _favoriteIdea = FavoriteIdea();
  final _unfavoriteIdea = UnfavoriteIdea();
  final _deleteWords = DeleteWords();
  final _deleteIdeas = DeleteIdeas();
  final _blockIdeas = BlockIdeas();

  bool _wordsLoaded = false;
  bool _ideasLoaded = false;

  HistoryBloc() {
    _observeAppTheme.invoke()
      .listen((appTheme) {
      _state.value = _state.value.buildNew(
        appTheme: appTheme,
      );
    }).addTo(_subscriptions);

    _observeWords.invoke()
      .listen((words) {
      _wordsLoaded = true;
      _state.value = _state.value.buildNew(
        words: words,
        isProgressShown: !_wordsLoaded || !_ideasLoaded,
      );
    }).addTo(_subscriptions);

    _observeIdeas.invoke()
      .listen((ideas) {
      _ideasLoaded = true;
      _state.value = _state.value.buildNew(
        ideas: ideas,
        isProgressShown: !_wordsLoaded || !_ideasLoaded,
      );
    }).addTo(_subscriptions);
  }

  @override
  void dispose() {
    _subscriptions.dispose();
  }

  void onNavigationBarItemClicked(ChildScreenKey key) {
    _setChildScreen.invoke(key);
  }

  void onWordTabClicked() {
    _state.value = _state.value.buildNew(
      isWordTab: true,
    );
  }

  void onIdeaTabClicked() {
    _state.value = _state.value.buildNew(
      isWordTab: false,
    );
  }

  void onWordItemClicked(Word item) {
    if (_state.value.selectionMode == SelectionMode.WORDS) {
      final map = _state.value.selectedWords;
      if (map.containsKey(item)) {
        map.remove(item);
      } else {
        map[item] = true;
      }

      _state.value = _state.value.buildNew(
        selectedWords: map,
      );
    } else {
      _state.value = _state.value.buildNew(
        wordItemDialog: WordItemDialog(WordItemDialog.TYPE_LIST, item),
      );
    }
  }

  void onWordItemDialogCloseClicked() {
    _state.value = _state.value.buildNew(
      wordItemDialog: WordItemDialog.NONE,
    );
  }

  void onWordItemDialogDeleteClicked(Word item) {
    _state.value = _state.value.buildNew(
      wordItemDialog: WordItemDialog(WordItemDialog.TYPE_CONFIRM_DELETE, item),
    );
  }

  void onConfirmDeleteWordClicked(Word item) {
    _deleteWord.invoke(item);

    _state.value = _state.value.buildNew(
      wordItemDialog: WordItemDialog.NONE,
    );
  }

  void onWordItemLongPressed(Word item) {
    _state.value = _state.value.buildNew(
      selectionMode: SelectionMode.WORDS,
      selectedWords: {item: true},
    );
  }

  void onIdeaItemClicked(Idea item) {
    if (_state.value.selectionMode == SelectionMode.IDEAS) {
      final map = _state.value.selectedIdeas;
      if (map.containsKey(item)) {
        map.remove(item);
      } else {
        map[item] = true;
      }

      _state.value = _state.value.buildNew(
        selectedIdeas: map,
      );
    } else {
      _state.value = _state.value.buildNew(
        ideaItemDialog: IdeaItemDialog(IdeaItemDialog.TYPE_LIST, item),
      );
    }
  }

  void onIdeaItemLongPressed(Idea item) {
    _state.value = _state.value.buildNew(
      selectionMode: SelectionMode.IDEAS,
      selectedIdeas: {item: true},
    );
  }

  void onIdeaItemDialogDeleteClicked(Idea item) {
    _state.value = _state.value.buildNew(
      ideaItemDialog: IdeaItemDialog(IdeaItemDialog.TYPE_CONFIRM_DELETE, item),
    );
  }

  void onIdeaItemDialogBlockClicked(Idea item) {
    _state.value = _state.value.buildNew(
      ideaItemDialog: IdeaItemDialog(IdeaItemDialog.TYPE_CONFIRM_BLOCK, item),
    );
  }

  void onIdeaItemDialogCloseClicked() {
    _state.value = _state.value.buildNew(
      ideaItemDialog: IdeaItemDialog.NONE,
    );
  }

  void onConfirmDeleteIdeaClicked(Idea item) {
    _deleteIdea.invoke(item);

    _state.value = _state.value.buildNew(
      ideaItemDialog: IdeaItemDialog.NONE,
    );
  }

  void onConfirmBlockIdeaClicked(Idea item) {
    _blockIdea.invoke(item);

    _state.value = _state.value.buildNew(
      ideaItemDialog: IdeaItemDialog.NONE,
    );
  }

  void onIdeaItemFavoriteClicked(Idea item) {
    if (item.isFavorite) {
      _unfavoriteIdea.invoke(item);
    } else {
      _favoriteIdea.invoke(item);
    }
  }

  void onSelectionModeCloseClicked() {
    _state.value = _state.value.buildNew(
      selectionMode: SelectionMode.NONE,
      selectedWords: {},
      selectedIdeas: {},
    );
  }

  void onDeleteWordsClicked() {
    if (_state.value.selectedWords.isNotEmpty) {
      _state.value = _state.value.buildNew(
        isDeleteWordsDialogShown: true,
      );
    }
  }

  void onConfirmDeleteWordsClicked() {
    _deleteWords.invoke(_state.value.selectedWords);

    _state.value = _state.value.buildNew(
      isDeleteWordsDialogShown: false,
      selectionMode: SelectionMode.NONE,
      selectedWords: {},
      selectedIdeas: {},
    );
  }

  void onCloseDeleteWordsClicked() {
    _state.value = _state.value.buildNew(
      isDeleteWordsDialogShown: false,
    );
  }

  void onDeleteIdeasClicked() {
    if (_state.value.selectedIdeas.isNotEmpty) {
      _state.value = _state.value.buildNew(
        isDeleteIdeasDialogShown: true,
      );
    }
  }

  void onConfirmDeleteIdeasClicked() {
    _deleteIdeas.invoke(_state.value.selectedIdeas);

    _state.value = _state.value.buildNew(
      isDeleteIdeasDialogShown: false,
      selectionMode: SelectionMode.NONE,
      selectedWords: {},
      selectedIdeas: {},
    );
  }

  void onCloseDeleteIdeasClicked() {
    _state.value = _state.value.buildNew(
      isDeleteIdeasDialogShown: false,
    );
  }

  void onBlockIdeasClicked() {
    if (_state.value.selectedIdeas.isNotEmpty) {
      _state.value = _state.value.buildNew(
        isBlockIdeasDialogShown: true,
      );
    }
  }

  void onConfirmBlockIdeasClicked() {
    _blockIdeas.invoke(_state.value.selectedIdeas);

    _state.value = _state.value.buildNew(
      isBlockIdeasDialogShown: false,
      selectionMode: SelectionMode.NONE,
      selectedWords: {},
      selectedIdeas: {},
    );
  }

  void onCloseBlockIdeasClicked() {
    _state.value = _state.value.buildNew(
      isBlockIdeasDialogShown: false,
    );
  }

  bool handleBackPress() {
    if (_state.value.wordItemDialog.isValid()) {
      onWordItemDialogCloseClicked();
      return true;
    }

    if (_state.value.ideaItemDialog.isValid()) {
      onIdeaItemDialogCloseClicked();
      return true;
    }

    if (_state.value.isDeleteWordsDialogShown) {
      onCloseDeleteWordsClicked();
      return true;
    }

    if (_state.value.isDeleteIdeasDialogShown) {
      onCloseDeleteIdeasClicked();
      return true;
    }

    if (_state.value.isBlockIdeasDialogShown) {
      onCloseBlockIdeasClicked();
      return true;
    }

    if (_state.value.selectionMode != SelectionMode.NONE) {
      onSelectionModeCloseClicked();
      return true;
    }

    return false;
  }
}