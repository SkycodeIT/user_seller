import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:imart/api/category_repository.dart';
import 'package:imart/const/asset_path.dart';
import 'package:imart/const/my_theme.dart';
import 'package:imart/models/all_category_response_model.dart';
import 'package:imart/ui_section/product/product_list_category_wise.dart';

class Category extends StatefulWidget {
  const Category({super.key});

  @override
  _CategoryState createState() => _CategoryState();
}

class _CategoryState extends State<Category> with TickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController _searchController = TextEditingController();
  List<AllCategoryResponseData>? getCatagoryResponseList;

  @override
  void initState() {
    super.initState();
    getcategoryData();
  }

  getcategoryData() async {
    try {
      // await EasyLoading.show(
      //   status: 'loading...',
      //   maskType: EasyLoadingMaskType.black,
      // );
      AllCategoryResponseModel allCategoryResponseModel =
          await CategoryRepository().getAllCategories();

      await EasyLoading.dismiss();

      if (allCategoryResponseModel.status == 1) {
        if (_searchController.text.isEmpty) {
          getCatagoryResponseList = allCategoryResponseModel.data;
        } else {
          getCatagoryResponseList?.clear();
          for (var element in allCategoryResponseModel.data!) {
            if ((element.name!.toLowerCase())
                .contains(_searchController.text.toLowerCase())) {
              getCatagoryResponseList?.add(element);
            }
          }
        }
      } else {
        print("not got");
      }
    } catch (e) {
      await EasyLoading.dismiss();
      print(e);
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: const Color.fromRGBO(247, 249, 250, 1.0),
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
                    'Categories',
                    style: TextStyle(
                      color: MyTheme.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(),
                ],
              ),
            ),
            searchBar(),
            const SizedBox(height: 15),
            categoryList(),
            const SizedBox(height: 90),
          ],
        ),
      ),
    );
  }

  Widget categoryList() {
    return Expanded(
      child: RefreshIndicator(
        onRefresh: () async {
          await getcategoryData();
        },
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: GridView.builder(
              shrinkWrap: true,
              physics: const BouncingScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 1.2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: getCatagoryResponseList?.length ?? 0,
              itemBuilder: (BuildContext ctx, index) {
                return InkWell(
                  onTap: () {
                    print(getCatagoryResponseList![index].id.toString());
                    print(getCatagoryResponseList![index].name ?? '');
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProductListPage(
                          catId: getCatagoryResponseList![index].id,
                          title: getCatagoryResponseList![index].name ?? '',
                        ),
                      ),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.only(bottom: 7),
                    decoration: const BoxDecoration(color: Colors.white),
                    child: Column(
                      children: [
                        Container(
                          height: MediaQuery.of(context).size.height * 0.12,
                          width: MediaQuery.of(context).size.width,
                          decoration: const BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage('assets/image/fruits.png'),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 5),
                            child: Text(
                              getCatagoryResponseList![index].name ?? '',
                              style: const TextStyle(fontSize: 14),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget searchBar() {
    return Container(
      margin: const EdgeInsets.only(top: 15, right: 15, left: 15),
      child: TextField(
        controller: _searchController,
        onTap: () {},
        onChanged: (txt) {
          getcategoryData();
        },
        onSubmitted: (txt) {},
        autofocus: false,
        decoration: InputDecoration(
            hintText: 'Search Product',
            hintStyle: TextStyle(fontSize: 14.0, color: MyTheme.textfield_grey),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.0),
              borderSide: BorderSide(color: MyTheme.accent_color, width: 1.0),
            ),
            filled: true,
            fillColor: Colors.white,
            suffixIcon: Icon(Icons.mic, color: MyTheme.accent_color),
            border: OutlineInputBorder(
              borderSide: BorderSide(color: MyTheme.accent_color, width: 1.0),
              borderRadius: BorderRadius.circular(12.0),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.0),
              borderSide: BorderSide(color: MyTheme.accent_color, width: 1.0),
            ),
            prefixIcon: Icon(Icons.search, color: MyTheme.accent_color),
            contentPadding: const EdgeInsets.only(left: 10)),
      ),
    );
  }
}
