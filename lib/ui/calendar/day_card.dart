import 'package:animated_size_and_fade/animated_size_and_fade.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:implicitly_animated_reorderable_list/implicitly_animated_reorderable_list.dart';
import 'package:implicitly_animated_reorderable_list/transitions.dart';
import 'package:simple_todo_flutter/data/models/task/task.dart';
import 'package:simple_todo_flutter/resources/colors.dart';
import 'package:simple_todo_flutter/resources/constants.dart';
import 'package:simple_todo_flutter/resources/dimens.dart';
import 'package:simple_todo_flutter/resources/icons/icons.dart';
import 'package:simple_todo_flutter/resources/routes.dart';
import 'package:simple_todo_flutter/ui/base/base_state.dart';
import 'package:simple_todo_flutter/ui/calendar/day_card_view_model.dart';
import 'package:simple_todo_flutter/ui/custom/checkbox_custom.dart';
import 'package:simple_todo_flutter/ui/custom/future_builder_success.dart';
import 'package:simple_todo_flutter/ui/custom/slidable_actions.dart';
import 'package:simple_todo_flutter/ui/tags/list/tag_list_item.dart';
import 'package:simple_todo_flutter/ui/task/task_edit_widget.dart';
import 'package:simple_todo_flutter/utils/time.dart';

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
          width: double.infinity,
          margin: EdgeInsets.symmetric(
              vertical: Margin.small.h
          ),
          decoration: BoxDecoration(
              color: context.surface,
              borderRadius: BorderRadius.all(Radiuss.small),
          ),
          child: Stack(
            children: [
              Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.vertical(
                          top: Radiuss.small,
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
                                    fontSize: Dimens.text_normal_smaller,
                                    color: context.onSurface),
                              )),
                          _reorderableTasksWidget(),
                        ],
                      ),
                    ),
                  ),
                  TaskEditWidget(
                    date: widget.date,
                    taskAdded: (task) => setState(() {}),
                  ),
                ],
              ),
            ],
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
      setState(() {});
    }
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
                    vsync: this,
                    child: !widget.task.status
                        ? _additionalTaskInfoWidget()
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

  Widget _additionalTaskInfoWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        widget.task.time != null
            ? SizedBox(
                height: Margin.small.h,
              )
            : Container(),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            widget.task.time != null ? _timeWidget() : Container(),
            widget.task.time != null && widget.task.remindBeforeTask != null
                ? _remindTimeWidget()
                : Container(),
          ],
        ),
        widget.task.tags.isNotEmpty
            ? SizedBox(
                height: Margin.small.h,
              )
            : Container(),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          physics: BouncingScrollPhysics(),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: widget.task.tags
                .map((e) => TagItem(
                      tag: widget.model.getTag(e),
                      onRemove: () {},
                      type: SizeType.SMALL,
                      isEnabled: widget.task.status,
                    ))
                .toList(),
          ),
        ),
      ],
    );
  }

  Widget _timeWidget() {
    return _smallWidget(
        icon: IconsC.clock,
        text: Time.getTimeFromMilliseconds(widget.task.time!));
  }

  Widget _remindTimeWidget() {
    return _smallWidget(
        icon: IconsC.remind,
        text: Time.getBeforeTimeFromMilliseconds(widget.task.remindBeforeTask!));
  }

  Widget _smallWidget({required String text, required IconData icon}) {
    return Container(
      decoration: BoxDecoration(
          color: Color.lerp(context.surfaceAccent, context.primary, widget.task.status ? 0 : 1),
          borderRadius: BorderRadius.all(Radiuss.circle)),
      padding: EdgeInsets.symmetric(
        vertical: Paddings.small_half.h,
        horizontal: Paddings.small.w,
      ),
      margin: EdgeInsets.only(
        right: Margin.small_half.w,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: Color.lerp(context.onSurface, context.onPrimary, widget.task.status ? 0 : 1),
            size: 18,
          ),
          SizedBox(
            width: Margin.small_half.w,
          ),
          Text(
            text,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
                color:
                Color.lerp(context.onSurface, context.onPrimary, widget.task.status ? 0 : 1),
                fontWeight: FontWeight.w500, fontSize: Dimens.text_small_bigger),
          ),
        ],
      ),
    );
  }
}
