import 'dart:ui';

import 'package:animated_size_and_fade/animated_size_and_fade.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:implicitly_animated_reorderable_list/implicitly_animated_reorderable_list.dart';
import 'package:implicitly_animated_reorderable_list/transitions.dart';
import 'package:simple_todo_flutter/data/models/task/task.dart';
import 'package:simple_todo_flutter/resources/constants.dart';
import 'package:simple_todo_flutter/resources/dimens.dart';
import 'package:simple_todo_flutter/resources/colors.dart';
import 'package:simple_todo_flutter/resources/icons/icons.dart';
import 'package:simple_todo_flutter/resources/routes.dart';
import 'package:simple_todo_flutter/ui/custom/button_icon_rounded.dart';
import 'package:simple_todo_flutter/ui/custom/checkbox_custom.dart';
import 'package:simple_todo_flutter/ui/custom/future_builder_success.dart';
import 'package:simple_todo_flutter/ui/custom/input_field_rounded.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:simple_todo_flutter/ui/custom/slidable_actions.dart';
import 'package:simple_todo_flutter/ui/task/task_edit_view_model.dart';
import 'package:simple_todo_flutter/utils/time.dart';

class TaskEditPage extends StatefulWidget {
  final Task? task;
  final DateTime date;

  const TaskEditPage({Key? key, this.task, required this.date}) : super(key: key);

  @override
  _TaskEditPageState createState() => _TaskEditPageState();
}

class _TaskEditPageState extends State<TaskEditPage> with TickerProviderStateMixin{
  TaskEditViewModel _model = TaskEditViewModel();

  final TextEditingController _cntrlTitle = TextEditingController();
  final TextEditingController _cntrlDescription = TextEditingController();
  final TextEditingController _cntrlAddItem = TextEditingController();

  final _formKeyTitle = GlobalKey<FormState>();

