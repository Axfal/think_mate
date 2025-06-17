class VerifyPromoModel {
  bool? success;
  Data? data;

  VerifyPromoModel({this.success, this.data});

  VerifyPromoModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  String? code;
  String? status;
  String? discount;

  Data({this.code, this.status, this.discount});

  Data.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    status = json['status'];
    discount = json['discount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    data['status'] = this.status;
    data['discount'] = this.discount;
    return data;
  }
}
