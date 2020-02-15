
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

class AppLocalizations {
  static const CANCEL = 'cancel';
  static const ADD = 'add';

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static Map<String, Map<String, String>> _localizedValues = {
    'en': {
      CANCEL: 'Cancel',
      ADD: 'Add',
    },
    'ko': {
      CANCEL: '취소',
      ADD: '추가',
    },
  };

  final Locale locale;

  AppLocalizations(this.locale);

  String get cancel => _localizedValues[locale.languageCode][CANCEL];
  String get add => _localizedValues[locale.languageCode][ADD];

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