import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:imart/api/category_repository.dart';
import 'package:imart/api/order_repository.dart';
import 'package:imart/api/payment_repository.dart';
import 'package:imart/api/product_repository.dart';
import 'package:imart/models/all_category_response_model.dart';
import 'package:imart/models/all_payments_response_model.dart';
import 'package:imart/models/all_products_response_model.dart';
import 'package:imart/models/all_order_response_model.dart';

class productsProv extends ChangeNotifier {
  List<AllProductsResponseData>? allProductsResponseData;
  List<AllPaymentsResponseData>? allPaymentsResponseData;
  List<String>? paymentDoneOrderIds = [];
  List<GetOrderResponseData>? getOrderResponseData;
  List<AllCategoryResponseData>? allCatagoryResponseList;
  int totalSale = 0;

  getAllData() async {
    try {
      // await EasyLoading.show(
      //   status: 'loading...',
      //   maskType: EasyLoadingMaskType.black,
      // );

      AllProductsResponseModel allProductsResponseModel =
          await ProductRepository().getAllProductList();

      AllPaymentsResponseModel allPaymentsResponseModel =
          await PaymentRepository().getAllPayments();

      GetOrderResponseModel getOrderResponseModel =
          await orderRepository().allOrders();

      AllCategoryResponseModel allCatagoryResponseModel =
          await CategoryRepository().getAllCategories();

      await EasyLoading.dismiss();

      if (allProductsResponseModel.status == 1) {
        allProductsResponseData = allProductsResponseModel.data;
        notifyListeners();
      } else {
        print("allProductsResponseData not got");
      }

      if (allPaymentsResponseModel.status == 1) {
        allPaymentsResponseData = allPaymentsResponseModel.data;
        paymentDoneOrderIds?.clear();
        for (var i = 0; i < allPaymentsResponseData!.length; i++) {
          paymentDoneOrderIds?.add(allPaymentsResponseData?[i].orderId ?? "");
        }
        notifyListeners();
      } else {
        print("No Payments fetched");
      }

      if (getOrderResponseModel.status == 1) {
        getOrderResponseData = getOrderResponseModel.data;
        totalSale = 0;
        for (var i = 0; i < getOrderResponseData!.length; i++) {
          if (getOrderResponseData?[i].status == "delivered" &&
              paymentDoneOrderIds!.contains(getOrderResponseData?[i].id)) {
            totalSale = totalSale +
                int.parse(getOrderResponseData?[i].grandTotal ?? "0");
          }
        }
        notifyListeners();
      } else {
        print("getOrderResponseData not got");
      }

      if (allCatagoryResponseModel.status == 1) {
        allCatagoryResponseList = allCatagoryResponseModel.data;
        notifyListeners();
      } else {
        print("allCategories not got");
      }
    } catch (e) {
      await EasyLoading.dismiss();
      EasyLoading.showToast(e.toString());
      print(e);
    }
  }
}
