import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:imart/api/category_repository.dart';
import 'package:imart/api/product_repository.dart';
import 'package:imart/api/sub_category_repository.dart';
import 'package:imart/const/my_theme.dart';
import 'package:imart/const/text_field.dart';
import 'package:imart/models/all_products_response_model.dart';
import 'package:imart/models/all_category_response_model.dart';
import 'package:imart/models/sub_category_response_model.dart';

class EditProduct extends StatefulWidget {
  final bool? isEdit;
  final AllProductsResponseData? productResponse;
  const EditProduct({this.isEdit, this.productResponse, super.key});

  @override
  State<EditProduct> createState() => _EditProductState();
}

class _EditProductState extends State<EditProduct> {
  TextEditingController? productName = TextEditingController();
  TextEditingController? description = TextEditingController();
  TextEditingController? mrpPrice = TextEditingController();
  TextEditingController? sellPrice = TextEditingController();
  TextEditingController? units = TextEditingController();
  TextEditingController? image1 = TextEditingController();
  TextEditingController? image2 = TextEditingController();
  TextEditingController? image3 = TextEditingController();
  TextEditingController? newCategory = TextEditingController();
  TextEditingController? newSubcategory = TextEditingController();
  TextEditingController? descriptionSubCategory = TextEditingController();
  String unitChooosen = "Kg's";
  String categoryChoosen = "fruits";
  String categoryChoosenId = "";
  String subCategoryChoosen = "all";
  String subCategoryChoosenId = "";
  AllCategoryResponseModel? categories;
  GetSubCategoryResponseModel? subCategories;

  @override
  void initState() {
    super.initState();
    if (widget.isEdit == true) {
      productName = TextEditingController(
          text: widget.productResponse?.productName ?? '');
      description = TextEditingController(
          text: widget.productResponse?.description ?? '');
      mrpPrice =
          TextEditingController(text: widget.productResponse?.mrpPrice ?? '');
      sellPrice =
          TextEditingController(text: widget.productResponse?.sellPrice ?? '');
      units =
          TextEditingController(text: widget.productResponse!.unit.toString());
      unitChooosen =
          widget.productResponse?.unitChoosen == "kg" ? "Kg's" : "grm";

      if (widget.productResponse!.image?.length == 1) {
        image1 = TextEditingController(
            text: widget.productResponse!.image?[0].toString());
      } else if (widget.productResponse!.image?.length == 2) {
        image1 = TextEditingController(
            text: widget.productResponse!.image?[0].toString());
        image2 = TextEditingController(
            text: widget.productResponse!.image?[1].toString());
      } else if (widget.productResponse!.image?.length == 3) {
        image1 = TextEditingController(
            text: widget.productResponse!.image?[0].toString());
        image2 = TextEditingController(
            text: widget.productResponse!.image?[1].toString());
        image3 = TextEditingController(
            text: widget.productResponse!.image?[2].toString());
      }
    }
    getAllCategories();
  }

  getAllCategories() async {
    try {
      // EasyLoading.show(
      //   status: 'loading...',
      //   maskType: EasyLoadingMaskType.black,
      // );

      AllCategoryResponseModel resCat =
          await CategoryRepository().getAllCategories();

      EasyLoading.dismiss();
      if (resCat.status == 1) {
        categories = resCat;
        if (widget.isEdit == true) {
          for (var i = 0; i < categories!.data!.length; i++) {
            if (categories?.data?[i].id ==
                widget.productResponse?.categorieId) {
              categoryChoosen = categories?.data?[i].name ?? "fruits";
              categoryChoosenId = categories?.data?[i].id ?? "";
              break;
            }
          }
          getAllSubCategories(categoryChoosenId, true);
        }
      } else {
        print("Categiries not got");
      }
    } catch (e) {
      EasyLoading.dismiss();
      print(e);
    }
    setState(() {});
    return categories;
  }

