
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

class AppLocalizations {
  static const CANCEL = 'cancel';
  static const ADD = 'add';
  static const WORD_EDITOR_HINT = 'wordEditorHint';
  static const EDITING_WORD_EMPTY = 'editingWordEmpty';
  static const EDITING_WORD_ALREADY_EXISTS = 'editingWordAlreadyExists';
  static const SPEECH_TO_TEXT_NOT_READY = 'speechToTextNotReady';

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
    },
    'ko': {
      CANCEL: '취소',
      ADD: '추가',
      WORD_EDITOR_HINT: '추가할 단어',
      EDITING_WORD_EMPTY: '단어를 입력해주세요',
      EDITING_WORD_ALREADY_EXISTS: '이미 저장된 단어입니다',
      SPEECH_TO_TEXT_NOT_READY: '음성 인식기가 아직 준비중입니다',
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