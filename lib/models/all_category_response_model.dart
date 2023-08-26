class AllCategoryResponseModel {
  int? status;
  String? message;
  List<AllCategoryResponseData>? data;

  AllCategoryResponseModel({this.status, this.message, this.data});

  AllCategoryResponseModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <AllCategoryResponseData>[];
      json['data'].forEach((v) {
        data!.add(AllCategoryResponseData.fromJson(v));
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

class AllCategoryResponseData {
  String? id;
  String? name;
  String? description;
  String? image;
  String? status;
  String? createdAt;
  String? updatedAt;

  AllCategoryResponseData(
      {this.id,
      this.name,
      this.description,
      this.image,
      this.status,
      this.createdAt,
      this.updatedAt});

  AllCategoryResponseData.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    name = json['name'];
    description = json['description'];
    image = json['image'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = id;
    data['name'] = name;
    data['description'] = description;
    data['image'] = image;
    data['status'] = status;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}
