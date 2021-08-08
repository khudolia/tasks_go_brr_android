import 'package:animated_size_and_fade/animated_size_and_fade.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:simple_todo_flutter/data/models/task_regular/task_regular.dart';
import 'package:simple_todo_flutter/resources/colors.dart';
import 'package:simple_todo_flutter/resources/dimens.dart';
import 'package:simple_todo_flutter/resources/icons/icons.dart';
import 'package:simple_todo_flutter/resources/routes.dart';
import 'package:simple_todo_flutter/ui/custom/animated_gesture_detector.dart';
import 'package:simple_todo_flutter/ui/custom/clippers/app_bar_clipper_2.dart';
import 'package:simple_todo_flutter/ui/custom/day_and_date_widget.dart';
import 'package:simple_todo_flutter/ui/custom/floating_action_button.dart';
import 'package:simple_todo_flutter/ui/custom/future_builder_success.dart';
import 'package:simple_todo_flutter/ui/custom/slidable_actions.dart';
import 'package:simple_todo_flutter/ui/main/regularly/regularly_page_view_model.dart';
import 'package:simple_todo_flutter/utils/time.dart';

class RegularlyPage extends StatefulWidget {
  const RegularlyPage({Key? key}) : super(key: key);

  @override
  _RegularlyPageState createState() => _RegularlyPageState();
}

class _RegularlyPageState extends State<RegularlyPage> with TickerProviderStateMixin {
  RegularlyPageViewModel _model = RegularlyPageViewModel();

  DateTime _currentDate = DateTime.now().onlyDate();

