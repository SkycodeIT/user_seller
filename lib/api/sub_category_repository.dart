import 'dart:convert';
import 'package:imart/const/base_urls.dart';
import 'package:http/http.dart' as http;
import 'package:imart/const/token.dart';
import 'package:imart/models/sub_category_response_model.dart';

class SubCategoryRepository {
  Future getSubCategories(String id) async {
    Uri url = Uri.parse("${ApiUrl.baseUrl}${ApiUrl.subcategory}");
    var body = {'categorieId': id};
    final response = await http.post(
      url,
      body: jsonEncode(body),
      headers: {'Authorization': token!, "Content-Type": "application/json"},
    );
    return GetSubCategoryResponseModel.fromJson(json.decode(response.body));
  }

  Future addSubCategories(String id, String name, String desc) async {
    Uri url = Uri.parse("${ApiUrl.baseUrl}${ApiUrl.addSubCategory}");
    var body = {
      'categorieId': id,
      'name': name,
      'description': desc,
    };
    final response = await http.post(
      url,
      body: jsonEncode(body),
      headers: {
        'Authorization': token!,
        "Content-Type": "application/json",
      },
    );
    return json.decode(response.body);
  }
}
