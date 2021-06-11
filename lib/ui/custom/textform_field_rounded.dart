import 'package:flutter/material.dart';
import 'package:simple_todo_flutter/resources/colors.dart';
import 'package:simple_todo_flutter/resources/constants.dart';
import 'package:simple_todo_flutter/resources/dimens.dart';
import 'package:simple_todo_flutter/ui/base/base_state.dart';

class InputFieldRounded extends StatefulWidget {
  TextEditingController? textController;
  Function(String)? onChange;
  final TextInputType keyboardType;
  final Key? formKey;
  final FormFieldValidator<String>? validator;

  String? labelText;
  final String text;
  final int? minLines;
  final int? maxLines;
  final List<Widget>? suffixIcons;
  final Icon? prefixIcon;
  final Color? borderColor;
  final Color? textColor;
  final Color? labelUnselectedColor;

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
    this.suffixIcons,
    this.borderColor, this.textColor, this.labelUnselectedColor,
  }) : super(key: key) {
    textController = textController ?? TextEditingController();
    onChange = onChange ?? (text) {};
  }

  @override
  State<StatefulWidget> createState() => _InputFieldRoundedState();
}

class _InputFieldRoundedState extends BaseState<InputFieldRounded> {
  FocusNode focusNode = new FocusNode();

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
    return Form(
      key: widget.formKey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: TextFormField(
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
          suffixIcon: widget.suffixIcons != null ? Row(
            mainAxisSize: MainAxisSize.min,
            children: widget.suffixIcons!,
          ) : null,
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

    widget.textController!.addListener(() {
      if(mounted)
        setState(() {});
    });
  }

  _onClearPressed() {
    //hideKeyboard();
    FocusScope.of(context).unfocus();
    widget.textController!.clear();
  }
}