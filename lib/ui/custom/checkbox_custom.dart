import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:simple_todo_flutter/resources/colors.dart';

class CheckboxCustom extends StatelessWidget {
  final ValueChanged<bool?>? onChanged;
  final bool? value;
  const CheckboxCustom({Key? key, required this.onChanged, required this.value}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 24.w,
      width: 24.w,
      child: Theme(
        data: Theme.of(context).copyWith(
          unselectedWidgetColor: context.onSurface,
        ),
        child: Checkbox(
          activeColor: context.primary,
          checkColor: context.onPrimary,
          onChanged: onChanged,
          value: value,
        ),
      ),
    );
  }
}
