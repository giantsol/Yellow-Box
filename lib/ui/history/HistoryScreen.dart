
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:yellow_box/AppColors.dart';
import 'package:yellow_box/Localization.dart';
import 'package:yellow_box/entity/AppTheme.dart';
import 'package:yellow_box/entity/ChildScreenKey.dart';
import 'package:yellow_box/entity/Combination.dart';
import 'package:yellow_box/entity/NavigationBarItem.dart';
import 'package:yellow_box/entity/Word.dart';
import 'package:yellow_box/ui/history/HistoryBloc.dart';
import 'package:yellow_box/ui/history/HistoryState.dart';
import 'package:yellow_box/IntExtension.dart';

class HistoryScreen extends StatefulWidget {

  @override
  State createState() => _HistoryScreenState();

}

class _HistoryScreenState extends State<HistoryScreen> {
  HistoryBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = HistoryBloc();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      initialData: _bloc.getInitialState(),
      stream: _bloc.observeState(),
      builder: (context, snapshot) {
        return _buildUI(snapshot.data);
      }
    );
  }

  @override
  void dispose() {
    super.dispose();
    _bloc.dispose();
  }

  Widget _buildUI(HistoryState state) {
    final appTheme = state.appTheme;
    final isScrimVisible = false;

    return WillPopScope(
      onWillPop: () async => !_bloc.handleBackPress(),
      child: Stack(
        children: <Widget>[
          _MainUI(
            appTheme: appTheme,
            bloc: _bloc,
            isWordTab: state.isWordTab,
            words: state.words,
            combinations: state.combinations,
          ),
          isScrimVisible ? _Scrim() : const SizedBox.shrink(),
        ],
      ),
    );
  }
}

class _MainUI extends StatelessWidget {
  final AppTheme appTheme;
  final HistoryBloc bloc;
  final bool isWordTab;
  final List<Word> words;
  final List<Combination> combinations;

  _MainUI({
    @required this.appTheme,
    @required this.bloc,
    @required this.isWordTab,
    @required this.words,
    @required this.combinations,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        verticalDirection: VerticalDirection.up,
        children: <Widget>[
          _NavigationBar(
            bloc: bloc,
          ),
          isWordTab ? _WordList(
            bloc: bloc,
            items: words,
            appTheme: appTheme,
          ) : _CombinationList(
            bloc: bloc,
            items: combinations,
            appTheme: appTheme,
          ),
          _TabBar(
            bloc: bloc,
            appTheme: appTheme,
            isWordTab: isWordTab,
          ),
        ],
      ),
    );
  }
}

class _NavigationBar extends StatelessWidget {
  final HistoryBloc bloc;

  _NavigationBar({
    @required this.bloc,
  });

  @override
  Widget build(BuildContext context) {
    final items = NavigationBarItem.ITEMS;
    return Container(
      decoration: BoxDecoration(
        color: AppColors.BACKGROUND_WHITE,
        boxShadow: [
          BoxShadow(
            color: AppColors.SHADOW,
            offset: Offset(0, -1),
            blurRadius: 4,
          ),
        ],
      ),
      child: Row(
        children: List.generate(items.length, (index) {
          final item = items[index];
          return Expanded(
            child: Material(
              child: InkWell(
                onTap: () => bloc.onNavigationBarItemClicked(item),
                child: Container(
                  height: 60,
                  alignment: Alignment.center,
                  child: Image.asset(item.iconPath,
                    width: 24,
                    height: 24,
                    color: item.key == ChildScreenKey.HISTORY ? AppColors.TEXT_BLACK : AppColors.TEXT_BLACK_LIGHT,
                  ),
                ),
              ),
            ),
          );
        }),
      ),
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
      child: Stack(
        children: <Widget>[
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: 1,
              color: isDarkTheme ? AppColors.DIVIDER_WHITE : AppColors.DIVIDER_BLACK,
            ),
          ),
          Row(
            children: <Widget>[
              Expanded(
                child: InkWell(
                  onTap: () => bloc.onWordTabClicked(),
                  child: Container(
                    constraints: BoxConstraints(
                      minHeight: 56,
                    ),
                    alignment: Alignment.center,
                    child: IntrinsicWidth(
                      child: Stack(
                        children: <Widget>[
                          Center(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 8),
                              child: Text(
                                AppLocalizations.of(context).word,
                                style: TextStyle(
                                  color: isDarkTheme ? AppColors.TEXT_WHITE : AppColors.TEXT_BLACK,
                                  fontSize: 20,
                                  fontWeight: isWordTab ? FontWeight.bold : FontWeight.normal,
                                ),
                                strutStyle: StrutStyle(
                                  fontSize: 20,
                                  fontWeight: isWordTab ? FontWeight.bold : FontWeight.normal,
                                ),
                              ),
                            ),
                          ),
                          isWordTab ? Align(
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
              ),
              Expanded(
                child: InkWell(
                  onTap: () => bloc.onCombinationTabClicked(),
                  child: Container(
                    constraints: BoxConstraints(
                      minHeight: 56,
                    ),
                    alignment: Alignment.center,
                    child: IntrinsicWidth(
                      child: Stack(
                        children: <Widget>[
                          Center(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 8),
                              child: Text(
                                AppLocalizations.of(context).combination,
                                style: TextStyle(
                                  color: isDarkTheme ? AppColors.TEXT_WHITE : AppColors.TEXT_BLACK,
                                  fontSize: 20,
                                  fontWeight: !isWordTab ? FontWeight.bold : FontWeight.normal,
                                ),
                                strutStyle: StrutStyle(
                                  fontSize: 20,
                                  fontWeight: !isWordTab ? FontWeight.bold : FontWeight.normal,
                                ),
                              ),
                            ),
                          ),
                          !isWordTab ? Align(
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
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _WordList extends StatelessWidget {
  final HistoryBloc bloc;
  final List<Word> items;
  final AppTheme appTheme;

  _WordList({
    @required this.bloc,
    @required this.items,
    @required this.appTheme,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkTheme = appTheme.isDarkTheme;

    return Expanded(
      child: items.length > 0 ? ListView.builder(
        itemCount: items.length,
        itemBuilder: (context, index) {
          return _WordItem(
            bloc: bloc,
            item: items[index],
            isDarkTheme: isDarkTheme,
          );
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
      ),
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
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 24,),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Text(
                    item.word,
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

class _CombinationList extends StatelessWidget {
  final HistoryBloc bloc;
  final List<Combination> items;
  final AppTheme appTheme;

  _CombinationList({
    @required this.bloc,
    @required this.items,
    @required this.appTheme,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkTheme = appTheme.isDarkTheme;

    return Expanded(
      child: items.length > 0 ? ListView.builder(
        itemCount: items.length,
        itemBuilder: (context, index) {
          return _CombinationItem(
            bloc: bloc,
            item: items[index],
            isDarkTheme: isDarkTheme,
          );
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
      ),
    );
  }
}

class _CombinationItem extends StatelessWidget {
  final HistoryBloc bloc;
  final Combination item;
  final bool isDarkTheme;

  _CombinationItem({
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
          onTap: () => bloc.onCombinationItemClicked(item),
          child: Row(
            children: <Widget>[
              const SizedBox(width: 8,),
              InkWell(
                onTap: () => bloc.onCombinationItemFavoriteClicked(item),
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
                    item.combination,
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



class _Scrim extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.SCRIM,
    );
  }
}
