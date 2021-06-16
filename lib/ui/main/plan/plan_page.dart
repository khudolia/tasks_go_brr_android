import 'dart:ui';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:implicitly_animated_reorderable_list/implicitly_animated_reorderable_list.dart';
import 'package:implicitly_animated_reorderable_list/transitions.dart';
import 'package:simple_todo_flutter/data/models/task.dart';
import 'package:simple_todo_flutter/resources/colors.dart';
import 'package:simple_todo_flutter/resources/dimens.dart';
import 'package:simple_todo_flutter/resources/icons.dart';
import 'package:simple_todo_flutter/ui/custom/animated_gesture_detector.dart';
import 'package:simple_todo_flutter/ui/custom/app_bar_clipper.dart';
import 'package:simple_todo_flutter/ui/main/plan/plan_page_view_model.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:simple_todo_flutter/ui/task/task_edit_widget.dart';

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
            clipper: AppBarClipper(),
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
          return _dayWidget(index);
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

  Widget _dayWidget(int index) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(
        vertical: Margin.small.h
      ),
      decoration: BoxDecoration(
        color: context.primary,
        borderRadius: BorderRadius.all(Radiuss.small),
        boxShadow: [
          Shadows.smallAround(context)
        ]
      ),
      child: Stack(
        children: [
          Row(
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: context.surface,
                    borderRadius: BorderRadius.only(
                      topLeft: Radiuss.small,
                      bottomLeft: Radiuss.small,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: context.primary,
                    borderRadius: BorderRadius.only(
                      bottomRight: Radiuss.small,
                      topRight: Radiuss.small,
                    ),
                  ),
                ),
              ),
            ],
          ),
          Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              TaskEditWidget(
                taskAdded: (task) {
                  model.getTasks().insert(0, task);
                  setState(() {});
                },
              ),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: context.surface,
                    borderRadius: BorderRadius.only(
                      topRight: Radiuss.small,
                      bottomRight: Radiuss.small,
                      bottomLeft: Radiuss.small,
                    ),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      SizedBox(
                        height: Margin.small.h,
                      ),
                      Container(
                          alignment: Alignment.centerLeft,
                          margin: EdgeInsets.symmetric(horizontal: Margin.middle),
                          child: Text(
                            "tasks_for_day:".tr(),
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: Dimens.text_normal_smaller),
                          )),
                      _reorderableTasksWidget(),
                      SizedBox(
                        height: Margin.middle,
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _reorderableTasksWidget() {
    return Expanded(
      child: Container(
        child: ImplicitlyAnimatedReorderableList<Task>(
          items: model.taskList,
          areItemsTheSame: (oldItem, newItem) => oldItem == newItem,
          onReorderFinished: (item, from, to, newItems) {
            setState(() => model.updateList(newItems));
          },
          itemBuilder: (context, itemAnimation, item, index) {
            return Reorderable(
              key: ValueKey(item.id),
              builder: (context, dragAnimation, inDrag) {
                return Slidable(
                  actionPane: SlidableBehindActionPane(),
                  closeOnScroll: true,
                  secondaryActions: [
                    Container(
                      margin: EdgeInsets.symmetric(
                        vertical: Margin.small_very.h,
                        horizontal: Margin.small_very.w,
                      ),
                      child: SlideAction(
                        closeOnTap: true,
                        decoration: new BoxDecoration(
                            color: context.error,
                            borderRadius:
                                new BorderRadius.all(Radiuss.small_smaller)),
                        onTap: () async {
                          model.removeTask(index);
                          await Future.delayed(Duration(milliseconds: 200));
                          setState(() {

                          });
                        },
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
                    ),
                  ],
                  child: SizeFadeTransition(
                    sizeFraction: 0.7,
                    curve: Curves.easeInOut,
                    animation: itemAnimation,
                    child: Container(
                      margin: EdgeInsets.symmetric(
                        vertical: Margin.small_very.h,
                      ),
                      padding: EdgeInsets.symmetric(
                        vertical: Paddings.middle_smaller.h,
                        horizontal: Paddings.small.w,
                      ),
                      decoration: new BoxDecoration(
                          color: context.surface,
                          borderRadius:
                              new BorderRadius.all(Radiuss.small_very)),
                      child: Row(
                        children: [
                          SizedBox(
                            width: Margin.middle.w,
                          ),
                          Expanded(
                            child: Container(
                              child: Text(model.getTaskTitle(index)),
                            ),
                          ),
                          Handle(
                            delay: Durations.handle_short,
                            child: Icon(
                              IconsC.handle,
                              color: context.background,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
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
            model.getDayTitle(id)[0],
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
    var firstWeekDay = model.getStartOfDaysList(DateTime.now());

    return Transform.scale(
      scale: scaleOffset,
      child: Container(
        margin: EdgeInsets.only(
            left: Margin.middle
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(model.getDayTitle(index), style: TextStyle(
                  color: Color.lerp(context.textInversed,
                      context.textInversed.withOpacity(0.0), colorOffset)!,
                  fontSize: Dimens.text_big,
                fontWeight: FontWeight.bold
            ),),
            SizedBox(
              height: Margin.small,
            ),
            Text(
              "day_of_month".tr(namedArgs: {
                "day": (firstWeekDay.add(Duration(days: index)).day).toString(),
                "month": model.getMonthTitle(
                    firstWeekDay.add(Duration(days: index)).month)
              }),
              style: TextStyle(
                  color: Color.lerp(context.textInversed,
                      context.textInversed.withOpacity(0.0), colorOffset)!,
                  fontSize: Dimens.text_normal_smaller,
                fontWeight: FontWeight.w500
            ),),
          ],
        ),
      ),
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
