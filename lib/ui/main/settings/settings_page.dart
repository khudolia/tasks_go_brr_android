import 'package:auto_size_text/auto_size_text.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:shimmer/shimmer.dart';
import 'package:simple_todo_flutter/resources/colors.dart';
import 'package:simple_todo_flutter/resources/constants.dart';
import 'package:simple_todo_flutter/resources/dimens.dart';
import 'package:simple_todo_flutter/resources/routes.dart';
import 'package:simple_todo_flutter/ui/custom/animated_gesture_detector.dart';
import 'package:simple_todo_flutter/ui/custom/clippers/app_bar_clipper_4.dart';
import 'package:simple_todo_flutter/ui/main/settings/settings_view_model.dart';
import 'package:simple_todo_flutter/utils/locale.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> with TickerProviderStateMixin{
  SettingsViewModel _model = SettingsViewModel();
  late Future _futureSettings;

  @override
  void initState() {
    _futureSettings = _model.initRepo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: context.surface,
      child: Stack(
        children: [
          PreferredSize(
            preferredSize: Size.fromHeight(Dimens.app_bar_height),
            child: ClipPath(
              clipper: AppBarClipper4(),
              child: Container(
                color: context.secondary,
              ),
            ),
          ),
          Column(
            children: [
              SizedBox(
                height: Dimens.getStatusBarHeight(context),
              ),
              SizedBox(
                height: Margin.big.h,
              ),
               _ProfileWidget(model: _model,),
            ],
          ),
          FutureBuilder(
              future: _futureSettings,
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      SizedBox(
                        height: Dimens.top_curve_height_4 + Margin.middle.h,
                      ),
                      _notificationSettings(),
                      SizedBox(
                        height: Margin.middle.h,
                      ),
                      _localizationSettings(),
                      SizedBox(
                        height: Margin.middle.h,
                      ),
                      _themeSettings(),
                      SizedBox(
                        height: Margin.middle.h,
                      ),
                      _devInfo(),
                      SizedBox(
                        height: Margin.middle.h,
                      ),
                      FutureBuilder(
                        future: _model.getPackageInfo(),
                        builder:
                            (BuildContext context, AsyncSnapshot snapshot) {
                          if (snapshot.connectionState ==
                                  ConnectionState.done &&
                              !snapshot.hasError) {
                            return Container(
                              alignment: Alignment.center,
                              child: Text(
                                "version".tr(
                                    namedArgs: {"ver": snapshot.data!.version}),
                                style: TextStyle(
                                    fontSize: Dimens.text_small_bigger,
                                    fontWeight: FontWeight.w500,
                                    color: context.textSubtitleDefault),
                              ),
                            );
                          } else
                            return Container();
                        },
                      ),
                    ],
                  );
                } else {
                  return Container();
                }
              }),
        ],
      ),
    );
  }

  Widget _notificationSettings() {
    return Column(
      children: [
        _titleOfCategory(text: "settings.notifications".tr()),
      ],
    );
  }

  Widget _localizationSettings() {
    var _languageButtonKey = GlobalKey();
    return Column(
      children: [
        _titleOfCategory(text: "settings.localization".tr()),
        SizedBox(
          height: Margin.small.h,
        ),
        Container(
          alignment: Alignment.centerLeft,
          margin: EdgeInsets.only(
              left: Margin.middle.w * 2
          ),
          child: AnimatedGestureDetector(
            onTap: () => _showLanguageDialog(_languageButtonKey),
            child: Text("${"language".tr()}: ${_model.getCurrentLanguage()}",
              key: _languageButtonKey,
              style: TextStyle(
                color: context.textSubtitleDefault,
                fontWeight: FontWeight.w500,
                fontSize: Dimens.text_normal_smaller,
              ),),
          ),
        )
      ],
    );
  }

  Widget _themeSettings() {
    return Column(
      children: [
        _titleOfCategory(text: "settings.theme".tr()),
        Container(
          width: double.infinity,
          margin: EdgeInsets.only(
            left: Margin.middle.w * 2,
          ),
          child: Column(
            children: [
              SizedBox(
                height: Margin.small.h,
              ),
              _radioItem(
                  id: Themes.LIGHT,
                  selectedId: _model.settings.theme,
                  text: "themes.light".tr()),
              SizedBox(
                height: Margin.middle_smaller.h,
              ),
              _radioItem(
                  id: Themes.DARK,
                  selectedId: _model.settings.theme,
                  text: "themes.dark".tr()),
              SizedBox(
                height: Margin.middle_smaller.h,
              ),
              _radioItem(
                  id: Themes.DEVICE,
                  selectedId: _model.settings.theme,
                  text: "same_as_device".tr()),
            ],
          ),
        ),
      ],
    );
  }

  Widget _devInfo() {
    return Column(
      children: [
        _titleOfCategory(text: "settings.dev".tr()),
        SizedBox(
          height: Margin.small.h,
        ),
        Container(
          alignment: Alignment.centerLeft,
          margin: EdgeInsets.only(
              left: Margin.middle.w * 2
          ),
          child: AnimatedGestureDetector(
            onTap: () => _showRateView(),
            child: Text("rate_my_app".tr(),
              style: TextStyle(
                color: context.textSubtitleDefault,
                fontWeight: FontWeight.w500,
                fontSize: Dimens.text_normal_smaller,
              ),),
          ),
        ),
        SizedBox(
          height: Margin.small.h,
        ),
        Container(
          alignment: Alignment.centerLeft,
          margin: EdgeInsets.only(
              left: Margin.middle.w * 2
          ),
          child: AnimatedGestureDetector(
            onTap: () => Routes.showDevInfoPage(context),
            child: Text("dev_info".tr(),
              style: TextStyle(
                color: context.textSubtitleDefault,
                fontWeight: FontWeight.w500,
                fontSize: Dimens.text_normal_smaller,
              ),),
          ),
        )
      ],
    );
  }

  Widget _titleOfCategory({required String text}) {
    return Container(
      alignment: Alignment.centerLeft,
      margin: EdgeInsets.only(
          left: Margin.middle
      ),
      child: Text(text,
        style: TextStyle(
          color: context.textDefault,
          fontWeight: FontWeight.bold,
          fontSize: Dimens.text_normal,
        ),),
    );
  }

  _showLanguageDialog(GlobalKey key) async {
    RenderBox? renderBox =
    key.currentContext!.findRenderObject() as RenderBox?;
    var size = renderBox!.size;
    var offset =
    renderBox.localToGlobal(Offset(0.0, size.height + Margin.small));

    String? result = await showMenu(
      position: RelativeRect.fromLTRB(
          offset.dx + renderBox.size.width * .45,
          offset.dy,
          renderBox.size.width + offset.dx,
          renderBox.size.height + offset.dy),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
              Radiuss.small)),
      color: context.surface,
      items: _getAvailableLocales(),
      context: context,
    );

    if(result != null) {
      await _model.setLocale(context, result);
      setState(() {});
    }
  }

  List<PopupMenuEntry<String>> _getAvailableLocales() {
    List<PopupMenuEntry<String>> list = [];

    for(var locale in EasyLocalization.of(context)!.supportedLocales){
      list.add(PopupMenuItem(
        enabled: !(_model.settings.locale == locale.toString()),
        value: locale.toString(),
        child: Text(locale.toString().getLanguage()),
      ));
    }

    list.add(PopupMenuItem(
      value: LocalesSupported.DEVICE,
      enabled: !(_model.settings.locale == LocalesSupported.DEVICE),
      child: Text("same_as_device".tr(),),
    ));

    return list;
  }

  Widget _radioItem(
      {required int id, required int selectedId, required String text}) {
    return AnimatedGestureDetector(
      onTap: () async {
        await _model.setTheme(context, id);
        setState(() {});
      },
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          Container(
            width: Dimens.radio_button_size,
            height: Dimens.radio_button_size,
            decoration: BoxDecoration(
                color: Color.lerp(context.primary, context.surfaceAccent,
                    id == selectedId ? 0 : 1),
                borderRadius: BorderRadius.all(Radiuss.small_smaller)),
          ),
          SizedBox(
            width: Margin.small.w,
          ),
          Text(
            text,
            style: TextStyle(
              color: context.textSubtitleDefault,
              fontWeight: FontWeight.w500,
              fontSize: Dimens.text_normal_smaller,
            ),
          ),
          Expanded(
              child: Container(
            color: context.surface,
            height: 20.h,
          ))
        ],
      ),
    );
  }

  _showRateView() async  {
    final InAppReview inAppReview = InAppReview.instance;

    if (await inAppReview.isAvailable()) {
      inAppReview.requestReview().onError((error, stackTrace) => showDialog(
          context: context,
          builder: (contextDialog) => AlertDialog(
            backgroundColor: Colors.transparent,
            elevation: 0.0,
            content: Container(
              decoration: BoxDecoration(
                color: context.surface,
                borderRadius: BorderRadius.all(Radiuss.small_smaller),
              ),
              padding: EdgeInsets.symmetric(
                  horizontal: Paddings.small, vertical: Paddings.middle),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(error.toString()),
                  SizedBox(
                    height: Margin.middle,
                  ),
                ],
              ),
            ),
          )));
    } else {
    }
  }
}



