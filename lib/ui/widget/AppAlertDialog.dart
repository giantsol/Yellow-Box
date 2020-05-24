
import 'package:flutter/material.dart';
import 'package:yellow_box/AppColors.dart';
import 'package:yellow_box/entity/AppTheme.dart';

class AppAlertDialog extends StatelessWidget {
  final AppTheme appTheme;
  final String title;
  final String subtitle;
  final String primaryButtonText;
  final Function() onPrimaryButtonClicked;
  final String secondaryButtonText;
  final Function() onSecondaryButtonClicked;

  AppAlertDialog({
    @required this.appTheme,
    @required this.title,
    this.subtitle = '',
    @required this.primaryButtonText,
    @required this.onPrimaryButtonClicked,
    @required this.secondaryButtonText,
    @required this.onSecondaryButtonClicked,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              color: AppColors.BACKGROUND_WHITE,
            ),
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                _Title(title),
                _Subtitle(subtitle),
                const SizedBox(height: 20),
                _ButtonBar(
                  appTheme: appTheme,
                  primaryButtonText: primaryButtonText,
                  onPrimaryButtonClicked: onPrimaryButtonClicked,
                  secondaryButtonText: secondaryButtonText,
                  onSecondaryButtonClicked: onSecondaryButtonClicked,
                ),
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
    return Text(
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
    );
  }
}

class _Subtitle extends StatelessWidget {
  final String subtitle;

  _Subtitle(this.subtitle);

  @override
  Widget build(BuildContext context) {
    return subtitle.isNotEmpty ? Padding(
      padding: const EdgeInsets.only(top: 20),
      child: Text(
        subtitle,
        style: TextStyle(
          color: AppColors.TEXT_BLACK,
          fontSize: 12,
        ),
        strutStyle: StrutStyle(
          fontSize: 12,
        ),
      ),
    ) : const SizedBox.shrink();
  }
}

class _ButtonBar extends StatelessWidget {
  final AppTheme appTheme;
  final String primaryButtonText;
  final Function() onPrimaryButtonClicked;
  final String secondaryButtonText;
  final Function() onSecondaryButtonClicked;

  _ButtonBar({
    @required this.appTheme,
    @required this.primaryButtonText,
    @required this.onPrimaryButtonClicked,
    @required this.secondaryButtonText,
    @required this.onSecondaryButtonClicked,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Material(
            color: AppColors.BACKGROUND_WHITE,
            borderRadius: BorderRadius.circular(4),
            child: InkWell(
              borderRadius: BorderRadius.circular(4),
              onTap: onSecondaryButtonClicked,
              child: Container(
                alignment: Alignment.center,
                constraints: BoxConstraints(
                  minWidth: 96,
                ),
                padding: const EdgeInsets.symmetric(vertical: 11),
                child: Text(
                  secondaryButtonText,
                  style: TextStyle(
                    color: AppColors.TEXT_BLACK_LIGHT,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                  strutStyle: StrutStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 4),
          Material(
            color: appTheme.darkColor,
            borderRadius: BorderRadius.circular(4),
            child: InkWell(
              borderRadius: BorderRadius.circular(4),
              onTap: onPrimaryButtonClicked,
              child: Container(
                alignment: Alignment.center,
                constraints: BoxConstraints(
                  minWidth: 96,
                ),
                padding: const EdgeInsets.symmetric(vertical: 11),
                child: Text(
                  primaryButtonText,
                  style: TextStyle(
                    color: AppColors.TEXT_WHITE,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                  strutStyle: StrutStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
