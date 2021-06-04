import 'package:flutter/cupertino.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:flutter/material.dart';
import 'package:simple_todo_flutter/resources/colors.dart';
import 'package:simple_todo_flutter/resources/dimens.dart';
import 'package:simple_todo_flutter/ui/base/base_state.dart';
import 'package:simple_todo_flutter/ui/main/plan_page.dart';
import 'package:simple_todo_flutter/ui/main/regularly_page.dart';
import 'package:simple_todo_flutter/ui/main/settings_page.dart';
import 'package:simple_todo_flutter/ui/main/stat_page.dart';
import 'package:easy_localization/easy_localization.dart';

class MainPage extends StatefulWidget {
  MainPage({Key? key}) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends BaseState<MainPage> {
  PersistentTabController? _controller;

  List<PersistentBottomNavBarItem> _navBarsItems() {
    return [
      PersistentBottomNavBarItem(
        icon: Icon(CupertinoIcons.calendar),
        title: "main.plan".tr(),
        textStyle: TextStyle(
            fontWeight: FontWeight.w500
        ),
        activeColorPrimary: context.primary,
        activeColorSecondary: context.surface,
        inactiveColorPrimary: context.background,
      ),
      PersistentBottomNavBarItem(
        icon: Icon(CupertinoIcons.today),
        textStyle: TextStyle(
          fontWeight: FontWeight.w500
        ),
        title: "main.regularly".tr(),
        activeColorPrimary: context.primary,
        activeColorSecondary: context.surface,
        inactiveColorPrimary: context.background,
      ),
      PersistentBottomNavBarItem(
        icon: Icon(CupertinoIcons.graph_square),
        title: "main.statistic".tr(),
        textStyle: TextStyle(
            fontWeight: FontWeight.w500
        ),
        activeColorPrimary: context.primary,
        activeColorSecondary: context.surface,
        inactiveColorPrimary: context.background,
      ),
      PersistentBottomNavBarItem(
        icon: Icon(CupertinoIcons.settings),
        title: "main.settings".tr(),
        textStyle: TextStyle(
            fontWeight: FontWeight.w500
        ),
        activeColorPrimary: context.primary,
        activeColorSecondary: context.surface,
        inactiveColorPrimary: context.background,
      ),
    ];
  }

  List<Widget> _buildScreens() {
    return [
      PlanPage(),
      RegularlyPage(),
      StatPage(),
      SettingsPage(),
    ];
  }

  @override
  void initState() {
    _controller = PersistentTabController(initialIndex: 0);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PersistentTabView(
        context,
        controller: _controller,
        screens: _buildScreens(),
        items: _navBarsItems(),
        confineInSafeArea: false,
        backgroundColor: context.surface,
        decoration: NavBarDecoration(
          borderRadius: BorderRadius.only(
              topLeft: Radius.middle,
          topRight: Radius.middle,),
          colorBehindNavBar: context.success,
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
    );
  }
}