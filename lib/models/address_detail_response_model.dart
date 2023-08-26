class AddressDetailResponseModel {
  int? status;
  String? message;
  AddressDetailResponseData? data;

  AddressDetailResponseModel({this.status, this.message, this.data});

  AddressDetailResponseModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null
        ? AddressDetailResponseData.fromJson(json['data'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class AddressDetailResponseData {
  String? id;
  String? userId;
  String? firstName;
  String? lastName;
  String? mobileNumber;
  String? address;
  String? city;
  String? state;
  String? country;
  String? zipCode;
  int? isDefault;
  String? createdAt;
  String? updatedAt;

  AddressDetailResponseData(
      {this.id,
      this.userId,
      this.firstName,
      this.lastName,
      this.mobileNumber,
      this.address,
      this.city,
      this.state,
      this.country,
      this.zipCode,
      this.isDefault,
      this.createdAt,
      this.updatedAt});

  AddressDetailResponseData.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    userId = json['userId'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    mobileNumber = json['mobileNumber'];
    address = json['address'];
    city = json['city'];
    state = json['state'];
    country = json['country'];
    zipCode = json['zipCode'];
    isDefault = json['isDefault'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = id;
    data['userId'] = userId;
    data['firstName'] = firstName;
    data['lastName'] = lastName;
    data['mobileNumber'] = mobileNumber;
    data['address'] = address;
    data['city'] = city;
    data['state'] = state;
    data['country'] = country;
    data['zipCode'] = zipCode;
    data['isDefault'] = isDefault;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}
