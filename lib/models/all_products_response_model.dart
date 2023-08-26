class AllProductsResponseModel {
  int? status;
  String? message;
  List<AllProductsResponseData>? data;

  AllProductsResponseModel({this.status, this.message, this.data});

  AllProductsResponseModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <AllProductsResponseData>[];
      json['data'].forEach((v) {
        data!.add(AllProductsResponseData.fromJson(v));
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

class AllProductsResponseData {
  String? id;
  int? productId;
  String? categorieId;
  String? subCategorieId;
  String? productName;
  String? description;
  int? unit;
  String? unitChoosen;
  String? mrpPrice;
  String? sellPrice;
  int? isWishlist;
  List<String>? image;

  AllProductsResponseData(
      {this.id,
      this.productId,
      this.categorieId,
      this.subCategorieId,
      this.productName,
      this.description,
      this.unit,
      this.unitChoosen,
      this.mrpPrice,
      this.sellPrice,
      this.isWishlist,
      this.image});

  AllProductsResponseData.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    productId = json['productId'];
    categorieId = json['categorieId'];
    subCategorieId = json['subCategorieId'];
    productName = json['productName'];
    description = json['description'];
    unit = json['unit'];
    unitChoosen = json['kgOrgm'];
    mrpPrice = json['mrpPrice'];
    isWishlist = json['isWishlist'];
    sellPrice = json['sellPrice'];
    if (json['image'] != null) {
      image = List<String>.from(
        json['image'].map((dynamic e) => e.toString()),
      );
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = id;
    data['productId'] = productId;
    data['categorieId'] = categorieId;
    data['subCategorieId'] = subCategorieId;
    data['productName'] = productName;
    data['description'] = description;
    data['unit'] = unit;
    data['kgOrgm'] = unitChoosen;
    data['mrpPrice'] = mrpPrice;
    data['sellPrice'] = sellPrice;
    data['image'] = image;
    return data;
  }
}
