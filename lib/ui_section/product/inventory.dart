import 'package:flutter/material.dart';
import 'package:imart/const/asset_path.dart';
import 'package:imart/const/my_theme.dart';
import 'package:imart/provider/productsData.dart';
import 'package:imart/ui_section/drawer/seller_drawer.dart';
import 'package:imart/ui_section/product/edit_product_list.dart';
import 'package:provider/provider.dart';

class Inventory extends StatefulWidget {
  @override
  _InventoryState createState() => _InventoryState();
}

class _InventoryState extends State<Inventory> with TickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  productsProv prov1 = productsProv();
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    prov1 = Provider.of<productsProv>(context, listen: false);
    // prov1.getAllData();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<productsProv>(
      builder: (context, value, child) {
        return Scaffold(
          key: _scaffoldKey,
          drawer: const SellerDrawer(),
          body: SafeArea(
            child: Column(
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
                      Text(
                        'Inventory',
                        style: TextStyle(
                            color: MyTheme.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(),
                    ],
                  ),
                ),
                const SizedBox(height: 5),
                searchBar(),
                const SizedBox(height: 15),
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: () async {
                      prov1.getAllData();
                    },
                    child: _searchController.text.isEmpty
                        ? SingleChildScrollView(
                            physics: const AlwaysScrollableScrollPhysics(),
                            child: Column(
                              children: [
                                productListWidget(),
                                const SizedBox(height: 90),
                              ],
                            ),
                          )
                        : productListWidget2(),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget searchBar() {
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.only(right: 20, left: 20, top: 15),
      // padding: EdgeInsets.symmetric(horizontal: 10),
      child: TextField(
        controller: _searchController,
        onTap: () {},
        onChanged: (txt) {
          setState(() {});
        },
        onSubmitted: (txt) {},
        autofocus: false,
        decoration: InputDecoration(
          hintText: 'Search Product',
          hintStyle: TextStyle(fontSize: 14.0, color: MyTheme.textfield_grey),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: BorderSide(color: MyTheme.accent_color, width: 2.0),
          ),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderSide: BorderSide(color: MyTheme.accent_color, width: 2.0),
            borderRadius: BorderRadius.circular(12.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: BorderSide(color: MyTheme.accent_color, width: 2.0),
          ),
          prefixIcon: Icon(Icons.search, color: MyTheme.accent_color),
          suffixIcon: Icon(Icons.mic, color: MyTheme.accent_color),
          contentPadding: const EdgeInsets.only(left: 10),
        ),
      ),
    );
  }

  Widget productListWidget() {
    return Consumer<productsProv>(
      builder: (BuildContext context, value, Widget? child) {
        return ListView.builder(
          itemCount: value.allProductsResponseData?.length,
          shrinkWrap: true,
          physics: const BouncingScrollPhysics(),
          itemBuilder: (context, index) {
            return Container(
              padding: const EdgeInsets.only(bottom: 10, top: 10, left: 8),
              margin: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
              width: MediaQuery.of(context).size.width * 0.5,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey[200]!),
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(5),
                    width: 70,
                    height: 70,
                    child: Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: NetworkImage(
                            value.allProductsResponseData?[index].image?[0] ??
                                "",
                          ),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${value.allProductsResponseData?[index].productName}',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          'Qty: ${value.allProductsResponseData?[index].unit}',
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 10.0),
                    child: IconButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EditProduct(
                              isEdit: true,
                              productResponse:
                                  value.allProductsResponseData?[index],
                            ),
                          ),
                        );
                      },
                      icon: Icon(
                        Icons.edit,
                        color: MyTheme.accent_color,
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget productListWidget2() {
    return Consumer<productsProv>(
      builder: (BuildContext context, value, Widget? child) {
        return ListView.builder(
          itemCount: value.allProductsResponseData?.length,
          shrinkWrap: true,
          physics: const BouncingScrollPhysics(),
          itemBuilder: (context, index) {
            return (value.allProductsResponseData?[index].productName!
                            .toLowerCase() ??
                        '')
                    .contains(_searchController.text.toLowerCase())
                ? Container(
                    padding:
                        const EdgeInsets.only(bottom: 10, top: 10, left: 8),
                    margin:
                        const EdgeInsets.only(left: 10, right: 10, bottom: 10),
                    width: MediaQuery.of(context).size.width * 0.5,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey[200]!),
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(5),
                          width: 70,
                          height: 70,
                          child: Container(
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: NetworkImage(
                                  value.allProductsResponseData?[index]
                                          .image?[0] ??
                                      "",
                                ),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 20),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${value.allProductsResponseData?[index].productName}',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                'Qty: ${value.allProductsResponseData?[index].unit}',
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 10.0),
                          child: IconButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => EditProduct(
                                    isEdit: true,
                                    productResponse:
                                        value.allProductsResponseData?[index],
                                  ),
                                ),
                              );
                            },
                            icon: Icon(
                              Icons.edit,
                              color: MyTheme.accent_color,
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                : const SizedBox.shrink();
          },
        );
      },
    );
  }
}
