
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:yellow_box/AppColors.dart';
import 'package:yellow_box/IntExtension.dart';
import 'package:yellow_box/Localization.dart';
import 'package:yellow_box/Utils.dart';
import 'package:yellow_box/entity/AppTheme.dart';
import 'package:yellow_box/entity/ChildScreenKey.dart';
import 'package:yellow_box/entity/Idea.dart';
import 'package:yellow_box/entity/Word.dart';
import 'package:yellow_box/ui/history/HistoryBloc.dart';
import 'package:yellow_box/ui/history/HistoryNavigator.dart';
import 'package:yellow_box/ui/history/HistoryState.dart';
import 'package:yellow_box/ui/widget/AppAlertDialog.dart';
import 'package:yellow_box/ui/widget/AppChoiceListDialog.dart';
import 'package:yellow_box/ui/widget/CenterProgress.dart';
import 'package:yellow_box/ui/widget/ChildScreenNavigationBar.dart';
import 'package:yellow_box/ui/widget/Scrim.dart';
import 'package:yellow_box/ui/widget/Tutorial.dart';

class HistoryScreen extends StatefulWidget {
  @override
  State createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen>
  with AutomaticKeepAliveClientMixin<HistoryScreen>
  implements HistoryNavigator {

  HistoryBloc _bloc;

  final GlobalKey _wordListKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _bloc = HistoryBloc(this);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return StreamBuilder(
      initialData: _bloc.getInitialState(),
      stream: _bloc.observeState(),
      builder: (context, snapshot) => _buildUI(snapshot.data),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _bloc.dispose();
  }

  @override
  bool get wantKeepAlive => true;

  Widget _buildUI(HistoryState state) {
    final appTheme = state.appTheme;

    return WillPopScope(
      onWillPop: () async => !_bloc.handleBackPress(),
      child: Stack(
        children: <Widget>[
          _MainUI(
            appTheme: appTheme,
            bloc: _bloc,
            isWordTab: state.isWordTab,
            words: state.words,
            ideas: state.ideas,
            selectionMode: state.selectionMode,
            selectedWords: state.selectedWords,
            selectedIdeas: state.selectedIdeas,
            wordListKey: _wordListKey,
          ),
          state.isScrimVisible ? Scrim(
            onTap: _bloc.handleBackPress,
          ) : const SizedBox.shrink(),
          state.wordItemDialog.isValid() ? _WordItemDialog(
            appTheme: appTheme,
            bloc: _bloc,
            data: state.wordItemDialog,
          ) : const SizedBox.shrink(),
          state.ideaItemDialog.isValid() ? _IdeaItemDialog(
            appTheme: appTheme,
            bloc: _bloc,
            data: state.ideaItemDialog,
          ) : const SizedBox.shrink(),
          state.isDeleteWordsDialogShown ? AppAlertDialog(
            appTheme: appTheme,
            title: AppLocalizations.of(context).getDeleteItemsTitle(state.selectedWords.length),
            primaryButtonText: AppLocalizations.of(context).delete,
            onPrimaryButtonClicked: _bloc.onConfirmDeleteWordsClicked,
            secondaryButtonText: AppLocalizations.of(context).cancel,
            onSecondaryButtonClicked: _bloc.onCloseDeleteWordsClicked,
          ) : const SizedBox.shrink(),
          state.isDeleteIdeasDialogShown ? AppAlertDialog(
            appTheme: appTheme,
            title: AppLocalizations.of(context).getDeleteItemsTitle(state.selectedIdeas.length),
            primaryButtonText: AppLocalizations.of(context).delete,
            onPrimaryButtonClicked: _bloc.onConfirmDeleteIdeasClicked,
            secondaryButtonText: AppLocalizations.of(context).cancel,
            onSecondaryButtonClicked: _bloc.onCloseDeleteIdeasClicked,
          ) : const SizedBox.shrink(),
          state.isBlockIdeasDialogShown ? AppAlertDialog(
            appTheme: appTheme,
            title: AppLocalizations.of(context).getBlockItemsTitle(state.selectedIdeas.length),
            subtitle: AppLocalizations.of(context).blockIdeaSubtitle,
            primaryButtonText: AppLocalizations.of(context).block,
            onPrimaryButtonClicked: _bloc.onConfirmBlockIdeasClicked,
            secondaryButtonText: AppLocalizations.of(context).cancel,
            onSecondaryButtonClicked: _bloc.onCloseBlockIdeasClicked,
          ) : const SizedBox.shrink(),
          state.isProgressShown ? CenterProgress(
            appTheme: appTheme,
          ) : const SizedBox.shrink(),
        ],
      ),
    );
  }

  @override
  void showTutorial(int phase) {
    if (phase == 4) {
      Tutorial.of(context).showTutorialFour(_wordListRectFinder, () {
        _bloc.onTutorialFourFinished();
      });
    }
  }

  @override
  void hideTutorial() {
    Tutorial.of(context).hide();
  }

  Rect _wordListRectFinder() {
    return Utils.getRect(_wordListKey.currentContext?.findRenderObject());
  }

}

class _MainUI extends StatefulWidget {
  final AppTheme appTheme;
  final HistoryBloc bloc;
  final bool isWordTab;
  final List<Word> words;
  final List<Idea> ideas;
  final SelectionMode selectionMode;
  final Map<Word, bool> selectedWords;
  final Map<Idea, bool> selectedIdeas;
  final Key wordListKey;

