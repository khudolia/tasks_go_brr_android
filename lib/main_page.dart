import 'package:flutter/cupertino.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:simple_todo_flutter/data/models/root_data.dart';
import 'package:simple_todo_flutter/resources/colors.dart';
import 'package:simple_todo_flutter/resources/dimens.dart';
import 'package:simple_todo_flutter/resources/icons/icons.dart';
import 'package:simple_todo_flutter/ui/base/base_state.dart';
import 'package:simple_todo_flutter/ui/main/plan/plan_page.dart';
import 'package:simple_todo_flutter/ui/main/regularly/regularly_page.dart';
import 'package:simple_todo_flutter/ui/main/settings/settings_page.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:simple_todo_flutter/ui/main/stat/stats_page.dart';

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
        icon: Icon(IconsC.calendar),
        title: "main.plan".tr(),
        textStyle: TextStyle(
            fontWeight: FontWeight.w500
        ),
        activeColorPrimary: context.primary,
        activeColorSecondary: context.surface,
        inactiveColorPrimary: context.background,
      ),
      PersistentBottomNavBarItem(
        icon: Icon(IconsC.regularly),
        textStyle: TextStyle(
          fontWeight: FontWeight.w500
        ),
        title: "main.regularly".tr(),
        activeColorPrimary: context.primary,
        activeColorSecondary: context.surface,
        inactiveColorPrimary: context.background,
      ),
      PersistentBottomNavBarItem(
        icon: Icon(IconsC.stats),
        title: "main.statistic".tr(),
        textStyle: TextStyle(
            fontWeight: FontWeight.w500
        ),
        activeColorPrimary: context.primary,
        activeColorSecondary: context.surface,
        inactiveColorPrimary: context.background,
      ),
      PersistentBottomNavBarItem(
        icon: Icon(IconsC.settings),
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
      StatsPage(),
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
    Provider.of<RootData>(context, listen: false).setRootContext(context);

    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.black,
      resizeToAvoidBottomInset: false,
      body: PersistentTabView(
        context,
        controller: _controller,
        screens: _buildScreens(),
        items: _navBarsItems(),
        confineInSafeArea: false,
        handleAndroidBackButtonPress: true,
        backgroundColor: context.surface,
        decoration: NavBarDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radiuss.middle,
            topRight: Radiuss.middle,
          ),
          boxShadow: [Shadows.middle(context)],
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
}