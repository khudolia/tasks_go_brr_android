import 'package:async/async.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:simple_todo_flutter/data/models/settings/settings.dart';
import 'package:simple_todo_flutter/data/repositories/settings_repository.dart';
import 'package:simple_todo_flutter/resources/constants.dart';
import 'package:simple_todo_flutter/utils/authentication.dart';
import 'package:simple_todo_flutter/resources/routes.dart';

class SplashPageViewModel {
  SettingsRepository _repo = SettingsRepository();
  AsyncMemoizer _memoizer = AsyncMemoizer();
  late User? _user;
  late Settings _settings;

  initializeData(BuildContext context) {
    return _memoizer.runOnce(() async {
      _user = await Authentication.initializeFirebase();
      await initRepo(context);

      initCrashlytics();

      goToPage(context);
    });
  }

  initRepo(BuildContext context) async {
    _settings = await _repo.initSettingsBox();
    syncLocalization(context);
  }

  initCrashlytics() {
    FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);
    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
  }

  syncLocalization(BuildContext context) {
    if(_settings.locale == LocalesSupported.DEVICE) {
      if(context.locale != context.deviceLocale)
        if(context.supportedLocales.contains(context.deviceLocale))
          context.resetLocale();
    } else {
      if(context.locale.toString() != _settings.locale)
        context.setLocale(Locale.fromSubtags(
            languageCode: _settings.locale.split("_")[0],
            countryCode: _settings.locale.split("_")[1]));
    }
  }

  goToPage(BuildContext context) {
    if(_user == null)
      Routes.toLoginPage(context);
    else
      Routes.toMainPage(context);
  }
}