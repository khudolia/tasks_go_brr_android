import 'package:easy_localization/easy_localization.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:simple_todo_flutter/data/models/statistics/statistics.dart';
import 'package:simple_todo_flutter/resources/colors.dart';
import 'package:simple_todo_flutter/resources/constants.dart';
import 'package:simple_todo_flutter/resources/dimens.dart';
import 'package:simple_todo_flutter/resources/icons.dart';
import 'package:simple_todo_flutter/resources/routes.dart';
import 'package:simple_todo_flutter/ui/custom/animated_gesture_detector.dart';
import 'package:simple_todo_flutter/ui/custom/clippers/app_bar_clipper_3.dart';
import 'package:simple_todo_flutter/ui/main/stat/stats_page_view_model.dart';
import 'package:simple_todo_flutter/utils/time.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';

class StatsPage extends StatefulWidget {
  const StatsPage({Key? key}) : super(key: key);

  @override
  _StatsPageState createState() => _StatsPageState();
}

class _StatsPageState extends State<StatsPage> {
  StatsPageViewModel _model = StatsPageViewModel();

  DateTime _currentDate = DateTime.now();
  int countChartDays = 0;

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
                  SizedBox(
                    height: Margin.middle.h,
                  ),
                  _chartWidget(),
                  SizedBox(
                    height: Margin.big.h + Margin.middle_smaller.h,
                  ),
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
                          fontSize: Dimens.text_small_bigger))
                ])),
            SizedBox(
              height: Margin.small,
            ),
          ],
        ),
      ),
    );
  }

  Widget _chartWidget() {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
            color: context.surface,
            borderRadius: BorderRadius.all(Radiuss.small_very),
            boxShadow: [
              Shadows.smallAround(context),
            ]),
        margin: EdgeInsets.symmetric(
          horizontal: Margin.middle,
        ),
        child: Stack(
          children: [
            Container(
              margin: EdgeInsets.only(
                right: Paddings.middle,
                top: Paddings.middle,
                left: Paddings.small,
                bottom: Paddings.small,
              ),
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  minY: 0,
                  barTouchData: BarTouchData(
                    enabled: true,
                    touchTooltipData: BarTouchTooltipData(
                        tooltipBgColor: context.surfaceAccent.withOpacity(0.9),
                        tooltipRoundedRadius: 10.0,
                        getTooltipItem: (group, groupIndex, rod, rodIndex) {
                          var countTaskDefault =
                              rod.rodStackItems[0].toY.toInt();
                          var countTaskRegular = (rod.rodStackItems[1].toY -
                                  rod.rodStackItems[0].toY)
                              .toInt();
                          return BarTooltipItem(
                            DateTime.now()
                                    .add(Duration(days: 1 + group.x.toInt()))
                                    .weekday
                                    .getDayTitle() +
                                '\n',
                            TextStyle(
                              color: context.textDefault,
                              fontWeight: FontWeight.bold,
                              fontSize: Dimens.text_normal_smaller,
                            ),
                            children: <TextSpan>[
                              TextSpan(
                                text: "${"default".tr()}: $countTaskDefault\n"
                                        .toLowerCase() +
                                    "${"regular".tr()}: $countTaskRegular"
                                        .toLowerCase(),
                                style: TextStyle(
                                  color: context.textSubtitleDefault,
                                  fontSize: Dimens.text_small_bigger,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          );
                        }),
                  ),
                  titlesData: FlTitlesData(
                    show: true,
                    bottomTitles: SideTitles(
                      showTitles: true,
                      getTextStyles: (value) => TextStyle(
                          color: context.textSubtitleDefault, fontSize: 10),
                      margin: Margin.small,
                      getTitles: (double value) => DateTime.now()
                          .add(Duration(days: 1 + value.toInt()))
                          .weekday
                          .getDayTitleShort(),
                    ),
                    leftTitles: SideTitles(
                      showTitles: true,
                      getTextStyles: (value) => TextStyle(
                          color: context.textSubtitleDefault,
                          fontSize: Dimens.text_small),
                      margin: Margin.small.w,
                    ),
                  ),
                  gridData: FlGridData(
                    show: true,
                    checkToShowHorizontalLine: (value) => true,
                    getDrawingHorizontalLine: (value) => FlLine(
                      color: context.gray.withOpacity(.15),
                      strokeWidth: 1,
                    ),
                  ),
                  borderData: FlBorderData(
                    show: false,
                  ),
                  barGroups: _getChartData(),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(right: Margin.small, top: Margin.small),
              alignment: Alignment.topRight,
              child: AnimatedGestureDetector(
                onTap: () => _openHelpDialog(),
                child: Icon(
                  IconsC.help,
                  color: context.gray.withOpacity(.5),
                ),
              ),
            ),
            countChartDays == 0
                ? Container(
                    alignment: Alignment.center,
                    child: Text(
                      "error.no_chart_data".tr(),
                      style: TextStyle(
                          color: context.textSubtitleDefault,
                          fontSize: Dimens.text_big,
                          fontWeight: FontWeight.bold),
                    ),
                  )
                : Container(),
          ],
        ),
      ),
    );
  }

  List<BarChartGroupData> _getChartData() {
    List<BarChartGroupData> list = [];

    for (int i = 0; i < 7; i++) {
      DayStats? day = _model.getDayForChart(i);

      if (day == null)
        day = DayStats()
          ..completedRegularTasks = 0
          ..completedDefaultTasks = 0;
      else
        countChartDays++;

      list.add(BarChartGroupData(
        x: i,
        barsSpace: 40,
        barRods: [
          BarChartRodData(
              width: Dimens.chart_bar_width,
              y: (day.completedDefaultTasks + day.completedRegularTasks)
                  .toDouble(),
              rodStackItems: [
                BarChartRodStackItem(0, day.completedDefaultTasks.toDouble(),
                    context.chartSecondary),
                BarChartRodStackItem(
                    day.completedDefaultTasks.toDouble(),
                    (day.completedDefaultTasks + day.completedRegularTasks)
                        .toDouble(),
                    context.chartPrimary),
              ],
              borderRadius: BorderRadius.all(Radiuss.circle)),
        ],
      ));
    }
    return list;
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
                  borderRadius: BorderRadius.all(Radiuss.small_smaller)),
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
                    minValue: Constants.GOAL_TASKS_DAY_MIN,
                    maxValue: Constants.GOAL_TASKS_DAY_MAX,
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

  _openHelpDialog() {
    showDialog(
        context: context,
        builder: (contextDialog) => AlertDialog(
              backgroundColor: Colors.transparent,
              elevation: 0.0,
              content: Container(
                decoration: BoxDecoration(
                  color: context.surface,
                  borderRadius: BorderRadius.all(Radiuss.small_smaller),
                ),
                padding: EdgeInsets.symmetric(
                    horizontal: Paddings.small, vertical: Paddings.middle),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _colorExplanation(
                        context.chartPrimary, "dialog.expl_default_task".tr()),
                    SizedBox(
                      height: Margin.small,
                    ),
                    _colorExplanation(
                        context.chartSecondary, "dialog.expl_regular_task".tr())
                  ],
                ),
              ),
            ));
  }

  Widget _colorExplanation(Color color, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.all(Radiuss.circle),
          ),
        ),
        SizedBox(
          width: Margin.small.w,
        ),
        Flexible(
          child: Text(text,
              style: TextStyle(
                  fontSize: Dimens.text_small_bigger,
                  color: context.textSubtitleDefault),
              textAlign: TextAlign.left),
        ),
      ],
    );
  }
}
