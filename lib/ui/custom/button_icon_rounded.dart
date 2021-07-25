import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:simple_todo_flutter/resources/colors.dart';
import 'package:simple_todo_flutter/resources/dimens.dart';
import 'package:simple_todo_flutter/ui/custom/animated_gesture_detector.dart';

class ButtonIconRounded extends StatelessWidget {
  Color? backgroundColor;
  Color? iconColor;
  final IconData? icon;
  final VoidCallback onTap;
  final EdgeInsets padding;
  final String? text;
  Color? textColor;

  ButtonIconRounded(
      {Key? key, this.backgroundColor,
        this.iconColor,
        this.icon,
      required this.onTap,
      this.padding = const EdgeInsets.all(0.0),
      this.text,
      this.textColor,})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    backgroundColor = backgroundColor ?? context.primary;
    iconColor = iconColor ?? context.surface;
    textColor = textColor ?? context.textDefault;

    return AnimatedGestureDetector(
      child: Container(
        padding: padding,
        decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.all(Radiuss.small_smaller),
          boxShadow: [Shadows.smallAround(context),],),
        child: text != null && text!.isNotEmpty ? Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            icon != null ? Icon(
              icon,
              color: iconColor,
            ) : Container(),
            icon != null ? SizedBox(
              width: Margin.small.w,
            ) : Container(),
            Text(
                text!,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: textColor,
              ),
            ),
          ],
        ) : icon != null ? Icon(
          icon,
          color: iconColor,
        ) : Container(),
      ),
      onTap: onTap,
    );
  }
}
