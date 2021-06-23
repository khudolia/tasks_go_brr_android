import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:simple_todo_flutter/resources/colors.dart';
import 'package:simple_todo_flutter/resources/dimens.dart';
import 'package:simple_todo_flutter/utils/time.dart';

class DayAndDateWidget extends StatefulWidget {
  final DateTime date;
  final double colorOffset;

  const DayAndDateWidget({Key? key, required this.date, this.colorOffset = 0})
      : super(key: key);

  @override
  _DayAndDateWidgetState createState() => _DayAndDateWidgetState();
}

class _DayAndDateWidgetState extends State<DayAndDateWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
          left: Margin.middle
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.date.weekday.getDayTitle(),
            style: TextStyle(
                color: Color.lerp(context.textInversed,
                  context.textInversed.withOpacity(0.0), widget.colorOffset)!,
              fontSize: Dimens.text_big,
              fontWeight: FontWeight.bold
          ),),
          SizedBox(
            height: Margin.small,
          ),
          Text(
            "day_of_month".tr(namedArgs: {
              "day": widget.date.day.toString(),
              "month": widget.date.month.getMonthTitle().toString()
            }),
            style: TextStyle(
                color: Color.lerp(context.textInversed,
                    context.textInversed.withOpacity(0.0), widget.colorOffset)!,
                fontSize: Dimens.text_normal_smaller,
                fontWeight: FontWeight.w500
            ),),
        ],
      ),
    );
  }
}
