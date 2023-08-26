class AllPaymentsResponseModel {
  int? status;
  String? message;
  List<AllPaymentsResponseData>? data;

  AllPaymentsResponseModel({this.status, this.message, this.data});

  AllPaymentsResponseModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <AllPaymentsResponseData>[];
      json['data'].forEach((v) {
        data!.add(AllPaymentsResponseData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class AllPaymentsResponseData {
  String? id;
  String? userId;
  String? orderId;
  String? name;
  String? grandTotal;
  String? paymentMethod;
  String? mobile;
  String? paymentdate;

  AllPaymentsResponseData(
      {this.id,
      this.userId,
      this.orderId,
      this.name,
      this.grandTotal,
      this.paymentMethod,
      this.mobile,
      this.paymentdate});

  AllPaymentsResponseData.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    userId = json['userId'];
    orderId = json['orderId'];
    name = json['name'];
    grandTotal = json['grandTotal'];
    paymentMethod = json['paymentMethod'];
    mobile = json['mobile'];
    paymentdate = json['paymentdate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = id;
    data['userId'] = userId;
    data['orderId'] = orderId;
    data['name'] = name;
    data['grandTotal'] = grandTotal;
    data['paymentMethod'] = paymentMethod;
    data['mobile'] = mobile;
    data['paymentdate'] = paymentdate;
    return data;
  }
}
