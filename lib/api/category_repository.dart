import 'dart:convert';
import 'package:imart/const/base_urls.dart';
import 'package:http/http.dart' as http;
import 'package:imart/const/token.dart';
import 'package:imart/models/all_category_response_model.dart';

class CategoryRepository {
  Future getAllCategories() async {
    Uri url = Uri.parse("${ApiUrl.baseUrl}${ApiUrl.category}");
    final response = await http.get(
      url,
      headers: {'Authorization': token!, "Content-Type": "application/json"},
    );
    return AllCategoryResponseModel.fromJson(json.decode(response.body));
  }

  Future addCategory(String name) async {
    Uri url = Uri.parse("${ApiUrl.baseUrl}${ApiUrl.addNewCategory}");
    var req = {"name": name};
    final response = await http.post(
      url,
      body: jsonEncode(req),
      headers: {
        'Authorization': token!,
        "Content-Type": "application/json",
      },
    );
    return json.decode(response.body);
  }
}
