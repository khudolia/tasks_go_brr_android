import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:implicitly_animated_reorderable_list/implicitly_animated_reorderable_list.dart';
import 'package:implicitly_animated_reorderable_list/transitions.dart';
import 'package:simple_todo_flutter/data/models/task/task.dart';
import 'package:simple_todo_flutter/resources/colors.dart';
import 'package:simple_todo_flutter/resources/dimens.dart';
import 'package:simple_todo_flutter/resources/icons/icons.dart';
import 'package:simple_todo_flutter/resources/routes.dart';
import 'package:simple_todo_flutter/ui/calendar/day_card_view_model.dart';
import 'package:simple_todo_flutter/ui/custom/animated_gesture_detector.dart';
import 'package:simple_todo_flutter/ui/custom/future_builder_success.dart';
import 'package:simple_todo_flutter/ui/custom/slidable_actions.dart';
import 'package:simple_todo_flutter/ui/task/task_edit_widget.dart';

class DayCard extends StatefulWidget {
  final DateTime date;

  const DayCard({Key? key, required this.date}) : super(key: key);

  @override
  _DayCardState createState() => _DayCardState();
}

class _DayCardState extends State<DayCard> {
  DayCardViewModel _model = DayCardViewModel();
  @override
  Widget build(BuildContext context) {
    return FutureBuilderSuccess(
      future: _model.initRepo(widget.date),
      child: Container(
        width: double.infinity,
        margin: EdgeInsets.symmetric(
            vertical: Margin.small.h
        ),
        decoration: BoxDecoration(
            color: context.primary,
            borderRadius: BorderRadius.all(Radiuss.small),
            boxShadow: [
              Shadows.smallAround(context)
            ]
        ),
        child: Stack(
          children: [
            Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: context.surface,
                      borderRadius: BorderRadius.only(
                        topLeft: Radiuss.small,
                        bottomLeft: Radiuss.small,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: context.primary,
                      borderRadius: BorderRadius.only(
                        bottomRight: Radiuss.small,
                        topRight: Radiuss.small,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                TaskEditWidget(
                  date: widget.date,
                  taskAdded: (task) => setState(() {}),
                ),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: context.surface,
                      borderRadius: BorderRadius.only(
                        topRight: Radiuss.small,
                        bottomRight: Radiuss.small,
                        bottomLeft: Radiuss.small,
                      ),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        SizedBox(
                          height: Margin.small.h,
                        ),
                        Container(
                            alignment: Alignment.centerLeft,
                            margin: EdgeInsets.symmetric(horizontal: Margin.middle),
                            child: Text(
                              "tasks_for_day:".tr(),
                              style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: Dimens.text_normal_smaller),
                            )),
                        _reorderableTasksWidget(),
                        SizedBox(
                          height: Margin.middle,
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _reorderableTasksWidget() {
    return Expanded(
      child: Container(
        child: StreamBuilder<List<Task>>(
          initialData: [],
          stream: _model.streamTasks.stream,
          builder: (context, snapshot) {
            return ImplicitlyAnimatedReorderableList<Task>(
              physics: BouncingScrollPhysics(),
              items: snapshot.data!,
              areItemsTheSame: (oldItem, newItem) => oldItem == newItem,
              onReorderFinished: (item, from, to, newItems) {
                setState(() => _model.updateList(newItems));
              },
              itemBuilder: (context, itemAnimation, item, index) {
                return Reorderable(
                  key: ValueKey(item.id),
                  builder: (context, dragAnimation, inDrag) {
                    return Slidable(
                      actionPane: SlidableBehindActionPane(),
                      closeOnScroll: true,
                      secondaryActions: [
                        DeleteAction(onTap: () async {
                          _model.removeTask(_model.tasks[index]);
                          await Future.delayed(Duration(milliseconds: 200));
                          setState(() {});
                        }),
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
                            vertical: Paddings.middle_smaller.h,
                            horizontal: Paddings.small.w,
                          ),
                          decoration: new BoxDecoration(
                              color: context.surface,
                              borderRadius:
                                  new BorderRadius.all(Radiuss.small_very)),
                          child: Row(
                            children: [
                              SizedBox(
                                width: Margin.small.w,
                              ),
                              SizedBox(
                                height: 24.w,
                                width: 24.w,
                                child: Checkbox(
                                  //materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                  activeColor: context.primary,
                                  checkColor: context.surface,
                                  onChanged: (state) async {
                                    await _model
                                        .changeTaskStatus(_model.tasks[index]);
                                    setState(() {});
                                  },
                                  value: index < _model.tasks.length
                                      ? _model.tasks[index].status
                                      : false,
                                ),
                              ),
                              SizedBox(
                                width: Margin.middle.w,
                              ),
                              Expanded(
                                child: AnimatedGestureDetector(
                                  onTap: () => goToTaskEdit(index),
                                  child: Container(
                                    child: Text(
                                      _model.getTaskTitle(index),
                                      style: TextStyle(
                                        decoration:
                                            index < _model.tasks.length &&
                                                    _model.tasks[index].status
                                                ? TextDecoration.lineThrough
                                            : TextDecoration.none,
                                      ),
                                    ),
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
            );
          },
        ),
      ),
    );
  }

  goToTaskEdit(int index) async {
    Task? result = await Routes.showBottomTaskEditPage(
        context,
        date: widget.date,
        task: _model.tasks[index]);

    if(result != null) {
      await _model.checkTaskForCompatibility(result, widget.date, index);
      setState(() {});
    }
  }
}
