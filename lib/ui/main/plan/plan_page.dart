import 'dart:ui';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:simple_todo_flutter/resources/colors.dart';
import 'package:simple_todo_flutter/resources/dimens.dart';
import 'package:simple_todo_flutter/ui/calendar/day_card.dart';
import 'package:simple_todo_flutter/ui/custom/animated_gesture_detector.dart';
import 'package:simple_todo_flutter/ui/custom/clippers/app_bar_clipper_1.dart';
import 'package:simple_todo_flutter/ui/custom/day_and_date_widget.dart';
import 'package:simple_todo_flutter/ui/main/plan/plan_page_view_model.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PlanPage extends StatefulWidget {
  const PlanPage({Key? key}) : super(key: key);

  @override
  _PlanPageState createState() => _PlanPageState();
}

class _PlanPageState extends State<PlanPage> {
  PlanPageViewModel model = PlanPageViewModel();

  CarouselController carouselController = CarouselController();
  late PageController controllerCurrentDayBottom;
  late PageController controllerCurrentDayTop;

  double? currentPageValue;
  var reasonForBottomDaysView = CarouselPageChangedReason.manual;

  late DateTime centerDate;
  late int renderRange;

  @override
  void initState() {
    centerDate = model.getCurrentDayOfWeek();
    renderRange = model.getLengthOfRenderDays(centerDate);

    _initializeListeners();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        PreferredSize(
          preferredSize: Size.fromHeight(Dimens.app_bar_height),
          child: ClipPath(
            clipper: AppBarClipper1(),
            child: Container(
              color: context.secondary,
            ),
          ),
        ),
        Container(
            color: Colors.transparent,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                SizedBox(
                  height: Dimens.getStatusBarHeight(context),
                ),
                SizedBox(
                  height: Margin.middle.h,
                ),
                _currentDayTopWidget(),
                SizedBox(
                  height: Margin.small.h,
                ),
                Expanded(
                  child: _daysWidget(),
                ),
                _bottomWeek(),
                SizedBox(
                  height: Margin.big.h,
                )
              ],
            )
        ),
      ],
    );
  }

  Widget _currentDayTopWidget() {
    return Container(
      height: Dimens.app_bar_height,
      child: PageView.builder(
        controller: controllerCurrentDayTop,
        pageSnapping: true,
        itemCount: renderRange,
        physics: NeverScrollableScrollPhysics(),
        itemBuilder: (context, position) {
          var distance = _getDistance(position.toDouble(), currentPageValue!);
          var offset = (1 / distance)
              .clamp(0.0, 1.0);

          double colorOffset = (distance <
                  Dimens.days_top_widget_disappear_pos)
              ? (distance).clamp(0.0, 1)
              : 1;

          return _currentDayAndDateWidget(offset, colorOffset, position);
        },
      ),
    );
  }

  Widget _daysWidget() {
    return CarouselSlider.builder(
      carouselController: carouselController,
      itemCount: renderRange,
      itemBuilder: (context, index, realIndex) {
          return DayCard(date: model.getDateFromPosition(centerDate, index),);
      },
      options: CarouselOptions(
          initialPage: model.getPositionOfCenterDate(centerDate),
          autoPlay: false,
          enlargeCenterPage: true,
          enableInfiniteScroll: false,
          height: double.infinity,
          scrollPhysics: BouncingScrollPhysics(),
          onPageChanged: (index, reason) async {
            if (reason == CarouselPageChangedReason.manual) {
              controllerCurrentDayTop.animateToPage(index,
                  duration: Durations.milliseconds_middle,
                  curve: Curves.fastOutSlowIn);
              this.reasonForBottomDaysView =
                  CarouselPageChangedReason.controller;
              await controllerCurrentDayBottom.animateToPage(index,
                  duration: Durations.milliseconds_middle,
                  curve: Curves.fastOutSlowIn);
              this.reasonForBottomDaysView = CarouselPageChangedReason.manual;
            }
          }),
    );
  }

  Widget _bottomWeek() {
    double minValue = 0.7;
    return Container(
      height: Dimens.days_small_bar_height,
      child: PageView.builder(
        controller: controllerCurrentDayBottom,
        pageSnapping: true,
        itemCount: renderRange,
        onPageChanged: (index) {
          if(reasonForBottomDaysView == CarouselPageChangedReason.manual) {
            controllerCurrentDayTop.animateToPage(index,
                duration: Durations.milliseconds_middle,
                curve: Curves.fastOutSlowIn);
            carouselController.animateToPage(index,
                duration: Durations.milliseconds_middle,
                curve: Curves.fastOutSlowIn);
          }
        },
        physics: BouncingScrollPhysics(),
        itemBuilder: (context, position) {
          var distance = _getDistance(position.toDouble(), currentPageValue!);

          var offset = (1 /
                  (distance.clamp(0.0, 1) +
                      Dimens.days_small_bar_size_multiplier))
              .clamp(0.0, 1.0);

          if(offset < minValue)
            minValue = offset;

          var colorOffset = (offset - minValue) / (1 - minValue);

          return _daySmallWidget(offset, colorOffset, position);
        },
      ),
    );
  }

  Widget _daySmallWidget(double offset, double colorOffset, int id) {
    return Transform.scale(
      scale: offset,
      child: AnimatedGestureDetector(
        onTap: () {
          this.reasonForBottomDaysView = CarouselPageChangedReason.manual;
          controllerCurrentDayBottom.animateToPage(id,
              duration: Durations.milliseconds_middle,
              curve: Curves.fastOutSlowIn);
        },
        child: Container(
          margin: EdgeInsets.symmetric(
              vertical: Margin.small.h, horizontal: Margin.small_half.h),
          decoration: BoxDecoration(
              color: Color.lerp(context.surface, context.primary, colorOffset)!,
              borderRadius: BorderRadius.all(Radiuss.circle),
              boxShadow: [Shadows.small(context)]),
          child: Center(
              child: Text(
            model.getDayTitle(model.getDateFromPosition(centerDate, id).weekday)[0],
            style: TextStyle(
                color: Color.lerp(
                    context.textDefault, context.textInversed, colorOffset)!,
                fontWeight: FontWeight.w500,
                fontSize: lerpDouble(
                    Dimens.text_normal, Dimens.text_normal_bigger, offset)),
          )),
        ),
      ),
    );
  }

  Widget _currentDayAndDateWidget(double scaleOffset, double colorOffset, int index) {
    return Transform.scale(
      scale: scaleOffset,
      child: DayAndDateWidget(
        date: model.getDateFromPosition(centerDate, index),
        colorOffset: colorOffset,
      )
    );
  }

  _initializeListeners() {
    controllerCurrentDayBottom = PageController(
        initialPage: model.getPositionOfCenterDate(centerDate),
        viewportFraction:
        (Dimens.days_small_bar_height - Margin.small.h) / 1.sw);

    controllerCurrentDayTop = PageController(
        initialPage: model.getPositionOfCenterDate(centerDate),
        viewportFraction: 1);

    currentPageValue = model.getPositionOfCenterDate(centerDate).toDouble();

    controllerCurrentDayBottom.addListener(() {
      setState(() {
        currentPageValue = controllerCurrentDayBottom.page;
      });
    });
  }

  double _getDistance(double pos1, double pos2) => (pos1 - pos2).abs();
}
