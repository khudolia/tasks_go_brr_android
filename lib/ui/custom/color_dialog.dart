import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:simple_todo_flutter/resources/colors.dart';
import 'package:simple_todo_flutter/resources/dimens.dart';
import 'package:simple_todo_flutter/resources/routes.dart';
import 'package:simple_todo_flutter/ui/custom/dialog_parts.dart';

class ColorPickerDialog extends StatefulWidget {
  Color initialColor;

  ColorPickerDialog({Key? key, required this.initialColor}) : super(key: key);

  @override
  _ColorPickerDialogState createState() => _ColorPickerDialogState();
}

class _ColorPickerDialogState extends State<ColorPickerDialog> {
  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
            color: context.surface,
            borderRadius: BorderRadius.all(Radiuss.small_smaller)),
        padding: EdgeInsets.symmetric(vertical: Paddings.middle.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DialogTitle(text: "action.pick_color".tr()),
            SizedBox(
              height: Margin.middle.h,
            ),
            Container(
              child: ColorPicker(
                pickerAreaHeightPercent: .8,
                pickerColor: widget.initialColor,
                onColorChanged: (color) =>
                    setState(() => widget.initialColor = color),
                enableAlpha: false,
                displayThumbColor: false,
                showLabel: false,
                paletteType: PaletteType.hsv,
              ),
            ),
            Container(
                margin: EdgeInsets.symmetric(
                  horizontal: Margin.small.w,
                ),
                child: DialogPositiveButton(
                    onTap: () => Routes.back(context,
                        result: widget.initialColor.value))),
          ],
        ));
  }
}
