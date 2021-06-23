import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:simple_todo_flutter/data/models/task_regular/task_regular.dart';
import 'package:simple_todo_flutter/resources/colors.dart';
import 'package:simple_todo_flutter/resources/dimens.dart';
import 'package:simple_todo_flutter/resources/icons.dart';
import 'package:simple_todo_flutter/resources/routes.dart';
import 'package:simple_todo_flutter/ui/custom/animated_gesture_detector.dart';
import 'package:simple_todo_flutter/ui/custom/app_bar_clipper_2.dart';
import 'package:simple_todo_flutter/ui/custom/day_and_date_widget.dart';
import 'package:simple_todo_flutter/ui/custom/future_builder_success.dart';
import 'package:simple_todo_flutter/ui/custom/slidable_actions.dart';
import 'package:simple_todo_flutter/ui/main/regularly/regularly_page_view_model.dart';

class RegularlyPage extends StatefulWidget {
  const RegularlyPage({Key? key}) : super(key: key);

  @override
  _RegularlyPageState createState() => _RegularlyPageState();
}

class _RegularlyPageState extends State<RegularlyPage> {
  RegularlyPageViewModel _model = RegularlyPageViewModel();

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
          _fab(),
        ],
      ),
    );
  }

  Widget _taskWidget(TaskRegular task) {
    return Slidable(
      actionPane: SlidableBehindActionPane(),
      closeOnScroll: true,
      actions: [
        CompleteAction(onTap: () {}),
      ],
      secondaryActions: [
        DeleteAction(onTap: () async {
          //_model.removeTask(index);
          await Future.delayed(Duration(milliseconds: 200));
          setState(() {});
        }),
      ],
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
    );
  }

  Widget _taskList() {
    return StreamBuilder<List<TaskRegular>>(
      initialData: [],
      stream: _model.streamTasks.stream,
        builder: (context, snapshot) {
         return Column(
            children: _getListOfTasks(snapshot.data!),
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
                DayAndDateWidget(date: DateTime.now()),
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
            Routes.showBottomTaskRegEditPage(context);
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

  List<Widget> _getListOfTasks(List<TaskRegular> tasks) {
    List<Widget> list = [];

    for(var task in tasks)
      list.add(_taskWidget(task));

    return list;
  }

  _goToTaskEdit(TaskRegular task) async {
    TaskRegular? result = await Routes.showBottomTaskRegEditPage(
        context,
        task: task);

    if(result != null) {
      task = result;
      setState(() {});
    }
  }
}
