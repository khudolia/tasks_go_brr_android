import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:implicitly_animated_reorderable_list/implicitly_animated_reorderable_list.dart';
import 'package:implicitly_animated_reorderable_list/transitions.dart';
import 'package:simple_todo_flutter/data/models/task/task.dart';
import 'package:simple_todo_flutter/resources/constants.dart';
import 'package:simple_todo_flutter/resources/dimens.dart';
import 'package:simple_todo_flutter/resources/colors.dart';
import 'package:simple_todo_flutter/resources/icons.dart';
import 'package:simple_todo_flutter/resources/routes.dart';
import 'package:simple_todo_flutter/ui/custom/button_icon_rounded.dart';
import 'package:simple_todo_flutter/ui/custom/future_builder_success.dart';
import 'package:simple_todo_flutter/ui/custom/textform_field_rounded.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:simple_todo_flutter/ui/task/task_edit_view_model.dart';

class TaskEditPage extends StatefulWidget {
  final Task? task;
  final DateTime date;

  const TaskEditPage({Key? key, this.task, required this.date}) : super(key: key);

  @override
  _TaskEditPageState createState() => _TaskEditPageState();
}

class _TaskEditPageState extends State<TaskEditPage> {
  TaskEditViewModel _model = TaskEditViewModel();

  final _formKeyTitle = GlobalKey<FormState>();

  @override
  void initState() {
    if(widget.task != null)
      _model.task = widget.task!;
    else
      _model.task = Task()..date = widget.date.millisecondsSinceEpoch;

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
                            iconColor: context.background,
                            icon: IconsC.back,
                            onTap: () => Routes.back(context)),
                        Expanded(
                          child: Container(),
                        ),
                        _buttonRoundedWithIcon(
                          backgroundColor: context.primary,
                          iconColor: context.surface,
                          icon: IconsC.check,
                          onTap: () async {
                            if(!_formKeyTitle.currentState!.validate())
                              return;

                            await _model.completeTask(widget.task, widget.date);
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
                            onChange: (text) => _model.task.title = text,
                            text: _model.task.title,
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
                              onChange: (text) => _model.task.description = text,
                              text: _model.task.description,
                              label: "description".tr(), maxLines: 3),
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
    String inputText = Constants.EMPTY_STRING;
    return _inputField(
      label: "item".tr(),
      maxLines: 1,
      text: inputText,
      onChange: (text) => inputText = text,
      buttonIcon: IconsC.add,
      shouldUnfocus: false,
      onTap: () {
        if (inputText.isNotEmpty) {
          _model.addNewItemToChecklist(inputText);
          inputText = Constants.EMPTY_STRING;
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
                  Container(
                    margin: EdgeInsets.symmetric(
                      vertical: Margin.small_half.h,
                      horizontal: Margin.small_half.w,
                    ),
                    child: SlideAction(
                      closeOnTap: true,
                      decoration: new BoxDecoration(
                          color: context.error,
                          borderRadius: new BorderRadius.all(Radiuss.small_smaller)),
                      onTap: () async {
                        _model.task.checkList
                            .removeAt(index);
                        await Future.delayed(Duration(milliseconds: 200));
                        setState(() {

                        });
                      },
                      child: Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Icon(
                              IconsC.delete,
                              color: context.surface,
                            ),
                            const SizedBox(height: Margin.small_half),
                            Text(
                              "action.delete".tr(),
                              style: TextStyle(
                                color: context.textInversed,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
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
                        Checkbox(
                          activeColor: context.primary,
                          checkColor: context.surface,

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
                            ),
                          ),
                        ),
                        Handle(
                          delay: Durations.handle_short,
                          child: Icon(
                            IconsC.handle,
                            color: context.background,
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
      textColor: context.textDefault,
      padding: EdgeInsets.symmetric(
          vertical: Paddings.small, horizontal: Paddings.middle),
    );
  }

  Widget _titledButtonWidget({required String title, required IconData icon, required String textButton, required VoidCallback onTap}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            color: context.textDefault,
            fontWeight: FontWeight.bold,
            fontSize: Dimens.text_normal,
          ),
        ),
        SizedBox(
          height: Margin.small_half.h,
        ),
        _buttonRoundedWithIcon(
          backgroundColor: context.surfaceAccent,
          iconColor: context.background,
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
      String text = Constants.EMPTY_STRING,
      Function(String)? onChange,
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
        text: text,
        borderColor: context.primary,
        textColor: context.textDefault,
        labelUnselectedColor: context.textSubtitleDefault,
        buttonIcon: buttonIcon ?? null,
        onTap: onTap,
        shouldUnfocus: shouldUnfocus ?? null,
        onChange: onChange ?? (text) {},
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
          color: context.textDefault,
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
}
