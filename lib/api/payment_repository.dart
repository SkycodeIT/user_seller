import 'dart:convert';
import 'package:imart/const/base_urls.dart';
import 'package:http/http.dart' as http;
import 'package:imart/const/token.dart';
import 'package:imart/models/all_payments_response_model.dart';

class PaymentRepository {
  Future getAllPayments() async {
    Uri url = Uri.parse("${ApiUrl.baseUrl}${ApiUrl.allpayments}");
    final response = await http.post(
      url,
      headers: {
        'Authorization': token!,
        "Content-Type": "application/json",
      },
    );
    return AllPaymentsResponseModel.fromJson(json.decode(response.body));
  }

  Future addPayment(String userId, String orderId, String name,
      String grandTotal, String paymentMethod, String mobile) async {
    Uri url = Uri.parse("${ApiUrl.baseUrl}${ApiUrl.addpayment}");
    var req = {
      "userId": userId,
      "orderId": orderId,
      "name": name,
      "grandTotal": grandTotal,
      "paymentMethod": paymentMethod,
      "mobile": mobile,
      "paymentdate": DateTime.now().month < 10
          ? "${DateTime.now().day.toString()}-0${DateTime.now().month.toString()}-${DateTime.now().year.toString()}"
          : "${DateTime.now().day.toString()}-${DateTime.now().month.toString()}-${DateTime.now().year.toString()}",
    };
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