  _MainUI({
    @required this.appTheme,
    @required this.bloc,
    @required this.isWordTab,
    @required this.words,
    @required this.ideas,
    @required this.selectionMode,
    @required this.selectedWords,
    @required this.selectedIdeas,
    @required this.wordListKey,
  });

  @override
  State createState() => _MainUIState();

}

class _MainUIState extends State<_MainUI> with SingleTickerProviderStateMixin {

  TabController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TabController(length: 2, vsync: this);
    _controller.addListener(_tabControllerListener);
  }

  void _tabControllerListener() {
    if (_controller.index == 0) {
      widget.bloc.onWordTabClicked();
    } else {
      widget.bloc.onIdeaTabClicked();
    }
  }

  @override
  void dispose() {
    super.dispose();
    _controller.removeListener(_tabControllerListener);
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isWordTab) {
      _controller.index = 0;
    } else {
      _controller.index = 1;
    }

    return Column(
      verticalDirection: VerticalDirection.up,
      children: <Widget>[
        ChildScreenNavigationBar(
          currentChildScreenKey: ChildScreenKey.HISTORY,
          onItemClicked: widget.bloc.onNavigationBarItemClicked,
        ),
        Expanded(
          child: SafeArea(
            bottom: false,
            child: ClipRect(
              child: Column(
                verticalDirection: VerticalDirection.up,
                children: [
                  Expanded(
                    child: TabBarView(
                      controller: _controller,
                      children: [
                        _WordList(
                          key: widget.wordListKey,
                          bloc: widget.bloc,
                          items: widget.words,
                          appTheme: widget.appTheme,
                          isSelectionMode: widget.selectionMode == SelectionMode.WORDS,
                          selectedItems: widget.selectedWords,
                        ),
                        _IdeaList(
                          bloc: widget.bloc,
                          items: widget.ideas,
                          appTheme: widget.appTheme,
                          isSelectionMode: widget.selectionMode == SelectionMode.IDEAS,
                          selectedItems: widget.selectedIdeas,
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: 1,
                    color: widget.appTheme.isDarkTheme ? AppColors.DIVIDER_WHITE : AppColors.DIVIDER_BLACK,
                  ),
                  widget.selectionMode == SelectionMode.NONE ? _TabBar(
                    bloc: widget.bloc,
                    appTheme: widget.appTheme,
                    isWordTab: widget.isWordTab,
                  ) : widget.selectionMode == SelectionMode.WORDS ? _WordsSelectionBar(
                    bloc: widget.bloc,
                    appTheme: widget.appTheme,
                    selectedItems: widget.selectedWords,
                  ) : _IdeasSelectionBar(
                    bloc: widget.bloc,
                    appTheme: widget.appTheme,
                    selectedItems: widget.selectedIdeas,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _TabBar extends StatelessWidget {
  final HistoryBloc bloc;
  final AppTheme appTheme;
  final bool isWordTab;

  _TabBar({
    @required this.bloc,
    @required this.appTheme,
    @required this.isWordTab,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkTheme = appTheme.isDarkTheme;

    return IntrinsicHeight(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minHeight: 56,
        ),
        child: Row(
          children: <Widget>[
            _TabBarItem(
              title: AppLocalizations.of(context).word,
              onTap: bloc.onWordTabClicked,
              isDarkTheme: isDarkTheme,
              isSelected: isWordTab,
            ),
            _TabBarItem(
              title: AppLocalizations.of(context).idea,
              onTap: bloc.onIdeaTabClicked,
              isDarkTheme: isDarkTheme,
              isSelected: !isWordTab,
            ),
          ],
        ),
      ),
    );
  }
}

class _TabBarItem extends StatelessWidget {
  final String title;
  final Function() onTap;
  final bool isDarkTheme;
  final bool isSelected;

  _TabBarItem({
    @required this.title,
    @required this.onTap,
    @required this.isDarkTheme,
    @required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: Container(
          alignment: Alignment.center,
          child: IntrinsicWidth(
            child: Stack(
              children: <Widget>[
                Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Text(
                      title,
                      style: TextStyle(
                        color: isDarkTheme ? AppColors.TEXT_WHITE : AppColors.TEXT_BLACK,
                        fontSize: 20,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                      strutStyle: StrutStyle(
                        fontSize: 20,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                  ),
                ),
                isSelected ? Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    height: 4,
                    color: isDarkTheme ? AppColors.TEXT_WHITE : AppColors.TEXT_BLACK,
                  ),
                ) : const SizedBox.shrink(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _WordsSelectionBar extends StatelessWidget {
  final HistoryBloc bloc;
  final AppTheme appTheme;
  final Map<Word, bool> selectedItems;

  _WordsSelectionBar({
    @required this.bloc,
    @required this.appTheme,
    @required this.selectedItems,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkTheme = appTheme.isDarkTheme;

    return IntrinsicHeight(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minHeight: 56,
        ),
        child: Row(
          children: <Widget>[
            InkWell(
              onTap: () => bloc.onSelectionModeCloseClicked(),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 21, horizontal: 24),
                child: Image.asset(
                  'assets/ic_close.png',
                  color: isDarkTheme ? AppColors.TEXT_WHITE : AppColors.TEXT_BLACK,
                ),
              ),
            ),
            Expanded(
              child: Text(
                AppLocalizations.of(context).getSelectionTitle(selectedItems.length),
                style: TextStyle(
                  color: isDarkTheme ? AppColors.TEXT_WHITE : AppColors.TEXT_BLACK,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                strutStyle: StrutStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            InkWell(
              onTap: () => bloc.onDeleteWordsClicked(),
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Image.asset(
                  'assets/ic_delete.png',
                  color: isDarkTheme ? AppColors.TEXT_WHITE : AppColors.TEXT_BLACK,
                ),
              ),
            ),
            const SizedBox(width: 10),
          ],
        ),
      ),
    );
  }

}

class _IdeasSelectionBar extends StatelessWidget {
  final HistoryBloc bloc;
  final AppTheme appTheme;
  final Map<Idea, bool> selectedItems;

  _IdeasSelectionBar({
    @required this.bloc,
    @required this.appTheme,
    @required this.selectedItems,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkTheme = appTheme.isDarkTheme;

    return ConstrainedBox(
      constraints: BoxConstraints(
        minHeight: 56,
      ),
      child: Row(
        children: <Widget>[
          InkWell(
            onTap: () => bloc.onSelectionModeCloseClicked(),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 21, horizontal: 24),
              child: Image.asset(
                'assets/ic_close.png',
                color: isDarkTheme ? AppColors.TEXT_WHITE : AppColors.TEXT_BLACK,
              ),
            ),
          ),
          Expanded(
            child: Text(
              AppLocalizations.of(context).getSelectionTitle(selectedItems.length),
              style: TextStyle(
                color: isDarkTheme ? AppColors.TEXT_WHITE : AppColors.TEXT_BLACK,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
              strutStyle: StrutStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          InkWell(
            onTap: () => bloc.onBlockIdeasClicked(),
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Image.asset(
                'assets/ic_block.png',
                color: isDarkTheme ? AppColors.TEXT_WHITE : AppColors.TEXT_BLACK,
              ),
            ),
          ),
          InkWell(
            onTap: () => bloc.onDeleteIdeasClicked(),
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Image.asset(
                'assets/ic_delete.png',
                color: isDarkTheme ? AppColors.TEXT_WHITE : AppColors.TEXT_BLACK,
              ),
            ),
          ),
          const SizedBox(width: 10),
        ],
      ),
    );
  }

}


class _WordList extends StatelessWidget {
  final HistoryBloc bloc;
  final List<Word> items;
  final AppTheme appTheme;
  final bool isSelectionMode;
  final Map<Word, bool> selectedItems;

  _WordList({
    Key key,
    @required this.bloc,
    @required this.items,
    @required this.appTheme,
    @required this.isSelectionMode,
    @required this.selectedItems,
  }): super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDarkTheme = appTheme.isDarkTheme;

    return items.length > 0 ? ListView.builder(
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        if (isSelectionMode) {
          return _SelectionWordItem(
            bloc: bloc,
            item: item,
            isDarkTheme: isDarkTheme,
            isSelected: selectedItems.containsKey(item),
          );
        } else {
          return _WordItem(
            bloc: bloc,
            item: item,
            isDarkTheme: isDarkTheme,
          );
        }
      },
    ) : Center(
      child: Text(
        AppLocalizations.of(context).noHistory,
        style: TextStyle(
          fontSize: 18,
          color: isDarkTheme ? AppColors.TEXT_WHITE : AppColors.TEXT_BLACK,
        ),
        strutStyle: StrutStyle(
          fontSize: 18,
        ),
      ),
    );
  }
}

class _SelectionWordItem extends StatelessWidget {
  final HistoryBloc bloc;
  final Word item;
  final bool isDarkTheme;
  final bool isSelected;

  _SelectionWordItem({
    @required this.bloc,
    @required this.item,
    @required this.isDarkTheme,
    @required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Material(
          color: isSelected ? (isDarkTheme ? AppColors.SELECTION_WHITE : AppColors.SELECTION_BLACK)
            : Colors.transparent,
          child: InkWell(
            onTap: () => bloc.onWordItemClicked(item),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: Image.asset(
                      isSelected ? 'assets/ic_radio_fill.png' : 'assets/ic_radio.png',
                      color: isDarkTheme ? AppColors.TEXT_WHITE : AppColors.TEXT_BLACK,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      child: Text(
                        item.title,
                        style: TextStyle(
                          fontSize: 18,
                          color: isDarkTheme ? AppColors.TEXT_WHITE : AppColors.TEXT_BLACK,
                        ),
                        strutStyle: StrutStyle(
                          fontSize: 18,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                  Text(
                    item.dateMillis.toYearMonthDateString(),
                    style: TextStyle(
                      fontSize: 12,
                      color: isDarkTheme ? AppColors.TEXT_WHITE_LIGHT : AppColors.TEXT_BLACK_LIGHT,
                    ),
                    strutStyle: StrutStyle(
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Container(
            height: 1,
            color: isDarkTheme ? AppColors.DIVIDER_WHITE : AppColors.DIVIDER_BLACK,
          ),
        ),
      ],
    );
  }
}

class _WordItem extends StatelessWidget {
  final HistoryBloc bloc;
  final Word item;
  final bool isDarkTheme;

  _WordItem({
    @required this.bloc,
    @required this.item,
    @required this.isDarkTheme,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        InkWell(
          onTap: () => bloc.onWordItemClicked(item),
          onLongPress: () => bloc.onWordItemLongPressed(item),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 24,),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Text(
                    item.title,
                    style: TextStyle(
                      fontSize: 18,
                      color: isDarkTheme ? AppColors.TEXT_WHITE : AppColors.TEXT_BLACK,
                    ),
                    strutStyle: StrutStyle(
                      fontSize: 18,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Text(
                  item.dateMillis.toYearMonthDateString(),
                  style: TextStyle(
                    fontSize: 12,
                    color: isDarkTheme ? AppColors.TEXT_WHITE_LIGHT : AppColors.TEXT_BLACK_LIGHT,
                  ),
                  strutStyle: StrutStyle(
                    fontSize: 12,
                  ),
                )
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Container(
            height: 1,
            color: isDarkTheme ? AppColors.DIVIDER_WHITE : AppColors.DIVIDER_BLACK,
          ),
        ),
      ],
    );
  }
}

class _IdeaList extends StatelessWidget {
  final HistoryBloc bloc;
  final List<Idea> items;
  final AppTheme appTheme;
  final bool isSelectionMode;
  final Map<Idea, bool> selectedItems;

  _IdeaList({
    @required this.bloc,
    @required this.items,
    @required this.appTheme,
    @required this.isSelectionMode,
    @required this.selectedItems,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkTheme = appTheme.isDarkTheme;

    return items.length > 0 ? ListView.builder(
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        if (isSelectionMode) {
          return _SelectionIdeaItem(
            bloc: bloc,
            item: item,
            isDarkTheme: isDarkTheme,
            isSelected: selectedItems.containsKey(item),
          );
        } else {
          return _IdeaItem(
            bloc: bloc,
            item: item,
            isDarkTheme: isDarkTheme,
          );
        }
      },
    ) : Center(
      child: Text(
        AppLocalizations.of(context).noHistory,
        style: TextStyle(
          fontSize: 18,
          color: isDarkTheme ? AppColors.TEXT_WHITE : AppColors.TEXT_BLACK,
        ),
        strutStyle: StrutStyle(
          fontSize: 18,
        ),
      ),
    );
  }
}

class _SelectionIdeaItem extends StatelessWidget {
  final HistoryBloc bloc;
  final Idea item;
  final bool isDarkTheme;
  final bool isSelected;

  _SelectionIdeaItem({
    @required this.bloc,
    @required this.item,
    @required this.isDarkTheme,
    @required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Material(
          color: isSelected ? (isDarkTheme ? AppColors.SELECTION_WHITE : AppColors.SELECTION_BLACK)
            : Colors.transparent,
          child: InkWell(
            onTap: () => bloc.onIdeaItemClicked(item),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: Image.asset(
                      isSelected ? 'assets/ic_radio_fill.png' : 'assets/ic_radio.png',
                      color: isDarkTheme ? AppColors.TEXT_WHITE : AppColors.TEXT_BLACK,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      child: Text(
                        item.title,
                        style: TextStyle(
                          fontSize: 18,
                          color: isDarkTheme ? AppColors.TEXT_WHITE : AppColors.TEXT_BLACK,
                        ),
                        strutStyle: StrutStyle(
                          fontSize: 18,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                  Text(
                    item.dateMillis.toYearMonthDateString(),
                    style: TextStyle(
                      fontSize: 12,
                      color: isDarkTheme ? AppColors.TEXT_WHITE_LIGHT : AppColors.TEXT_BLACK_LIGHT,
                    ),
                    strutStyle: StrutStyle(
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Container(
            height: 1,
            color: isDarkTheme ? AppColors.DIVIDER_WHITE : AppColors.DIVIDER_BLACK,
          ),
        ),
      ],
    );
  }
}

class _IdeaItem extends StatelessWidget {
  final HistoryBloc bloc;
  final Idea item;
  final bool isDarkTheme;

  _IdeaItem({
    @required this.bloc,
    @required this.item,
    @required this.isDarkTheme,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        InkWell(
          onTap: () => bloc.onIdeaItemClicked(item),
          onLongPress: () => bloc.onIdeaItemLongPressed(item),
          child: Row(
            children: <Widget>[
              const SizedBox(width: 8,),
              InkWell(
                onTap: () => bloc.onIdeaItemFavoriteClicked(item),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Image.asset(
                    item.isFavorite ? 'assets/ic_star_fill.png' : 'assets/ic_star_stroke.png',
                    color: isDarkTheme ? AppColors.TEXT_WHITE : AppColors.TEXT_BLACK,
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  child: Text(
                    item.title,
                    style: TextStyle(
                      fontSize: 18,
                      color: isDarkTheme ? AppColors.TEXT_WHITE : AppColors.TEXT_BLACK,
                    ),
                    strutStyle: StrutStyle(
                      fontSize: 18,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
              Text(
                item.dateMillis.toYearMonthDateString(),
                style: TextStyle(
                  fontSize: 12,
                  color: isDarkTheme ? AppColors.TEXT_WHITE_LIGHT : AppColors.TEXT_BLACK_LIGHT,
                ),
                strutStyle: StrutStyle(
                  fontSize: 12,
                ),
              ),
              const SizedBox(width: 24,),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Container(
            height: 1,
            color: isDarkTheme ? AppColors.DIVIDER_WHITE : AppColors.DIVIDER_BLACK,
          ),
        ),
      ],
    );
  }
}

class _WordItemDialog extends StatelessWidget {
  final AppTheme appTheme;
  final HistoryBloc bloc;
  final WordItemDialog data;

  _WordItemDialog({
    @required this.appTheme,
    @required this.bloc,
    @required this.data,
  });

  @override
  Widget build(BuildContext context) {
    if (data.type == WordItemDialog.TYPE_LIST) {
      return AppChoiceListDialog(
        title: data.word.title,
        items: [
          ChoiceItem(
            AppLocalizations.of(context).delete,
              () => bloc.onWordItemDialogDeleteClicked(data.word),
          ),
          ChoiceItem(
            AppLocalizations.of(context).close,
            bloc.onWordItemDialogCloseClicked,
          ),
        ],
      );
    } else {
      return AppAlertDialog(
        appTheme: appTheme,
        title: AppLocalizations.of(context).getConfirmDeleteTitle(data.word.title),
        primaryButtonText: AppLocalizations.of(context).delete,
        onPrimaryButtonClicked: () => bloc.onConfirmDeleteWordClicked(data.word),
        secondaryButtonText: AppLocalizations.of(context).cancel,
        onSecondaryButtonClicked: bloc.onWordItemDialogCloseClicked,
      );
    }
  }
}

class _IdeaItemDialog extends StatelessWidget {
  final AppTheme appTheme;
  final HistoryBloc bloc;
  final IdeaItemDialog data;

  _IdeaItemDialog({
    @required this.appTheme,
    @required this.bloc,
    @required this.data,
  });

  @override
  Widget build(BuildContext context) {
    if (data.type == IdeaItemDialog.TYPE_LIST) {
      return AppChoiceListDialog(
        title: data.idea.title,
        items: [
          ChoiceItem(
            AppLocalizations.of(context).delete,
              () => bloc.onIdeaItemDialogDeleteClicked(data.idea),
          ),
          ChoiceItem(
            AppLocalizations.of(context).block,
              () => bloc.onIdeaItemDialogBlockClicked(data.idea),
          ),
          ChoiceItem(
            AppLocalizations.of(context).close,
            bloc.onIdeaItemDialogCloseClicked,
          ),
        ],
      );
    } else if (data.type == IdeaItemDialog.TYPE_CONFIRM_DELETE) {
      return AppAlertDialog(
        appTheme: appTheme,
        title: AppLocalizations.of(context).getConfirmDeleteTitle(data.idea.title),
        primaryButtonText: AppLocalizations.of(context).delete,
        onPrimaryButtonClicked: () => bloc.onConfirmDeleteIdeaClicked(data.idea),
        secondaryButtonText: AppLocalizations.of(context).cancel,
        onSecondaryButtonClicked: bloc.onIdeaItemDialogCloseClicked,
      );
    } else {
      return AppAlertDialog(
        appTheme: appTheme,
        title: AppLocalizations.of(context).getConfirmBlockTitle(data.idea.title),
        subtitle: AppLocalizations.of(context).blockIdeaSubtitle,
        primaryButtonText: AppLocalizations.of(context).block,
        onPrimaryButtonClicked: () => bloc.onConfirmBlockIdeaClicked(data.idea),
        secondaryButtonText: AppLocalizations.of(context).cancel,
        onSecondaryButtonClicked: bloc.onIdeaItemDialogCloseClicked,
      );
    }
  }
}
