class CheckUserSubscriptionPlanModel {
  bool? success;
  String? userType;
  String? subscriptionName;

  CheckUserSubscriptionPlanModel(
      {this.success, this.userType, this.subscriptionName});

  CheckUserSubscriptionPlanModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    userType = json['user_type'];
    subscriptionName = json['subscription_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['user_type'] = this.userType;
    data['subscription_name'] = this.subscriptionName;
    return data;
  }
}
