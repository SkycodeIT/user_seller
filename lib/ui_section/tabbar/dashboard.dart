import 'package:flutter/material.dart';
import 'package:imart/const/asset_path.dart';
import 'package:imart/provider/productsData.dart';
import 'package:imart/const/my_theme.dart';
import 'package:imart/ui_section/categories/category.dart';
import 'package:imart/ui_section/drawer/seller_drawer.dart';
import 'package:imart/ui_section/product/manage_product_list.dart';
import 'package:imart/ui_section/tabbar/seller_tabbar.dart';
import 'package:provider/provider.dart';

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> with TickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  productsProv prov1 = productsProv();

  @override
  void initState() {
    super.initState();
    prov1 = Provider.of<productsProv>(context, listen: false);
    // prov1.getAllData();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Consumer<productsProv>(
        builder: (BuildContext context, value, Widget? child) {
          return Scaffold(
            key: _scaffoldKey,
            backgroundColor: const Color.fromRGBO(247, 249, 250, 1.0),
            drawer: const SellerDrawer(),
            body: Column(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(color: MyTheme.accent_color),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                        onTap: () {
                          _scaffoldKey.currentState!.openDrawer();
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: Image.asset(
                            ImagePath.icDrawer,
                            height: 20,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      Container(
                        height: 30,
                        width: 30,
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage(ImagePath.icAppbarIcon),
                          ),
                        ),
                      ),
                      const SizedBox(),
                    ],
                  ),
                ),
                const SizedBox(height: 15),
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: () async {
                      await prov1.getAllData();
                    },
                    child: SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10, right: 10),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                menuWidget(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (builder) =>
                                            ManageProductList(),
                                      ),
                                    );
                                  },
                                  title: 'Products',
                                  subTitle:
                                      "${value.allProductsResponseData?.length}",
                                ),
                                const SizedBox(width: 10),
                                menuWidget(
                                  onTap: () {
                                    Navigator.of(context, rootNavigator: true)
                                        .push(
                                      NoAnimationMaterialPageRoute(
                                        builder: (context) =>
                                            SellerBottomTabbar(positionTab: 3),
                                      ),
                                    );
                                  },
                                  title: 'Orders',
                                  subTitle:
                                      "${value.getOrderResponseData?.length}",
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                menuWidget(
                                  onTap: () {
                                    Navigator.of(context, rootNavigator: true)
                                        .push(
                                      NoAnimationMaterialPageRoute(
                                        builder: (context) =>
                                            SellerBottomTabbar(positionTab: 2),
                                      ),
                                    );
                                  },
                                  title: 'Total Sale',
                                  subTitle: '${value.totalSale} ₹',
                                ),
                                const SizedBox(width: 10),
                                menuWidget(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (builder) => Category(),
                                      ),
                                    );
                                  },
                                  title: 'Categories',
                                  subTitle:
                                      '${value.allCatagoryResponseList?.length}',
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget menuWidget({String? title, String? subTitle, onTap}) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: Container(
          height: MediaQuery.of(context).size.width * 0.43,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: MyTheme.accent_color,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                title!,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                subTitle!,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
