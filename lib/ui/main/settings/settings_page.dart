import 'package:animated_size_and_fade/animated_size_and_fade.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:shimmer/shimmer.dart';
import 'package:tasks_go_brr/resources/colors.dart';
import 'package:tasks_go_brr/resources/constants.dart';
import 'package:tasks_go_brr/resources/dimens.dart';
import 'package:tasks_go_brr/resources/routes.dart';
import 'package:tasks_go_brr/ui/custom/animated_gesture_detector.dart';
import 'package:tasks_go_brr/ui/custom/button_icon_rounded.dart';
import 'package:tasks_go_brr/ui/custom/checkbox_custom.dart';
import 'package:tasks_go_brr/ui/custom/clippers/app_bar_clipper_4.dart';
import 'package:tasks_go_brr/ui/custom/dialog_parts.dart';
import 'package:tasks_go_brr/ui/main/settings/settings_view_model.dart';
import 'package:tasks_go_brr/utils/locale.dart';
import 'package:tasks_go_brr/utils/time.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> with TickerProviderStateMixin{
  SettingsViewModel _model = SettingsViewModel();
  late Future _futureSettings;
  late Future _futurePackageInfo;

  @override
  void initState() {
    _futureSettings = _model.initRepo();
    _futurePackageInfo = _model.getPackageInfo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: context.background,
      child: Stack(
        children: [
          FutureBuilder(
              future: _futureSettings,
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return SingleChildScrollView(
                    physics: BouncingScrollPhysics(),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        SizedBox(
                          height: Dimens.top_curve_height_4 + Margin.middle.h,
                        ),
                        _notificationSettings(),
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
                          future: _futurePackageInfo,
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
                                      color: context.onSurfaceAccent),
                                ),
                              );
                            } else
                              return Container();
                          },
                        ),
                        SizedBox(
                          height: Margin.big.h + Margin.middle.h,
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(
                            horizontal: Margin.big.w,
                          ),
                          child: Image.asset(
                            ImagePath.CAT_FREE,
                            color: context.onSurface,
                          ),
                        ),
                        SizedBox(
                          height: Margin.big.h + Margin.middle.h,
                        ),
                      ],
                    ),
                  );
                } else {
                  return Container();
                }
              }),
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
        ],
      ),
    );
  }

  Widget _notificationSettings() {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _titleOfCategory(text: "settings.notifications".tr()),
            Container(
              margin: EdgeInsets.only(
                top: (48 / 12)
                    .h, //48 - height of switch. It's make switch centered vertically.
              ),
              child: Switch(
                  value: _model.settings.isNotificationsEnabled,
                  activeColor: context.primary,
                  inactiveTrackColor: context.onSurface.withOpacity(.3),
                  splashRadius: 0,
                  onChanged: (value) async {
                    _model.settings.isNotificationsEnabled = value;
                    await _model.updateSettings();
                    setState(() {});
                  }),
            ),
          ],
        ),
        AnimatedSizeAndFade(
          vsync: this,
          child: _model.settings.isNotificationsEnabled ? Column(
            children: [
              Container(
                alignment: Alignment.centerLeft,
                margin: EdgeInsets.only(
                    left: Margin.middle.w * 2
                ),
                child: AnimatedGestureDetector(
                  onTap: () => _showNotificationLayoutDialog(),
                  child: Text("${"layouts".tr()}",
                    style: TextStyle(
                      color: context.onSurfaceAccent,
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
                  left: Margin.middle.w * 2,
                ),
                child: _titledButtonWidget(
                  onTap: () async {
                    var result = await Routes.showTimePicker(context,
                        value: _model.settings.remindEveryMorningTime.toDate(),
                        isFirstHalfOfDay: true);

                    if (result != null) {
                      _model.settings.remindEveryMorningTime =
                          result.millisecondsSinceEpoch;
                      await _model.updateSettings();
                      setState(() {});
                    }
                  },
                  title: "in_the_morning".tr(),
                  textButton: Time.getTimeFromMilliseconds(
                      _model.settings.remindEveryMorningTime),
                ),
              ),
              SizedBox(
                height: Margin.small.h,
              ),
              Container(
                alignment: Alignment.centerLeft,
                margin: EdgeInsets.only(
                  left: Margin.middle.w * 2,
                ),
                child: _titledButtonWidget(
                  onTap: () async {
                    var result = await Routes.showTimePicker(context,
                        value: _model.settings.remindEveryEveningTime.toDate(),
                        isFirstHalfOfDay: false);

                    if (result != null) {
                      _model.settings.remindEveryEveningTime =
                          result.millisecondsSinceEpoch;
                      await _model.updateSettings();
                      setState(() {});
                    }
                  },
                  title: "in_the_evening".tr(),
                  textButton: Time.getTimeFromMilliseconds(
                      _model.settings.remindEveryEveningTime),
                ),
              ),
              SizedBox(
                height: Margin.middle.h,
              ),
            ],
          ) : Container(),
        ),
      ],
    );
  }

  Widget _titledButtonWidget(
      {required String title,
        required String textButton,
        required VoidCallback onTap}) {
    return Row(
      children: [
        Text(
          title,
          style: TextStyle(
            color: context.onSurfaceAccent,
            fontWeight: FontWeight.w500,
            fontSize: Dimens.text_normal_smaller,
          ),
        ),
        SizedBox(
          width: Margin.small_half.h,
        ),
        _buttonRoundedWithIcon(
          text: textButton,
          onTap: onTap,
        ),
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
                color: context.onSurfaceAccent,
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
                color: context.onSurfaceAccent,
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
                color: context.onSurfaceAccent,
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
          color: context.onSurface,
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
      elevation: 0
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
        enabled: _model.settings.locale != locale.toString(),
        value: locale.toString(),
        child: Text(
          locale.toString().getLanguage(),
          style: TextStyle(
            color: _model.settings.locale != locale.toString()
                ? context.onSurface
                : context.onSurfaceAccent,
            fontWeight: _model.settings.locale != locale.toString()
                ? FontWeight.w500
                : FontWeight.normal,
          ),
        ),
      ));
    }

    list.add(PopupMenuItem(
      value: LocalesSupported.DEVICE,
      enabled: _model.settings.locale != LocalesSupported.DEVICE,
      child: Text(
        "same_as_device".tr(),
        style: TextStyle(
          color: _model.settings.locale != LocalesSupported.DEVICE
              ? context.onSurface
              : context.onSurfaceAccent,
          fontWeight: _model.settings.locale != LocalesSupported.DEVICE
              ? FontWeight.w500
              : FontWeight.normal,
        ),
      ),
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
              color: context.onSurfaceAccent,
              fontWeight: FontWeight.w500,
              fontSize: Dimens.text_normal_smaller,
            ),
          ),
          Expanded(
              child: Container(
            color: context.background,
            height: 20.h,
          ))
        ],
      ),
    );
  }

  Widget _buttonRoundedWithIcon(
      {IconData? icon,
        required VoidCallback onTap, String? text}) {
    return ButtonIconRounded(
      icon: icon,
      onTap: onTap,
      backgroundColor: context.surfaceAccent,
      iconColor: context.onSurface,
      text: text ?? null,
      textColor: context.onSurface,
      padding: EdgeInsets.symmetric(
          vertical: Paddings.small, horizontal: Paddings.middle),
    );
  }

  _showRateView() async {
    final InAppReview inAppReview = InAppReview.instance;

    if (await inAppReview.isAvailable()) inAppReview.requestReview();
  }

  _showNotificationLayoutDialog() {
    showDialog(
        context: context,
        builder: (contextDialog) => NotificationLayoutDialog(model: _model,));
  }
}

