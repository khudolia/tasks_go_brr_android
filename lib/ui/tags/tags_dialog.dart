import 'package:animated_size_and_fade/animated_size_and_fade.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:simple_todo_flutter/data/models/tag/tag.dart';
import 'package:simple_todo_flutter/data/repositories/tags_repository.dart';
import 'package:simple_todo_flutter/resources/colors.dart';
import 'package:simple_todo_flutter/resources/dimens.dart';
import 'package:simple_todo_flutter/resources/icons/icons.dart';
import 'package:simple_todo_flutter/resources/routes.dart';
import 'package:simple_todo_flutter/ui/custom/animated_gesture_detector.dart';
import 'package:simple_todo_flutter/ui/custom/button_icon_rounded.dart';
import 'package:simple_todo_flutter/ui/custom/input_field_rounded.dart';
import 'package:simple_todo_flutter/ui/custom/slidable_actions.dart';

class TagsDialog extends StatefulWidget {
  final TagsRepository repo;
  final List<String> selectedTags;
  const TagsDialog({Key? key, required this.repo, required this.selectedTags}) : super(key: key);

  @override
  _TagsDialogState createState() => _TagsDialogState();
}

class _TagsDialogState extends State<TagsDialog> {
  TextEditingController controller = TextEditingController();
  List<Tag> chosenTags = [];
  Tag _tag = Tag();

  @override
  void initState() {
    controller.addListener(() {setState((){});});
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => Routes.back(context, result: chosenTags),
      child: Material(
        child: Container(
          decoration: BoxDecoration(
              color: context.surface,
              borderRadius: BorderRadius.all(Radiuss.small_smaller)),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              InputFieldRounded(textController: controller),
              SizedBox(
                height: Margin.middle.h,
              ),
              _editWidget(onAdd: (tag) async {
                await widget.repo.addTag(tag);
                _tag = Tag();
                setState(() {});
              }),
              SizedBox(
                height: Margin.middle.h,
              ),
              SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                  child: _tagsList(widget.repo, controller, chosenTags)),
              AnimatedGestureDetector(
                onTap: () async {
                  Routes.back(context, result: chosenTags);
                },
                child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: context.primary,
                      borderRadius: BorderRadius.all(Radiuss.small_smaller),
                    ),
                    padding: EdgeInsets.symmetric(
                        horizontal: Paddings.small,
                        vertical: Paddings.small_bigger),
                    child: Center(
                        child: Text(
                          "action.save".tr(),
                          style: TextStyle(
                              color: context.onPrimary,
                              fontWeight: FontWeight.bold),
                        ))),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _editWidget({required Function(Tag) onAdd}) {
    TextEditingController controller = TextEditingController();

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        AnimatedGestureDetector(
          onTap: () async {
            var color = await _showColorDialog(Color(_tag.colorCode));

            if(color != null) {
              setState(() {
                _tag.colorCode = color;
              });
            }
          },
          child: Container(
            width: 24,
            height: 24,
            color:  Color(_tag.colorCode),
          ),
        ),
        SizedBox(
          width: Margin.small.w,
        ),
        Flexible(
          child: TextFormField(
            controller: controller,
          ),
        ),
        SizedBox(
          height: Margin.middle.h,
        ),
        _buttonRoundedWithIcon(
            iconColor: context.onSurface,
            backgroundColor: context.surfaceAccent,
            icon: IconsC.add,
            onTap: () => onAdd(_tag
              ..title = controller.text)),
        SizedBox(
          height: Margin.middle.h,
        ),
      ],
    );
  }

  Widget _buttonRoundedWithIcon(
      {required Color backgroundColor,
        required Color iconColor,
        required IconData icon,
        required VoidCallback onTap, String? text}) {
    return ButtonIconRounded(
      icon: icon,
      onTap: onTap,
      backgroundColor: backgroundColor,
      iconColor: iconColor,
      text: text ?? null,
      textColor: context.onSurface,
      padding: EdgeInsets.symmetric(
          vertical: Paddings.small, horizontal: Paddings.middle),
    );
  }

  Widget _tagsList(TagsRepository repo, TextEditingController controller, List<Tag> selectedTags) {
    List<Widget> list = [];

    for(var tag in repo.getAllTags())
      if (!widget.selectedTags.contains(tag.id))
        list.add(_TagItem(
          controller: controller,
          tag: tag,
          onAdd: () => selectedTags.add(tag),
          onDelete: () async => repo.removeTag(tag.id),
        ));

    return Column(children: list,);
  }

  _showColorDialog(Color color) async {
    Color chosenColor = color;
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          elevation: 0,
          backgroundColor: Colors.transparent,
          content: Container(
              decoration: BoxDecoration(
                  color: context.surface,
                  borderRadius: BorderRadius.all(Radiuss.small_smaller)),
              child: Column(
                children: [
                  ColorPicker(
                    pickerColor: color,
                    onColorChanged: (color) => setState(()=> chosenColor = color),
                    enableAlpha: false,
                    displayThumbColor: false,
                    showLabel: false,
                    paletteType: PaletteType.hsv,
                    pickerAreaBorderRadius: BorderRadius.all(
                        Radiuss.middle
                    ),
                  ),
                  AnimatedGestureDetector(
                    onTap: () async {
                      Routes.back(context, result: chosenColor.value);
                    },
                    child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: context.primary,
                          borderRadius: BorderRadius.all(Radiuss.small_smaller),
                        ),
                        padding: EdgeInsets.symmetric(
                            horizontal: Paddings.small,
                            vertical: Paddings.small_bigger),
                        child: Center(
                            child: Text(
                              "action.save".tr(),
                              style: TextStyle(
                                  color: context.onPrimary,
                                  fontWeight: FontWeight.bold),
                            ))),
                  ),
                ],
              )),
        );
      },
    );
    return chosenColor.value;
  }
}

class _TagItem extends StatefulWidget {
  final Tag tag;
  final TextEditingController controller;
  final VoidCallback onDelete;
  final VoidCallback onAdd;

  const _TagItem(
      {Key? key, required this.tag, required this.controller, required this.onDelete, required this.onAdd})
      : super(key: key);

  @override
  _TagItemState createState() => _TagItemState();
}

class _TagItemState extends State<_TagItem> with TickerProviderStateMixin {
  bool isVisible = true;
  @override
  Widget build(BuildContext context) {
    print(widget.tag.colorCode);
    return AnimatedSizeAndFade(
      vsync: this,
      child: isItemVisible()
          ? Slidable(
              actionPane: SlidableBehindActionPane(),
              closeOnScroll: true,
              secondaryActions: [
                DeleteAction(
                  onTap: () {
                    isVisible = false;
                    setState(() {});
                    widget.onDelete();
                  },
                )
              ],
              child: AnimatedGestureDetector(
                onTap: () {
                  isVisible = false;
                  setState(() {
                  });
                  widget.onAdd();
                },
                child: Container(
                  decoration: BoxDecoration(
                      color: context.surface,
                      borderRadius: BorderRadius.all(Radiuss.small_smaller)),
                  height: 50,
                  child: Row(
                    children: [
                      Container(
                        width: 24,
                        height: 24,
                        color: Color(widget.tag.colorCode),
                      ),
                      SizedBox(
                        width: Margin.small.w,
                      ),
                      Text(
                        widget.tag.title,
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: context.onSurface,
                        ),
                      )
                    ],
                  ),
                ),
              ),
            )
          : Container(),
    );
  }

  bool isItemVisible() {
    if(!isVisible)
      return isVisible;

    return widget.controller.text.isEmpty ||
        widget.tag.title.contains(widget.controller.text);
  }

}
