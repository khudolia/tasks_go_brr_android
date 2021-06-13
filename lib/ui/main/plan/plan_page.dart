import 'dart:ui';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:simple_todo_flutter/data/models/task.dart';
import 'package:simple_todo_flutter/resources/colors.dart';
import 'package:simple_todo_flutter/resources/dimens.dart';
import 'package:simple_todo_flutter/resources/routes.dart';
import 'package:simple_todo_flutter/ui/custom/animated_gesture_detector.dart';
import 'package:simple_todo_flutter/ui/custom/app_bar_clipper.dart';
import 'package:simple_todo_flutter/ui/custom/textform_field_rounded.dart';
import 'package:simple_todo_flutter/ui/main/plan/plan_page_view_model.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:simple_todo_flutter/ui/task/task_edit_view_model.dart';
import 'package:easy_localization/easy_localization.dart';

class PlanPage extends StatefulWidget {
  const PlanPage({Key? key}) : super(key: key);

  @override
  _PlanPageState createState() => _PlanPageState();
}

class _PlanPageState extends State<PlanPage> {
  PlanPageViewModel model = PlanPageViewModel();
  TaskEditViewModel modelTask = TaskEditViewModel();

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
              Container(
                decoration: BoxDecoration(
                    color: context.primary,
                  borderRadius: BorderRadius.only(
                    topLeft: Radiuss.small,
                    topRight: Radiuss.small,
                    bottomLeft: Radiuss.small,
                  ),
                ),
                child: Column(
                  children: [
                    SizedBox(
                      height: Margin.middle,
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(
                          horizontal: Margin.middle
                      ),
                      child: InputFieldRounded(
                        labelText: "task".tr(),
                        maxLines: 1,
                        onChange: (text) => modelTask.changeTitle(text),
                        borderColor: context.surface,
                        textColor: context.textInversed,
                        labelUnselectedColor: context.textSubtitleInversed,
                        suffixIcons: [
                          AnimatedGestureDetector(
                            onTap: () {
                              model.getTasks().insert(0, modelTask.task);
                              modelTask.task = Task(title: "");
                              setState(() {
                              });

                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  color: context.success,
                                  borderRadius: BorderRadius.all(Radiuss.circle)),
                              child: Icon(Icons.check, color: context.surface,),
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: Margin.small.h,
                    ),
                    Row(
                      children: [
                        SizedBox(
                          width: Margin.middle.w,
                        ),
                        AnimatedGestureDetector(
                          child: Container(
                            decoration: BoxDecoration(
                              color: context.surface,
                              borderRadius: BorderRadius.all(Radiuss.small_smaller),
                            ),
                            padding: EdgeInsets.symmetric(
                              vertical: Paddings.small,
                              horizontal: Paddings.small,
                            ),
                            child: Text((modelTask.task.startTime ?? "Time").toString()),
                          ),
                          onTap: () async {
                            modelTask.task.startTime = (await Routes.showTimePicker(context)).hour;
                            setState(() {

                            });
                          },
                        ),
                      ],
                    ),
                    SizedBox(
                      height: Margin.small.h,
                    ),
                  ],
                ),
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
                      Expanded(
                        child: Container(
                          child: ReorderableListView(
                            shrinkWrap: false,
                            physics: BouncingScrollPhysics(),
                            onReorder: (int oldIndex, int newIndex) {
                              setState(() {
                                if (newIndex > oldIndex) {
                                  newIndex -= 1;
                                }
                                var item = model.getTasks().removeAt(oldIndex);
                                model.getTasks().insert(newIndex, item);
                              });
                            },
                            children: _getWidgetsFromTasks(),
                          ),
                        ),
                      ),
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

  List<Widget> _getWidgetsFromTasks() {
    List<Widget> list = [];

    for (int i = 0; i < model.getTasks().length; i++)
      list.add(Container(
        key: Key(model.getTasks()[i].id + DateTime.now().millisecondsSinceEpoch.toString()),
        decoration: BoxDecoration(
            color: i.isEven ? context.surface : context.surfaceAccent,
            borderRadius: BorderRadius.horizontal(
                left: Radiuss.small_smaller,
                right: i.isEven ? Radiuss.small : Radiuss.zero)),
        padding: EdgeInsets.symmetric(
            horizontal: Paddings.middle,
            vertical: Paddings.middle
        ),
        child: AnimatedGestureDetector(
          child: Container(

            child: Text(model.getTasks()[i].title),
          ),
        ),
      ));

    return list;
  }

  double _getDistance(double pos1, double pos2) => (pos1 - pos2).abs();
}