class NotificationLayoutDialog extends StatefulWidget {
  final SettingsViewModel model;

  const NotificationLayoutDialog({Key? key, required this.model})
      : super(key: key);

  @override
  _NotificationLayoutDialogState createState() =>
      _NotificationLayoutDialogState();
}

class _NotificationLayoutDialogState extends State<NotificationLayoutDialog> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
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
            DialogTitle(text: "dialog.choose_notifications_type".tr(),),
            SizedBox(
              height: Margin.middle.h,
            ),
            _item(NotificationsLayout.ONLY_TASKS),
            _item(NotificationsLayout.ACTIVITY_REMINDER),
            _item(NotificationsLayout.DAILY_REMINDER),
            SizedBox(
              height: Margin.middle.h,
            ),
            DialogPositiveButton(
              onTap: () async {
                await widget.model.updateSettings();
                setState(() {});
                Routes.back(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _item(int id) {
    return Row(
      children: [
        Container(
          margin: EdgeInsets.all(Margin.small),
          child: CheckboxCustom(
              value: widget.model.settings.notificationsLayout[id],
              onChanged: (value) => setState(
                  () => widget.model.settings.notificationsLayout[id] = value!)),
        ),
        Flexible(
          child: Text(getTitle(id), style: TextStyle(
            fontWeight: FontWeight.w500,
            color: context.onSurfaceAccent
          ),),
        ),
      ],
    );
  }

  String getTitle(int id) {
    switch (id) {
      case NotificationsLayout.ONLY_TASKS:
        return "notification_layout.only_tasks".tr();
      case NotificationsLayout.DAILY_REMINDER:
        return "notification_layout.daily_reminder".tr();
      case NotificationsLayout.ACTIVITY_REMINDER:
        return "notification_layout.activity_reminders".tr();
      default:
        return Constants.EMPTY_STRING.tr();
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
                  onTap: () =>
                      _futureInfo.whenComplete(() => _goToUserEditPage()),
                  backgroundColor: context.surface,
                  textColor: context.onSurface),
              _roundedButton(
                  title: "action.log_out".tr(),
                  onTap: () => widget.model.logoutFromAccount(context),
                  backgroundColor: context.primary,
                  textColor: context.onPrimary),
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
        baseColor: context.surface.withOpacity(.6),
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
                      color: context.surface,
                      fontWeight: FontWeight.bold,
                      fontSize: Dimens.text_big_smaller),
                ),
                Text(
                  widget.model.userInfo.email ??
                      "profile.empty_email".tr(),
                  style: TextStyle(
                      color: context.surface,
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

  _goToUserEditPage() async {
    var result = await Routes.showBottomUserEditPage(context,
        userInfo: widget.model.userInfo, devSettings: widget.model.devSettings);

    if(result != null) {
      widget.model.userInfo = result;
      setState(() {});
    }
  }
}