class _ProfileWidget extends StatefulWidget {
  final SettingsViewModel model;

  const _ProfileWidget({Key? key, required this.model}) : super(key: key);

  @override
  _ProfileWidgetState createState() => _ProfileWidgetState();
}

class _ProfileWidgetState extends State<_ProfileWidget> {
  late Future _futureInfo;
  bool _isLoaded = false;

  @override
  void initState() {
    _futureInfo = widget.model.initUserInfo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: Margin.middle.w, right: Margin.middle.w),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FutureBuilder(
              future: _futureInfo,
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.connectionState == ConnectionState.done)
                  _isLoaded = true;
                else
                  _isLoaded = false;

                return Stack(
                  children: [
                    _loadingPlaceholder(),
                    _userInfo(),
                  ],
                );
              }),
          SizedBox(
            height: Margin.middle.h,
          ),
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _roundedButton(
                  title: "action.edit".tr(),
                  onTap: () {},
                  backgroundColor: context.surfaceAccent,
                  textColor: context.textSubtitleDefault),
              _roundedButton(
                  title: "action.log_out".tr(),
                  onTap: () => widget.model.logoutFromAccount(context),
                  backgroundColor: context.primary,
                  textColor: context.textInversed),
            ],
          )
        ],
      ),
    );
  }

  Widget _roundedButton(
      {required String title,
        required VoidCallback onTap,
        required Color textColor,
        required Color backgroundColor}) {
    return AnimatedGestureDetector(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.all(Radiuss.circle),
              boxShadow: [Shadows.smallAround(context)]
          ),
          padding: EdgeInsets.symmetric(
              vertical: Paddings.small_bigger,
              horizontal: Paddings.middle_bigger),
          child: Text(
            title,
            style: TextStyle(
                color: textColor,
                fontWeight: FontWeight.w500,
                fontSize: Dimens.text_normal),
          ),
        ));
  }

  Widget _loadingPlaceholder() {
    return AnimatedOpacity(
      opacity: _isLoaded ? 0 : 1,
      duration: Durations.milliseconds_short,
      child: Shimmer.fromColors(
        baseColor: context.grayLight,
        highlightColor: context.surface,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ClipOval(
              child: Container(
                height: Dimens.avatar_photo_size,
                width: Dimens.avatar_photo_size,
                color: context.surface,
              ),
            ),
            SizedBox(
              width: Margin.middle.w,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  height: 29.h,
                  width: 200.w,
                  decoration: BoxDecoration(
                      color: context.surface,
                      borderRadius: BorderRadius.all(
                          Radiuss.small_smaller)),
                ),
                SizedBox(
                  height: Margin.small.h,
                ),
                Container(
                  height: 16.h,
                  width: 150.w,
                  decoration: BoxDecoration(
                      color: context.surface,
                      borderRadius: BorderRadius.all(
                          Radiuss.small_smaller)),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _userInfo() {
    return AnimatedOpacity(
      opacity: _isLoaded ? 1 : 0,
      duration: Durations.milliseconds_middle,
      child: _isLoaded ? Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            height: Dimens.avatar_photo_size,
            width: Dimens.avatar_photo_size,
            child: ClipOval(
              child: FittedBox(
                fit: BoxFit.cover,
                alignment: Alignment.centerLeft,
                child: Image.network(widget.model.userInfo.photoURL ??
                    widget.model.devSettings.emptyPhotoURL),
              ),
            ),
          ),
          SizedBox(
            width: Margin.middle.w,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                AutoSizeText(
                  widget.model.userInfo.name ??
                      "profile.empty_name".tr(),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      color: context.textInversed,
                      fontWeight: FontWeight.bold,
                      fontSize: Dimens.text_big_smaller),
                ),
                Text(
                  widget.model.userInfo.email ??
                      "profile.empty_email".tr(),
                  style: TextStyle(
                      color: context.textInversed,
                      fontWeight: FontWeight.w500,
                      fontSize: Dimens.text_small_bigger),
                ),
              ],
            ),
          )
        ],
      ) : Container(),
    );
  }
}

