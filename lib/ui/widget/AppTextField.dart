
import 'package:flutter/material.dart';
import 'package:yellow_box/AppColors.dart';

// Wraps framework's TextField because it itself doesn't work very well with Bloc and State pattern.
// Specifically, we keep track of TextEditingController here.
class AppTextField extends StatefulWidget {
  FocusNode? focusNode = null;
  final String text;
  final double textSize;
  final Color textColor;
  final String hintText;
  final double hintTextSize;
  final Color hintTextColor;
  final ValueChanged<String?> onChanged;
  final int minLines;
  final int maxLines;
  final void Function() onEditingComplete;
  TextInputType? keyboardType = null;
  final Color cursorColor;
  final bool enabled;
  final bool autoFocus;

  AppTextField({
    Key? key,
    this.focusNode,
    required this.text,
    required this.textSize,
    required this.textColor,
    required this.hintText,
    required this.hintTextSize,
    required this.hintTextColor,
    required this.onChanged,
    this.minLines = 1,
    this.maxLines = 1,
    required this.onEditingComplete,
    this.keyboardType,
    this.cursorColor = AppColors.TEXT_BLACK,
    this.enabled = true,
    this.autoFocus = false,
  }): super(key: key);

  @override
  State createState() {
    return _AppTextFieldState();
  }
}

class _AppTextFieldState extends State<AppTextField> {
  late TextEditingValue? _value = null;

  @override
  Widget build(BuildContext context) {
    final controller = TextEditingController.fromValue(
      _value?.copyWith(text: widget.text),
    );

    controller.addListener(() {
      _value = controller.value;
      if (widget.onChanged != null) {
        widget.onChanged(_value?.text);
      }
    });

    return Theme(
      data: Theme.of(context).copyWith(splashColor: Colors.transparent),
      child: TextField(
        focusNode: widget.focusNode,
        controller: controller,
        style: TextStyle(
          fontSize: widget.textSize,
          color: widget.textColor,
        ),
        minLines: widget.minLines,
        maxLines: widget.maxLines,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.all(0),
          border: InputBorder.none,
          isDense: true,
          hintText: widget.hintText,
          hintStyle: TextStyle(
            fontSize: widget.hintTextSize,
            color: widget.hintTextColor,
          )
        ),
        textAlign: TextAlign.left,
        onEditingComplete: widget.onEditingComplete,
        keyboardType: widget.keyboardType,
        textCapitalization: TextCapitalization.sentences,
        cursorColor: widget.cursorColor,
        enabled: widget.enabled,
        autofocus: widget.autoFocus,
      ),
    );
  }
}