class GetSubscriptionModel {
  final bool? success;
  final List<Subscriptions>? subscriptions;

  GetSubscriptionModel({this.success, this.subscriptions});

  factory GetSubscriptionModel.fromJson(Map<String, dynamic> json) {
    return GetSubscriptionModel(
      success: json['success'],
      subscriptions: json['subscriptions'] != null
          ? (json['subscriptions'] as List)
          .map((v) => Subscriptions.fromJson(v))
          .toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      if (subscriptions != null)
        'subscriptions': subscriptions!.map((v) => v.toJson()).toList(),
    };
  }
}

class Subscriptions {
  final int? id;
  final String? subscriptionName;
  final int? months;
  final String? price;

  Subscriptions({
    this.id,
    this.subscriptionName,
    this.months,
    this.price,
  });

  factory Subscriptions.fromJson(Map<String, dynamic> json) {
    return Subscriptions(
      id: json['id'],
      subscriptionName: json['subscription_name'],
      months: json['months'],
      price: json['price'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'subscription_name': subscriptionName,
      'months': months,
      'price': price,
    };
  }
}
