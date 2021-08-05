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
    return Container(
      margin: EdgeInsets.symmetric(
        vertical: Margin.small_very.h,
        horizontal: Margin.small_very.w,
      ),
      child: SlideAction(
        closeOnTap: true,
        decoration: new BoxDecoration(
            color: context.error,
            borderRadius: new BorderRadius.all(
                Radiuss.small_smaller)),
        onTap: onTap,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Icon(
                IconsC.delete,
                color: context.surface,
              ),
              SizedBox(height: Margin.small_half.h),
              Text(
                "action.delete".tr(),
                style: TextStyle(
                  color: context.textInversed,
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

class CompleteAction extends StatelessWidget {
  final VoidCallback onTap;

  const CompleteAction({Key? key, required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
        vertical: Margin.small_very.h,
        horizontal: Margin.small_very.w,
      ),
      child: SlideAction(
        closeOnTap: true,
        decoration: new BoxDecoration(
            color: context.success,
            borderRadius: new BorderRadius.all(
                Radiuss.small_smaller)),
        onTap: onTap,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Icon(
                IconsC.check,
                color: context.surface,
              ),
              SizedBox(height: Margin.small_half.h),
              Text(
                "action.complete".tr(),
                style: TextStyle(
                  color: context.textInversed,
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

