import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:simple_todo_flutter/resources/colors.dart';
import 'package:simple_todo_flutter/resources/constants.dart';
import 'package:simple_todo_flutter/resources/dimens.dart';
import 'package:simple_todo_flutter/resources/icons.dart';
import 'package:simple_todo_flutter/ui/base/base_state.dart';
import 'package:simple_todo_flutter/ui/custom/button_icon_rounded.dart';

class InputFieldRounded extends StatefulWidget {
  TextEditingController? textController;
  Function(String)? onChange;
  final TextInputType keyboardType;
  final Key? formKey;
  final FormFieldValidator<String>? validator;

  String? labelText;
  String text;
  final int? minLines;
  final int? maxLines;
  final IconData? buttonIcon;
  final VoidCallback? onTap;
  final Icon? prefixIcon;
  final Color? borderColor;
  final Color? textColor;
  final Color? labelUnselectedColor;
  bool? shouldUnfocus;

  InputFieldRounded({
    Key? key,
    this.labelText,
    this.minLines,
    this.maxLines,
    this.textController,
    this.onChange,
    this.text = Constants.EMPTY_STRING,
    this.keyboardType = TextInputType.text,
    this.formKey,
    this.validator,
    this.prefixIcon,
    this.buttonIcon,
    this.borderColor,
    this.textColor,
    this.labelUnselectedColor,
    this.onTap,
    this.shouldUnfocus,
  }) {
    textController = textController ?? TextEditingController();
    onChange = onChange ?? (text) {};
    shouldUnfocus = shouldUnfocus ?? true;
  }

  @override
  State<StatefulWidget> createState() => _InputFieldRoundedState();
}

class _InputFieldRoundedState extends BaseState<InputFieldRounded> {
  final FocusNode focusNode = FocusNode();

  void changeLabel(String label){
    widget.labelText = label;
    setState(() {});
  }

  @override
  void initState() {
    _setListeners();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if(widget.buttonIcon != null) {
      return IntrinsicHeight(
        child: Row(
          crossAxisAlignment: (widget.maxLines ?? 1) > 1
              ? CrossAxisAlignment.start
              : CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(child: _inputField()),
            SizedBox(
              width: Margin.small_half.w,
            ),
            Container(
              height: 42.h,
              width: 42.h,
              margin: EdgeInsets.symmetric(
                horizontal: Margin.small,
                vertical: Margin.small_very
              ),
              child: ButtonIconRounded(
                  icon: widget.buttonIcon!,
                  backgroundColor: context.surfaceAccent,
                  iconColor: context.background,
                  onTap: () {
                    if(widget.shouldUnfocus!)
                      _onClearPressed();
                    if (widget.onTap != null) widget.onTap!();
                  }),
            ),
          ],
        ),
      );
    } else {
      return _inputField();
    }
  }

  Widget _inputField() {
    return Form(
      key: widget.formKey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: TextFormField(
        key: widget.key,
        validator: widget.validator,
        onChanged: (text) {
          setState(() {});
          widget.onChange!(text.trim());
        },
        focusNode: focusNode,
        controller: widget.textController,
        textAlign: TextAlign.start,
        textInputAction: TextInputAction.next,
        keyboardType: widget.keyboardType,
        cursorColor: widget.borderColor!,
        style: TextStyle(
            fontSize: Dimens.text_normal,
            color: widget.textColor!),
        minLines: widget.minLines,
        maxLines: widget.maxLines,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(
              vertical: Paddings.middle,
              horizontal: Paddings.middle
          ),
          labelText: widget.labelText,
          labelStyle: TextStyle(
              fontSize: Dimens.text_normal,
              color: focusNode.hasFocus ? widget.borderColor! : widget.labelUnselectedColor!),
          alignLabelWithHint: true,
          prefixIcon: widget.prefixIcon,
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radiuss.small_smaller),
            borderSide: BorderSide(
              color: widget.borderColor!,
              width: Borders.small,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radiuss.small_smaller),
            borderSide: BorderSide(
              color: widget.borderColor!,
              width: Borders.small,
            ),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radiuss.small_smaller),
            borderSide: BorderSide(
              color: context.error,
              width: Borders.small,
            ),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radiuss.small_smaller),
            borderSide: BorderSide(
              color: context.error,
              width: Borders.small,
            ),
          ),
        ),
      ),
    );
  }

  void _setListeners() {
    focusNode.addListener(() {
      if(mounted)
        setState(() {});
    });

    widget.textController!.text = widget.text;

    /*widget.textController!.addListener(() {
      if(mounted)
        setState(() {});
    });*/
  }

  _onClearPressed() {
    //hideKeyboard();
    FocusScope.of(context).unfocus();
    widget.textController!.clear();
  }
}