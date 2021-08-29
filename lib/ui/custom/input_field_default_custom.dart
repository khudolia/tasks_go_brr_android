import 'package:flutter/material.dart';
import 'package:tasks_go_brr/resources/colors.dart';

class InputFieldDefaultCustom extends StatelessWidget {
  final String? initialValue;
  final ValueChanged<String>? onChanged;
  final TextStyle? style;
  final TextEditingController? controller;

  const InputFieldDefaultCustom(
      {Key? key,
      this.initialValue,
      this.onChanged,
      this.style,
      this.controller})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      initialValue: initialValue,
      onChanged: onChanged,
      style: style,
      cursorColor: context.primary,
      decoration: InputDecoration(
        focusColor: context.primary,
        hoverColor: context.onSurface,
        border: UnderlineInputBorder(
            borderSide: BorderSide(color: context.onSurface)),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: context.primary,
          ),
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: context.onSurfaceAccent,
          ),
        ),
      ),
    );
  }
}