  @override
  void initState() {
    if(widget.task != null)
      _model.task = widget.task!;
    else
      _model.task = Task()..date = widget.date.millisecondsSinceEpoch;

    _setListeners();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilderSuccess(
      future: _model.initRepo(widget.date),
      child: FractionallySizedBox(
        heightFactor: _getHeightUnderDateWidget(),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Container(
            decoration: new BoxDecoration(
                color: context.surface,
                borderRadius: new BorderRadius.only(
                    topLeft: Radiuss.middle, topRight: Radiuss.middle)),
            child: Container(
              margin: EdgeInsets.only(
                top: Margin.middle_smaller.h,
              ),
              child: Column(
                children: [
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: Margin.middle),
                    child: Row(
                      children: [
                        _buttonRoundedWithIcon(
                            backgroundColor: context.surfaceAccent,
                            iconColor: context.onSurface,
                            icon: IconsC.back,
                            onTap: () => Routes.back(context)),
                        Expanded(
                          child: Container(),
                        ),
                        _buttonRoundedWithIcon(
                          backgroundColor: context.primary,
                          iconColor: context.onPrimary,
                          icon: IconsC.check,
                          onTap: () async {
                            if(!_formKeyTitle.currentState!.validate())
                              return;

                            await _model.completeTask(
                                context, widget.task, widget.date);
                            Routes.back(context, result: _model.task);
                            _model.resetTask();
                          } ,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: Margin.small.h,
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      physics: BouncingScrollPhysics(),
                      child: Column(
                        children: [
                          SizedBox(
                            height: Margin.small.h,
                          ),
                          _titleOfCategory(
                            text: "title".tr()
                          ),
                          SizedBox(
                            height: Margin.small.h,
                          ),
                          _inputField(
                            label: "title".tr(),
                            maxLines: 1,
                            textController: _cntrlTitle,
                            formKey: _formKeyTitle,
                            validator: (value) {
                              if (value!.trim().isEmpty) {
                                return "error.title_cant_be_empty".tr();
                              }

                              return null;
                            },
                          ),
                          SizedBox(
                            height: Margin.middle.h,
                          ),
                          Container(
                            margin: EdgeInsets.symmetric(
                              horizontal: Margin.middle.w
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Expanded(
                                    child: _titledButtonWidget(
                                  title: "time".tr(),
                                  icon: IconsC.clock,
                                  textButton:
                                      _model.getFormattedTime(_model.task.time),
                                  onTap: () async {
                                    await _model.showTimePicker(context);
                                    setState(() {});
                                  },
                                )),
                                SizedBox(
                                  width: Margin.middle.w,
                                ),
                                Expanded(
                                  child: _titledButtonWidget(
                                    title: "date".tr(),
                                    icon: IconsC.calendar,
                                    textButton:
                                        _model.getFormattedDate(_model.task.date),
                                    onTap: () async {
                                      await _model.showDateCalendarPicker(context);
                                      setState(() {});
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: Margin.middle.h,
                          ),
                          _remindBeforeWidget(),
                          _titleOfCategory(
                              text: "checklist".tr()
                          ),
                          SizedBox(
                            height: Margin.small.h,
                          ),
                          _checkInput(),
                          _checklistReorderable(),
                          SizedBox(
                            height: Margin.middle.h,
                          ),
                          _titleOfCategory(
                              text: "description".tr()
                          ),
                          SizedBox(
                            height: Margin.small.h,
                          ),
                          _inputField(
                              textController: _cntrlDescription,
                              label: "description".tr(), maxLines: 3),
                          SizedBox(
                            height: Margin.middle.h,
                          ),
                          Container(
                            margin: EdgeInsets.symmetric(
                              horizontal: Margin.big.w * 2,
                            ),
                            child: Image.asset(ImagePath.CAT_WITH_FRIEND, color: context.onSurface,),
                          ),
                          SizedBox(
                            height: Margin.middle.h,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _checkInput() {
    return _inputField(
      label: "item".tr(),
      maxLines: 1,
      textController: _cntrlAddItem,
      buttonIcon: IconsC.add,
      shouldUnfocus: false,
      onTap: () {
        if (_cntrlAddItem.text.isNotEmpty) {
          _model.addNewItemToChecklist(_cntrlAddItem.text);
          _cntrlAddItem.clear();
          setState(() {});
        }
      },
    );
  }

  Widget _checklistReorderable() {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: Margin.middle.w,
      ),
      child: ImplicitlyAnimatedReorderableList<CheckItem>(
        shrinkWrap: true,
        items: _model.task.checkList,
        areItemsTheSame: (oldItem, newItem) => oldItem == newItem,
        onReorderFinished: (item, from, to, newItems) {
          setState(() => _model.updateChecklist(newItems));
        },
        itemBuilder: (context, itemAnimation, item, index) {
          return Reorderable(
            key: ValueKey(item),
            builder: (context, dragAnimation, inDrag) {
              return Slidable(
                actionPane: SlidableBehindActionPane(),
                closeOnScroll: true,
                secondaryActions: [
                  DeleteAction(
                    onTap: () async {
                      _model.task.checkList.removeAt(index);
                      await Future.delayed(Duration(milliseconds: 200));
                      setState(() {});
                    },
                  )
                ],
                child: SizeFadeTransition(
                  sizeFraction: 0.7,
                  curve: Curves.easeInOut,
                  animation: itemAnimation,
                  child: Container(
                    margin: EdgeInsets.symmetric(
                      vertical: Margin.small_very.h,
                    ),
                    padding: EdgeInsets.symmetric(
                      vertical: Paddings.small.h,
                      horizontal: Paddings.small.w,
                    ),
                    decoration: new BoxDecoration(
                        color: context.surface,
                        borderRadius: new BorderRadius.all(Radiuss.small_smaller)),
                    child: Row(
                      children: [
                        CheckboxCustom(
                          onChanged: (state) async {
                            await _model.changeCheckItemStatus(index);

                            setState(() {});
                          },
                          value: index < _model.task.checkList.length
                              ? _model.task.checkList[index].isCompleted
                              : false,
                        ),
                        Expanded(
                          child: TextFormField(
                            initialValue: item.text,
                            onChanged: (text) => {
                              item.text = text,
                              _model.changeCheckItemText(
                                  _model.task.checkList[index], text)
                            },
                            style: TextStyle(
                              decoration: index < _model.task.checkList.length &&
                                  _model.task.checkList[index].isCompleted
                                  ? TextDecoration.lineThrough
                                  : TextDecoration.none,
                              color: context.onSurface
                            ),
                          ),
                        ),
                        Handle(
                          delay: Durations.handle_short,
                          child: Icon(
                            IconsC.handle,
                            color: context.onSurface,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _remindBeforeWidget() {
    return AnimatedSizeAndFade(
      vsync: this,
      child: _model.task.time != null
          ? Column(
              children: [
                Container(
                  alignment: Alignment.centerLeft,
                  margin: EdgeInsets.symmetric(horizontal: Margin.middle.w),
                  child: _titledButtonWidget(
                    icon: IconsC.remind,
                    onTap: () async => await _model.showBeforeTimePicker(context) != null ? setState((){}) : null,
                    title: _model.task.remindBeforeTask != null
                        ? "remind_before_task".tr()
                        : "dont_remind".tr(),
                    textButton: _model.task.remindBeforeTask != null
                        ? Time.getBeforeTimeFromMilliseconds(
                            _model.task.remindBeforeTask!)
                        : "add_time".tr(),
                    isCanceled: _model.task.remindBeforeTask != null,
                    onCancel: () =>
                        setState(() => _model.task.remindBeforeTask = null),
                  ),
                ),
                SizedBox(
                  height: Margin.middle.h,
                ),
              ],
            )
          : Container(),
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

  Widget _titledButtonWidget(
      {required String title,
      required IconData icon,
      required String textButton,
      required VoidCallback onTap,
      VoidCallback? onCancel,
      bool isCanceled = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            color: context.onSurface,
            fontWeight: FontWeight.bold,
            fontSize: Dimens.text_normal,
          ),
        ),
        SizedBox(
          height: Margin.small_half.h,
        ),
        isCanceled
            ? Row(
                children: [
                  _buttonRoundedWithIcon(
                    backgroundColor: context.surfaceAccent,
                    iconColor: context.onSurface,
                    icon: icon,
                    text: textButton,
                    onTap: onTap,
                  ),
                  SizedBox(
                    width: Margin.small.w,
                  ),
                  _buttonRoundedWithIcon(
                    backgroundColor: context.surfaceAccent,
                    iconColor: context.onSurface,
                    icon: IconsC.delete,
                    onTap: onCancel!,
                  ),
                ],
              )
            : _buttonRoundedWithIcon(
                backgroundColor: context.surfaceAccent,
                iconColor: context.onSurface,
                icon: icon,
                text: textButton,
                onTap: onTap,
              ),
      ],
    );
  }

  Widget _inputField(
      {Key? formKey, required String label,
      required int maxLines,
        required TextEditingController textController,
      VoidCallback? onTap,
      IconData? buttonIcon,
      bool? shouldUnfocus,
        FormFieldValidator<String>? validator}) {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: Margin.middle,
      ),
      child: InputFieldRounded(
        formKey: formKey ?? null,
        labelText: label,
        maxLines: maxLines,
        textController: textController,
        borderColor: context.primary,
        textColor: context.onSurface,
        labelUnselectedColor: context.onSurfaceAccent,
        buttonIcon: buttonIcon ?? null,
        onTap: onTap,
        shouldUnfocus: shouldUnfocus ?? null,
        validator: validator ?? null,
      ),
    );
  }

  Widget _titleOfCategory({required String text}) {
    return Container(
      alignment: Alignment.centerLeft,
      margin: EdgeInsets.only(
          left: Margin.middle
      ),
      child: Text(text,
        style: TextStyle(
          color: context.onSurface,
          fontWeight: FontWeight.bold,
          fontSize: Dimens.text_normal,
        ),),
    );
  }

  double _getHeightUnderDateWidget() {
    return (1.sh -
        (Dimens.app_bar_height +
            Dimens.getStatusBarHeight(context) +
            1.5 * Margin.big)) /
        1.sh;
  }

  _setListeners() {
    _cntrlTitle..addListener(() {
      _model.task.title = _cntrlTitle.text;
    })..text = _model.task.title;

    _cntrlDescription..addListener(() {
      _model.task.description = _cntrlDescription.text;
    })..text = _model.task.description;
  }


}
