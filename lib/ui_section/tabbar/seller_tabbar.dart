import 'package:flutter/material.dart';
import 'package:imart/const/asset_path.dart';
import 'package:imart/const/my_theme.dart';
import 'package:imart/ui_section/product/inventory.dart';
import 'package:imart/ui_section/tabbar/dashboard.dart';
import 'package:imart/ui_section/tabbar/payment.dart';
import 'package:imart/ui_section/tabbar/seller_orders.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';

bool isback = true;

class SellerBottomTabbar extends StatefulWidget {
  SellerBottomTabbar({this.positionTab});
  final int? positionTab;

  @override
  _SellerBottomTabbarState createState() => _SellerBottomTabbarState();
}

class _SellerBottomTabbarState extends State<SellerBottomTabbar> {
  // CupertinoTabController _controller;
  PersistentTabController? _controller;

  @override
  void initState() {
    super.initState();
    _fillSingleTon();
  }

  int homePageLength = 4;
  // int menuLength = 0;
  Future<void> _fillSingleTon() async {
    setState(() {
      isback = false;
    });
    // if (tempVariables.userType == 'guest') homePageLength = 2;
    if (widget.positionTab == 0) {
      _controller = PersistentTabController(initialIndex: 0);
    } else if (widget.positionTab == 1) {
      _controller = PersistentTabController(initialIndex: 1);
    } else if (widget.positionTab == 2) {
      _controller = PersistentTabController(initialIndex: 2);
    } else if (widget.positionTab == 3) {
      _controller = PersistentTabController(initialIndex: 3);
    } else {
      _controller = PersistentTabController(initialIndex: 0);
    }
  }

  // DateTime currentBackPressTime;
  // Future<bool> onWillPop() {
  //   if (isback) {
  //     return Future.value(true);
  //   } else {
  //     DateTime now = DateTime.now();
  //     if (currentBackPressTime == null ||
  //         now.difference(currentBackPressTime) > Duration(seconds: 2)) {
  //       currentBackPressTime = now;
  //       ToastComponent.showDialog('Double Click to exit app', context,
  //           gravity: Toast.BOTTOM, duration: Toast.LENGTH_LONG);
  //       return Future.value(false);
  //     }
  //     return Future.value(true);
  //   }
  // }

  List<Widget> _buildScreens() {
    return [
      Dashboard(),
      Inventory(),
      Payment(),
      SellerOrderPage(),
    ];
  }

  List<PersistentBottomNavBarItem> _navBarsItems() {
    return [
      PersistentBottomNavBarItem(
        icon: Icon(
          Icons.home,
          color: _controller!.index == 0
              ? MyTheme.accent_color
              : const Color.fromRGBO(153, 153, 153, 1),
        ),
        textStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
        title: ("Dashboard"),
        activeColorPrimary: MyTheme.accent_color,
        inactiveColorPrimary: const Color.fromRGBO(153, 153, 153, 1),
      ),
      PersistentBottomNavBarItem(
        textStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
        icon: Image.asset(
          ImagePath.icProduct,
          color: _controller!.index == 1
              ? MyTheme.accent_color
              : const Color.fromRGBO(153, 153, 153, 1),
          height: 20,
        ),
        title: ("Inventory"),
        activeColorPrimary: MyTheme.accent_color,
        inactiveColorPrimary: const Color.fromRGBO(153, 153, 153, 1),
      ),
      PersistentBottomNavBarItem(
        textStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
        icon: Image.asset(
          ImagePath.icWallet,
          height: 25,
          color: _controller!.index == 3
              ? MyTheme.accent_color
              : const Color.fromRGBO(153, 153, 153, 1),
        ),
        title: ("Payment"),
        activeColorPrimary: MyTheme.accent_color,
        inactiveColorPrimary: const Color.fromRGBO(153, 153, 153, 1),
      ),
      PersistentBottomNavBarItem(
        iconSize: 25,
        textStyle: const TextStyle(fontSize: 13),
        icon: Image.asset(
          ImagePath.icOrder,
          // height: 30,
          color: _controller!.index == 4
              ? MyTheme.accent_color
              : const Color.fromRGBO(153, 153, 153, 1),
        ),
        title: ("Orders"),
        activeColorPrimary: MyTheme.accent_color,
        inactiveColorPrimary: const Color.fromRGBO(153, 153, 153, 1),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return PersistentTabView(
      context,
      onItemSelected: (c) {
        setState(() {});
      },
      controller: _controller,
      screens: _buildScreens(),
      items: _navBarsItems(),
      navBarHeight: 70,
      confineInSafeArea: true,
      bottomScreenMargin: 0,
      // padding: NavBarPadding.all(5),
      backgroundColor: Colors.white, // Default is Colors.white.
      handleAndroidBackButtonPress: true, // Default is true.
      resizeToAvoidBottomInset:
          true, // This needs to be true if you want to move up the screen when keyboard appears. Default is true.
      stateManagement: true, // Default is true.
      hideNavigationBarWhenKeyboardShows:
          true, // Recommended to set 'resizeToAvoidBottomInset' as true while using this argument. Default is true.
      decoration: NavBarDecoration(
        borderRadius: BorderRadius.circular(10.0),
        colorBehindNavBar: Colors.white,
      ),
      popAllScreensOnTapOfSelectedTab: true,
      popActionScreens: PopActionScreensType.all,
      itemAnimationProperties: const ItemAnimationProperties(
        // Navigation Bar's items animation properties.
        duration: Duration(milliseconds: 200),
        curve: Curves.ease,
      ),
      screenTransitionAnimation: const ScreenTransitionAnimation(
        // Screen transition animation on change of selected tab.
        animateTabTransition: true,
        curve: Curves.ease,
        duration: Duration(milliseconds: 200),
      ),
      navBarStyle:
          NavBarStyle.style6, // Choose the nav bar style with this property.
    );
  }
}
