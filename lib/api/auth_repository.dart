import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:imart/const/base_urls.dart';
import 'package:imart/const/token.dart';

class AuthRepository {
  Future getLoginResponse({String? mobile, String? deviceToken}) async {
    var postBody = {
      "mobileno": mobile,
      "device_token": "a",
    };

    Uri url = Uri.parse("${ApiUrl.baseUrl}${ApiUrl.login}");
    final response = await http.post(
      url,
      headers: {
        'Authorization': token!,
        "Content-Type": "application/json",
      },
      body: jsonEncode(postBody),
    );
    return json.decode(response.body);
  }

  Future getSignUpResponse(
      {String? mobile, String? deviceToken, String? name}) async {
    var postBody = {
      "mobileno": mobile,
      "device_token": deviceToken,
      "name": name
    };

    Uri url = Uri.parse("${ApiUrl.baseUrl}${ApiUrl.signUp}");
    final response = await http.post(
      url,
      headers: {
        'Authorization': token!,
        "Content-Type": "application/json",
      },
      body: jsonEncode(postBody),
    );
    return jsonDecode(response.body);
  }

  Future sendOtp({String? phoneNumber}) async {
    var postBody = {
      "phoneNumber": phoneNumber,
    };
    Uri url = Uri.parse("${ApiUrl.baseUrl}${ApiUrl.sendOtpVendor}");
    final response = await http.post(
      url,
      body: jsonEncode(postBody),
      headers: {"Content-Type": "application/json"},
    );
    return jsonDecode(response.body);
  }

  Future verifyOtp({String? phoneNumber, String? otpCode}) async {
    var postBody = {
      "phoneNumber": phoneNumber,
      "otpCode": otpCode,
    };
    Uri url = Uri.parse("${ApiUrl.baseUrl}${ApiUrl.verifyOtpVendor}");
    final response = await http.post(
      url,
      body: jsonEncode(postBody),
      headers: {"Content-Type": "application/json"},
    );
    return jsonDecode(response.body);
  }
}
