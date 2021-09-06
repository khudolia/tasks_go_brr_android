import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tasks_go_brr/resources/colors.dart';
import 'package:tasks_go_brr/resources/dimens.dart';
import 'package:tasks_go_brr/ui/custom/animated_gesture_detector.dart';

class DeleteButton extends StatelessWidget {
  final VoidCallback onTap;
  const DeleteButton({Key? key, required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedGestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: context.error,
          borderRadius: BorderRadius.all(Radiuss.small_smaller),
        ),
        padding: EdgeInsets.symmetric(
            vertical: Paddings.small.h,
            horizontal: Paddings.middle.w
        ),
        child: Text(
          "action.delete".tr(),
          style: TextStyle(
              color: context.onPrimary,
              fontWeight: FontWeight.bold,
              fontSize: Dimens.text_normal
          ),
        ),
      ),
    );
  }
}
