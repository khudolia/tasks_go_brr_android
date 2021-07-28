import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:simple_todo_flutter/data/models/root_data.dart';
import 'package:simple_todo_flutter/resources/constants.dart';

extension Colorss on BuildContext {
  Color dynamicColor({required Color light, required Color dark}) {
    return Color.lerp(light, dark, Provider.of<RootData>(this, listen: false).theme == Themes.LIGHT ? 0 : 1)!;
  }

  Color get primary => dynamicColor(light: Color(0xFF454ADE), dark: Color(0xFF454ADE));
  Color get secondary => dynamicColor(light: Color(0xFFFF8811), dark: Color(0xFFFF8811));
  Color get surface => dynamicColor(light: Color(0xFFFFFFFC), dark: Color(0xFF242421));
  Color get surfaceAccent => dynamicColor(light: Color(0xFFE8E9F3), dark: Color(0xFFE8E9F3));
  Color get background => dynamicColor(light: Color(0xFF363636), dark: Color(0xFF363636));
  Color get gray => dynamicColor(light: Color(0xff939393), dark: Color(0xff939393));
  Color get grayLight => dynamicColor(light: Color(0xffcdcccc), dark: Color(0xff939393));

  Color get error => dynamicColor(light: Color(0xFFDE0A31), dark: Color(0xFFB00020));
  Color get success => dynamicColor(light: Color(0xFF008E4D), dark: Color(0xFF008E4D));

  Color get textDefault => dynamicColor(light: Color(0xFF000000), dark: Color(0xFF008E4D));
  Color get textSubtitleDefault => dynamicColor(light: Color(0xFF767676), dark: Color(0xFF008E4D));
  Color get textSubtitleInversed => dynamicColor(light: Color(0xFFC1C1C1), dark: Color(0xFF008E4D));
  Color get textInversed => dynamicColor(light: Color(0xFFFFFFFF), dark: Color(0xFF008E4D));

  Color get chartSecondary => dynamicColor(light: Color(0xFFFFd500), dark: Color(0xFF008E4D));
  Color get chartPrimary => dynamicColor(light: Color(0xFF279AF1), dark: Color(0xFF008E4D));

  Color get shadow => dynamicColor(light: Colors.grey.withOpacity(0.5), dark: Colors.grey.withOpacity(0.5));
}