import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:simple_todo_flutter/resources/dimens.dart';
import 'package:simple_todo_flutter/ui/welcome/splash/splash_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

  runApp(EasyLocalization(
        supportedLocales: [
          Locale('en', 'US'),
          Locale('ru', 'RU'),
          Locale('uk', 'UA')
        ],
        path: 'assets/localizations',
        fallbackLocale: Locale('en', 'US'),
        useFallbackTranslations: true,
        child: ScreenUtilInit(
          designSize: Dimens.dev_screen_size,
            builder: () => App())),
  );
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    if(context.locale != context.deviceLocale)
      if(context.supportedLocales.contains(context.deviceLocale))
        context.resetLocale();

    return MaterialApp(
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: SplashPage(),
    );
  }
}


