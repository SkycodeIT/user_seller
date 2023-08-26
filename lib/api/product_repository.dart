import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:imart/const/base_urls.dart';
import 'package:imart/const/token.dart';
import 'package:imart/models/all_products_response_model.dart';
import 'package:imart/models/product_detail_response_model.dart';

class ProductRepository {
  Future getAllProductList() async {
    Uri url = Uri.parse("${ApiUrl.baseUrl}${ApiUrl.products}");
    final response = await http.post(
      url,
      headers: {'Authorization': token!},
    );
    return AllProductsResponseModel.fromJson(json.decode(response.body));
  }

  Future getProductListByCategory({String? id}) async {
    Uri url = Uri.parse("${ApiUrl.baseUrl}${ApiUrl.productByCatId}");
    var reqBody = {'categorieId': id};
    final response = await http.post(
      url,
      body: jsonEncode(reqBody),
      headers: {'Authorization': token!, "Content-Type": "application/json"},
    );
    return AllProductsResponseModel.fromJson(json.decode(response.body));
  }

  Future getProductDetail({int? id}) async {
    Uri url = Uri.parse("${ApiUrl.baseUrl}${ApiUrl.productDetails}");
    var reqBody = {"productId": id};
    final response = await http.post(
      url,
      body: jsonEncode(reqBody),
      headers: {'Authorization': token!, "Content-Type": "application/json"},
    );
    return ProductDetailResponseModel.fromJson(json.decode(response.body));
  }

  Future updateProduct(
      {String? id,
      int? productId,
      String? categorieId,
      String? subCategorieId,
      String? productName,
      String? description,
      String? mrpPrice,
      String? sellPrice,
      String? kgOrgm,
      int? isWishlist,
      int? unit,
      List<String>? image}) async {
    Uri url = Uri.parse("${ApiUrl.baseUrl}${ApiUrl.updateProduct}");
    var reqBody = {
      "_id": id,
      "productId": productId,
      "categorieId": categorieId,
      "subCategorieId": subCategorieId,
      "productName": productName,
      "description": description,
      "mrpPrice": mrpPrice,
      "sellPrice": sellPrice,
      "kgOrgm": kgOrgm,
      "isWishlist": isWishlist,
      "unit": unit,
      "image": image,
    };
    final response = await http.post(
      url,
      body: jsonEncode(reqBody),
      headers: {
        'Authorization': token!,
        "Content-Type": "application/json",
      },
    );
    return json.decode(response.body);
  }

  Future addProduct(
      {int? productId,
      String? categorieId,
      String? subCategorieId,
      String? productName,
      String? description,
      String? mrpPrice,
      String? sellPrice,
      String? kgOrgm,
      int? isWishlist,
      int? unit,
      List<String>? image}) async {
    Uri url = Uri.parse("${ApiUrl.baseUrl}${ApiUrl.addNewProduct}");
    var reqBody = {
      "productId": productId,
      "categorieId": categorieId,
      "subCategorieId": subCategorieId,
      "productName": productName,
      "description": description,
      "mrpPrice": mrpPrice,
      "sellPrice": sellPrice,
      "kgOrgm": kgOrgm,
      "isWishlist": isWishlist,
      "unit": unit,
      "image": image,
    };
    final response = await http.post(
      url,
      body: jsonEncode(reqBody),
      headers: {
        'Authorization': token!,
        "Content-Type": "application/json",
      },
    );
    return json.decode(response.body);
  }

  Future deleteProduct({int? productId}) async {
    Uri url = Uri.parse("${ApiUrl.baseUrl}${ApiUrl.deleteProduct}");
    var reqBody = {
      "productId": productId,
    };
    final response = await http.post(
      url,
      body: jsonEncode(reqBody),
      headers: {
        'Authorization': token!,
        "Content-Type": "application/json",
      },
    );
    return json.decode(response.body);
  }
}
