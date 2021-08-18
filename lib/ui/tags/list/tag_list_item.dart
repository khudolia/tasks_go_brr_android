import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:simple_todo_flutter/data/models/tag/tag.dart';
import 'package:simple_todo_flutter/resources/dimens.dart';
import 'package:simple_todo_flutter/resources/colors.dart';
import 'package:simple_todo_flutter/resources/icons/icons.dart';
import 'package:simple_todo_flutter/ui/custom/animated_gesture_detector.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

enum SizeType {
  DEFAULT,
  SMALL,
}

class TagItem extends StatefulWidget {
  final Tag tag;
  final VoidCallback onRemove;

  final SizeType type;
  final bool isEnabled;

  const TagItem({Key? key, required this.tag, required this.onRemove, this.type = SizeType.DEFAULT, this.isEnabled = true})
      : super(key: key);

  @override
  _TagItemState createState() => _TagItemState();
}

class _TagItemState extends State<TagItem> with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    switch (widget.type) {
      case SizeType.DEFAULT: return _widgetDefault();
      case SizeType.SMALL: return _widgetSmall();
    }
  }

  Widget _widgetDefault() {
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

  Widget _widgetSmall() {
    return Container(
      decoration: BoxDecoration(
          color: Color.lerp(context.surfaceAccent, Color(widget.tag.colorCode), widget.isEnabled ? 0 : 1),
          borderRadius: BorderRadius.all(Radiuss.circle)),
      padding: EdgeInsets.symmetric(
        vertical: Paddings.small_half.h,
        horizontal: Paddings.small.w,
      ),
      margin: EdgeInsets.only(
        right: Margin.small_half.w,
      ),
      child: Text(
        widget.tag.title,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
            color:
            Color.lerp(context.onSurface, context.getColorByBrightness(Color(widget.tag.colorCode)), widget.isEnabled ? 0 : 1),
            fontWeight: FontWeight.w500, fontSize: Dimens.text_small_bigger),
      ),
    );
  }
}