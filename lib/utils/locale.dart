import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:simple_todo_flutter/resources/constants.dart';

import 'package:easy_localization/src/easy_localization_controller.dart';
import 'package:easy_localization/src/localization.dart';

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

class LocaleOutOfContext {

  static Future<void> loadTranslations() async {

    await EasyLocalizationController.initEasyLocation();

    final controller = EasyLocalizationController(
      saveLocale: true,
      fallbackLocale: Locales.FALLBACK_LOCALE,
      supportedLocales: Locales.SUPPORTED_LOCALES,
      useFallbackTranslations: true,
      path: Locales.LOCALES_PATH,
      onLoadError: (FlutterError e) {},
      useOnlyLangCode: false,
      assetLoader: const RootBundleAssetLoader(),
    );

    await controller.loadTranslations();

    Localization.load(controller.locale, translations: controller.translations, fallbackTranslations: controller.fallbackTranslations);
  }
}
