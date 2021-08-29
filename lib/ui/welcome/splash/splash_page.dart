import 'package:flutter/material.dart';
import 'package:tasks_go_brr/resources/colors.dart';
import 'package:tasks_go_brr/resources/constants.dart';
import 'package:tasks_go_brr/resources/dimens.dart';
import 'package:tasks_go_brr/ui/welcome/splash/splash_page_view_model.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  SplashPageViewModel model = SplashPageViewModel();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.background,
      body: Stack(
        children: [
          Container(
            alignment: Alignment.center,
            child: Image.asset(
              AppInfo.IC_APP_FULL_PATH,
              height: Dimens.app_icon_size_big,
              width: Dimens.app_icon_size_big,
            ),
          ),
          FutureBuilder(
            future: model.initializeData(context),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              return Container();
            },
          ),
        ],
      ),
    );
  }


}
