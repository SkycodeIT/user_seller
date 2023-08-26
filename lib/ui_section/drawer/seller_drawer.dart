import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:imart/const/asset_path.dart';
import 'package:imart/const/my_theme.dart';
import 'package:imart/ui_section/auth/login.dart';
import 'package:imart/ui_section/drawer/about_us.dart';
import 'package:imart/ui_section/drawer/legal_policies.dart';
import 'package:imart/ui_section/product/edit_product_list.dart';
import 'package:imart/ui_section/tabbar/seller_tabbar.dart';
import 'package:url_launcher/url_launcher.dart';

class SellerDrawer extends StatefulWidget {
  const SellerDrawer({Key? key}) : super(key: key);

  @override
  _SellerDrawerState createState() => _SellerDrawerState();
}

class _SellerDrawerState extends State<SellerDrawer> {
  onTapLogout(context) async {
    Navigator.of(context, rootNavigator: true).pushReplacement(
      MaterialPageRoute(
        builder: (context) => const LoginPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        padding: const EdgeInsets.only(top: 50),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              ListTile(
                leading: Container(
                  height: 70,
                  width: 70,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.blue,
                  ),
                ),
                title: const Text(
                  'Hello',
                  style: TextStyle(
                    fontSize: 16,
                    color: Color.fromRGBO(153, 153, 153, 1),
                  ),
                ),
                subtitle: const Text(
                  'Green House',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: Divider(thickness: 1, height: 0),
              ),
              commonListTile(ImagePath.icProfile, 'Edit Profile', () {}),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: Divider(thickness: 1, height: 0),
              ),
              commonListTile(ImagePath.icOrder, 'My Orders', () {
                Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
                  NoAnimationMaterialPageRoute(
                    builder: (context) => SellerBottomTabbar(positionTab: 3),
                  ),
                  (route) => false,
                );
              }),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: Divider(thickness: 1, height: 0),
              ),
              commonListTile(ImagePath.icAddProduct, 'Add Product', () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EditProduct(),
                  ),
                );
              }),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: Divider(thickness: 1, height: 0),
              ),
              commonListTile(ImagePath.icWallet, 'Payments', () {
                Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
                  NoAnimationMaterialPageRoute(
                    builder: (context) => SellerBottomTabbar(positionTab: 2),
                  ),
                  (route) => false,
                );
              }),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: Divider(thickness: 1, height: 0),
              ),
              commonListTile(ImagePath.icCustomerSupport, 'Customer Support',
                  () {
                whatsapp();
              }),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: Divider(thickness: 1, height: 0),
              ),
              commonListTile(ImagePath.icPolicy, 'Legal Policies', () {
                Navigator.of(context, rootNavigator: true).push(
                  NoAnimationMaterialPageRoute(
                    builder: (context) => LegalPolicies(),
                  ),
                );
              }),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: Divider(thickness: 1, height: 0),
              ),
              commonListTile(ImagePath.icInfo, 'About us', () {
                Navigator.of(context, rootNavigator: true).push(
                  NoAnimationMaterialPageRoute(
                    builder: (context) => AboutUs(),
                  ),
                );
              }),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: Divider(thickness: 1, height: 0),
              ),
              commonListTile(ImagePath.icLogout, 'Logout', () {
                onTapLogout(context);
              }),
            ],
          ),
        ),
      ),
    );
  }

  whatsapp() async {
    var contact = "+919008627777";
    var androidUrl = "whatsapp://send?phone=$contact&text=Hi, I need some help";
    var iosUrl =
        "https://wa.me/$contact?text=${Uri.parse('Hi, I need some help')}";

    try {
      if (Platform.isIOS) {
        await launchUrl(Uri.parse(iosUrl));
      } else {
        await launchUrl(Uri.parse(androidUrl));
      }
    } on Exception {
      print('object');
      EasyLoading.showError('WhatsApp is not installed.');
    }
  }

  Widget commonListTile(String? imgPath, String? name, onTap) {
    return ListTile(
      horizontalTitleGap: 0,
      leading: Image.asset(
        imgPath!,
        height: 30,
        width: 30,
        color: MyTheme.accent_color,
      ),
      title: Text(
        name!,
        style: const TextStyle(
          fontSize: 14,
          color: Colors.black,
        ),
      ),
      trailing: const Icon(
        CupertinoIcons.right_chevron,
        color: Colors.grey,
      ),
      onTap: onTap!,
    );
  }
}

class NoAnimationMaterialPageRoute<T> extends MaterialPageRoute<T> {
  NoAnimationMaterialPageRoute({
    required WidgetBuilder builder,
    RouteSettings? settings,
    bool maintainState = true,
    bool fullscreenDialog = false,
  }) : super(
            builder: builder,
            maintainState: maintainState,
            settings: settings,
            fullscreenDialog: fullscreenDialog);
  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    return child;
  }
}
