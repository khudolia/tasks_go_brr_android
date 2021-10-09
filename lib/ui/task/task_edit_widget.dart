import 'package:animated_size_and_fade/animated_size_and_fade.dart';
import 'package:flutter/material.dart';
import 'package:tasks_go_brr/resources/constants.dart';
import 'package:tasks_go_brr/resources/dimens.dart';
import 'package:tasks_go_brr/resources/colors.dart';
import 'package:tasks_go_brr/resources/icons/icons.dart';
import 'package:tasks_go_brr/resources/routes.dart';
import 'package:tasks_go_brr/ui/custom/animated_gesture_detector.dart';
import 'package:tasks_go_brr/ui/custom/future_builder_success.dart';
import 'package:tasks_go_brr/ui/custom/input_field_rounded.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:tasks_go_brr/ui/task/task_edit_view_model.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tasks_go_brr/utils/time.dart';

class TaskEditWidget extends StatefulWidget {
  final VoidCallback taskAdded;
  final DateTime date;

  const TaskEditWidget({Key? key, required this.taskAdded, required this.date}) : super(key: key);

  @override
  _TaskEditWidgetState createState() => _TaskEditWidgetState();
}

class _TaskEditWidgetState extends State<TaskEditWidget> with TickerProviderStateMixin {
  TaskEditViewModel _model = TaskEditViewModel();

  final _formKeyTitle = GlobalKey<FormState>();
  final TextEditingController _cntrlTitle = TextEditingController();

  bool _shouldValidateTitle = true;
  @override
  void initState() {
    _setListeners();
    _model.task.date = widget.date.onlyDate().millisecondsSinceEpoch;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilderSuccess(
      future: _model.initRepo(widget.date),
      child: Column(
        children: [
          Container(
            height: 1,
            color: context.onSurface.withOpacity(.3),
            margin: EdgeInsets.symmetric(
              horizontal: Margin.middle.w,
            ),
          ),
          SizedBox(
            height: Margin.small.h,
          ),
          _additionalSettings(),
          SizedBox(
            height: Margin.small.h,
          ),
          _inputField(),
          SizedBox(
            height: Margin.middle,
          ),
          SizedBox(
            height: MediaQuery.of(context).viewInsets.bottom / 1.5,
          ),
        ],
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
        labelText: "task".tr(),
        maxLines: 1,
        textController: _cntrlTitle,
        formKey: _formKeyTitle,
        borderColor: context.primary,
        textColor: context.onSurface,
        labelUnselectedColor: context.onSurfaceAccent,
        buttonIcon: IconsC.check,
        shouldUnfocus: true,
        validator: (value) {
          if(!_shouldValidateTitle)
            return null;

          if (value!.trim().isEmpty) {
            return "error.title_cant_be_empty".tr();
          }

          return null;
        },
        onTap: () async {
          if(!_formKeyTitle.currentState!.validate())
            return;

          await _model.saveTask(widget.date);
          widget.taskAdded();
          _model.resetTask(widget.date);
          _shouldValidateTitle = false;
          _cntrlTitle.clear();
        },
      ),
    );
  }

  Widget _additionalSettings() {
    GlobalKey key = GlobalKey();
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: Margin.middle.w,
      ),
      width: double.infinity,
      child: Stack(
        children: [
          SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _timeWidget(),
                _remindWidget(),
                _dateWidget(),
                SizedBox(width: 50.w,)
              ],
            ),
          ),
          Positioned(
            right: 0,
            child: Container(
              key: key,
              decoration: BoxDecoration(
                  color: context.surface,
                  gradient: LinearGradient(
                      tileMode: TileMode.clamp,
                      begin: FractionalOffset.centerLeft,
                      end: FractionalOffset.centerRight,
                      colors: [
                        context.surface.withOpacity(0.0),
                        context.surface,
                        context.surface,
                        context.surface
                      ])
              ),
              padding: EdgeInsets.only(
                left: Paddings.middle.w
              ),
              child: AnimatedGestureDetector(
                child: Container(
                  decoration: BoxDecoration(
                    color: context.primary,
                    borderRadius: BorderRadius.all(Radiuss.small_smaller),
                  ),
                  padding: EdgeInsets.symmetric(
                    vertical: Paddings.small_half,
                    horizontal: Paddings.small,
                  ),
                  child: Icon(
                    IconsC.up,
                    color: context.onPrimary,
                  ),
                ),
                onTap: () => _extendWidget(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _timeWidget() => _smallButtonWidget(
      icon: IconsC.clock,
      onTap: () async {
        await _model.showTimePicker(context, isDeleteWhenHas: true);
        setState(() {});
      },
      text: _model.getFormattedTime(_model.task.time));

  Widget _remindWidget() => AnimatedSizeAndFade(
        vsync: this,
        child: _model.task.time != null
            ? _smallButtonWidget(
                icon: IconsC.remind,
                onTap: () async {
                  await _model.showBeforeTimePicker(context,
                      isDeleteWhenHas: true);
                  setState(() {});
                },
                text: _model.task.remindBeforeTask != null
                    ? Time.getBeforeTimeFromMilliseconds(
                        _model.task.remindBeforeTask!)
                    : Constants.EMPTY_STRING)
            : Container(),
      );

  Widget _dateWidget() => _smallButtonWidget(
      icon: IconsC.calendar,
      onTap: () async {
        await _model.showDateCalendarPicker(context);
        setState(() {});
      },
      text: _model.getFormattedDate(_model.task.date));

  Widget _smallButtonWidget(
          {required IconData icon,
          required String text,
          required VoidCallback onTap}) =>
      Row(
        children: [
          AnimatedGestureDetector(
            child: Container(
              decoration: BoxDecoration(
                color: context.surfaceAccent,
                borderRadius: BorderRadius.all(Radiuss.small_smaller),
              ),
              padding: EdgeInsets.symmetric(
                vertical: Paddings.small_half,
                horizontal: Paddings.middle_smaller,
              ),
              child: Row(
                children: [
                  Icon(
                    icon,
                    color: context.onSurface,
                  ),
                  text.isNotEmpty ? SizedBox(
                    width: Margin.small_half.w,
                  ) : Container(),
                  Text(text, style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: context.onSurface
                  ),),
                ],
              ),
            ),
            onTap: onTap,
          ),
          SizedBox(
            width: Margin.small.w,
          ),
        ],
      );

  _extendWidget() async {
    var result = await Routes.showBottomTaskEditPage(context,
        task: _model.task.title.isNotEmpty ? _model.task : null,
        date: widget.date);

    widget.taskAdded();

    if(result != null) {
      _model.resetTask(widget.date);
      _shouldValidateTitle = false;
      _cntrlTitle.clear();
    }
    setState(() {});
  }

  _setListeners() {
    _cntrlTitle..addListener(() {
      if(_cntrlTitle.text.isNotEmpty)
        _shouldValidateTitle = true;

      _model.changeTitle(_cntrlTitle.text);
    })..text = _model.task.title;
  }
}
