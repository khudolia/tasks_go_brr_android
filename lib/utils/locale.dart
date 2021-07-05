import 'package:easy_localization/easy_localization.dart';
import 'package:simple_todo_flutter/resources/constants.dart';

extension LocalizedLocaleName on String {
  String getLanguage() {
    switch (this) {
      case LocalesSupported.en_US:
        return "lng.english".tr();

      case LocalesSupported.ru_RU:
        return "lng.russian".tr();

      case LocalesSupported.uk_UA:
        return "lng.ukrainian".tr();

        case LocalesSupported.DEVICE:
        return "same_as_device".tr();

      default:
        return Constants.EMPTY_STRING;
    }
  }
}
