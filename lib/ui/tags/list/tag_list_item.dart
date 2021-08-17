import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:simple_todo_flutter/data/models/tag/tag.dart';
import 'package:simple_todo_flutter/resources/dimens.dart';
import 'package:simple_todo_flutter/resources/colors.dart';
import 'package:simple_todo_flutter/resources/icons/icons.dart';
import 'package:simple_todo_flutter/ui/custom/animated_gesture_detector.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TagItem extends StatefulWidget {
  final Tag tag;
  final VoidCallback onRemove;

  const TagItem({Key? key, required this.tag, required this.onRemove})
      : super(key: key);

  @override
  _TagItemState createState() => _TagItemState();
}

class _TagItemState extends State<TagItem> with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Color(widget.tag.colorCode),
          borderRadius: BorderRadius.all(Radiuss.circle)),
      padding: EdgeInsets.only(
        top: Paddings.small_half.h,
        bottom: Paddings.small_half.h,
        right: Paddings.small.w,
        left: Paddings.middle.w,
      ),
      margin: EdgeInsets.only(
        right: Margin.small.w,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(
            child: Text(
              widget.tag.title,
              maxLines: 1,
              overflow: TextOverflow.visible,
              style: TextStyle(
                  color:
                  context.getColorByBrightness(Color(widget.tag.colorCode)),
                  fontWeight: FontWeight.w500),
            ),
          ),
          SizedBox(
            width: Margin.small.w,
          ),
          AnimatedGestureDetector(
            onTap: widget.onRemove,
            child: Icon(
              IconsC.close,
              color: context.getColorByBrightness(Color(widget.tag.colorCode)),
            ),
          )
        ],
      ),
    );
  }
}