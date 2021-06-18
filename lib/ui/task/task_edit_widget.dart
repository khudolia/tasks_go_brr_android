import 'package:flutter/material.dart';
import 'package:simple_todo_flutter/data/models/task/task.dart';
import 'package:simple_todo_flutter/resources/constants.dart';
import 'package:simple_todo_flutter/resources/dimens.dart';
import 'package:simple_todo_flutter/resources/colors.dart';
import 'package:simple_todo_flutter/resources/icons.dart';
import 'package:simple_todo_flutter/resources/routes.dart';
import 'package:simple_todo_flutter/ui/custom/animated_gesture_detector.dart';
import 'package:simple_todo_flutter/ui/custom/future_builder_success.dart';
import 'package:simple_todo_flutter/ui/custom/textform_field_rounded.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:simple_todo_flutter/ui/task/task_edit_view_model.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TaskEditWidget extends StatefulWidget {
  final Function(Task) taskAdded;
  final DateTime date;

  const TaskEditWidget({Key? key, required this.taskAdded, required this.date}) : super(key: key);

  @override
  _TaskEditWidgetState createState() => _TaskEditWidgetState();
}

class _TaskEditWidgetState extends State<TaskEditWidget> {
  TaskEditViewModel _model = TaskEditViewModel();

  final _formKeyTitle = GlobalKey<FormState>();
  final TextEditingController controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return FutureBuilderSuccess(
      future: _model.initRepo(),
      child: Container(
        decoration: BoxDecoration(
          color: context.primary,
          borderRadius: BorderRadius.only(
            topLeft: Radiuss.small,
            topRight: Radiuss.small,
            bottomLeft: Radiuss.small,
          ),
        ),
        child: Column(
          children: [
            SizedBox(
              height: Margin.middle,
            ),
            _inputField(),
            SizedBox(
              height: Margin.small.h,
            ),
            _additionalSettings(),
            SizedBox(
              height: Margin.small.h,
            ),
          ],
        ),
      ),
    );
  }

  Widget _inputField() {
    return Container(
      margin: EdgeInsets.only(
          left: Margin.middle.w,
        right: Margin.small.w,
      ),
      child: InputFieldRounded(
        key: GlobalKey(),
        labelText: "task".tr(),
        maxLines: 1,
        textController: controller,
        formKey: _formKeyTitle,
        onChange: (text) => _model.changeTitle(text),
        text: _model.task.title,
        borderColor: context.surface,
        textColor: context.textInversed,
        labelUnselectedColor: context.textSubtitleInversed,
        buttonIcon: IconsC.check,
        shouldUnfocus: false,
        validator: (value) {
          if (value!.trim().isEmpty) {
            return "error.title_cant_be_empty".tr();
          }

          return null;
        },
        onTap: () async {
          if(!_formKeyTitle.currentState!.validate())
            return;

          await _model.saveTask(context, widget.date);
          widget.taskAdded(_model.task);
          _model.resetTask();
        },
      ),
    );
  }

  Widget _additionalSettings() {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: Margin.middle.w,
      ),
      child: Stack(
        children: [
          Row(
            children: [
              AnimatedGestureDetector(
                child: Container(
                  decoration: BoxDecoration(
                    color: context.surface,
                    borderRadius: BorderRadius.all(Radiuss.small_smaller),
                  ),
                  padding: EdgeInsets.symmetric(
                    vertical: Paddings.small_half,
                    horizontal: Paddings.small,
                  ),
                  child: Row(
                    children: [
                      Icon(
                        IconsC.clock,
                      ),
                      Text(_model.getFormattedTime(_model.task.time)),
                    ],
                  ),
                ),
                onTap: () async {
                  await _model.showTimePicker(context);
                  setState(() {});
                },
              ),
            ],
          ),
          Positioned(
            right: 0,
            child: AnimatedGestureDetector(
              child: Container(
                decoration: BoxDecoration(
                  color: context.surface,
                  borderRadius: BorderRadius.all(Radiuss.small_smaller),
                ),
                padding: EdgeInsets.symmetric(
                  vertical: Paddings.small_half,
                  horizontal: Paddings.small,
                ),
                child: Icon(
                  IconsC.more,
                ),
              ),
              onTap: () => _extendWidget(),
            ),
          ),
        ],
      ),
    );
  }

  _extendWidget() async {
    var result = await Routes.showBottomEditPage(context,
        task: _model.task.title.isNotEmpty ? _model.task : null,
        date: widget.date);

    if(result != null) {
      widget.taskAdded(result);
      _model.task = Task();
    }
  }
}
