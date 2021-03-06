
import 'package:flutter/material.dart';
import 'package:yellow_box/AppColors.dart';

class ChoiceItem {
  final String title;
  final Function() onClick;

  const ChoiceItem(this.title, this.onClick);
}

class AppChoiceListDialog extends StatelessWidget {
  final String title;
  final List<ChoiceItem> items;

  AppChoiceListDialog({
    @required this.title,
    @required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              color: AppColors.BACKGROUND_WHITE,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                _Title(title),
                const SizedBox(height: 6,),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: List.generate(items.length, (i) {
                    return _ChoiceItem(items[i]);
                  }),
                ),
                const SizedBox(height: 6,),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Title extends StatelessWidget {
  final String title;

  _Title(this.title);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, top: 20),
      child: Text(
        title,
        style: TextStyle(
          color: AppColors.TEXT_BLACK,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
        strutStyle: StrutStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}

class _ChoiceItem extends StatelessWidget {
  final ChoiceItem item;

  _ChoiceItem(this.item);

  @override
  Widget build(BuildContext context) {
    return Material(
      child: InkWell(
        onTap: item.onClick,
        child: Container(
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20,),
          child: Text(
            item.title,
            style: TextStyle(
              color: AppColors.TEXT_BLACK,
              fontSize: 12,
            ),
            strutStyle: StrutStyle(
              fontSize: 12,
            ),
          ),
        ),
      ),
    );
  }
}
