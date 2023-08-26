import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:imart/api/category_repository.dart';
import 'package:imart/const/my_theme.dart';
import 'package:imart/models/all_category_response_model.dart';
import 'package:imart/provider/productsData.dart';
import 'package:imart/ui_section/drawer/seller_drawer.dart';
import 'package:imart/ui_section/product/edit_product_list.dart';
import 'package:provider/provider.dart';

class ManageProductList extends StatefulWidget {
  const ManageProductList({super.key});

  @override
  _ManageProductListState createState() => _ManageProductListState();
}

class _ManageProductListState extends State<ManageProductList>
    with TickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  productsProv prov1 = productsProv();
  AllCategoryResponseModel? categories;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    allCategories();
    prov1 = Provider.of<productsProv>(context, listen: false);
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
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(color: MyTheme.accent_color),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: const Padding(
                          padding: EdgeInsets.only(left: 10),
                          child: Icon(
                            CupertinoIcons.left_chevron,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      Text(
                        'Manage Product',
                        style: TextStyle(
                          color: MyTheme.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      IconButton(
                        onPressed: () async {
                          var data = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EditProduct(isEdit: false),
                            ),
                          );
                          if (data != null && data == true) {
                            prov1.getAllData();
                            allCategories();
                          }
                        },
                        icon: Icon(
                          CupertinoIcons.add_circled,
                          color: Colors.white,
                        ),
                      )
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
                      allCategories();
                    },
                    child: _searchController.text.isEmpty
                        ? SingleChildScrollView(
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

  allCategories() async {
    try {
      AllCategoryResponseModel model =
          await CategoryRepository().getAllCategories();
      if (model.status == 1) {
        categories = model;
      } else {
        print("Categiries not got");
      }
    } catch (e) {
      print(e);
    }
    setState(() {});
    return categories;
  }

  Widget productListWidget() {
    return Consumer<productsProv>(
      builder: (context, value, child) {
        return FutureBuilder(
          future: allCategories(),
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                itemCount: value.allProductsResponseData?.length,
                shrinkWrap: true,
                physics: BouncingScrollPhysics(),
                itemBuilder: (context, index) {
                  String categoryName = "";
                  int i = 0;
                  for (i = 0; i < categories!.data!.length; i++) {
                    if (value.allProductsResponseData?[index].categorieId ==
                        categories?.data?[i].id) {
                      categoryName = categories?.data?[i].name ?? "";
                      break;
                    }
                  }
                  return Container(
                    padding:
                        const EdgeInsets.only(bottom: 10, top: 10, left: 8),
                    margin:
                        const EdgeInsets.only(left: 10, right: 10, bottom: 10),
                    width: MediaQuery.of(context).size.width * 0.5,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade200),
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
                              const SizedBox(height: 3),
                              Text(
                                categoryName,
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.grey[600],
                                ),
                              ),
                              const SizedBox(height: 3),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'mrp: ${value.allProductsResponseData?[index].mrpPrice} ₹',
                                        style: const TextStyle(
                                          fontSize: 12,
                                          decoration:
                                              TextDecoration.lineThrough,
                                        ),
                                      ),
                                      const SizedBox(height: 5),
                                      Text(
                                        '${value.allProductsResponseData?[index].sellPrice} ₹',
                                        style: TextStyle(
                                          fontSize: 15,
                                          color: Colors.grey[600],
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(width: 15),
                                  int.parse(value
                                                  .allProductsResponseData?[
                                                      index]
                                                  .sellPrice ??
                                              "") <
                                          int.parse(value
                                                  .allProductsResponseData?[
                                                      index]
                                                  .mrpPrice ??
                                              "")
                                      ? Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 10,
                                            vertical: 6,
                                          ),
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                                color: MyTheme.accent_color),
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                          child: Text(
                                            "${100 - ((int.parse(value.allProductsResponseData?[index].sellPrice ?? "1") / int.parse(value.allProductsResponseData?[index].mrpPrice ?? "1") * 100)).toInt()}% Off",
                                            style: TextStyle(
                                              fontSize: 13,
                                              color: MyTheme.accent_color,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        )
                                      : Container(),
                                ],
                              ),
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: () async {
                            var data = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => EditProduct(
                                  isEdit: true,
                                  productResponse:
                                      value.allProductsResponseData?[index],
                                ),
                              ),
                            );
                            if (data != null && data == true) {
                              prov1.getAllData();
                              allCategories();
                            }
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(right: 10.0),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: MyTheme.accent_color,
                              ),
                              child: const Text(
                                'Edit',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
            } else {
              return const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Center(
                    child: Text("Loading"),
                  ),
                ],
              );
            }
          },
        );
      },
    );
  }

  Widget productListWidget2() {
    return Consumer<productsProv>(
      builder: (context, value, child) {
        return ListView.builder(
          itemCount: value.allProductsResponseData?.length,
          shrinkWrap: true,
          physics: BouncingScrollPhysics(),
          itemBuilder: (context, index) {
            String categoryName = "";
            int i = 0;
            for (i = 0; i < categories!.data!.length; i++) {
              if (value.allProductsResponseData?[index].categorieId ==
                  categories?.data?[i].id) {
                categoryName = categories?.data?[i].name ?? "";
                break;
              }
            }
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
                      border: Border.all(color: Colors.grey.shade200),
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
                              const SizedBox(height: 3),
                              Text(
                                categoryName,
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.grey[600],
                                ),
                              ),
                              const SizedBox(height: 3),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'mrp: ${value.allProductsResponseData?[index].mrpPrice} ₹',
                                        style: const TextStyle(
                                          fontSize: 12,
                                          decoration:
                                              TextDecoration.lineThrough,
                                        ),
                                      ),
                                      const SizedBox(height: 5),
                                      Text(
                                        '${value.allProductsResponseData?[index].sellPrice} ₹',
                                        style: TextStyle(
                                          fontSize: 15,
                                          color: Colors.grey[600],
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(width: 15),
                                  int.parse(value
                                                  .allProductsResponseData?[
                                                      index]
                                                  .sellPrice ??
                                              "") <
                                          int.parse(value
                                                  .allProductsResponseData?[
                                                      index]
                                                  .mrpPrice ??
                                              "")
                                      ? Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 10,
                                            vertical: 6,
                                          ),
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                                color: MyTheme.accent_color),
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                          child: Text(
                                            "${100 - ((int.parse(value.allProductsResponseData?[index].sellPrice ?? "1") / int.parse(value.allProductsResponseData?[index].mrpPrice ?? "1") * 100)).toInt()}% Off",
                                            style: TextStyle(
                                              fontSize: 13,
                                              color: MyTheme.accent_color,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        )
                                      : Container(),
                                ],
                              ),
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: () async {
                            var data = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => EditProduct(
                                  isEdit: true,
                                  productResponse:
                                      value.allProductsResponseData?[index],
                                ),
                              ),
                            );
                            if (data != null && data == true) {
                              prov1.getAllData();
                              allCategories();
                            }
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(right: 10.0),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: MyTheme.accent_color,
                              ),
                              child: const Text(
                                'Edit',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                : SizedBox.shrink();
          },
        );
      },
    );
  }
}
