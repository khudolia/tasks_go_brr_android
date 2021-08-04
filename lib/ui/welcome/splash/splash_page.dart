import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:simple_todo_flutter/resources/constants.dart';
import 'package:simple_todo_flutter/ui/welcome/splash/splash_page_view_model.dart';

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
      body: Stack(
        children: [
          Container(
            alignment: Alignment.center,
            child: Image.asset(
              AppInfo.IC_APP_FULL_PATH,
              height: 160.w,
              width: 160.w,
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
