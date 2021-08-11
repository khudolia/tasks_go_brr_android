import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:simple_todo_flutter/resources/colors.dart';
import 'package:simple_todo_flutter/resources/dimens.dart';
import 'package:simple_todo_flutter/resources/icons/icons.dart';
import 'package:simple_todo_flutter/resources/routes.dart';
import 'package:simple_todo_flutter/ui/calendar/day_card.dart';
import 'package:simple_todo_flutter/ui/custom/animated_gesture_detector.dart';
import 'package:simple_todo_flutter/ui/custom/clippers/app_bar_clipper_1.dart';
import 'package:simple_todo_flutter/ui/custom/day_and_date_widget.dart';
import 'package:simple_todo_flutter/ui/main/plan/plan_page_view_model.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:simple_todo_flutter/utils/time.dart';

class PlanPage extends StatefulWidget {
  const PlanPage({Key? key}) : super(key: key);

  @override
  _PlanPageState createState() => _PlanPageState();
}

class _PlanPageState extends State<PlanPage> {
  PlanPageViewModel _model = PlanPageViewModel();

  late PageController _cDayPages;
  late PageController _cDayTitles;

  double? currentPageValue;

  late DateTime _centerDate;
  late int _renderRange;

  @override
  void initState() {
    _centerDate = _model.getCurrentDayOfWeek();
    _renderRange = _model.getLengthOfRenderDays(_centerDate);

    _initializeListeners();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: context.background,
      child: Stack(
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
                  _appBar(),
                  SizedBox(
                    height: Margin.small.h,
                  ),
                  Expanded(
                    child: _daysWidget(),
                  ),
                  SizedBox(
                    height: Margin.big.h,
                  )
                ],
              )
          ),
        ],
      ),
    );
  }

  Widget _appBar() {
    return Stack(
      children: [
        _currentDayTopWidget(),
        Positioned(
          right: 0,
          child: Transform.scale(
            scale: !_centerDate.isSameDate(DateTime.now()) ? 1.0 : _getDistance(
                _model.getPositionOfCenterDate(_centerDate).toDouble(),
                currentPageValue!)
                .clamp(0.0, 1.0),

            child: AnimatedGestureDetector(
                    onTap: () async {
                      if(_getDistance(
                          _model.getPositionOfCenterDate(_centerDate).toDouble(),
                          currentPageValue!) > 0)
                        _cDayPages.animateToPage(
                            _model.getPositionOfCenterDate(_centerDate),
                            duration: Durations.milliseconds_middle,
                            curve: Curves.fastOutSlowIn);
                      else
                        if(!_centerDate.isSameDate(DateTime.now().onlyDate()))
                          setState(() => _centerDate = DateTime.now().onlyDate());
                    },
                    child: Container(
                      margin: EdgeInsets.only(
                        right: Margin.middle.h,
                        left: Margin.middle.h,
                      ),
                      decoration: BoxDecoration(
                          color: context.surface,
                          borderRadius: BorderRadius.all(Radiuss.circle),),
                      padding: EdgeInsets.symmetric(
                          vertical: Paddings.small_bigger,
                          horizontal: Paddings.small_bigger),
                      child: Icon(
                        IconsC.home,
                        size: Dimens.icon_size,
                        color: context.onSurface,
                      ),
                    )),
              ),
        ),
      ],
    );
  }

  Widget _currentDayTopWidget() {
    return Container(
      height: Dimens.app_bar_height,
      child: AnimatedGestureDetector(
        onTap: () async {
          _centerDate = (await Routes.showDateCalendarPicker(
              context, _centerDate)) ??
              _centerDate;
          _centerDate.onlyDate();
          setState(() {});
        },
        child: PageView.builder(
          controller: _cDayTitles,
          pageSnapping: true,
          itemCount: _renderRange,
          physics: NeverScrollableScrollPhysics(),
          itemBuilder: (context, position) {
            var distance = _getDistance(position.toDouble(), currentPageValue!);
            var offset = (1 / distance)
                .clamp(0.0, 1.0);

            double colorOffset = distance.clamp(0.0, 1);

            return _currentDayAndDateWidget(offset, colorOffset, position);
          },
        ),
      ),
    );
  }

  Widget _daysWidget() {
    return PageView.builder(
      controller: _cDayPages,
      itemCount: _renderRange,
      itemBuilder: (context, position) {
        var distance = _getDistance(position.toDouble(), currentPageValue!);

        return Transform.scale(
          scale: 1 - distance.clamp(0.0, .15),
          child: Container(
            margin: EdgeInsets.symmetric(
              horizontal: Margin.middle.w,
            ),
            child: DayCard(
              date: _model.getDateFromPosition(_centerDate, position),
            ),
          ),
        );
      },
      onPageChanged: (index) async {
        _cDayTitles.animateToPage(index,
            duration: Durations.milliseconds_middle,
            curve: Curves.fastOutSlowIn);
      },
      pageSnapping: true,
      physics: BouncingScrollPhysics(),
    );
  }

  Widget _currentDayAndDateWidget(double scaleOffset, double colorOffset, int index) {
    return Transform.scale(
      scale: scaleOffset,
      child: DayAndDateWidget(
        date: _model.getDateFromPosition(_centerDate, index),
        colorOffset: colorOffset,
      )
    );
  }

  _initializeListeners() {
    _cDayTitles = PageController(
        initialPage: _model.getPositionOfCenterDate(_centerDate),
        viewportFraction: 1);

    _cDayPages = PageController(
        initialPage: _model.getPositionOfCenterDate(_centerDate),
        viewportFraction: 1);

    currentPageValue = _model.getPositionOfCenterDate(_centerDate).toDouble();

    _cDayPages.addListener(() {
      if (currentPageValue != _cDayPages.page)
        setState(() => currentPageValue = _cDayPages.page);
    });
  }

  double _getDistance(double pos1, double pos2) => (pos1 - pos2).abs();
}
