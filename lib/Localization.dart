
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

class AppLocalizations {
  static const CANCEL = 'cancel';
  static const ADD = 'add';
  static const WORD_EDITOR_HINT = 'wordEditorHint';
  static const EDITING_WORD_EMPTY = 'editingWordEmpty';
  static const EDITING_WORD_ALREADY_EXISTS = 'editingWordAlreadyExists';
  static const WORD_BOX_FULL = 'wordBoxFull';
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
  static const MINI_BOX_NOT_SUPPORTED = 'miniBoxNotSupported';
  static const IDEA_BOX_FULL_TITLE = 'ideaBoxFullTitle';
  static const IDEA_BOX_FULL_SUBTITLE = 'ideaBoxFullSubtitle';
  static const HISTORY = 'history';
  static const IDEA_BOX_FULL_TOAST = 'ideaBoxFullToast';
  static const BLOCK = 'block';
  static const BLOCK_IDEA_SUBTITLE = 'blockIdeaSubtitle';
  static const PICKED_BLOCKED_IDEA = 'pickedBlockedIdea';
  static const AUTO_GENERATE_IDEAS_TITLE = 'autoGenerateIdeasTitle';
  static const AUTO_GENERATE_IDEAS_SUBTITLE = 'autoGenerateIdeasSubtitle';
  static const RESET_BLOCKED_IDEAS_TITLE = 'resetBlockedIdeasTitle';
  static const RESET_BLOCKED_IDEAS_SUBTITLE = 'resetBlockedIdeasSubtitle';
  static const RESET_BLOCKED_IDEAS_DIALOG_SUBTITLE = 'resetBlockedIdeasDialogSubtitle';
  static const RESET = 'reset';
  static const INTERVAL_TITLE = 'intervalTitle';
  static const INTERVAL_SUBTITLE = 'intervalSubtitle';
  static const YELLOW_BOX_TITLE = 'yellowBoxTitle';
  static const YELLOW_BOX_SUBTITLE = 'yellowBoxSubtitle';
  static const TUTORIAL_ZERO_TITLE = 'tutorialZeroTitle';
  static const START = 'start';
  static const SKIP = 'skip';
  static const TUTORIAL_FIRST_WORD = 'tutorialFirstWord';
  static const TUTORIAL_SECOND_WORD = 'tutorialSecondWord';
  static const TUTORIAL_ONE_TITLE = 'tutorialOneTitle';
  static const TUTORIAL_TWO_TITLE = 'tutorialTwoTitle';
  static const TUTORIAL_THREE_TITLE = 'tutorialThreeTitle';
  static const TUTORIAL_FOUR_TITLE = 'tutorialFourTitle';
  static const TUTORIAL_FIVE_TITLE = 'tutorialFiveTitle';
  static const HOW_ABOUT_GREEN = 'howAboutGreen';
  static const NAH = 'nah';
  static const NICE = 'nice';
  static const NEXT = 'next';
  static const DONE = 'done';

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static Map<String, Map<String, String>> _localizedValues = {
    'en': {
      CANCEL: 'Cancel',
      ADD: 'Add',
      WORD_EDITOR_HINT: 'Add word',
      EDITING_WORD_EMPTY: 'Word is empty',
      EDITING_WORD_ALREADY_EXISTS: 'This word is already saved',
      WORD_BOX_FULL: 'Word box is full!',
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
      MINI_BOX_NOT_SUPPORTED: 'Not supported in this platform',
      IDEA_BOX_FULL_TITLE: 'Idea box is full!',
      IDEA_BOX_FULL_SUBTITLE: 'Clear some history',
      HISTORY: 'History',
      IDEA_BOX_FULL_TOAST: 'Idea box is full!',
      BLOCK: 'Block',
      BLOCK_IDEA_SUBTITLE: 'Blocked ideas will never appear again.\nYou can reset this in settings.',
      PICKED_BLOCKED_IDEA: 'You picked out a blocked idea',
      AUTO_GENERATE_IDEAS_TITLE: 'Auto-generate ideas',
      AUTO_GENERATE_IDEAS_SUBTITLE: 'Generate new ideas periodically in background',
      RESET_BLOCKED_IDEAS_TITLE: 'Reset blocked ideas',
      RESET_BLOCKED_IDEAS_SUBTITLE: 'Unblock all previously blocked ideas',
      RESET_BLOCKED_IDEAS_DIALOG_SUBTITLE: 'Are you sure to unblock all previously blocked ideas?',
      RESET: 'Reset',
      INTERVAL_TITLE: 'Interval',
      INTERVAL_SUBTITLE: 'New ideas will be generated every interval approximately',
      YELLOW_BOX_TITLE: 'Yellow Box',
      YELLOW_BOX_SUBTITLE: 'Beginning of your ideas',
      TUTORIAL_ZERO_TITLE: 'Welcome!\nLet me help you get started.',
      START: 'Start',
      SKIP: 'Skip',
      TUTORIAL_FIRST_WORD: 'Green',
      TUTORIAL_SECOND_WORD: 'Day',
      TUTORIAL_ONE_TITLE: 'Press the pen to add your first word.',
      TUTORIAL_TWO_TITLE: 'Now click the box!',
      TUTORIAL_THREE_TITLE: 'How was your first idea?\nAll histories are kept here.',
      TUTORIAL_FOUR_TITLE: 'You see, I\'ve added two dummy words, too :P\nYou can view and edit history here.',
      TUTORIAL_FIVE_TITLE: 'That\'s it! Look around,\nadd any words you can think of.\nLet your own crazy ideas happen!',
      HOW_ABOUT_GREEN: 'e.g. Green',
      NAH: 'Nah..',
      NICE: 'Nice!',
      NEXT: 'Next',
      DONE: 'Done',
    },
    'ko': {
      CANCEL: '취소',
      ADD: '추가',
      WORD_EDITOR_HINT: '추가할 단어',
      EDITING_WORD_EMPTY: '단어를 입력해주세요',
      EDITING_WORD_ALREADY_EXISTS: '이미 저장된 단어입니다',
      WORD_BOX_FULL: '단어 박스가 가득 찼습니다!',
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
      MINI_BOX_NOT_SUPPORTED: '현재 환경에선 지원되지 않는 기능입니다',
      IDEA_BOX_FULL_TITLE: '아이디어 박스가 가득 찼습니다!',
      IDEA_BOX_FULL_SUBTITLE: '기록을 정리해보세요',
      HISTORY: '기록',
      IDEA_BOX_FULL_TOAST: '아이디어 박스가 가득 찼습니다!',
      BLOCK: '차단',
      BLOCK_IDEA_SUBTITLE: '차단된 아이디어는 다시 생성되지 않습니다.\n설정에서 초기화할 수 있습니다.',
      PICKED_BLOCKED_IDEA: '차단된 아이디어입니다',
      AUTO_GENERATE_IDEAS_TITLE: '아이디어 자동 생성',
      AUTO_GENERATE_IDEAS_SUBTITLE: '백그라운드에서 주기적으로 아이디어를 생성합니다',
      RESET_BLOCKED_IDEAS_TITLE: '차단된 아이디어 리셋',
      RESET_BLOCKED_IDEAS_SUBTITLE: '차단된 아이디어들을 모두 해제합니다',
      RESET_BLOCKED_IDEAS_DIALOG_SUBTITLE: '정말로 차단된 아이디어들을 모두 해제하겠습니까?',
      RESET: '리셋',
      INTERVAL_TITLE: '시간 간격',
      INTERVAL_SUBTITLE: '정해진 시간 간격마다 아이디어가 생성됩니다',
      YELLOW_BOX_TITLE: '옐로 박스',
      YELLOW_BOX_SUBTITLE: '새로운 아이디어의 시작',
      TUTORIAL_ZERO_TITLE: '환영합니다!\n앱의 사용법을 알려드리겠습니다.',
      START: '시작하기',
      SKIP: '건너뛰기',
      TUTORIAL_FIRST_WORD: '초록색',
      TUTORIAL_SECOND_WORD: '하루',
      TUTORIAL_ONE_TITLE: '먼저 펜을 눌러 첫 단어를 추가해보세요!',
      TUTORIAL_TWO_TITLE: '이제 박스를 눌러보세요!',
      TUTORIAL_THREE_TITLE: '첫 아이디어는 어떠셨나요?\n모든 히스토리는 여기 보관됩니다.',
      TUTORIAL_FOUR_TITLE: '제가 몰래 넣어둔 단어도 보이네요 ^^..\n이 화면에서 조회와 삭제가 가능합니다.',
      TUTORIAL_FIVE_TITLE: '끝났습니다!\n떠오르는 단어 무엇이든 넣어보세요.\n당신만의 특별한 아이디어가 나올겁니다!',
      HOW_ABOUT_GREEN: '예) 초록색',
      NAH: '별로..',
      NICE: '좋아요!',
      NEXT: '다음',
      DONE: '완료',
    },
  };

