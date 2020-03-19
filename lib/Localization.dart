
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

class AppLocalizations {
  static const CANCEL = 'cancel';
  static const ADD = 'add';
  static const WORD_EDITOR_HINT = 'wordEditorHint';
  static const EDITING_WORD_EMPTY = 'editingWordEmpty';
  static const EDITING_WORD_ALREADY_EXISTS = 'editingWordAlreadyExists';
  static const SPEECH_TO_TEXT_NOT_READY = 'speechToTextNotReady';
  static const ADD_MORE_WORDS_FOR_IDEA = 'addMoreWordsForIdea';
  static const NEW_IDEA = 'newIdea';
  static const GOOD_OLD_ONE = 'goodOldOne';
  static const CLOSE = 'close';
  static const WORD = 'word';
  static const IDEA = 'idea';
  static const NO_HISTORY = 'noHistory';
  static const DELETE = 'delete';
  static const GENERAL = 'general';
  static const MINI_BOX_TITLE = 'miniBoxTitle';
  static const MINI_BOX_SUBTITLE = 'miniBoxSubtitle';
  static const FAILED_TO_LAUNCH_MINI_BOX = 'failedToLaunchMiniBox';
  static const IDEA_BOX_FULL_TITLE = 'ideaBoxFullTitle';
  static const IDEA_BOX_FULL_SUBTITLE = 'ideaBoxFullSubtitle';
  static const HISTORY = 'history';
  static const IDEA_BOX_FULL_TOAST = 'ideaBoxFullToast';
  static const BLOCK = 'block';
  static const BLOCK_IDEA_SUBTITLE = 'blockIdeaSubtitle';
  static const PICKED_BLOCKED_IDEA = 'pickedBlockedIdea';

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static Map<String, Map<String, String>> _localizedValues = {
    'en': {
      CANCEL: 'Cancel',
      ADD: 'Add',
      WORD_EDITOR_HINT: 'Add word',
      EDITING_WORD_EMPTY: 'Word is empty',
      EDITING_WORD_ALREADY_EXISTS: 'This word is already saved',
      SPEECH_TO_TEXT_NOT_READY: 'Speech recognizer is not yet ready',
      ADD_MORE_WORDS_FOR_IDEA: 'Add more words for idea',
      NEW_IDEA: 'New idea!',
      GOOD_OLD_ONE: 'Good old one...',
      CLOSE: 'Close',
      WORD: 'Word',
      IDEA: 'Idea',
      NO_HISTORY: 'No history',
      DELETE: 'Delete',
      GENERAL: 'General',
      MINI_BOX_TITLE: 'Mini Box',
      MINI_BOX_SUBTITLE: 'Quickly add new words using floating button',
      FAILED_TO_LAUNCH_MINI_BOX: 'Failed to launch mini box',
      IDEA_BOX_FULL_TITLE: 'Idea box is full!',
      IDEA_BOX_FULL_SUBTITLE: 'Clear some history',
      HISTORY: 'History',
      IDEA_BOX_FULL_TOAST: 'Idea box is full!',
      BLOCK: 'Block',
      BLOCK_IDEA_SUBTITLE: 'Blocked ideas will never appear again.\nYou can reset this in settings.',
      PICKED_BLOCKED_IDEA: 'You picked out a blocked idea',
    },
    'ko': {
      CANCEL: '취소',
      ADD: '추가',
      WORD_EDITOR_HINT: '추가할 단어',
      EDITING_WORD_EMPTY: '단어를 입력해주세요',
      EDITING_WORD_ALREADY_EXISTS: '이미 저장된 단어입니다',
      SPEECH_TO_TEXT_NOT_READY: '음성 인식기가 아직 준비중입니다',
      ADD_MORE_WORDS_FOR_IDEA: '단어를 더 추가해보세요',
      NEW_IDEA: '새로운 아이디어!',
      GOOD_OLD_ONE: '익숙한 조합이네요...',
      CLOSE: '닫기',
      WORD: '단어',
      IDEA: '아이디어',
      NO_HISTORY: '기록이 없습니다',
      DELETE: '삭제',
      GENERAL: '일반',
      MINI_BOX_TITLE: '미니 박스',
      MINI_BOX_SUBTITLE: '플로팅 버튼을 사용해 쉽게 새 단어를 추가합니다',
      FAILED_TO_LAUNCH_MINI_BOX: '미니 박스 실행에 실패하였습니다',
      IDEA_BOX_FULL_TITLE: '아이디어 박스가 가득 찼습니다!',
      IDEA_BOX_FULL_SUBTITLE: '기록을 정리해보세요',
      HISTORY: '기록',
      IDEA_BOX_FULL_TOAST: '아이디어 박스가 가득 찼습니다!',
      BLOCK: '차단',
      BLOCK_IDEA_SUBTITLE: '차단된 아이디어는 다시 생성되지 않습니다.\n설정에서 초기화할 수 있습니다.',
      PICKED_BLOCKED_IDEA: '차단된 아이디어입니다',
    },
  };

