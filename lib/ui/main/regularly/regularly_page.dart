import 'package:animated_size_and_fade/animated_size_and_fade.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:tasks_go_brr/data/models/task_regular/task_regular.dart';
import 'package:tasks_go_brr/resources/colors.dart';
import 'package:tasks_go_brr/resources/constants.dart';
import 'package:tasks_go_brr/resources/dimens.dart';
import 'package:tasks_go_brr/resources/icons/icons.dart';
import 'package:tasks_go_brr/resources/routes.dart';
import 'package:tasks_go_brr/ui/custom/animated_gesture_detector.dart';
import 'package:tasks_go_brr/ui/custom/button_icon_rounded.dart';
import 'package:tasks_go_brr/ui/custom/clippers/app_bar_clipper_2.dart';
import 'package:tasks_go_brr/ui/custom/day_and_date_widget.dart';
import 'package:tasks_go_brr/ui/custom/dialog_parts.dart';
import 'package:tasks_go_brr/ui/custom/floating_action_button.dart';
import 'package:tasks_go_brr/ui/custom/future_builder_success.dart';
import 'package:tasks_go_brr/ui/custom/home_button.dart';
import 'package:tasks_go_brr/ui/custom/slidable_actions.dart';
import 'package:tasks_go_brr/ui/main/regularly/regularly_page_view_model.dart';
import 'package:tasks_go_brr/ui/task/list_item/task_additional_widget.dart';
import 'package:tasks_go_brr/utils/time.dart';

class RegularlyPage extends StatefulWidget {
  const RegularlyPage({Key? key}) : super(key: key);

  @override
  _RegularlyPageState createState() => _RegularlyPageState();
}

class _RegularlyPageState extends State<RegularlyPage>
    with TickerProviderStateMixin {
  RegularlyPageViewModel _model = RegularlyPageViewModel();

  DateTime _currentDate = DateTime.now().onlyDate();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: context.background,
      child: FutureBuilderSuccess(
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
      ),
    );
  }

  Widget _taskList() {
    return StreamBuilder<List<TaskRegular>>(
      initialData: [],
      stream: _model.streamTasks.stream,
      builder: (context, snapshot) {
        if (snapshot.data != null && snapshot.data!.isNotEmpty)
          return Column(
            children: _getTaskList(snapshot.data!),
          );
        else
          return Column(
            children: [
              Container(
                  margin: EdgeInsets.symmetric(
                      horizontal: Margin.big.w * 1.5,
                      vertical: Margin.middle.h),
                  child: Image.asset(
                    ImagePath.CAT_EMPTY,
                    color: context.onSurface,
                  )),
              Container(
                child: Text(
                  "error.no_tasks".tr(),
                  style: TextStyle(
                      color: context.onSurface,
                      fontSize: Dimens.text_big,
                      fontWeight: FontWeight.bold),
                ),
              )
            ],
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
            Container(
              margin: EdgeInsets.only(
                top: Margin.middle.h,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AnimatedGestureDetector(
                      onTap: () async {
                        _currentDate = (await Routes.showDateCalendarPicker(
                                context, _currentDate)) ??
                            _currentDate;
                        _currentDate.onlyDate();
                        setState(() {});
                      },
                      child: DayAndDateWidget(date: _currentDate)),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
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
                                    color: context.onSurface,
                                    fontWeight: FontWeight.w500,
                                    fontSize: Dimens.text_normal),
                              ),
                            )),
                      ),
                      SizedBox(
                        height: Margin.small.h,
                      ),
                      HomeButton(
                        scale: !_currentDate.isSameDate(DateTime.now())
                            ? 1.0
                            : 0.0,
                        onTap: () {
                          if (!_currentDate
                              .isSameDate(DateTime.now().onlyDate()))
                            setState(
                                () => _currentDate = DateTime.now().onlyDate());
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  _goToTaskEdit() async {
    TaskRegular? result = await Routes.showBottomTaskRegEditPage(context,
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
        onDelete: () async {
          await _model.deleteTaskForDay(task, _currentDate);
          setState(() {});
        },
        onDeleteAll: () async {
          await _model.deleteTask(task);
          setState(() {});
        },
        onComplete: () async {
          _model.addCompletedDay(task, _currentDate);
          await Future.delayed(Duration(milliseconds: 200));
          setState(() {});
        },
      ));

    return list;
  }
}

class _TaskItem extends StatefulWidget {
  final RegularlyPageViewModel model;
  final TaskRegular task;
  final DateTime currentDate;

  final VoidCallback onDelete;
  final VoidCallback onDeleteAll;
  final VoidCallback onComplete;

  const _TaskItem(
      {Key? key,
      required this.model,
      required this.task,
      required this.currentDate,
      required this.onDelete,
      required this.onDeleteAll,
      required this.onComplete})
      : super(key: key);

  @override
  _TaskItemState createState() => _TaskItemState();
}

class _TaskItemState extends State<_TaskItem> with TickerProviderStateMixin {

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
                  actions: widget.task.statistic[widget
                            .currentDate.millisecondsSinceEpoch
                            .onlyDateInMilli()] !=
                        true
                    ? [CompleteAction(onTap: widget.onComplete),]
                    : null,
                secondaryActions: [
                  DeleteAction(
                    onTap: () async => _showDeleteDialog(widget.task),
                  ),
                ],
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
        padding: EdgeInsets.symmetric(vertical: Paddings.middle.h),
        decoration: BoxDecoration(
          color: context.surface,
          borderRadius: BorderRadius.all(Radiuss.small_smaller),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.only(
                left: Margin.middle.w,
              ),
              child: Text(
                widget.task.title,
                style: TextStyle(
                    color: context.onSurface,
                    fontWeight: FontWeight.bold,
                    fontSize: Dimens.text_normal_bigger),
              ),
            ),
            AnimatedSizeAndFade(
              vsync: this,
              child: !widget.task.status
                  ? TaskAdditionalWidget(
                      task: widget.task,
                      timeLeftMargin: Margin.middle.w,
                      getTag: (id) => widget.model.getTag(id),
                    )
                  : Container(),
            ),
          ],
        ),
      ),
    );
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
                    DialogTitle(text: "dialog.do_u_want_to_delete".tr()),
                    SizedBox(
                      height: Margin.middle,
                    ),
                    Container(
                      margin:
                          EdgeInsets.symmetric(horizontal: Paddings.small.w),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ButtonIconRounded(
                            onTap: () async {
                              Routes.back(contextDialog);
                              await Future.delayed(Duration(milliseconds: 200));
                              widget.onDeleteAll();
                            },
                            text: "action.delete_all".tr(),
                            backgroundColor: context.surfaceAccent,
                            textColor: context.onSurface,
                            padding: EdgeInsets.symmetric(
                                vertical: Paddings.small.h,
                                horizontal: Paddings.middle.w),
                          ),
                          ButtonIconRounded(
                            onTap: () async {
                              Routes.back(contextDialog);
                              await Future.delayed(Duration(milliseconds: 200));
                              widget.onDelete();
                            },
                            text: "action.delete".tr(),
                            backgroundColor: context.error,
                            textColor: context.onPrimary,
                            padding: EdgeInsets.symmetric(
                                vertical: Paddings.small.h,
                                horizontal: Paddings.middle.w),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ));
  }

  _goToTaskEdit(TaskRegular? task) async {
    TaskRegular? result = await Routes.showBottomTaskRegEditPage(context,
        task: task ?? null, dateTime: widget.currentDate);

    if (result != null) {
      if (task != null)
        task = result;
      else
        widget.model.tasks.add(result);
      setState(() {});
    }
  }
}
