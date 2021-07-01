import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:simple_todo_flutter/resources/colors.dart';
import 'package:simple_todo_flutter/resources/dimens.dart';
import 'package:simple_todo_flutter/resources/icons.dart';
import 'package:simple_todo_flutter/resources/routes.dart';
import 'package:simple_todo_flutter/ui/custom/animated_gesture_detector.dart';
import 'package:simple_todo_flutter/ui/custom/clippers/app_bar_clipper_3.dart';
import 'package:simple_todo_flutter/ui/main/stat/stats_page_view_model.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';

class StatsPage extends StatefulWidget {
  const StatsPage({Key? key}) : super(key: key);

  @override
  _StatsPageState createState() => _StatsPageState();
}

class _StatsPageState extends State<StatsPage> {
  StatsPageViewModel _model = StatsPageViewModel();

  DateTime _currentDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _model.initRepo(_currentDate),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.connectionState == ConnectionState.done &&
            !snapshot.hasError) {
          return Stack(
            children: [
              PreferredSize(
                preferredSize: Size.fromHeight(Dimens.app_bar_height),
                child: ClipPath(
                  clipper: AppBarClipper3(),
                  child: Container(
                    color: context.secondary,
                  ),
                ),
              ),
              Column(
                children: [
                  SizedBox(
                    height: Dimens.getStatusBarHeight(context),
                  ),
                  SizedBox(
                    height: Margin.middle.h,
                  ),
                  Container(
                    child: SleekCircularSlider(
                      appearance: CircularSliderAppearance(
                          size: MediaQuery.of(context).size.width / 1.5,
                          angleRange: 180,
                          startAngle: 180,
                          customWidths: CustomSliderWidths(
                            progressBarWidth: 15,
                            trackWidth: 15,
                          ),
                          customColors: CustomSliderColors(
                              trackColor: context.surface.withOpacity(.3),
                              progressBarColor: context.surface,
                              dotColor: Colors.transparent,
                              hideShadow: true)),
                      initialValue:
                          _model.getCompletedTasks(_currentDate).toDouble(),
                      max: _model.stats.goalOfTasksInDay.toDouble(),
                      min: 0,
                      innerWidget: (_) => _widgetInProgressBar(),
                      onChange: null,
                    ),
                  ),
                  _streakLayout(),
                ],
              ),
            ],
          );
        } else {
          return Container();
        }
      },
    );
  }

  Widget _widgetInProgressBar() {
    return Center(
      child: Container(
        child: AnimatedGestureDetector(
          onTap: () => _showGoalPickerDialog(),
          child: RichText(
              text: TextSpan(
                  text: _model.getCompletedTasks(_currentDate).toString(),
                  style: TextStyle(
                      color: context.textInversed,
                      fontWeight: FontWeight.bold,
                      fontSize: Dimens.text_big),
                  children: <TextSpan>[
                TextSpan(
                    text: "/" + _model.stats.goalOfTasksInDay.toString(),
                    style: TextStyle(
                        color: context.textSubtitleInversed,
                        fontSize: Dimens.text_normal))
              ])),
        ),
      ),
    );
  }

  Widget _streakLayout() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: Margin.middle),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _streakWidget("stats.current_streak".tr(), _model.stats.daysInRow),
          SizedBox(
            width: Margin.middle,
          ),
          _streakWidget("stats.beast_streak".tr(), _model.stats.maxDaysInRow)
        ],
      ),
    );
  }

  Widget _streakWidget(String title, int value) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
            color: context.surface,
            borderRadius: BorderRadius.all(Radiuss.small_very),
            boxShadow: [
              Shadows.smallAround(context),
            ]),
        padding: EdgeInsets.only(left: Paddings.small),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: Margin.small,
            ),
            Text(
              title,
              style: TextStyle(
                color: context.textDefault,
                fontSize: Dimens.text_normal,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              height: Margin.small,
            ),
            RichText(
                text: TextSpan(
                    text: value.toString(),
                    style: TextStyle(
                      color: context.primary,
                      fontSize: Dimens.text_normal,
                      fontWeight: FontWeight.w500,
                    ),
                    children: <TextSpan>[
                  TextSpan(
                      text: " " + "stats.days_in_a_row".tr(),
                      style: TextStyle(
                          color: context.textSubtitleDefault,
                          fontSize: Dimens.text_small))
                ])),
            SizedBox(
              height: Margin.small,
            ),
          ],
        ),
      ),
    );
  }

  _showGoalPickerDialog() async {
    var currentValue = _model.stats.goalOfTasksInDay;
    await showDialog(
      context: context,
      builder: (BuildContext contextDialog) {
        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
            elevation: 0,
            backgroundColor: Colors.transparent,
            content: Container(
              decoration: BoxDecoration(
                  color: context.surface,
                  borderRadius: BorderRadius.all(Radiuss.small)),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    margin: EdgeInsets.symmetric(
                      vertical: Margin.small,
                      horizontal: Margin.small,
                    ),
                    child: Text(
                      "dialog.how_many_tasks_complete_in_day".tr(),
                      style: TextStyle(
                        color: context.textDefault,
                        fontSize: Dimens.text_normal,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  NumberPicker(
                    selectedTextStyle: TextStyle(
                      color: context.primary,
                      fontSize: Dimens.text_normal_bigger,
                      fontWeight: FontWeight.bold,
                    ),
                    infiniteLoop: true,
                    itemHeight: 50,
                    minValue: 1,
                    maxValue: 100,
                    value: currentValue,
                    onChanged: (value) => setState(() => currentValue = value),
                  ),
                  AnimatedGestureDetector(
                    onTap: () async {
                      _model.stats.goalOfTasksInDay = currentValue;
                      await _model.updateStats();

                      Routes.back(contextDialog);
                    },
                    child: Container(
                      width: double.infinity,
                      margin: EdgeInsets.symmetric(
                          horizontal: Margin.small, vertical: Margin.small),
                      padding: EdgeInsets.symmetric(vertical: Paddings.small),
                      decoration: BoxDecoration(
                          color: context.primary,
                          borderRadius: BorderRadius.all(Radiuss.small)),
                      child: Icon(
                        IconsC.check,
                        color: context.surface,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
      },
    ).then((value) => setState(() {}));
  }
}
