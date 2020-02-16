
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

class AppLocalizations {
  static const CANCEL = 'cancel';
  static const ADD = 'add';
  static const WORD_EDITOR_HINT = 'wordEditorHint';

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static Map<String, Map<String, String>> _localizedValues = {
    'en': {
      CANCEL: 'Cancel',
      ADD: 'Add',
      WORD_EDITOR_HINT: 'Add word',
    },
    'ko': {
      CANCEL: '취소',
      ADD: '추가',
      WORD_EDITOR_HINT: '추가할 단어',
    },
  };

  final Locale locale;

  AppLocalizations(this.locale);

  String get cancel => _localizedValues[locale.languageCode][CANCEL];
  String get add => _localizedValues[locale.languageCode][ADD];
  String get wordEditorHint => _localizedValues[locale.languageCode][WORD_EDITOR_HINT];

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