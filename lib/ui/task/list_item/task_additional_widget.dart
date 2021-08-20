import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:simple_todo_flutter/resources/colors.dart';
import 'package:simple_todo_flutter/resources/dimens.dart';
import 'package:simple_todo_flutter/resources/icons/icons.dart';
import 'package:simple_todo_flutter/ui/tags/list/tag_list_item.dart';
import 'package:simple_todo_flutter/utils/time.dart';

class TaskAdditionalWidget extends StatefulWidget {
  final dynamic task;
  final dynamic getTag;
  final double timeLeftMargin;

  const TaskAdditionalWidget(
      {Key? key, required this.task, this.getTag, this.timeLeftMargin = 0})
      : super(key: key);

  @override
  _TaskAdditionalWidgetState createState() => _TaskAdditionalWidgetState();
}

class _TaskAdditionalWidgetState extends State<TaskAdditionalWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        widget.task.time != null
            ? SizedBox(
                height: Margin.small.h,
              )
            : Container(),
        Container(
          margin: EdgeInsets.only(
            left: widget.timeLeftMargin,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              widget.task.time != null ? _timeWidget() : Container(),
              widget.task.time != null && widget.task.remindBeforeTask != null
                  ? _remindTimeWidget()
                  : Container(),
            ],
          ),
        ),
        widget.task.tags.isNotEmpty
            ? SizedBox(
                height: Margin.small.h,
              )
            : Container(),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          physics: BouncingScrollPhysics(),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: widget.timeLeftMargin,
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: (widget.task.tags as List<String>)
                    .map((e) => TagItem(
                          tag: widget.getTag(e),
                          onRemove: () {},
                          type: SizeType.SMALL,
                          isEnabled: widget.task.status,
                        ))
                    .toList(),
              ),
              SizedBox(
                width: widget.timeLeftMargin,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _timeWidget() {
    return _smallWidget(
        icon: IconsC.clock,
        text: Time.getTimeFromMilliseconds(widget.task.time!));
  }

  Widget _remindTimeWidget() {
    return _smallWidget(
        icon: IconsC.remind,
        text:
            Time.getBeforeTimeFromMilliseconds(widget.task.remindBeforeTask!));
  }

  Widget _smallWidget({required String text, required IconData icon}) {
    return Container(
      decoration: BoxDecoration(
          color: Color.lerp(context.surfaceAccent, context.primary,
              widget.task.status ? 0 : 1),
          borderRadius: BorderRadius.all(Radiuss.circle)),
      padding: EdgeInsets.symmetric(
        vertical: Paddings.small_half.h,
        horizontal: Paddings.small.w,
      ),
      margin: EdgeInsets.only(
        right: Margin.small_half.w,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: Color.lerp(context.onSurface, context.onPrimary,
                widget.task.status ? 0 : 1),
            size: 18,
          ),
          SizedBox(
            width: Margin.small_half.w,
          ),
          Text(
            text,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
                color: Color.lerp(context.onSurface, context.onPrimary,
                    widget.task.status ? 0 : 1),
                fontWeight: FontWeight.w500,
                fontSize: Dimens.text_small_bigger),
          ),
        ],
      ),
    );
  }
}
