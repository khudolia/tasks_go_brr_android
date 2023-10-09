import 'package:animated_size_and_fade/animated_size_and_fade.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:implicitly_animated_reorderable_list_2/implicitly_animated_reorderable_list_2.dart';
import 'package:implicitly_animated_reorderable_list_2/transitions.dart';
import 'package:tasks_go_brr/data/models/task/task.dart';
import 'package:tasks_go_brr/resources/colors.dart';
import 'package:tasks_go_brr/resources/constants.dart';
import 'package:tasks_go_brr/resources/dimens.dart';
import 'package:tasks_go_brr/resources/icons/icons.dart';
import 'package:tasks_go_brr/resources/routes.dart';
import 'package:tasks_go_brr/ui/base/base_state.dart';
import 'package:tasks_go_brr/ui/calendar/day_card_view_model.dart';
import 'package:tasks_go_brr/ui/custom/checkbox_custom.dart';
import 'package:tasks_go_brr/ui/custom/future_builder_success.dart';
import 'package:tasks_go_brr/ui/custom/slidable_actions.dart';
import 'package:tasks_go_brr/ui/task/list_item/task_additional_widget.dart';
import 'package:tasks_go_brr/ui/task/task_edit_widget.dart';

class DayCard extends StatefulWidget {
  final DateTime date;

  const DayCard({Key? key, required this.date}) : super(key: key);

  @override
  _DayCardState createState() => _DayCardState();
}

class _DayCardState extends BaseState<DayCard> {
  DayCardViewModel _model = DayCardViewModel();
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => unfocus(),
      child: FutureBuilderSuccess(
        future: _model.initRepo(widget.date),
        child: Container(
          margin: EdgeInsets.symmetric(
              vertical: Margin.small.h
          ),
          width: double.infinity,
          child: ClipRRect(
            borderRadius: BorderRadius.all(Radiuss.small),
            child: Container(
              color: context.surface,
              child: Stack(
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      _reorderableTasksWidget(),
                      TaskEditWidget(
                        date: widget.date,
                        taskAdded: () => setState(() {}),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
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
            if (snapshot.data != null && snapshot.data!.isNotEmpty)
              return ImplicitlyAnimatedReorderableList<Task>(
                physics: BouncingScrollPhysics(),
                items: snapshot.data!,
                areItemsTheSame: (oldItem, newItem) => oldItem == newItem,
                onReorderFinished: (item, from, to, newItems) {
                  setState(() => _model.updateList(newItems));
                },
                itemBuilder: (context, itemAnimation, task, index) {
                  return Reorderable(
                    key: ValueKey(task.id),
                    builder: (context, dragAnimation, inDrag) {
                        return SizeFadeTransition(
                          sizeFraction: 0.7,
                          curve: Curves.easeInOut,
                          animation: itemAnimation,
                          child: Column(
                            children: [
                              GestureDetector(
                                onTap: () => _goToTaskEdit(task),
                                child: _TaskItem(
                                    task: task,
                                    model: _model,
                                    date: widget.date,
                                onDelete: () async {
                                  await _model.removeTask(task);
                                  await Future.delayed(Duration(milliseconds: 200));
                                  setState(() {});
                                },),
                              ),
                              Container(
                                height: 2,
                                color: context.surfaceAccent,
                                width: double.infinity,
                              )
                            ],
                          ),
                        );
                      });
                },
              );
            else
              return _emptyListWidget();
          },
        ),
      ),
    );
  }

  Widget _emptyListWidget() {
    return Center(
      child: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
                margin: EdgeInsets.symmetric(
                  horizontal: Margin.big.w * 1.5,
                  vertical: Margin.middle.h,
                ),
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
            ),
          ],
        ),
      ),
    );
  }

  _goToTaskEdit(Task task) async {
    Task? result = await Routes.showBottomTaskEditPage(context,
        date: widget.date, task: task);

    if (result != null) {
      await _model.checkTaskForCompatibility(result, widget.date);
    }
    setState(() {});
  }
}

class _TaskItem extends StatefulWidget {
  final DayCardViewModel model;
  final Task task;
  final DateTime date;

  final VoidCallback onDelete;

  const _TaskItem(
      {Key? key, required this.model, required this.task, required this.date, required this.onDelete})
      : super(key: key);

  @override
  _TaskItemState createState() => _TaskItemState();
}

class _TaskItemState extends State<_TaskItem> with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return Slidable(
      actionPane: SlidableBehindActionPane(),
      closeOnScroll: true,
      secondaryActions: [
        DeleteAction(onTap: widget.onDelete),
      ],
      child: Container(
        margin: EdgeInsets.symmetric(
          vertical: Margin.small_very.h,
        ),
        padding: EdgeInsets.symmetric(
          vertical: Paddings.middle_smaller.h,
          horizontal: Paddings.small.w,
        ),
        decoration: BoxDecoration(
            color: context.surface,
            borderRadius: BorderRadius.all(Radiuss.small_very)),
        child: Row(
          children: [
            SizedBox(
              width: Margin.small.w,
            ),
            CheckboxCustom(
              onChanged: (state) async {
                await widget.model.changeTaskStatus(widget.task);
                setState(() {});
              },
              value: widget.task.status,
            ),
            SizedBox(
              width: Margin.middle.w,
            ),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.task.title,
                    style: TextStyle(
                        decoration: widget.task.status
                            ? TextDecoration.lineThrough
                            : TextDecoration.none,
                        color: context.onSurface,
                        fontWeight: FontWeight.bold,
                        fontSize: Dimens.text_normal_smaller),
                  ),
                  AnimatedSizeAndFade(
                    child: !widget.task.status
                        ? TaskAdditionalWidget(
                            task: widget.task,
                            getTag: (id) => widget.model.getTag(id),
                          )
                        : Container(),
                  ),
                ],
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
    );
  }
}