  getAllSubCategories(String id, bool isFirst) async {
    try {
      // EasyLoading.show(
      //   status: 'loading...',
      //   maskType: EasyLoadingMaskType.black,
      // );

      GetSubCategoryResponseModel resSubCat =
          await SubCategoryRepository().getSubCategories(id);

      EasyLoading.dismiss();
      if (resSubCat.status == 1) {
        subCategories = resSubCat;
        subCategoryChoosen = subCategories?.data?[0].name ?? "";
        subCategoryChoosenId = subCategories?.data?[0].id ?? "";
        if (widget.isEdit == true && isFirst == true) {
          for (var i = 0; i < subCategories!.data!.length; i++) {
            if (subCategories?.data?[i].id ==
                widget.productResponse?.subCategorieId) {
              subCategoryChoosen = subCategories?.data?[i].name ?? "all";
              subCategoryChoosenId = subCategories?.data?[i].id ?? "";
              break;
            }
          }
        }
      } else {
        print("Sub Categories not got");
      }
    } catch (e) {
      EasyLoading.dismiss();
      print(e);
    }
    setState(() {});
    return subCategories;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: const Icon(
                        CupertinoIcons.left_chevron,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Text(
                    widget.isEdit! ? 'Update Product' : 'Add Product',
                    style: TextStyle(
                      color: MyTheme.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: widget.isEdit == true
                        ? InkWell(
                            onTap: () async {
                              try {
                                var response =
                                    await ProductRepository().deleteProduct(
                                  productId: widget.productResponse?.productId,
                                );
                                EasyLoading.dismiss();
                                if (response['status'] == 1) {
                                  EasyLoading.showToast(response['message']);
                                  Navigator.pop(context, true);
                                } else {
                                  EasyLoading.showToast(response['message']);
                                }
                              } catch (e) {
                                EasyLoading.dismiss();
                                print(e);
                              }
                            },
                            child: Icon(
                              Icons.delete,
                              color: Colors.white,
                            ),
                          )
                        : SizedBox(),
                  ),
                ],
              ),
            ),
            _productList(),
            _addUpdateButton(),
          ],
        ),
      ),
    );
  }

  Widget _productList() {
    return Expanded(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomTextField().secondaryTextField(
                context,
                controller: productName,
                headline: 'Product Name',
                hintText: 'Enter Product Name',
              ),
              CustomTextField().secondaryTextField(
                context,
                controller: description,
                headline: 'Description',
                hintText: 'Enter description',
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Category",
                      textAlign: TextAlign.start,
                      style: Theme.of(context)
                          .textTheme
                          .bodyText2!
                          .copyWith(color: Colors.grey),
                    ),
                    TextButton(
                      onPressed: () {
                        addCategoryDialog();
                      },
                      child: Text(
                        "+ New Category",
                        textAlign: TextAlign.end,
                        style: Theme.of(context).textTheme.bodyText2!.copyWith(
                              color: Colors.grey.shade600,
                              fontSize: 10,
                            ),
                      ),
                    )
                  ],
                ),
              ),
              categorySelect(),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Subcategory",
                      textAlign: TextAlign.start,
                      style: Theme.of(context)
                          .textTheme
                          .bodyText2!
                          .copyWith(color: Colors.grey),
                    ),
                    TextButton(
                      onPressed: () {
                        addSubcategoryDialog(
                          categoryChoosen,
                          categoryChoosenId,
                        );
                      },
                      child: Text(
                        "+ New Subcategory",
                        textAlign: TextAlign.end,
                        style: Theme.of(context).textTheme.bodyText2!.copyWith(
                              color: Colors.grey.shade600,
                              fontSize: 10,
                            ),
                      ),
                    )
                  ],
                ),
              ),
              subCategorySelect(),
              CustomTextField().secondaryTextField(
                context,
                controller: mrpPrice,
                headline: 'MRP',
                hintText: 'Enter MRP',
              ),
              CustomTextField().secondaryTextField(
                context,
                controller: sellPrice,
                headline: 'Sell Price',
                hintText: 'Enter Your Sell Price',
              ),
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: CustomTextField().secondaryTextField(
                      context,
                      controller: units,
                      headline: 'Units',
                      hintText: 'Enter Units available',
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    flex: 1,
                    child: DropdownButtonHideUnderline(
                      child: Container(
                        decoration: BoxDecoration(
                          color: const Color(0xffF6F6F6),
                          border: Border.all(
                            color: const Color(0xffffffff).withOpacity(0.1),
                            width: 1,
                            style: BorderStyle.solid,
                          ),
                          borderRadius: BorderRadius.circular(
                            GlobalSizes.kBorderRadius / 4,
                          ),
                        ),
                        child: DropdownButton(
                          hint: Text("Select Unit"),
                          elevation: 0,
                          borderRadius: BorderRadius.circular(6),
                          dropdownColor: const Color(0xffF6F6F6),
                          focusColor: const Color(0xffF6F6F6),
                          icon: Icon(Icons.arrow_drop_down),
                          style: Theme.of(context).textTheme.bodyText1,
                          value: unitChooosen,
                          items: ["Kg's", "grm"].map((e) {
                            return DropdownMenuItem(
                              value: e,
                              child: Text(e),
                            );
                          }).toList(),
                          onChanged: (newvalue) {
                            setState(() {
                              unitChooosen = newvalue ?? "Kg's";
                            });
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              CustomTextField().secondaryTextField(
                context,
                controller: image1,
                headline: 'Image 1',
                hintText: '1st Image Url',
              ),
              CustomTextField().secondaryTextField(
                context,
                controller: image3,
                headline: 'Image 2',
                hintText: '2nd Image Url',
              ),
              CustomTextField().secondaryTextField(
                context,
                controller: image3,
                headline: 'Image 3',
                hintText: '3rd Image Url',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<dynamic> addSubcategoryDialog(String CatName, String CatId) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Center(
            child: Text(
              "Add SubCategory \n for $CatName",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: newSubcategory,
                decoration: InputDecoration(
                  labelText: 'SubCategory Name',
                  labelStyle: TextStyle(
                    color: Colors.grey.shade500,
                  ),
                  hintText: 'SubCategory Name',
                  filled: true,
                  fillColor: const Color.fromARGB(255, 242, 242, 242),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.green.shade400,
                    ),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.green.shade400,
                    ),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.green.shade400,
                    ),
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: descriptionSubCategory,
                decoration: InputDecoration(
                  labelText: 'description',
                  labelStyle: TextStyle(
                    color: Colors.grey.shade500,
                  ),
                  hintText: 'description',
                  filled: true,
                  fillColor: const Color.fromARGB(255, 242, 242, 242),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.green.shade400,
                    ),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.green.shade400,
                    ),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.green.shade400,
                    ),
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
              ),
            ],
          ),
          actions: [
            OutlinedButton(
              style: OutlinedButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
                shape: const StadiumBorder(),
              ),
              child: Text(
                'Cancel',
                style: TextStyle(
                  color: Colors.green.shade400,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green.shade400,
                shape: const StadiumBorder(),
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('Create'),
              onPressed: () async {
                try {
                  var responce = await SubCategoryRepository().addSubCategories(
                    CatId,
                    newSubcategory!.text,
                    descriptionSubCategory!.text,
                  );
                  if (responce['status'] == 1) {
                    EasyLoading.showToast(responce['message']);
                    Navigator.pop(context);
                    getAllSubCategories(CatId, false);
                  } else {
                    EasyLoading.showToast(responce['message']);
                  }
                } catch (e) {
                  EasyLoading.dismiss();
                  print(e);
                }
                setState(() {});
              },
            ),
          ],
        );
      },
    );
  }

  Future<dynamic> addCategoryDialog() {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            "Add Category",
            style: TextStyle(
              fontWeight: FontWeight.w600,
            ),
          ),
          content: TextFormField(
            controller: newCategory,
            decoration: InputDecoration(
              labelText: 'Category Name',
              labelStyle: TextStyle(
                color: Colors.green.shade400,
              ),
              hintText: 'Category Name',
              filled: true,
              fillColor: const Color.fromARGB(255, 242, 242, 242),
              border: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.green.shade400,
                ),
                borderRadius: BorderRadius.circular(6),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.green.shade400,
                ),
                borderRadius: BorderRadius.circular(6),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.green.shade400,
                ),
                borderRadius: BorderRadius.circular(6),
              ),
            ),
          ),
          actions: [
            OutlinedButton(
              style: OutlinedButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
                shape: const StadiumBorder(),
              ),
              child: Text(
                'Cancel',
                style: TextStyle(
                  color: Colors.green.shade400,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green.shade400,
                shape: const StadiumBorder(),
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('Create'),
              onPressed: () async {
                try {
                  var responce =
                      await CategoryRepository().addCategory(newCategory!.text);
                  if (responce['status'] == 1) {
                    EasyLoading.showToast(responce['message']);
                    Navigator.pop(context);
                    getAllCategories();
                  } else {
                    EasyLoading.showToast(responce['message']);
                  }
                } catch (e) {
                  EasyLoading.dismiss();
                  print(e);
                }
                setState(() {});
              },
            ),
          ],
        );
      },
    );
  }

  Widget _addUpdateButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: InkWell(
        onTap: () async {
          addOrupdateProduct();
        },
        child: Container(
          margin: const EdgeInsets.only(left: 20, right: 20, bottom: 70),
          padding: const EdgeInsets.symmetric(vertical: 15),
          decoration: BoxDecoration(
            color: MyTheme.accent_color,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Center(
            child: Text(
              widget.isEdit! ? 'Update' : 'Add',
              style: const TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
        ),
      ),
    );
  }

  Widget categorySelect() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xffF6F6F6),
          borderRadius: BorderRadius.circular(6),
        ),
        child: DropdownButton(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          items: categories?.data?.map((e) {
            return DropdownMenuItem(
              value: e.name,
              child: Text(e.name ?? ""),
            );
          }).toList(),
          value: categoryChoosen,
          onChanged: (value) {
            setState(() {
              categoryChoosen = value!;
            });
            int i = 0;
            for (i = 0; i < categories!.data!.length; i++) {
              if (categoryChoosen == categories?.data?[i].name) {
                categoryChoosenId = categories?.data?[i].id ?? "";
                getAllSubCategories(categories?.data?[i].id ?? "", false);
                break;
              }
            }
          },
          hint: Text(
            "Select Category",
            style: Theme.of(context)
                .textTheme
                .bodyText2!
                .copyWith(color: Colors.grey.withOpacity(0.9)),
          ),
          dropdownColor: const Color(0xffF6F6F6),
          icon: const Icon(Icons.arrow_drop_down_rounded),
          iconSize: 35,
          isExpanded: true,
          underline: const SizedBox(),
          style: Theme.of(context).textTheme.bodyText1,
        ),
      ),
    );
  }

  Widget subCategorySelect() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xffF6F6F6),
          borderRadius: BorderRadius.circular(6),
        ),
        child: DropdownButton(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          items: subCategories?.data?.map((e) {
            return DropdownMenuItem(
              value: e.name,
              child: Text(e.name ?? ""),
            );
          }).toList(),
          value: subCategoryChoosen,
          onChanged: (value) {
            subCategoryChoosen = value!;
            int i = 0;
            for (i = 0; i < subCategories!.data!.length; i++) {
              if (subCategoryChoosen == subCategories?.data?[i].name) {
                subCategoryChoosenId = subCategories?.data?[i].id ?? "";
                break;
              }
            }
            setState(() {});
          },
          hint: Text(
            "Select Subcategory",
            style: Theme.of(context)
                .textTheme
                .bodyText2!
                .copyWith(color: Colors.grey.withOpacity(0.9)),
          ),
          dropdownColor: const Color(0xffF6F6F6),
          icon: const Icon(Icons.arrow_drop_down_rounded),
          iconSize: 35,
          isExpanded: true,
          underline: const SizedBox(),
          style: Theme.of(context).textTheme.bodyText1,
        ),
      ),
    );
  }

  addOrupdateProduct() async {
    try {
      // EasyLoading.show(
      //   status: 'loading...',
      //   maskType: EasyLoadingMaskType.black,
      // );

      List<String> updatedImages = [];
      if (image1?.text.length != 0) {
        updatedImages.add(image1?.text ?? '');
      }
      if (image2?.text.length != 0) {
        updatedImages.add(image2?.text ?? '');
      }
      if (image3?.text.length != 0) {
        updatedImages.add(image3?.text ?? '');
      }

      if (updatedImages.isNotEmpty) {
        var responce = widget.isEdit == true
            ? await ProductRepository().updateProduct(
                id: widget.productResponse?.id,
                productId: widget.productResponse?.productId,
                categorieId: categoryChoosenId,
                subCategorieId: subCategoryChoosenId,
                productName: productName?.text,
                description: description?.text,
                mrpPrice: mrpPrice?.text,
                sellPrice: sellPrice?.text,
                kgOrgm: unitChooosen == "Kg's" ? "kg" : "gm",
                isWishlist: widget.productResponse!.isWishlist,
                unit: int.parse(units!.text),
                image: updatedImages,
              )
            : await ProductRepository().addProduct(
                productId: Random().nextInt(500),
                categorieId: categoryChoosenId,
                subCategorieId: subCategoryChoosenId,
                productName: productName?.text,
                description: description?.text,
                mrpPrice: mrpPrice?.text,
                sellPrice: sellPrice?.text,
                kgOrgm: unitChooosen == "Kg's" ? "kg" : "gm",
                isWishlist: 0,
                unit: int.parse(units!.text),
                image: updatedImages,
              );

        EasyLoading.dismiss();

        if (responce['status'] == 1) {
          EasyLoading.showToast(responce['message']);
          Navigator.pop(context, true);
        } else {
          widget.isEdit == true
              ? EasyLoading.showToast("Failed to Update")
              : EasyLoading.showToast("Failed to Add");
        }
      } else {
        EasyLoading.showToast("Please add the images");
      }
    } catch (e) {
      EasyLoading.dismiss();
      print(e);
    }
    setState(() {});
  }
}
