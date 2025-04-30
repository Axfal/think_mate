class SubscriptionHistoryModel {
  bool? success;
  List<PaymentHistory>? paymentHistory;

  SubscriptionHistoryModel({this.success, this.paymentHistory});

  SubscriptionHistoryModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    if (json['payment_history'] != null) {
      paymentHistory = <PaymentHistory>[];
      json['payment_history'].forEach((v) {
        paymentHistory!.add(new PaymentHistory.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    if (this.paymentHistory != null) {
      data['payment_history'] =
          this.paymentHistory!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class PaymentHistory {
  int? id;
  String? amount;
  String? paymentImage;
  String? paymentDate;
  String? status;
  String? testName;
  String? subscriptionName;

  PaymentHistory(
      {this.id,
        this.amount,
        this.paymentImage,
        this.paymentDate,
        this.status,
        this.testName,
        this.subscriptionName});

  PaymentHistory.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    amount = json['amount'];
    paymentImage = json['payment_image'];
    paymentDate = json['payment_date'];
    status = json['status'];
    testName = json['test_name'];
    subscriptionName = json['subscription_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['amount'] = this.amount;
    data['payment_image'] = this.paymentImage;
    data['payment_date'] = this.paymentDate;
    data['status'] = this.status;
    data['test_name'] = this.testName;
    data['subscription_name'] = this.subscriptionName;
    return data;
  }
}
