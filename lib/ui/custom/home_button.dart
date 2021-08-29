import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tasks_go_brr/resources/colors.dart';
import 'package:tasks_go_brr/resources/dimens.dart';
import 'package:tasks_go_brr/resources/icons/icons.dart';
import 'package:tasks_go_brr/ui/custom/animated_gesture_detector.dart';

class HomeButton extends StatefulWidget {
  final double scale;
  final VoidCallback onTap;

  const HomeButton({Key? key, required this.scale, required this.onTap})
      : super(key: key);

  @override
  _HomeButtonState createState() => _HomeButtonState();
}

class _HomeButtonState extends State<HomeButton> {
  @override
  Widget build(BuildContext context) {
    return Transform.scale(
      scale: widget.scale,
      child: AnimatedGestureDetector(
          onTap: widget.onTap,
          child: Container(
            margin: EdgeInsets.only(
              right: Margin.middle.h,
              left: Margin.middle.h,
            ),
            decoration: BoxDecoration(
              color: context.surface,
              borderRadius: BorderRadius.all(Radiuss.circle),
            ),
            padding: EdgeInsets.symmetric(
                vertical: Paddings.small_bigger,
                horizontal: Paddings.small_bigger),
            child: Icon(
              IconsC.home,
              size: Dimens.icon_size,
              color: context.onSurface,
            ),
          )),
    );
  }
}
