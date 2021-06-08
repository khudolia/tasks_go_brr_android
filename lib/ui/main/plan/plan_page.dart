import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:simple_todo_flutter/resources/colors.dart';
import 'package:simple_todo_flutter/resources/dimens.dart';
import 'package:simple_todo_flutter/ui/custom/animated_gesture_detector.dart';
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
  late PageController controller;

  double? currentPageValue;
  var reason = CarouselPageChangedReason.manual;

  @override
  void initState() {
    controller = PageController(
        initialPage: model.getCurrentDayOfWeek() - 1,
        viewportFraction:
            (Dimens.days_small_bar_height - Margin.middle.h) / 1.sw);

    currentPageValue = model.getCurrentDayOfWeek() - 1;

    controller.addListener(() {
      setState(() {
        currentPageValue = controller.page;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        color: context.surface,
        child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          SizedBox(
            height: 2 * Margin.big.h,
          ),
          Expanded(
            child: SafeArea(
              child: _daysWidget(),
            ),
          ),
          SizedBox(
            height: Margin.small.h,
          ),
          _bottomWeek(),
          SizedBox(
            height: Margin.big.h,
          )
        ],
      )
    );
  }

  Widget _daysWidget() {
    return CarouselSlider(
      carouselController: carouselController,
      items: _listOfDaysExtended(),
      options: CarouselOptions(
        initialPage: model.getCurrentDayOfWeek() - 1,
          autoPlay: false,
          enlargeCenterPage: true,
          enableInfiniteScroll: false,
          height: double.infinity,
          scrollPhysics: BouncingScrollPhysics(),
          onPageChanged: (index, reason) async {
            if (reason == CarouselPageChangedReason.manual) {
              this.reason = CarouselPageChangedReason.controller;
              await controller.animateToPage(index,
                  duration: Durations.milliseconds_middle,
                  curve: Curves.fastOutSlowIn);
              this.reason = CarouselPageChangedReason.manual;
            }
          }),
    );
  }

  Widget _bottomWeek() {
    double minValue = 0.7;
    double sizeMultiplier = 0.5;
    return Container(
      height: Dimens.days_small_bar_height,
      child: PageView.builder(
        clipBehavior: Clip.none,
        controller: controller,
        pageSnapping: true,
        itemCount: 7,
        onPageChanged: (index) {
          if(reason == CarouselPageChangedReason.manual)
            carouselController.animateToPage(index,
                duration: Durations.milliseconds_middle,
                curve: Curves.fastOutSlowIn);
        },
        physics: BouncingScrollPhysics(),
        itemBuilder: (context, position) {
          var offset = (1 /
                  (((position - currentPageValue!).abs()).clamp(0.0, 1) +
                      sizeMultiplier))
              .clamp(0.0, 1.0);

          if(offset < minValue)
            minValue = offset;

          var colorOffset = (offset - minValue) / (1 - minValue);

          return Transform.scale(
            scale: offset,
            child: _daySmallWidget(
                position,
                Color.lerp(context.surface, context.primary, colorOffset)!,
                Color.lerp(
                    context.textDefault, context.textInversed, colorOffset)!),
          );
        },
      ),
    );
  }

  Widget _dayWidget(String dayTitle) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(
        vertical: Margin.middle.h
      ),
      decoration: BoxDecoration(
        color: context.surface,
        borderRadius: BorderRadius.all(Radiuss.small),
        boxShadow: [
          Shadows.smallAround(context)
        ]
      ),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Text(dayTitle),
          SizedBox(
            height: Margin.middle.h,
          ),
          SingleChildScrollView(
            child: Column(
              children: [
                Text("Child"),
                Text("Child"),
                Text("Child"),
                Text("Child"),
                Text("Child"),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _daySmallWidget(int id, Color color, Color textColor) {
    return AnimatedGestureDetector(
      onTap: () {
        this.reason = CarouselPageChangedReason.manual;
        controller.animateToPage(id, duration: Durations.milliseconds_middle, curve: Curves.fastOutSlowIn);
      },
      child: Container(
        margin: EdgeInsets.symmetric(
            vertical: Margin.middle.h,
            horizontal: Margin.small.h
        ),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.all(Radiuss.circle),
            boxShadow: [
              Shadows.small(context)
            ]
        ),
        child: Center(
            child: Text(
          model.getDayTitle(id)[0],
          style: TextStyle(color: textColor, fontWeight: FontWeight.w500, fontSize: Dimens.text_normal),
        )),
      ),
    );
  }

  List<Widget> _listOfDaysExtended() {
    List<Widget> list = [];
    for(int i = 0; i < 7; i++)
      list.add(_dayWidget(model.getDayTitle(i)));

    return list;
  }
}
