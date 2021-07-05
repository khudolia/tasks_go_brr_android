import 'package:auto_size_text/auto_size_text.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:simple_todo_flutter/resources/colors.dart';
import 'package:simple_todo_flutter/resources/constants.dart';
import 'package:simple_todo_flutter/resources/dimens.dart';
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
              _profileInfoWidget(),
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

  Widget _profileInfoWidget() {
    return Container(
      margin: EdgeInsets.only(left: Margin.middle.w, right: Margin.middle.w),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ClipOval(
                child: FittedBox(
                  fit: BoxFit.cover,
                  alignment: Alignment.centerLeft,
                  child: _model.getUserPhotoPath() != null
                      ? Image.asset(_model.getUserPhotoPath()!)
                      : Container(
                          color: context.error,
                          height: Dimens.avatar_photo_size,
                          width: Dimens.avatar_photo_size,
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
                      "profile.empty_name".tr(),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          color: context.textInversed,
                          fontWeight: FontWeight.bold,
                          fontSize: Dimens.text_big_smaller),
                    ),
                    Text(
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
          ),
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
                  onTap: () => _model.logoutFromAccount(context),
                  backgroundColor: context.primary,
                  textColor: context.textInversed),
            ],
          )
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
      ],
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
}
