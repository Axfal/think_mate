class CheckUserSubscriptionPlanModel {
  bool? success;
  String? userType;
  String? subscriptionName;
  int? testId;

  CheckUserSubscriptionPlanModel(
      {this.success, this.userType, this.subscriptionName, this.testId});

  CheckUserSubscriptionPlanModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    userType = json['user_type'];
    subscriptionName = json['subscription_name'];
    testId = json['test_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['user_type'] = this.userType;
    data['subscription_name'] = this.subscriptionName;
    data['test_id'] = this.testId;
    return data;
  }
}
