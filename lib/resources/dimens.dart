import 'package:flutter/material.dart';
import 'package:simple_todo_flutter/resources/colors.dart';

class Dimens {
  static const bottom_app_bar_height = 64.0;

  static const text_normal = 18.0;
}

class Margin {
  static const big = 36.0;
  static const middle = 18.0;
  static const small = 9.0;
}

class Durations {
  static const milliseconds_short = Duration(milliseconds: 200);
  static const milliseconds_middle = Duration(milliseconds: 400);
}

class Radiuss {
  static const middle = Radius.circular(30.0);
  static const small = Radius.circular(20.0);
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