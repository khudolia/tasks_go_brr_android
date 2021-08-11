import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:simple_todo_flutter/data/models/root_data.dart';
import 'package:simple_todo_flutter/resources/constants.dart';

extension Colorss on BuildContext {
  Color dynamicColor({required Color light, required Color dark}) {
    return Color.lerp(light, dark, Provider.of<RootData>(this, listen: false).theme == Themes.LIGHT ? 0 : 1)!;
  }

  Color get primary => dynamicColor(light: Color(0xFF454ADE), dark: Color(0xFF3337A7));
  Color get primaryAccent => dynamicColor(light: Color(0xFF279AF1), dark: Color(0xFF1E7ABF));
  Color get secondary => dynamicColor(light: Color(0xFFFF8811), dark: Color(0xFFDB740C));
  Color get secondaryAccent => dynamicColor(light: Color(0xffffd500), dark: Color(0xffdcb801));
  Color get surface => dynamicColor(light: Color(0xFFFFFFFC), dark: Color(
      0xFF232323));
  Color get surfaceAccent => dynamicColor(light: Color(0xFFE8E9F3), dark: Color(
      0xFF363636));
  Color get background => dynamicColor(light: Color(0xFFF3F3F3), dark: Color(0xFF121212));

  Color get error => dynamicColor(light: Color(0xFFDE0A31), dark: Color(0xFF93011E));
  Color get success => dynamicColor(light: Color(0xFF008E4D), dark: Color(0xFF016F3D));

  Color get onPrimary => dynamicColor(light: Color(0xFFFFFFFF), dark: Color(0xFFE3E3E3));
  Color get onPrimaryAccent => dynamicColor(light: Color(0xFFC1C1C1), dark: Color(0xFF1C1C1C).withOpacity(.7));
  Color get onSurface => dynamicColor(light: Color(0xFF363636), dark: Color(0xFFD5D5D5));
  Color get onSurfaceAccent => dynamicColor(light: Color(0xFF767676), dark: Color(0xFFFAFAFA).withOpacity(.7));

  setNavBarColorLight() =>
      SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        systemNavigationBarColor: this.surface,
        systemNavigationBarDividerColor: this.surface,
      ));

  setNavBarColorDark() =>
      SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        systemNavigationBarColor: this.background,
        systemNavigationBarDividerColor: this.background,
      ));
}