  final Locale locale;

  AppLocalizations(this.locale);

  String get cancel => _localizedValues[locale.languageCode][CANCEL];
  String get add => _localizedValues[locale.languageCode][ADD];
  String get wordEditorHint => _localizedValues[locale.languageCode][WORD_EDITOR_HINT];
  String get editingWordEmpty => _localizedValues[locale.languageCode][EDITING_WORD_EMPTY];
  String get editingWordAlreadyExists => _localizedValues[locale.languageCode][EDITING_WORD_ALREADY_EXISTS];
  String get speechToTextNotReady => _localizedValues[locale.languageCode][SPEECH_TO_TEXT_NOT_READY];
  String get addMoreWordsForIdea => _localizedValues[locale.languageCode][ADD_MORE_WORDS_FOR_IDEA];
  String get newIdea => _localizedValues[locale.languageCode][NEW_IDEA];
  String get goodOldOne => _localizedValues[locale.languageCode][GOOD_OLD_ONE];
  String get close => _localizedValues[locale.languageCode][CLOSE];
  String get word => _localizedValues[locale.languageCode][WORD];
  String get idea => _localizedValues[locale.languageCode][IDEA];
  String get noHistory => _localizedValues[locale.languageCode][NO_HISTORY];
  String get delete => _localizedValues[locale.languageCode][DELETE];
  String get general => _localizedValues[locale.languageCode][GENERAL];
  String get miniBoxTitle => _localizedValues[locale.languageCode][MINI_BOX_TITLE];
  String get miniBoxSubtitle => _localizedValues[locale.languageCode][MINI_BOX_SUBTITLE];
  String get failedToLaunchMiniBox => _localizedValues[locale.languageCode][FAILED_TO_LAUNCH_MINI_BOX];
  String get ideaBoxFullTitle => _localizedValues[locale.languageCode][IDEA_BOX_FULL_TITLE];
  String get ideaBoxFullSubtitle => _localizedValues[locale.languageCode][IDEA_BOX_FULL_SUBTITLE];
  String get history => _localizedValues[locale.languageCode][HISTORY];
  String get ideaBoxFullToast => _localizedValues[locale.languageCode][IDEA_BOX_FULL_TOAST];
  String get block => _localizedValues[locale.languageCode][BLOCK];
  String get blockIdeaSubtitle => _localizedValues[locale.languageCode][BLOCK_IDEA_SUBTITLE];
  String get pickedBlockedIdea => _localizedValues[locale.languageCode][PICKED_BLOCKED_IDEA];

  String getConfirmDeleteTitle(String item) {
    if (locale.languageCode == 'ko') {
      return '"$item"을(를) 삭제하겠습니까?';
    } else {
      return 'Delete "$item?"';
    }
  }

  String getConfirmBlockTitle(String item) {
    if (locale.languageCode == 'ko') {
      return '"$item"을(를) 차단하겠습니까?';
    } else {
      return 'Block "$item?"';
    }
  }

  String getDeleteWordsTitle(int count) {
    if (locale.languageCode == 'ko') {
      return '$count개를 삭제하겠습니까?';
    } else {
      return 'Delete $count items?';
    }
  }

  String getSelectionTitle(int count) {
    if (locale.languageCode == 'ko') {
      return '$count개 선택';
    } else {
      return '$count selected';
    }
  }

}

class AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {

  const AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => ['en', 'ko'].contains(locale.languageCode);

  @override
  bool shouldReload(LocalizationsDelegate old) => false;

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(AppLocalizations(locale));
  }
}