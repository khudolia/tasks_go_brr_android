import 'package:auto_size_text/auto_size_text.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:simple_todo_flutter/resources/constants.dart';
import 'package:simple_todo_flutter/resources/dimens.dart';
import 'package:simple_todo_flutter/resources/icons/icons.dart';
import 'package:simple_todo_flutter/ui/welcome/login/login_view_model.dart';
import 'package:simple_todo_flutter/resources/colors.dart';
import 'package:simple_todo_flutter/ui/custom/animated_gesture_detector.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  LoginViewModel _model = LoginViewModel();

  FToast fToast = FToast();

  @override
  void initState() {
    super.initState();
    fToast.init(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            alignment: Alignment.center,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  AppInfo.IC_APP_FULL_PATH,
                  height: Dimens.app_icon_size,
                  width: Dimens.app_icon_size,
                ),
                SizedBox(
                  height: Margin.middle_smaller.h,
                ),
                Container(
                  margin: EdgeInsets.symmetric(
                      horizontal: Margin.middle.w
                  ),
                  child: Text(
                    AppInfo.APP_NAME,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: context.textDefault,
                        fontSize: Dimens.text_big,
                        fontWeight: FontWeight.bold
                    ),
                  ),
                ),
                SizedBox(
                  height: Margin.big.h,
                ),
                AnimatedGestureDetector(
                    onTap: () async {
                      var result = await _model.authUser(context);
                      if(result == 1)
                        _showPrivacyErrorToast();
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          color: context.primary,
                          borderRadius:
                              BorderRadius.all(Radiuss.small)),
                      padding: EdgeInsets.symmetric(
                        horizontal: Paddings.big.w,
                        vertical: Paddings.middle_smaller.h
                      ),
                      child: Text("action.log_in".tr(), style: TextStyle
                        (
                        fontWeight: FontWeight.w500,
                        fontSize: Dimens.text_normal_bigger,
                        color: context.textInversed
                      ),),
                    )),
              ],
            ),
          ),
          Column(
            children: [
              Flexible(
                child: Container(
                  alignment: Alignment.bottomCenter,
                  margin: EdgeInsets.symmetric(
                    horizontal: Margin.middle.w
                  ),
                  child: RichText(
                    textAlign: TextAlign.center,
                    softWrap: true,
                    text: new TextSpan(
                        text:
                            "p_c.description".tr(),
                        children: [
                          new TextSpan(
                            text: "p_c.privacy_policy".tr() + ".",
                            recognizer: TapGestureRecognizer()
                              ..onTap = () => _model.openPrivacyPolicy(),
                            style: TextStyle(
                              color: context.primary,
                              fontWeight: FontWeight.w500
                            )
                          )
                        ],
                        style: TextStyle(
                          color: context.textDefault,
                        )),
                  ),
                ),
              ),
              SizedBox(
                height: Margin.middle.h,
              )
            ],
          )
        ],
      ),
    );
  }

  _showPrivacyErrorToast() {
    Widget toast = Container(
      padding: EdgeInsets.symmetric(
          horizontal: Paddings.middle.w, vertical: Paddings.small_bigger.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(1000.0),
        color: context.error,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            IconsC.error,
            color: context.textInversed,
            size: 32,
          ),
          SizedBox(
            width: Margin.small_half.w,
          ),
          Flexible(
            child: AutoSizeText(
              "error.privacy_hasnt_been_read".tr(),
              style: TextStyle(
                  color: context.textInversed,
                  fontWeight: FontWeight.bold,
                  fontSize: Dimens.text_normal),
              textAlign: TextAlign.center,
              maxLines: 2,
            ),
          ),
        ],
      ),
    );

    fToast.showToast(
      child: toast,
      gravity: ToastGravity.BOTTOM,
      toastDuration: Duration(seconds: 2),
    );
  }
}
