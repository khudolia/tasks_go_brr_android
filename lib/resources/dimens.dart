import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Dimens {
  static const dev_screen_size = Size(360, 732);

  static double getStatusBarHeight(BuildContext context) =>
      MediaQuery.of(context).padding.top;

  static final bottom_app_bar_height = 64.0.h;
  static final app_bar_height = 68.0.h;
  static const chart_bar_width = 22.0;
  static const avatar_photo_size = 86.0;
  static const avatar_photo_size_middle = 124.0;
  static const radio_button_size = 12.0;

  static final top_curve_height_2 = 194.5.h;
  static final top_curve_height_4 = 252.h;

  static final text_small = 10.0.sp;
  static final text_small_bigger = 14.0.sp;
  static final text_normal = 18.0.sp;
  static final text_normal_smaller = 16.0.sp;
  static final text_normal_bigger = 20.0.sp;
  static final text_big = 30.0.sp;
  static final text_big_smaller = 25.0.sp;

  static final fab_size = 56.0.w;
  static final quiestion_button_size = 28.0.w;

  static final icon_size = 24.0.w;
  static final app_icon_size = 140.0.w;
  static final app_icon_size_big = 160.0.w;
}

class Margin {
  static const big = 36.0;
  static const middle = 18.0;
  static const middle_smaller = 14.0;
  static const small = 9.0;
  static const small_half = 4.5;
  static const small_very = 1.0;
}

class Borders {
  static const small = 2.0;
}

class Paddings {
  static const big = 36.0;
  static const big_smaller = 24.0;
  static const middle_bigger = 20.0;
  static const middle = 18.0;
  static const middle_smaller = 14.0;
  static const small_bigger = 12.0;
  static const small = 9.0;
  static const small_half = 4.5;
}

class Durations {
  static const milliseconds_short = Duration(milliseconds: 200);
  static const milliseconds_middle = Duration(milliseconds: 400);

  static const handle_short = Duration(milliseconds: 100);
}

class Radiuss {
  static final circle = Radius.circular(1000.0);
  static final middle = Radius.circular(30.0.r);
  static final small = Radius.circular(20.0.r);
  static final small_smaller = Radius.circular(15.0.r);
  static final small_very = Radius.circular(10.0.r);
  static final zero = Radius.circular(0.0);
}

class Blurs {
  static final middle = ImageFilter.blur(sigmaX: 3, sigmaY: 3);
}