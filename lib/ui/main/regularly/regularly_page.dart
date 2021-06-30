import 'package:animated_size_and_fade/animated_size_and_fade.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:simple_todo_flutter/data/models/task_regular/task_regular.dart';
import 'package:simple_todo_flutter/resources/colors.dart';
import 'package:simple_todo_flutter/resources/dimens.dart';
import 'package:simple_todo_flutter/resources/icons.dart';
import 'package:simple_todo_flutter/resources/routes.dart';
import 'package:simple_todo_flutter/ui/custom/animated_gesture_detector.dart';
import 'package:simple_todo_flutter/ui/custom/clippers/app_bar_clipper_2.dart';
import 'package:simple_todo_flutter/ui/custom/day_and_date_widget.dart';
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
      future: _model.initRepo(),
      child: Stack(
        children: [
          SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Column(
              children: [
                SizedBox(
                  height: Dimens.top_curve_height,
                ),
                _taskList(),
                SizedBox(
                  height: Margin.big.h,
                ),
              ],
            ),
          ),
          _appBar(),
          Container(
            margin: EdgeInsets.only(
              top: Dimens.getStatusBarHeight(context) + Margin.middle,
              right: Margin.middle,
            ),
            alignment: Alignment.topRight,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                AnimatedGestureDetector(
                  onTap: () async {
                    _model.showAllTasks = !_model.showAllTasks;
                    setState(() {});
                  },
                  child: Container(
                    child: Text("all"),
                  ),
                ),
                AnimatedGestureDetector(
                  onTap: () async {
                    _currentDate = (await _model.showDateCalendarPicker(
                        context, _currentDate)) ??
                        _currentDate;
                    _currentDate.onlyDate();
                    setState(() {});
                  },
                  child: Container(
                    child: Icon(IconsC.calendar),
                  ),
                ),
              ],
            ),
          ),
          _fab(),
        ],
      ),
    );
  }

  Widget _taskWidget(TaskRegular task) {
    return AnimatedSizeAndFade(
      vsync: this,
      child: _model.isTaskShouldBeShown(task, _currentDate) ? Slidable(
        actionPane: SlidableBehindActionPane(),
        closeOnScroll: true,
        actions: !_model.showAllTasks ? [
          CompleteAction(onTap: () async {
            _model.addCompletedDay(task, _currentDate);
            await Future.delayed(Duration(milliseconds: 200));
            setState(() { });
          }),
        ] : null,
        secondaryActions: !_model.showAllTasks ? [
          DeleteAction(onTap: () async {
            _showDeleteDialog(task);
            //_model.removeTask(index);
            await Future.delayed(Duration(milliseconds: 200));
            setState(() {});
          }),
        ] : null,
        child: AnimatedGestureDetector(
          onTap: () => _goToTaskEdit(task),
          child: Container(
            margin: EdgeInsets.symmetric(
              vertical: Margin.small.h,
              horizontal: Margin.middle.w
            ),
            padding: EdgeInsets.symmetric(
              vertical: Paddings.big.h,
              horizontal: Paddings.small.w,
            ),
            decoration: new BoxDecoration(
                color: context.surface,
                borderRadius:
                new BorderRadius.all(Radiuss.small_smaller)),
            child: Row(
              children: [
                SizedBox(
                  width: Margin.small.w,
                ),
                SizedBox(
                  width: Margin.middle.w,
                ),
                Expanded(
                  child: Container(
                    child: Text(
                      task.title,
                      style: TextStyle(),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ) : Container(),
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
            SizedBox(
              height: Margin.middle.h,
            ),
            Row(
              children: [
                DayAndDateWidget(date: _currentDate),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget _fab() {
    return Container(
      alignment: Alignment.bottomRight,
      margin: EdgeInsets.only(
          right: Margin.middle,
          bottom: Margin.big.h + Margin.small.h),
      child: AnimatedGestureDetector(
          onTap: () {
            _goToTaskEdit(null);
          },
          child: Container(
            decoration: BoxDecoration(
              color: context.primary,
              borderRadius: BorderRadius.all(Radiuss.circle),
              boxShadow: [Shadows.middle(context)],
            ),
            padding: EdgeInsets.all(Paddings.middle_smaller),
            child: Icon(
              IconsC.add,
              color: context.surface,
            ),
          )),
    );
  }

  _goToTaskEdit(TaskRegular? task) async {
    TaskRegular? result = await Routes.showBottomTaskRegEditPage(
        context,
        task: task ?? null, dateTime: _currentDate);

    if(result != null) {
      if(task != null)
        task = result;
      else
        _model.tasks.add(result);
      setState(() {});
    }
  }

  _showDeleteDialog(TaskRegular task) {
    showDialog(
        context: context,
        builder: (contextDialog) => AlertDialog(
              backgroundColor: Colors.transparent,
              content: Container(
                decoration: BoxDecoration(
                  color: context.surface,
                  borderRadius: BorderRadius.all(Radiuss.small),
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
                            await _model.deleteTaskForDay(task, _currentDate);
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
                            await _model.deleteTaskForDay(task, _currentDate);
                            setState(() {});
                            await Future.delayed(Duration(milliseconds: 200));
                            await _model.deleteTask(task);
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

  List<Widget> _getTaskList(List<TaskRegular> tasks) {
    List<Widget> list = [];

    for (var task in tasks)
        list.add(_taskWidget(task));

    return list;
  }
}
