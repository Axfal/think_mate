class GetSubscriptionModel {
  bool? success;
  String? testName;
  List<Subscriptions>? subscriptions;

  GetSubscriptionModel({this.success, this.testName, this.subscriptions});

  GetSubscriptionModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    testName = json['test_name'];
    if (json['subscriptions'] != null) {
      subscriptions = <Subscriptions>[];
      json['subscriptions'].forEach((v) {
        subscriptions!.add(new Subscriptions.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['test_name'] = this.testName;
    if (this.subscriptions != null) {
      data['subscriptions'] =
          this.subscriptions!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Subscriptions {
  int? id;
  String? subscriptionName;
  int? months;
  String? price;

  Subscriptions({this.id, this.subscriptionName, this.months, this.price});

  Subscriptions.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    subscriptionName = json['subscription_name'];
    months = json['months'];
    price = json['price'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['subscription_name'] = this.subscriptionName;
    data['months'] = this.months;
    data['price'] = this.price;
    return data;
  }
}
