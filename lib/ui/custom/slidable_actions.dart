import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:simple_todo_flutter/resources/colors.dart';
import 'package:simple_todo_flutter/resources/dimens.dart';
import 'package:simple_todo_flutter/resources/icons/icons.dart';

class DeleteAction extends StatelessWidget {
  final VoidCallback onTap;

  const DeleteAction({Key? key, required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _Action(
      onTap: onTap,
      icon: IconsC.delete,
      text: "action.delete".tr(),
      color: context.error,
    );
  }
}

class CompleteAction extends StatelessWidget {
  final VoidCallback onTap;

  const CompleteAction({Key? key, required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _Action(
      onTap: onTap,
      icon: IconsC.check,
      text: "action.complete".tr(),
      color: context.success,
    );
  }
}

class _Action extends StatelessWidget {
  final VoidCallback onTap;
  final IconData icon;
  final String text;
  final Color color;

  const _Action(
      {Key? key,
      required this.onTap,
      required this.icon,
      required this.text,
      required this.color})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
        vertical: Margin.small_very.h,
        horizontal: Margin.small_very.w,
      ),
      child: SlideAction(
        closeOnTap: true,
        decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.all(Radiuss.small_smaller)),
        onTap: onTap,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Icon(
                icon,
                color: context.onPrimary,
              ),
              SizedBox(height: Margin.small_half.h),
              Text(
                text,
                style: TextStyle(
                  color: context.onPrimary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
