import 'package:device_preview/device_preview.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:simple_todo_flutter/background/notifications/notification_alarm_manager.dart';
import 'package:simple_todo_flutter/data/models/root_data.dart';
import 'package:simple_todo_flutter/data/repositories/base/local_repository.dart';
import 'package:simple_todo_flutter/main_view_model.dart';
import 'package:simple_todo_flutter/resources/constants.dart';
import 'package:simple_todo_flutter/resources/dimens.dart';
import 'package:simple_todo_flutter/ui/welcome/splash/splash_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

  await LocalRepository.init();

  runApp(
    DevicePreview(
      enabled: false,
      builder: (context) => EasyLocalization(
          supportedLocales: Locales.SUPPORTED_LOCALES,
          path: Locales.LOCALES_PATH,
          fallbackLocale: Locales.FALLBACK_LOCALE,
          useFallbackTranslations: true,
          saveLocale: true,
          child: ScreenUtilInit(
              designSize: Dimens.dev_screen_size, builder: () => App())),
    ),
  );
}

class App extends StatelessWidget {
  MainViewModel _model = MainViewModel();

  @override
  Widget build(BuildContext context) {
    NotificationAlarmManager.init(context);

    return FutureBuilder(
      future: _model.initRepo(context),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return MultiProvider(
              providers: [
                ChangeNotifierProvider<RootData>(
                    create: (context) =>
                        RootData(_model.settings.theme))
              ],
              child: Consumer<RootData>(builder: (context, data, child) {
                  return MaterialApp(
                    localizationsDelegates: context.localizationDelegates,
                    supportedLocales: context.supportedLocales,
                    locale: context.locale,
                    theme: ThemeData(
                      visualDensity: VisualDensity.adaptivePlatformDensity,
                      brightness: _getBrightness(data.theme),
                    ),
                    home: SplashPage(),
                  );
                }),
            );
          } else {
            return Container();
        }
      }
    );
  }

  Brightness _getBrightness(int themeDb) {
    switch (themeDb) {
      case Themes.LIGHT:
        return Brightness.light;
      case Themes.DARK:
        return Brightness.dark;
      case Themes.DEVICE:
        return SchedulerBinding.instance!.window.platformBrightness;
      default:
        return Brightness.light;
    }
  }
}