  final Locale locale;

  AppLocalizations(this.locale);

  String? get cancel => _localizedValues[locale.languageCode]![CANCEL];
  String? get add => _localizedValues[locale.languageCode]![ADD];
  String? get wordEditorHint => _localizedValues[locale.languageCode]![WORD_EDITOR_HINT];
  String? get editingWordEmpty => _localizedValues[locale.languageCode]![EDITING_WORD_EMPTY];
  String? get editingWordAlreadyExists => _localizedValues[locale.languageCode]![EDITING_WORD_ALREADY_EXISTS];
  String? get wordBoxFull => _localizedValues[locale.languageCode]![WORD_BOX_FULL];
  String? get speechToTextNotReady => _localizedValues[locale.languageCode]![SPEECH_TO_TEXT_NOT_READY];
  String? get addMoreWordsForIdea => _localizedValues[locale.languageCode]![ADD_MORE_WORDS_FOR_IDEA];
  String? get newIdea => _localizedValues[locale.languageCode]![NEW_IDEA];
  String? get goodOldOne => _localizedValues[locale.languageCode]![GOOD_OLD_ONE];
  String? get close => _localizedValues[locale.languageCode]![CLOSE];
  String? get word => _localizedValues[locale.languageCode]![WORD];
  String? get idea => _localizedValues[locale.languageCode]![IDEA];
  String? get noHistory => _localizedValues[locale.languageCode]![NO_HISTORY];
  String? get delete => _localizedValues[locale.languageCode]![DELETE];
  String? get general => _localizedValues[locale.languageCode]![GENERAL];
  String? get miniBoxTitle => _localizedValues[locale.languageCode]![MINI_BOX_TITLE];
  String? get miniBoxSubtitle => _localizedValues[locale.languageCode]![MINI_BOX_SUBTITLE];
  String? get miniBoxNotSupported => _localizedValues[locale.languageCode]![MINI_BOX_NOT_SUPPORTED];
  String? get ideaBoxFullTitle => _localizedValues[locale.languageCode]![IDEA_BOX_FULL_TITLE];
  String? get ideaBoxFullSubtitle => _localizedValues[locale.languageCode]![IDEA_BOX_FULL_SUBTITLE];
  String? get history => _localizedValues[locale.languageCode]![HISTORY];
  String? get ideaBoxFullToast => _localizedValues[locale.languageCode]![IDEA_BOX_FULL_TOAST];
  String? get block => _localizedValues[locale.languageCode]![BLOCK];
  String? get blockIdeaSubtitle => _localizedValues[locale.languageCode]![BLOCK_IDEA_SUBTITLE];
  String? get pickedBlockedIdea => _localizedValues[locale.languageCode]![PICKED_BLOCKED_IDEA];
  String? get autoGenerateIdeasTitle => _localizedValues[locale.languageCode]![AUTO_GENERATE_IDEAS_TITLE];
  String? get autoGenerateIdeasSubtitle => _localizedValues[locale.languageCode]![AUTO_GENERATE_IDEAS_SUBTITLE];
  String? get resetBlockedIdeasTitle => _localizedValues[locale.languageCode]![RESET_BLOCKED_IDEAS_TITLE];
  String? get resetBlockedIdeasSubtitle => _localizedValues[locale.languageCode]![RESET_BLOCKED_IDEAS_SUBTITLE];
  String? get resetBlockedIdeasDialogSubtitle => _localizedValues[locale.languageCode]![RESET_BLOCKED_IDEAS_DIALOG_SUBTITLE];
  String? get reset => _localizedValues[locale.languageCode]![RESET];
  String? get intervalTitle => _localizedValues[locale.languageCode]![INTERVAL_TITLE];
  String? get intervalSubtitle => _localizedValues[locale.languageCode]![INTERVAL_SUBTITLE];
  String? get tutorialZeroTitle => _localizedValues[locale.languageCode]![TUTORIAL_ZERO_TITLE];
  String? get start => _localizedValues[locale.languageCode]![START];
  String? get skip => _localizedValues[locale.languageCode]![SKIP];
  String? get tutorialFirstWord => _localizedValues[locale.languageCode]![TUTORIAL_FIRST_WORD];
  String? get tutorialSecondWord => _localizedValues[locale.languageCode]![TUTORIAL_SECOND_WORD];
  String? get tutorialOneTitle => _localizedValues[locale.languageCode]![TUTORIAL_ONE_TITLE];
  String? get tutorialTwoTitle => _localizedValues[locale.languageCode]![TUTORIAL_TWO_TITLE];
  String? get tutorialThreeTitle => _localizedValues[locale.languageCode]![TUTORIAL_THREE_TITLE];
  String? get tutorialFourTitle => _localizedValues[locale.languageCode]![TUTORIAL_FOUR_TITLE];
  String? get tutorialFiveTitle => _localizedValues[locale.languageCode]![TUTORIAL_FIVE_TITLE];
  String? get howAboutGreen => _localizedValues[locale.languageCode]![HOW_ABOUT_GREEN];
  String? get nah => _localizedValues[locale.languageCode]![NAH];
  String? get nice => _localizedValues[locale.languageCode]![NICE];
  String? get next => _localizedValues[locale.languageCode]![NEXT];
  String? get done => _localizedValues[locale.languageCode]![DONE];

  String? get(String key) {
    return _localizedValues[locale.languageCode]![key];
  }

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

  String getDeleteItemsTitle(int count) {
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

  String getBlockItemsTitle(int count) {
    if (locale.languageCode == 'ko') {
      return '$count개를 차단하겠습니까?';
    } else {
      return 'Block $count items?';
    }
  }

  String getIntervalHours(int hour) {
    if (locale.languageCode == 'ko') {
      return '$hour 시간';
    } else {
      return '$hour hr';
    }
  }

  String getRemainingMiniBoxWordsCount(int count) {
    if (locale.languageCode == 'ko') {
      return '단어 박스가 가득 차서 $count개의 미니 박스 단어들이 저장되지 못했어요!\n단어들을 삭제하고 재실행해보세요!';
    } else {
      return '$count number of mini box words couldn\'t be saved!\nTry deleting some words and reopen the app.';
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