import 'dart:convert';
import 'package:imart/const/base_urls.dart';
import 'package:http/http.dart' as http;
import 'package:imart/const/token.dart';
import 'package:imart/models/address_detail_response_model.dart';
import 'package:imart/models/all_order_response_model.dart';
import 'package:imart/models/get_order_items_specific_order.dart';

class orderRepository {
  Future allOrders() async {
    Uri url = Uri.parse("${ApiUrl.baseUrl}${ApiUrl.allOrders}");
    final response = await http.post(
      url,
      headers: {
        'Authorization': token!,
      },
    );
    return GetOrderResponseModel.fromJson(json.decode(response.body));
  }

  Future orderedtoShipped(String id) async {
    Uri url = Uri.parse("${ApiUrl.baseUrl}${ApiUrl.orderStatus}");
    var body = {'id': id, 'status': "shipped"};
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

  Future shippedToDelivered(String id) async {
    Uri url = Uri.parse("${ApiUrl.baseUrl}${ApiUrl.orderStatus}");
    var body = {
      'id': id,
      'status': "delivered",
      "delivereddate": DateTime.now().month < 10
          ? "${DateTime.now().day.toString()}-0${DateTime.now().month.toString()}"
          : "${DateTime.now().day.toString()}-${DateTime.now().month.toString()}",
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

  Future getSpecificAddress({String? id}) async {
    Uri url = Uri.parse("${ApiUrl.baseUrl}${ApiUrl.specificAddress}");
    var reqBody = {
      "id": id,
    };
    final response = await http.post(
      url,
      body: jsonEncode(reqBody),
      headers: {
        'Authorization': token!,
        "Content-Type": "application/json",
      },
    );
    return AddressDetailResponseModel.fromJson(json.decode(response.body));
  }

  Future orderItemsOfSpecificOrder({String? orderId}) async {
    Uri url = Uri.parse("${ApiUrl.baseUrl}${ApiUrl.orderListSpecificOrder}");
    var reqBody = {"orderId": orderId};
    final response = await http.post(
      url,
      body: jsonEncode(reqBody),
      headers: {
        'Authorization': token!,
        "Content-Type": 'application/json',
      },
    );
    return GetOrderItemsOfSpecificOrder.fromJson(json.decode(response.body));
  }
}
