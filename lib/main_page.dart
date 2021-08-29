import 'package:flutter/cupertino.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tasks_go_brr/data/models/root_data.dart';
import 'package:tasks_go_brr/resources/colors.dart';
import 'package:tasks_go_brr/resources/dimens.dart';
import 'package:tasks_go_brr/resources/icons/icons.dart';
import 'package:tasks_go_brr/ui/base/base_state.dart';
import 'package:tasks_go_brr/ui/main/plan/plan_page.dart';
import 'package:tasks_go_brr/ui/main/regularly/regularly_page.dart';
import 'package:tasks_go_brr/ui/main/settings/settings_page.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:tasks_go_brr/ui/main/stat/stats_page.dart';

class MainPage extends StatefulWidget {
  MainPage({Key? key}) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends BaseState<MainPage> {
  PersistentTabController _controller = PersistentTabController(initialIndex: 0);

  List<PersistentBottomNavBarItem> _navBarsItems() {
    return [
      _navBarItem(
          text: "main.plan".tr(),
          icon: IconsC.calendar
      ),
      _navBarItem(
          text: "main.regularly".tr(),
          icon: IconsC.regularly
      ),
      _navBarItem(
          text: "main.statistic".tr(),
          icon: IconsC.calendar
      ),
      _navBarItem(
          text: "main.settings".tr(),
          icon: IconsC.settings
      ),
    ];
  }

  List<Widget> _buildScreens() {
    return [
      PlanPage(),
      RegularlyPage(),
      StatsPage(),
      SettingsPage(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    Provider.of<RootData>(context, listen: false).setRootContext(context);

    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: context.background,
      resizeToAvoidBottomInset: false,
      body: PersistentTabView(
        context,
        controller: _controller,
        screens: _buildScreens(),
        items: _navBarsItems(),
        confineInSafeArea: false,
        handleAndroidBackButtonPress: true,
        backgroundColor: context.background,
        decoration: NavBarDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radiuss.middle,
            topRight: Radiuss.middle,
          ),
        ),
        navBarHeight: Dimens.bottom_app_bar_height,
        popAllScreensOnTapOfSelectedTab: true,
        popActionScreens: PopActionScreensType.all,
        itemAnimationProperties: ItemAnimationProperties(
          duration: Durations.milliseconds_short,
          curve: Curves.ease,
        ),
        screenTransitionAnimation: ScreenTransitionAnimation(
          animateTabTransition: true,
          curve: Curves.ease,
          duration: Durations.milliseconds_short,
        ),
        navBarStyle: NavBarStyle.style7,
      ),
    );
  }

  PersistentBottomNavBarItem _navBarItem(
      {required IconData icon, required String text}) =>
      PersistentBottomNavBarItem(
        icon: Icon(icon),
        title: text,
        textStyle: TextStyle(fontWeight: FontWeight.w500),
        activeColorPrimary: context.primary,
        activeColorSecondary: context.onPrimary,
        inactiveColorPrimary: context.onSurface,
      );
}