  @override
  Widget build(BuildContext context) {
    return FutureBuilderSuccess(
      future: _model.initRepo(_currentDate),
      child: Stack(
        children: [
          SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Column(
              children: [
                SizedBox(
                  height: Dimens.top_curve_height_2,
                ),
                _taskList(),
                SizedBox(
                  height: Margin.big.h,
                ),
              ],
            ),
          ),
          _appBar(),
          FAB(
            onTap: () => _goToTaskEdit(),
            icon: IconsC.add,
          ),
        ],
      ),
    );
  }

  Widget _taskList() {
    return StreamBuilder<List<TaskRegular>>(
      initialData: [],
      stream: _model.streamTasks.stream,
      builder: (context, snapshot) {
        return Column(
          children: _getTaskList(snapshot.data!),
        );
      },
    );
  }

  Widget _appBar() {
    return Stack(
      children: [
        PreferredSize(
          preferredSize: Size.fromHeight(Dimens.app_bar_height),
          child: ClipPath(
            clipper: AppBarClipper2(),
            child: Container(
              color: context.secondary,
            ),
          ),
        ),
        Column(
          children: [
            SizedBox(
              height: Dimens.getStatusBarHeight(context),
            ),
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  margin: EdgeInsets.only(
                    top: Margin.middle.h,
                  ),
                  child: AnimatedGestureDetector(
                      onTap: () async {
                        _currentDate = (await Routes.showDateCalendarPicker(
                            context, _currentDate)) ??
                            _currentDate;
                        _currentDate.onlyDate();
                        setState(() {});
                      },
                      child: DayAndDateWidget(date: _currentDate)),
                ),
                Flexible(
                  child: AnimatedGestureDetector(
                      onTap: () async {
                        _model.showAllTasks = !_model.showAllTasks;
                        setState(() {});
                      },
                      child: Container(
                        margin: EdgeInsets.only(
                          right: Margin.middle.h,
                          left: Margin.middle.h,
                        ),
                        decoration: BoxDecoration(
                            color: context.surface,
                            borderRadius: BorderRadius.all(Radiuss.circle),
                            boxShadow: [Shadows.smallAround(context)]
                        ),
                        padding: EdgeInsets.symmetric(
                            vertical: Paddings.small_bigger,
                            horizontal: Paddings.middle_bigger),
                        child: AutoSizeText(
                          !_model.showAllTasks
                              ? "action.show_all".tr()
                              : "action.hide".tr(),
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          style: TextStyle(
                              color: context.textSubtitleDefault,
                              fontWeight: FontWeight.w500,
                              fontSize: Dimens.text_normal),
                        ),
                      )),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  _goToTaskEdit() async {
    TaskRegular? result = await Routes.showBottomTaskRegEditPage(
        context,
        task: null, dateTime: _currentDate);

    if (result != null) {
      _model.tasks.add(result);
      setState(() {});
    }
  }

  List<Widget> _getTaskList(List<TaskRegular> tasks) {
    List<Widget> list = [];

    for (var task in tasks)
      list.add(_TaskItem(
        task: task,
        model: _model,
        currentDate: _currentDate,
      ));

    return list;
  }
}

class _TaskItem extends StatefulWidget {
  final RegularlyPageViewModel model;
  final TaskRegular task;
  final DateTime currentDate;

  const _TaskItem(
      {Key? key,
      required this.model,
      required this.task,
      required this.currentDate})
      : super(key: key);

  @override
  _TaskItemState createState() => _TaskItemState();
}

class _TaskItemState extends State<_TaskItem> with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return AnimatedSizeAndFade(
      vsync: this,
      child: widget.model.isTaskShouldBeShown(widget.task, widget.currentDate)
          ? Container(
              margin: EdgeInsets.symmetric(
                  vertical: Margin.small.h, horizontal: Margin.middle.w),
              child: Slidable(
                actionPane: SlidableBehindActionPane(),
                closeOnScroll: true,
                actions: _getActions(),
                secondaryActions: _getSecondaryActions(),
                child: _cardWidget(),
              ),
            )
          : Container(),
    );
  }

  Widget _cardWidget() {
    return AnimatedGestureDetector(
      onTap: () => _goToTaskEdit(widget.task),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(
          horizontal: Paddings.small.w,
        ),
        decoration: BoxDecoration(
            color: context.surface,
            borderRadius: BorderRadius.all(Radiuss.small_smaller),
            boxShadow: [
              Shadows.smallAround(context),
            ]),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: Margin.middle.h,
            ),
            Container(
              margin: EdgeInsets.only(
                left: Margin.middle.w + Margin.small.w,
              ),
              child: Text(
                widget.task.title,
                style: TextStyle(
                  color: context.textDefault,
                  fontWeight: FontWeight.bold,
                  fontSize: Dimens.text_normal_bigger
                ),
              ),
            ),
            SizedBox(
              height: Margin.big.h,
            ),
          ],
        ),
      ),
    );
  }

  List<Widget>? _getActions() {
    return !widget.model.showAllTasks
        ? [
            CompleteAction(onTap: () async {
              widget.model.addCompletedDay(widget.task, widget.currentDate);
              await Future.delayed(Duration(milliseconds: 200));
              setState(() {});
            }),
          ]
        : null;
  }

  List<Widget>? _getSecondaryActions() {
    return !widget.model.showAllTasks
        ? [
            DeleteAction(
              onTap: () async {
                _showDeleteDialog(widget.task);
                await Future.delayed(Duration(milliseconds: 200));
                setState(() {});
              },
            ),
          ]
        : null;
  }

  _showDeleteDialog(TaskRegular task) {
    showDialog(
        context: context,
        builder: (contextDialog) => AlertDialog(
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          content: Container(
            decoration: BoxDecoration(
              color: context.surface,
              borderRadius: BorderRadius.all(Radiuss.small_smaller),
            ),
            padding: EdgeInsets.symmetric(
                horizontal: Paddings.small, vertical: Paddings.middle),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text("dialog.do_u_want_to_delete".tr()),
                SizedBox(
                  height: Margin.middle,
                ),
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    AnimatedGestureDetector(
                      onTap: () async {
                        Routes.back(contextDialog);
                        await Future.delayed(Duration(milliseconds: 200));
                        await widget.model.deleteTaskForDay(task, widget.currentDate);
                        setState(() {});
                      },
                      child: Container(
                          decoration: BoxDecoration(
                            color: context.error,
                            borderRadius:
                            BorderRadius.all(Radiuss.small_smaller),
                          ),
                          padding: EdgeInsets.symmetric(
                              horizontal: Paddings.small,
                              vertical: Paddings.small),
                          child: Text("action.delete".tr())),
                    ),
                    AnimatedGestureDetector(
                      child: Text("action.delete_all".tr()),
                      onTap: () async {
                        Routes.back(contextDialog);
                        await Future.delayed(Duration(milliseconds: 200));
                        await widget.model.deleteTaskForDay(task, widget.currentDate);
                        setState(() {});
                        await Future.delayed(Duration(milliseconds: 200));
                        await widget.model.deleteTask(task);
                        setState(() {});
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ));
  }

  _goToTaskEdit(TaskRegular? task) async {
    TaskRegular? result = await Routes.showBottomTaskRegEditPage(
        context,
        task: task ?? null, dateTime: widget.currentDate);

    if(result != null) {
      if(task != null)
        task = result;
      else
        widget.model.tasks.add(result);
      setState(() {});
    }
  }

}

