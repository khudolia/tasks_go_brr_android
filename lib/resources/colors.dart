import 'package:flutter/material.dart';

extension Colors on BuildContext {
  Color dynamicColor({Color light, Color dark}) {
    return (Theme.of(this).brightness == Brightness.light) ? light : dark;
  }

  Color get primary => dynamicColor(light: Color(0xFF454ADE), dark: Color(0xFF454ADE));
  Color get secondary => dynamicColor(light: Color(0xFFFF8811), dark: Color(0xFFFF8811));
  Color get surface => dynamicColor(light: Color(0xFFFFFFFC), dark: Color(0xFFFFFFFC));
  Color get surfaceAccent => dynamicColor(light: Color(0xFFE8E9F3), dark: Color(0xFFE8E9F3));
  Color get background => dynamicColor(light: Color(0xFF363636), dark: Color(0xFF363636));

  Color get error => dynamicColor(light: Color(0xFFB00020), dark: Color(0xFFB00020));
  Color get success => dynamicColor(light: Color(0xFF008E4D), dark: Color(0xFF008E4D));
}