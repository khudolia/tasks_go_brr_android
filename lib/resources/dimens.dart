import 'package:flutter/material.dart';
import 'package:simple_todo_flutter/resources/colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Dimens {
  static const dev_screen_size = Size(360, 732);

  static final bottom_app_bar_height = 64.0.h;
  static const app_bar_height = 64.0;
  static final days_small_bar_height = 90.0.h;

  static final text_normal = 18.0.sp;
}

class Margin {
  static const big = 36.0;
  static const middle = 18.0;
  static const small = 9.0;
}
class Paddings {
  static const big = 36.0;
  static const middle = 18.0;
  static const small = 9.0;
}


class Durations {
  static const milliseconds_short = Duration(milliseconds: 200);
  static const milliseconds_middle = Duration(milliseconds: 400);
}

class Radiuss {
  static final circle = Radius.circular(1000.0);
  static final middle = Radius.circular(30.0.r);
  static final small = Radius.circular(20.0.r);
}

class Shadows {

  static BoxShadow middle(BuildContext context) => BoxShadow(
    color: context.shadow.withOpacity(0.5),
    spreadRadius: 3,
    blurRadius: 5,
    offset: Offset(0, 3),
  );

  static BoxShadow small(BuildContext context) => BoxShadow(
    color: Colors.grey.withOpacity(0.5),
    spreadRadius: 2,
    blurRadius: 2,
    offset: Offset(1, 2),
  );

  static BoxShadow smallAround(BuildContext context) => BoxShadow(
    color: Colors.grey.withOpacity(0.5),
    spreadRadius: 1,
    blurRadius: 2,
    offset: Offset(1, 2),
  );


}