import 'package:animated_size_and_fade/animated_size_and_fade.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:simple_todo_flutter/data/models/tag/tag.dart';
import 'package:simple_todo_flutter/resources/colors.dart';
import 'package:simple_todo_flutter/resources/dimens.dart';
import 'package:simple_todo_flutter/resources/icons/icons.dart';
import 'package:simple_todo_flutter/resources/routes.dart';
import 'package:simple_todo_flutter/ui/base/base_state.dart';
import 'package:simple_todo_flutter/ui/custom/animated_gesture_detector.dart';
import 'package:simple_todo_flutter/ui/custom/button_icon_rounded.dart';
import 'package:simple_todo_flutter/ui/custom/dialog_parts.dart';
import 'package:simple_todo_flutter/ui/custom/input_field_default_custom.dart';
import 'package:simple_todo_flutter/ui/tags/tags_dialog_view_model.dart';

class TagsDialog extends StatefulWidget {
  final List<String> selectedTags;

  const TagsDialog({Key? key, required this.selectedTags}) : super(key: key);

  @override
  _TagsDialogState createState() => _TagsDialogState();
}

class _TagsDialogState extends BaseState<TagsDialog> {
  TagsDialogViewModel _model = TagsDialogViewModel();
  TextEditingController _cTitle = TextEditingController();

  late Future future;

  @override
  void initState() {
    future = _model.initRepo();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: future,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.done)
            return WillPopScope(
              onWillPop: () => Routes.back(context, result: _model.chosenTags),
              child: Scaffold(
                backgroundColor: Colors.transparent,
                resizeToAvoidBottomInset: false,
                body: Stack(
                  children: [
                    GestureDetector(
                      onTap: () =>
                          Routes.back(context, result: _model.chosenTags),
                      child: Container(
                        height: double.infinity,
                        width: double.infinity,
                        color: Colors.transparent,
                      ),
                    ),
                    Center(
                      child: Container(
                        decoration: BoxDecoration(
                            color: context.surface,
                            borderRadius:
                                BorderRadius.all(Radiuss.small_smaller)),
                        margin: EdgeInsets.symmetric(
                          horizontal: Margin.big.w,
                        ),
                        padding: EdgeInsets.symmetric(
                            vertical: Paddings.middle.h,
                            horizontal: Paddings.middle.w),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            DialogTitle(
                              text: "action.choose_tags".tr(),
                            ),
                            _editWidget(),
                            SizedBox(
                              height: Margin.small_half.h,
                            ),
                            _tagsList(),
                            SizedBox(
                              height: Margin.small_half.h,
                            ),
                            DialogPositiveButton(
                              onTap: () => Routes.back(context,
                                  result: _model.chosenTags),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          else
            return Container();
        });
  }

  Widget _editWidget() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        AnimatedGestureDetector(
          onTap: () async {
            var color = await Routes.showColorPickerDialog(context,
                initialColor: Color(_model.tag.colorCode));

            if (color != null) setState(() => _model.tag.colorCode = color);
          },
          child: ClipOval(
            child: Container(
              width: 24,
              height: 24,
              color: Color(_model.tag.colorCode),
            ),
          ),
        ),
        SizedBox(
          width: Margin.small.w,
        ),
        Flexible(
          child: InputFieldDefaultCustom(
            controller: _cTitle,
          ),
        ),
        SizedBox(
          width: Margin.middle.h,
        ),
        ButtonIconRounded(
          icon: IconsC.add,
          onTap: () async {
            _model.tag.title = _cTitle.text;
            await _model.addTag();
            _cTitle.clear();

            unfocus();

            setState(() {});
          },
          backgroundColor: context.surfaceAccent,
          iconColor: context.onSurface,
          padding: EdgeInsets.symmetric(
              vertical: Paddings.small, horizontal: Paddings.middle),
        ),
        SizedBox(
          height: Margin.middle.h,
        ),
      ],
    );
  }

  Widget _tagsList() {
    List<Widget> list = [];

    for (var tag in _model.getAllTags())
      if (!widget.selectedTags.contains(tag.id))
        list.add(_TagItem(
          tag: tag,
          onAdd: () => _model.chosenTags.add(tag),
          onDelete: () async => _model.removeTag(tag.id),
        ));

    return Container(
        height: MediaQuery.of(context).size.height / 3,
        child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Column(
              children: list,
            )));
  }
}

class _TagItem extends StatefulWidget {
  final Tag tag;
  final VoidCallback onDelete;
  final VoidCallback onAdd;

  const _TagItem(
      {Key? key,
      required this.tag,
      required this.onDelete,
      required this.onAdd})
      : super(key: key);

  @override
  _TagItemState createState() => _TagItemState();
}

class _TagItemState extends State<_TagItem> with TickerProviderStateMixin {
  bool isVisible = true;

  @override
  Widget build(BuildContext context) {
    return AnimatedSizeAndFade(
      vsync: this,
      child: isVisible
          ? AnimatedGestureDetector(
              onTap: () {
                setState(() => isVisible = false);
                widget.onAdd();
              },
              child: Container(
                decoration: BoxDecoration(
                    color: context.surface,
                    borderRadius: BorderRadius.all(Radiuss.small_smaller)),
                height: 50,
                child: Row(
                  children: [
                    ClipOval(
                      child: Container(
                        width: 24,
                        height: 24,
                        color: Color(widget.tag.colorCode),
                      ),
                    ),
                    SizedBox(
                      width: Margin.small.w,
                    ),
                    Expanded(
                      child: Text(
                        widget.tag.title,
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: context.onSurface,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: Margin.small.w,
                    ),
                    AnimatedGestureDetector(
                        onTap: () {
                          setState(() => isVisible = false);
                          widget.onDelete();
                        },
                        child: Container(
                          child: Icon(
                            IconsC.delete,
                            color: context.onSurfaceAccent,
                          ),
                        )),
                  ],
                ),
              ),
            )
          : Container(),
    );
  }
}
