
import 'package:flutter/material.dart';
import 'package:simple_todo_flutter/data/models/tag/tag.dart';
import 'package:simple_todo_flutter/resources/dimens.dart';
import 'package:simple_todo_flutter/resources/colors.dart';
import 'package:simple_todo_flutter/resources/icons/icons.dart';
import 'package:simple_todo_flutter/resources/routes.dart';
import 'package:simple_todo_flutter/ui/custom/animated_gesture_detector.dart';
import 'package:simple_todo_flutter/ui/custom/button_icon_rounded.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:simple_todo_flutter/ui/custom/title_of_category.dart';
import 'package:simple_todo_flutter/ui/tags/list/tag_list_item.dart';

class TagsList extends StatefulWidget {
  final dynamic model;
  const TagsList({Key? key, required this.model}) : super(key: key);

  @override
  _TagsListState createState() => _TagsListState();
}

class _TagsListState extends State<TagsList> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Row(
            children: [
              TitleOfCategory(text: "tags".tr()),
              SizedBox(
                width: Margin.small.w,
              ),
              widget.model.task.tags.isNotEmpty ? AnimatedGestureDetector(
                  onTap: () async => await _openTagDialog(),
                  child: Container(
                    decoration: BoxDecoration(
                        color: context.surfaceAccent,
                        borderRadius: BorderRadius.all(Radiuss.circle)),
                    padding: EdgeInsets.all(1),
                        child: Icon(
                      IconsC.add,
                      color: context.onSurface,
                    ),
                  )) : Container(),
            ],
          ),
          SizedBox(
            height: Margin.small.h,
          ),
          Container(
            alignment: Alignment.centerLeft,
            margin: EdgeInsets.only(left: Margin.middle.w),
            child: widget.model.task.tags.isEmpty ? ButtonIconRounded(
                icon: IconsC.tag,
                onTap: () async => await _openTagDialog(),
                backgroundColor: context.surfaceAccent,
                iconColor: context.onSurface,
                text: "add_tags".tr(),
                textColor: context.onSurface,
                padding: EdgeInsets.symmetric(
                    vertical: Paddings.small, horizontal: Paddings.middle)) :
            Wrap(
              alignment: WrapAlignment.start,
              spacing: Margin.small,
              runSpacing: Margin.small,
              children: _tagsList(),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _tagsList() {
    List<Widget> list = [];

    for (var tag in widget.model.task.tags) {
      list.add(TagItem(
        tag: widget.model.getTag(tag),
        onRemove: () => setState(() =>
            widget.model.task.tags.removeWhere((element) => element == tag)),
      ));
    }

    return list;
  }

  Future _openTagDialog() async {
    List<Tag>? result =
    await Routes.showTagDialog(context, widget.model.task.tags);

    if(result != null)
      setState(() => widget.model.task.tags.addAll(result.map((e) => e.id)));
  }
}