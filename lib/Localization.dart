
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

class AppLocalizations {
  static const CANCEL = 'cancel';
  static const ADD = 'add';
  static const WORD_EDITOR_HINT = 'wordEditorHint';
  static const EDITING_WORD_EMPTY = 'editingWordEmpty';
  static const EDITING_WORD_ALREADY_EXISTS = 'editingWordAlreadyExists';
  static const SPEECH_TO_TEXT_NOT_READY = 'speechToTextNotReady';
  static const ADD_MORE_WORDS_FOR_COMBINATION = 'addMoreWordsForCombination';
  static const NEW_COMBINATION = 'newCombination';
  static const GOOD_OLD_ONE = 'goodOldOne';
  static const NAH = 'nah';
  static const CLEVER = 'clever';
  static const CLOSE = 'close';
  static const WORD = 'word';
  static const COMBINATION = 'combination';
  static const NO_HISTORY = 'noHistory';
  static const DELETE = 'delete';

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
      ADD_MORE_WORDS_FOR_COMBINATION: 'Add more words for combination',
      NEW_COMBINATION: 'New combination!',
      GOOD_OLD_ONE: 'Good old one...',
      NAH: 'Nah...',
      CLEVER: 'Clever!',
      CLOSE: 'Close',
      WORD: 'Word',
      COMBINATION: 'Combination',
      NO_HISTORY: 'No history',
      DELETE: 'Delete',
    },
    'ko': {
      CANCEL: '취소',
      ADD: '추가',
      WORD_EDITOR_HINT: '추가할 단어',
      EDITING_WORD_EMPTY: '단어를 입력해주세요',
      EDITING_WORD_ALREADY_EXISTS: '이미 저장된 단어입니다',
      SPEECH_TO_TEXT_NOT_READY: '음성 인식기가 아직 준비중입니다',
      ADD_MORE_WORDS_FOR_COMBINATION: '단어 갯수를 더 추가해보세요',
      NEW_COMBINATION: '새로운 조합!',
      GOOD_OLD_ONE: '익숙한 조합이네요...',
      NAH: '별로...',
      CLEVER: '좋아요!',
      CLOSE: '닫기',
      WORD: '단어',
      COMBINATION: '조합',
      NO_HISTORY: '기록이 없습니다',
      DELETE: '삭제',
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
  String get addMoreWordsForCombination => _localizedValues[locale.languageCode][ADD_MORE_WORDS_FOR_COMBINATION];
  String get newCombination => _localizedValues[locale.languageCode][NEW_COMBINATION];
  String get goodOldOne => _localizedValues[locale.languageCode][GOOD_OLD_ONE];
  String get nah => _localizedValues[locale.languageCode][NAH];
  String get clever => _localizedValues[locale.languageCode][CLEVER];
  String get close => _localizedValues[locale.languageCode][CLOSE];
  String get word => _localizedValues[locale.languageCode][WORD];
  String get combination => _localizedValues[locale.languageCode][COMBINATION];
  String get noHistory => _localizedValues[locale.languageCode][NO_HISTORY];
  String get delete => _localizedValues[locale.languageCode][DELETE];

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